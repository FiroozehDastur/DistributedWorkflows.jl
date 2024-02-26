module DistributedWorkflow
  using CxxWrap, Markdown, Serialization, TOML
  export arc,
         client,
         compile_workflow, 
         connect,
         create_xpnet,
         function_name, 
         implementation, 
         input_pair, 
         julia_implementation, 
         output_dir, 
         place,
         set_workflow_env, 
         submit_workflow, 
         transition,
         workflow_config
  
  include("config.jl")
  include("cxxwrap_calls.jl")
  include("petri_net.jl")
  include("workflow_compiler.jl")
  include("wrapper.jl")
end
