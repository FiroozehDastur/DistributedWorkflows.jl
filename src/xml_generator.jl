# Generate input and output ports

# Generate transition code
using LightXML

# function module_code(name::String, transition::Transition, )

# end

function xpnet_generator(pnet::PetriNet[, filename::String])
  xpnet = XMLDocument()
  defun = create_root(xpnet, "defun")
  set_attribute(defun, "name", pnet.name)
  
  for i in 1:length(pnet.ports)
    port = new_child(defun, string(pnet.ports[i].type))
    set_attributes(port, Dict("name"=>pnet.ports[i].name, "type"=>"string" , "place"=>pnet.ports[i].place.name))
  end

  net = new_child(defun, "net")
  # all the places here...
  for i in 1:length(pnet.places)
    pl = new_child(net, "place")
    set_attributes(pl, Dict("name"=>pnet.places[i].name, "type"=>string(pnet.places[i].type)))
  end

  # transition with defun child, connect in/out/inout/read childs
  for i in 1:length(pnet.transitions)
    trans = new_child(net, "transition")
    set_attribute(trans, "name", pnet.transitions[i].name)
    # defun child 
    def = new_child(trans, "defun")
    for j in 1:length(pnet.arcs)
      if pnet.arcs[j].transition == pnet.transition[i]
        # defun child in/out/inout ports and module child
        prt = new_child(def, string(pnet.arcs[j].type))
        set_attributes(prt, Dict("name"=>pnet.arcs[j].place.name, "type"=>string(pnet.arcs[j].place.type)))
        # module with cinclude childs
        mod = new_child(def, "module")
        set_attributes(mod, Dict("name"=>, "function"=>, "require_function_unloads_without_rest"="false")
        cin1 = new_child(mod, "cinclude")
        set_attribute(cin1, "href", ""zeda/executor.hpp"")
        cin2 = new_child(mod, "cinclude")
        set_attribute(cin2, "href", "iostream")
        cin3 = new_child(mod, "cinclude")
        set_attribute(cin3, "href", "string")
        cin4 = new_child(mod, "cinclude")
        set_attribute(cin4, "href", "vector")
        # module with C code child
        code = new_child(mod, "code")
        add_cdata(xpnet, code, string(std::vector<std::vector<std::string>> output = zeda::execute(implementation, {in_file1, in_file2}, 2);
        out_file1 = output[0][0];
        out_file2 = output[1][0];))
        # connect ports
        connect_prt = new_child(trans, string("connect-", pnet.arcs[j].type))
        set_attributes(connect_prt, Dict("port"=>pnet.arcs[j].place.name, "place"=>string(pnet.arcs[j].place.name)))
      end
    end

  end
  return xpnet
  # if everything works well then write it to the file given in the filename part of the signature
  # if filename
  #   write(filename, xpnet)
  # else
  #   write(joinpath(ENV["HOME"],"tmp/$(pnet.name).xpnet"), xpnet)
  # end
  # dir, _ = splitdir(filename)
  # return println(IOStream, "An XML Petri net has been written to the location: $(dir).")
end

# xdoc = XMLDocument()

# # create & attach a root node
# xroot = create_root(xdoc, "States")

# # create the first child
# xs1 = new_child(xroot, "State")

# # add the inner content
# add_text(xs1, "Massachusetts")

# # set attribute
# set_attribute(xs1, "tag", "MA")

# # likewise for the second child
# xs2 = new_child(xroot, "State")
# add_text(xs2, "Illinois")
# # set multiple attributes using a dict
# set_attributes(xs2, Dict("tag"=>"IL", "cap"=>"Springfield"))

# # now, the third child
# xs3 = new_child(xroot, "State")
# add_text(xs3, "California")
# # set attributes using keyword arguments
# set_attributes(xs3; tag="CA", cap="Sacramento")