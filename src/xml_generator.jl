# using LightXML

# function _xpnet_generator(pnet::PetriNet)
#   xpnet = XMLDocument()
#   defun = create_root(xpnet, "defun")
#   set_attribute(defun, "name", pnet.name)
  
#   impl_port = new_child(defun, "in")
#   set_attributes(impl_port, Dict("name"=>"implementation", "type"=>"string", "place"=>"implementation"))
#   for i in 1:length(pnet.ports)
#     port = new_child(defun, string(pnet.ports[i].type))
#     set_attributes(port, Dict("name"=>pnet.ports[i].name, "type"=>"string" , "place"=>pnet.ports[i].place.name))
#   end

#   net = new_child(defun, "net")
#   # all the places here...
#   impl_pl = new_child(net, "place")
#   set_attributes(impl_pl, Dict("name"=>"implementation", "type"=>"string"))
#   for i in 1:length(pnet.places)
#     pl = new_child(net, "place")
#     set_attributes(pl, Dict("name"=>pnet.places[i].name, "type"=>string(pnet.places[i].type)))
#   end

#   # transition with defun child, connect in/out/inout/read childs
#   for i in 1:length(pnet.transitions)
#     trans = new_child(net, "transition")
#     t_name = pnet.transitions[i].name
#     set_attribute(trans, "name", t_name)
#     # defun child 
#     def = new_child(trans, "defun")
#     impl = new_child(def, "in")
#     set_attributes(impl, Dict("name"=>"implementation", "type"=>"string"))
#     for j in 1:length(pnet.arcs)
#       if pnet.arcs[j].transition == pnet.transition[i]
#         # defun child in/out/inout ports and module child
#         prt = new_child(def, string(pnet.arcs[j].type))
#         set_attributes(prt, Dict("name"=>pnet.arcs[j].place.name, "type"=>string(pnet.arcs[j].place.type)))
#         # module with cinclude childs

#         mod = new_child(def, "module")
#         set_attributes(mod, Dict("name"=>string(t_name, "mod"), "function"=>"operation (...., implementation)", "require_function_unloads_without_rest"="false"))
#         cin1 = new_child(mod, "cinclude")
#         set_attribute(cin1, "href", "zeda/executor.hpp")
#         cin2 = new_child(mod, "cinclude")
#         set_attribute(cin2, "href", "iostream")
#         cin3 = new_child(mod, "cinclude")
#         set_attribute(cin3, "href", "string")
#         cin4 = new_child(mod, "cinclude")
#         set_attribute(cin4, "href", "vector")
#         # module with C code child
#         code = new_child(mod, "code")
#         add_cdata(xpnet, code, string("std::vector<std::vector<std::string>> output = zeda::execute(implementation, {...}, number_of_outputs);\n", out_file1 = output[0][0];, "\n", out_file2 = output[1][0];))
#         # connect ports
#         connect_prt = new_child(trans, string("connect-", pnet.arcs[j].type))
#         set_attributes(connect_prt, Dict("port"=>pnet.arcs[j].place.name, "place"=>string(pnet.arcs[j].place.name)))
#       end
#     end
#     impl_port_connect = new_child(trans, "connect-in")
#     set_attributes(impl_port_connect, Dict("port"=>"implementation", "place"=>"implementation"))

#   end
#   return xpnet
# end

"""
    workflow_generator(pnet::PetriNet, path::String)
Given a Petri net description, creates an XML workflow and writes it to a file in the path.

# Examples
```julia-repl
julia>

```
"""
function workflow_generator(pnet::PetriNet, path::String="")
  xpnet = _xpnet_generator(pnet)
  dir = ""
  if !isempty(path)
    save_file(xpnet, joinpath(path,"$(pnet.name).xpnet"))
    dir = path
  else
    save_file(xpnet, joinpath(ENV["HOME"],"tmp/$(pnet.name).xpnet"))
    dir = joinpath(ENV["HOME"],"tmp")
  end
  free(xpnet)
  return "An XML workflow \"$(pnet.name)\" has been written to the location: $(dir)."
end


