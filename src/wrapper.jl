include("./cxxwrap_calls.jl")

function client(workers::Int, nodefile::String, rif_strategy::String, log_host::String, log_port::Int)
  worker = string("worker:", workers)
  gspc_home = string("--gspc-home=", readchomp(`spack location -i gpi-space`))
  nodefile = string("--nodefile=", nodefile)
  rif_strategy = string("--rif-strategy=", rif_strategy)
  log_host = string("--log-host=", log_host)
  log_port = string("--log-port=", log_port)
  client_config = string(gspc_home, " " ,nodefile, " ",rif_strategy, " ", log_host, " ", log_port, " --worker-env-copy-current")

  DistributedWorkflow.Client(worker, client_config)
end

function client(workers::Int, nodefile::String, rif_strategy::String)
  worker = string("worker:", workers)
  gspc_home = string("--gspc-home=", readchomp(`spack location -i gpi-space`))
  nodefile = string("--nodefile=", nodefile)
  rif_strategy = string("--rif-strategy=", rif_strategy)
  client_config = string(gspc_home, " " ,nodefile, " ",rif_strategy, " --worker-env-copy-current")

  DistributedWorkflow.Client(worker, client_config)
end

function_name(port_name::String, path::String) = KeyValuePair(port_name, path)

input_pair(port_name::String, path::String) = KeyValuePair(port_name, path)

implementation(port_name::String, path::String) = KeyValuePair(port_name, path)

julia_implementation(port_name::String, path::String) = KeyValuePair(port_name, path)

function output_dir(port_name::String, path::String)
  run(`mkdir -p $path`) 
  KeyValuePair(port_name, path)
end

function submit_workflow(client,workflow,input_params)
  output = DistributedWorkflow.submit(client, workflow, input_params)
  output_list = String[]
  for val in output
    deref_val = DistributedWorkflow.value_info(val)
    push!(output_list, deref_val) 
  end
  return output_list
end
