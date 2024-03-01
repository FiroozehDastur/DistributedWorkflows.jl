function __init__()
  path = joinpath(ENV["HOME"], ".distributedworkflow")
  run(`mkdir -p $path`)

  config_file = joinpath(path, "config.toml")
  if !isfile(config_file)
    data = Dict(
                "version" => "0.1",
                "workflow_path" => joinpath(ENV["HOME"], ".distributedworkflow/workflows"),
    );
    open(config_file, "w") do io
      TOML.print(io, data)
    end
  end
  global config = TOML.parsefile(config_file)
  workflow_path = config["workflow_path"]
  run(`mkdir -p $workflow_path`)


  lib_path = readchomp(`spack location -i distributedworkflow`)
  @wrapmodule(() -> joinpath(lib_path, "lib", "libzeda-distributedworkflow.so"), :define_module_interface)
  @initcxx
end

# add documentation
"""
    port_info(KV)
Description of function here...

# Examples
```julia-repl


```
"""
function port_info(KV)
  port = CxxWrap.CxxWrapCore.dereference_argument(DistributedWorkflow.get_port(KV))
  value = CxxWrap.CxxWrapCore.dereference_argument(DistributedWorkflow.get_value(KV))

  return port, value
end