function _xpnet_generator(pnet::PetriNet)
  # create an xml doc
  xpnet = XMLDocument()
  # define the root of the Petri net
  defun = create_root(xpnet, "defun")
  # add name to the Petri net
  set_attribute(defun, "name", pnet.name)
  
  # add input and output ports to the Petri net
  # implementation port for the executor
  for i in 1:length(pnet.transitions)
    impl_port = new_child(defun, "in")
    set_attributes(impl_port, Dict("name"=>"implementation_$i", "type"=>"string", "place"=>"implementation_$i"))
  end

  # in and out ports for the Petri net
  for i in 1:length(pnet.ports)
    port = new_child(defun, string(pnet.ports[i].type))
    set_attributes(port, Dict("name"=>pnet.ports[i].name, "type"=>"string" , "place"=>pnet.ports[i].place.name))
  end

  # creates the net field of the Petri net
  net = new_child(defun, "net")
  # all the places that require implementation to the executor.jl
  for i in 1:length(pnet.transitions)
    impl_pl = new_child(net, "place")
    set_attributes(impl_pl, Dict("name"=>"implementation_$i", "type"=>"string"))
  end

  # all the remaining places for the remaining transitions
  for i in 1:length(pnet.places)
    if pnet.places[i].type == :control
      pl = new_child(net, "place")
      set_attributes(pl, Dict("name"=>pnet.places[i].name, "type"=>"control"))
      tk = new_child(pl, "token")
      vl = new_child(tk, "value")
      add_text(vl,"[]")
    else
      pl = new_child(net, "place")
      set_attributes(pl, Dict("name"=>pnet.places[i].name, "type"=>string(pnet.places[i].type)))
    end
  end

  # transition(s) with defun child, connect in/out/inout/read childs
  for i in 1:length(pnet.transitions)
    trans = new_child(net, "transition")
    t_name = pnet.transitions[i].name
    set_attribute(trans, "name", t_name)
    # transition child defun 
    def = new_child(trans, "defun")
    impl = new_child(def, "in")
    set_attributes(impl, Dict("name"=>"implementation_$i", "type"=>"string"))

    # transition child with in/out ports
    for j in 1:length(pnet.arcs)
      if pnet.arcs[j].transition == pnet.transitions[i]
        # defun child in/out/inout ports and module child
        prt = new_child(def, string(pnet.arcs[j].type))
        set_attributes(prt, Dict("name"=>pnet.arcs[j].place.name, "type"=>string(pnet.arcs[j].place.type)))
      end
    end

    # continue here...
    # module with cinclude childs
    mod = new_child(def, "module")
    set_attributes(mod, Dict("name"=>string(t_name, "_mod"), "function"=>"operation (...., implementation_$i)", "require_function_unloads_without_rest"="false"))
    
    # module children cincludes
    cin1 = new_child(mod, "cinclude")
    set_attribute(cin1, "href", "zeda/executor.hpp")
    
    cin2 = new_child(mod, "cinclude")
    set_attribute(cin2, "href", "iostream")
    
    cin3 = new_child(mod, "cinclude")
    set_attribute(cin3, "href", "string")
    
    cin4 = new_child(mod, "cinclude")
    set_attribute(cin4, "href", "vector")
    
    # module child CDATA
    code = new_child(mod, "code")
    add_cdata(xpnet, code, string("std::vector<std::vector<std::string>> output = zeda::execute(implementation, {...}, number_of_outputs);\n", out_file1 = output[0][0];, "\n", out_file2 = output[1][0];))

    for j in 1:length(pnet.arcs)
      if pnet.arcs[j].transition == pnet.transitions[i]
        # transition child connection in/out ports
        connect_prt = new_child(trans, string("connect-", pnet.arcs[j].type))
        set_attributes(connect_prt, Dict("port"=>pnet.arcs[j].place.name, "place"=>string(pnet.arcs[j].place.name)))
      end
    end


    # transition child connection ports to executor.jl
    impl_port_connect = new_child(trans, "connect-in")
    set_attributes(impl_port_connect, Dict("port"=>"implementation_$i", "place"=>"implementation_$i"))
  end
  return xpnet
end
