module DistributedWorkflow
  using CxxWrap, Serialization, TOML
  export set_workflow_env, client, function_name, input_pair, implementation, julia_implementation, output_dir, submit_workflow, compile_workflow, workflow_config

  include("config.jl")
  include("cxxwrap_calls.jl")
  include("workflow_compiler.jl")
  include("wrapper.jl")
end
