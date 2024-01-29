module DistributedWorkflow
  using CxxWrap, Serialization
  export compile_workflow, client, function_name, implementation, initiate_connection, input_pair, julia_implementation, output_dir, port_info, submit_workflow, value_info

  include("cxxwrap_calls.jl")
  include("workflow_compiler.jl")
  include("wrapper.jl")
end
