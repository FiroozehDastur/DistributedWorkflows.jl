
# =============================================================================
# Petri net viewer using GraphViz
# =============================================================================
"""
    workflow_viewer(pnet::PetriNet, file_format::Symbol=:png, path::String="")
By default this method generates a png file after compiling the Petri net into an XML workflow and compiling the workflow.
If path is not given then the workflow image is stored in your home directory in \"tmp\" folder.
Note: supported file formats: :png, :svg


# Examples
```julia-repl


```
"""
# function workflow_viewer(pnet::PetriNet, file_format::Symbol=:png, path::String="")
#   install_dir = DistributedWorkflow.config["workflow_path"]
#   xml_wf = workflow_generator(pn, path)
#   xml_location = joinpath(xml_wf.path, xml_wf.name)
#   compile_workflow(xml_location, path)
#   Graphviz.load()
#   pnet2dot /root/.distributedworkflow/workflows/hello_julia.pnet --signature=OFF | dot -Tjpg > /root/tmp/hello_julia.jpg
# end

# required packages GraphViz, FileIO, Cairo
# Make this optional dependency
# types required for Graphviz
# net shape => box
# transition => box but light blue
# places = ellipse
# arrow/arc styles:
#   in arc => normal
#   out arc => normal
#   inout arc => arrow head and arrow tail. If not possible then add one arrow in and one arrow out
#   read arc => dashed

struct XML_renderer
  net::PetriNet
  port::Dict
  place::Dict
  transition::Dict
  arc::Dict
  location::String
end

function render_net(pnet::PetriNet, path::String="")
  # collect ports based on their types in and out for shape
  in_ports = Vector{Ports}()
  out_ports = Vector{Ports}()
  for p in pnet.ports
    if p.type == :in 
      push!(in_ports, p)
    elseif p.type == :out
      push!(out_ports, p)
    else
      push!(in_ports, p)
      push!(out_ports, p)
    end
  end

  # create a string list that has information for the port nodes
  nd_prt_in = """node [shape=house, style=filled, fillcolor=white]\n"""
  instr_port_list = [nd_prt_in]
  for p in in_ports
    prt_st = """Prt$(p.name) [label="$(p.name)"]\n"""
    push!(instr_port_list, prt_str)
  end
  nd_prt_out = """node [shape=invhouse, style=filled, fillcolor=white]\n"""
  outstr_port_list = [nd_prt_out]
  for p in out_ports
    prt_st = """Prt$(p.name) [label="$(p.name)"]"""
    push!(outstr_port_list, prt_str)
  end

  # create a string list that has information for the place nodes
  nd_pl = """node [shape=ellipse]\n"""
  plstr_list = [nd_pl]
  P_st = ""
  for i in 1:length(pnet.places)
    p = pnet.places[i]
    if p.type == :control_init
      b = "\u2022"
      P_st = """P$i [label = "$(b)", xlabel = "$(p.name)"]\n"""
    elseif p.type == :control
      P_st = """P$i [xlabel = "$(p.name)"]\n"""
    else
      P_st = """P$i [label = "$(p.name)"]\n"""
    end
    push!(plstr_list, P_st)
  end

  # create a string list that has information for the transition nodes
  nd_tr = """node [shape=box3d, style=filled, fillcolor=lightblue]\n"""
  trstr_list = [nd_tr]
  for t in pnet.transitions
    T_str = """T$(t.name) [label="$(t.name)"]\n"""
    push!(trstr_list, T_str)
  end

  # collect list of different kinds of arcs
  in_arcs = Vector{Arc}()
  out_arcs = Vector{Arc}()
  inout_arcs = Vector{Arc}()
  read_arcs = Vector{Arc}()
  out_many_arcs = Vector{Arc}()
  for a in pnet.arcs
    if a.type == :in
      push!(in_arcs, a)
    elseif a.type == :out
      push!(out_arcs, a)
    elseif a.type == :read
      push!(read_arcs, a)
    elseif a.type == :out_many
      push!(out_many_arcs, a)
    else
      push!(inout_arcs, a)
    end
  end

  # // Define edges with different arrow types
  # A -> B [arrowhead=normal]  // Normal arrowhead (default)
  # A -> C [arrowhead=dot]     // Dot arrowhead
  # B -> C [arrowhead=vee]     // Vee arrowhead
  # C1 -> A1 [style = "dotted", dir = "none"]
  # create a string list that has information for the arc styles
  arc_str_list = Vector{String}()
  for a in inout_arcs
    arc_str = """[arrowhead=normal, arrowtail=normal, dir="both"]\n"""
    push!(arc_str_list, arc_str)
  end
  for a in in_arcs
    arc_str = """[arrowhead=normal]\n"""
    push!(arc_str_list, arc_str)
  end
  for a in read_arcs
    arc_str = """[arrowhead=normal, style="dashed"]\n"""
    push!(arc_str_list, arc_str)
  end
  for a in out_arcs
    arc_str = """[arrowhead=normal]\n"""
    push!(arc_str_list, arc_str)
  end
  for a in out_many_arcs
    arc_str = """[arrowhead=normal, color = "black:invis:black"]\n"""
    push!(arc_str_list, arc_str)
  end


  title = """label = "$(pnet.name)";"""
  pos = """labelloc = "t";"""
  gen_str =
  """
  digraph petrinet {
    $label
    $pos
  """
  in_ports_string = instr_port_list[1]
  for i in 2:length(instr_port_list)
    in_ports_string = in_ports_string * instr_port_list[i]
  end
  out_ports_string = outstr_port_list[1]
  for i in 2:length(instr_port_list)
    out_ports_string = out_ports_string * outstr_port_list[i]
  end

  sub_gh_begin =  """subgraph net {
    style="rounded"
    color="lightgrey\n"
  """

  place_string = plstr_list[1]  
  for i in 2:length(plstr_list)
    place_string = place_string * plstr_list[i]
  end

  transition_string = trstr_list[1]  
  for i in 2:length(trstr_list)
    transition_string = transition_string * trstr_list[i]
  end

  sub_gh_end = """ }
    // Define edges
    // port to place dotted no arrows
    // place to transition no arrows
    // Define overall graph properties
    graph [bgcolor=lightyellow, margin=0.1, pad=0.2]\n
  }
  """
  graph_viz = GraphViz.Graph(gen_str)
  store_location = ""
  if isempty(path)
    store_location = joinpath(ENV["HOME"], "tmp/$(pnet.name).png")
  else
    store_location = joinpath(path, "tmp/$(pnet.name).png")
  end
  graph_gen = FileIO(store_location, graph_viz)
  return store_location
