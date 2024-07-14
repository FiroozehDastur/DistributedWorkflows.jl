module DistributedWorkflows
  using Cairo, CxxWrap, Documenter, FileIO, GraphViz, LightXML, Markdown, Serialization, TOML
  import Pkg
  export application_config,
         arc,
         client,
         compile_workflow, 
         connect,
         function_name,
         implementation, 
         input_pair, 
         julia_implementation, 
         output_dir,
         place,
         port,
         port_info,
         remove,
         submit_workflow, 
         transition,
         workflow_config,
         generate_workflow,
         savefig,
         show_workflow,
         Workflow_PetriNet
  
  include("init_calls.jl")

  include("helpers.jl")
  include("petri_net.jl")
  include("workflow_compiler.jl")
  include("workflow_renderer.jl")
  include("wrapper.jl")
  include("xml_generator.jl")

  # function to determine version number at compile time
  function _get_version()
    return VersionNumber(Pkg.TOML.parsefile(joinpath(dirname(@__DIR__), "Project.toml"))["version"])
  end
  const pkg_version = _get_version()
end
