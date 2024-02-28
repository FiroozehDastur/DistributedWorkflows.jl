module DistributedWorkflow
  using CxxWrap, LightXML, Markdown, Serialization, TOML
  export application_config,
         arc,
         client,
         compile_workflow, 
         connect,
         create_xpnet,
         function_name, 
         implementation, 
         input_pair, 
         julia_implementation, 
         output_dir,
         PetriNet, 
         place,
         port,
         port_info,
         set_workflow_env, 
         submit_workflow, 
         transition,
         workflow_config
  
  include("config.jl")
  include("cxxwrap_calls.jl")
  include("petri_net.jl")
  include("workflow_compiler.jl")
  include("wrapper.jl")
  include("xml_generator.jl")
end