end


# function render_net(pnet::PetriNet)
#   # label: place.name, transition.name, port.name
#   # nodes: place, transition, ports
#   # shapes: places,transitions. ports
#   # arrowhead styles: all arc styles
#   labels = Dict{Symbol, String}()
#   prt_nodes = Dict{}()
#   # for p in pnet.ports
    
#   p_nodes = Dict{}()
#   t_nodes = Dict{}()
#   shapes = Dict{}()
#   arrows = Dict{}()
#   for p in pnet.ports
#     port_dict[p.name]
#   end

#   port_dict = Dict{String, Symbol}()
#   for p in pnet.ports
#     if p.type == :in
#       port_dict[p] = :house
#     elseif p.type == :out
#       port_dict[p] = :invhouse
#     else
#       port_dict[p] = :diamond
#     end
#   end

#   place_dict = Dict{Place, Symbol}()
#   for p in pnet.places
#     place_dict[p] = :ellipse
#   end

#   transition_dict = Dict{Transition, Symbol}()
#   for t in pnet.transitions
#     transition_dict[t] = :box
#   end

#   arc_dict = Dict{Arc, Symbol}()
#   for a in pnet.arcs
#     if a.type == :read
#       arc_dict[a] = :dashed
#     else
#       arc_dict[a] = a.type
#     end
#   end

#   return XML_renderer(pnet, port_dict, place_dict, transition_dict, arc_dict, "")
# end

# using GraphViz, FileIO, Cairo

g = """digraph G {
  label = "hello";
  labelloc = "t";
  subgraph gh {

    // Define nodes and their attributes
    node [shape=ellipse, style=filled, fillcolor=lightblue]
    A1 [xlabel="Type A Node 1"]
    A2 [xlabel="Type A Node 2"]
    A3 [xlabel="Type A Node 3"]

    node [shape=box, style=filled, fillcolor=lightgreen]
    B1 [label="Type B Node 1"]
    B2 [label="Type B Node 2"]
    B3 [label="Type B Node 3"]

    // Define edges between nodes
    A1 -> B1 [color=red]
    A1 -> B2 [color=red]
    A2 -> B2 [color=green]
    A3 -> B3 [color=blue]

    // Define clusters for the bipartite sets
    subgraph cluster_A {
      label = "Set A"
      style = "rounded,filled"
      color = "lightgrey"
      A1 A2 A3
    }

    subgraph cluster_B {
      label = "Set B"
      style = "rounded,filled"
      color = "lightgrey"
      B1 B2 B3
    }

  
    label = "Set B"
    style = "rounded,filled"
    color = "white"
    cluster_A cluster_B
  }
  // Define overall graph properties
  graph [bgcolor=lightyellow, margin=0.1, pad=0.2]
}
"""
# gv = GraphViz.Graph(g)
# FileIO.save("filename.png", gv)

