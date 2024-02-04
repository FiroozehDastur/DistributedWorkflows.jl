# using Formatting
# include("./cxxwrap_calls.jl")

function client(workers::Int, nodefile::String, rif_strategy::String, log_host::String, log_port::Int)
  worker = string("worker:", workers)
  gspc_home = string("--gspc-home=", readchomp(`spack location -i gpi-space`))
  nodefile = string("--nodefile=", nodefile)
  rif_strategy = string("--rif-strategy=", rif_strategy)
  log_host = string("--log-host=", log_host)
  log_port = string("--log-port=", log_port)
  app_search_path = string("--application-search-path=", config["workflow_path"])
  client_config = string(gspc_home, " " , app_search_path, " " , nodefile, " ", rif_strategy, " ", log_host, " ", log_port, " --worker-env-copy-current")

  DistributedWorkflow.Client(worker, client_config)
end

function client(workers::Int, nodefile::String, rif_strategy::String)
  worker = string("worker:", workers)
  gspc_home = string("--gspc-home=", readchomp(`spack location -i gpi-space`))
  nodefile = string("--nodefile=", nodefile)
  rif_strategy = string("--rif-strategy=", rif_strategy)
  # app_search_path = string("--application-search-path=", ENV["GSPC_APPLICATION_SEARCH_PATH"])
  app_search_path = string("--application-search-path=", config["workflow_path"])
  client_config = string(gspc_home, " " , app_search_path, " ", nodefile, " ", rif_strategy, " --worker-env-copy-current")

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

function submit_workflow(client, workflow, input_params::Vector)
  input_vec = StdVector(input_params)
  output = DistributedWorkflow.submit(client, workflow, input_vec)
  output_list = String[]
  for val in output
    _, deref_val = DistributedWorkflow.port_info(val)
    push!(output_list, deref_val) 
  end
  return output_list
end

function workflow_config(workflow::String, workflow_config::Vector)
  workflow_config = StdVector(workflow_config)
  workflow_path = joinpath(DistributedWorkflow.config["workflow_path"], workflow)
  DistributedWorkflow.Workflow(workflow_path, workflow_config)
end