function initiate_connection()
  path = joinpath(ENV["HOME"], ".distributedworkflow/workflows")
  run(`mkdir -p $path`)
  lib_path = readchomp(`spack location -i distributedworkflow`)
  @wrapmodule(() -> joinpath(lib_path, "lib", "libzeda-distributedworkflow.so"), :define_module_interface)

  function __init__()
    @initcxx
  end
end

function port_info(KV)
  CxxWrap.CxxWrapCore.dereference_argument(DistributedWorkflow.get_port(KV))
end

function value_info(KV)
  CxxWrap.CxxWrapCore.dereference_argument(DistributedWorkflow.get_value(KV))
end