digraph G {
  label = "hello";
  labelloc = "t";

    // Define the outer box
    subgraph cluster_outer {
        label = "Outer Box"
        style = "rounded"
        color = "lightgrey"

        // Define the middle box
        subgraph cluster_middle {
            label = "Middle Box"
            style = "rounded"
            color = "lightgrey"

            node [shape=ellipse, style=filled, fillcolor=lightblue]
            C1 [xlabel="Type C Node 1"]
            C2 [xlabel="Type C Node 2"]
            C3 [xlabel="Type C Node 3"]
        

            // Define the inner box
            subgraph cluster_inner {
                label = "Inner Box"
                style = "rounded"
                color = "lightgrey"

                // Define the nodes inside the inner box
                node [shape=ellipse, style=filled, fillcolor=lightblue]
                A1 [xlabel="Type A Node 1"]
                A2 [xlabel="Type A Node 2"]
                A3 [xlabel="Type A Node 3"]
                // Define the nodes outside the boxes
                node [shape=box, style=filled, fillcolor=lightgreen]
                B1 [label="Type B Node 1"]
                B2 [label="Type B Node 2"]
                B3 [label="Type B Node 3"]            
            }
        }
        subgraph cluster_inner {

            label = "Set c"
            style = "rounded,filled"
            color = "white"
            cluster_A cluster_B
        }
    }

    // Define edges
    A1 -> B1 [color=red]
    A1 -> B2 [color=red]
    A2 -> B2 [color=green]
    A3 -> B3 [color=blue]
    C1 -> A1 [style = "dotted", dir = "none"]
    C2 -> A2
    C3 -> B2
    cluster_A -> cluster_B
    // Define overall graph properties
    graph [bgcolor=lightyellow, margin=0.1, pad=0.2]
  
}


digraph "hello_julia" {
compound=true
rankdir=LR
  subgraph cluster_0 {
    n0_condition [shape = "record", label = "hello_julia", style = "filled", fillcolor = "white"]
    n0_port_0 [shape = "house", label = "implementation_1\nstring", style = "filled", fillcolor = "white"]
    n0_port_1 [shape = "house", label = "input_file1\nstring", style = "filled", fillcolor = "white"]
    n0_port_2 [shape = "house", label = "input_file2\nstring", style = "filled", fillcolor = "white"]
    n0_port_3 [shape = "invhouse", label = "output_file1\nstring", style = "filled", fillcolor = "white"]
    n0_port_4 [shape = "invhouse", label = "output_file2\nstring", style = "filled", fillcolor = "white"]
    subgraph cluster_net_0 {
      n0_place_0 [shape = "ellipse", label = "implementation_1\nstring", style = "filled", fillcolor = "white"]
      n0_place_1 [shape = "ellipse", label = "input_file1\nstring", style = "filled", fillcolor = "white"]
      n0_place_2 [shape = "ellipse", label = "input_file2\nstring", style = "filled", fillcolor = "white"]
      n0_place_3 [shape = "ellipse", label = "output_file1\nstring", style = "filled", fillcolor = "white"]
      n0_place_4 [shape = "ellipse", label = "output_file2\nstring", style = "filled", fillcolor = "white"]
      subgraph cluster_1 {
        n1_condition [shape = "record", label = "hello_jl", style = "filled", fillcolor = "white"]
        n1_port_0 [shape = "house", label = "implementation_1\nstring", style = "filled", fillcolor = "white"]
        n1_port_1 [shape = "house", label = "input_file1\nstring", style = "filled", fillcolor = "white"]
        n1_port_2 [shape = "house", label = "input_file2\nstring", style = "filled", fillcolor = "white"]
        n1_port_3 [shape = "invhouse", label = "output_file1\nstring", style = "filled", fillcolor = "white"]
        n1_port_4 [shape = "invhouse", label = "output_file2\nstring", style = "filled", fillcolor = "white"]
        n1_modcall [shape = "box", label = "hello_julia.operation_1", style = "filled", fillcolor = "white"]
        bgcolor = "yellow"
      } /* cluster_1 == hello_jl */
      n1_port_3 -> n0_place_3
      n1_port_4 -> n0_place_4
      n0_place_0 -> n1_port_0
      n0_place_2 -> n1_port_2
      n0_place_1 -> n1_port_1
      bgcolor = "white"
    } /* cluster_net_0 */
    n0_port_0 -> n0_place_0 [style = "dotted", dir = "none"]
    n0_port_1 -> n0_place_1 [style = "dotted", dir = "none"]
    n0_port_2 -> n0_place_2 [style = "dotted", dir = "none"]
    n0_port_3 -> n0_place_3 [style = "dotted", dir = "none"]
    n0_port_4 -> n0_place_4 [style = "dotted", dir = "none"]
    bgcolor = "dimgray"
  } /* cluster_0 == hello_julia */
} /* hello_julia */
