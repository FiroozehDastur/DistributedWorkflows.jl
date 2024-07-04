struct Application_config
  port::String
  impl::String
  fname::String
end

struct Application_config_many
  ports::Vector{String}
  impl::Vector{String}
  fnames::Vector{String}
end

"""
    application_config(port::String, impl::String, fname::String)
Convenience constructor for configuring a workflow application with a single transition.

# Arguments
- `ports::String`: Ports to configure for the workflow transition.
- `impl::String`: Julia file containing the implementation called by the workflow transition.
- `fnames::String`: Function name to be executed by the workflow transition.

See also [`PetriNet`](@ref), [`generate_workflow`](@ref), [`compile_workflow`](@ref).
""" 
application_config(port::String, impl::String, fname::String) = Application_config(port, impl, fname)

"""
    application_config(ports::Vector{String}, impl::Vector{String}, fnames::Vector{String})
Constructor for configuring a workflow application with multiple transitions.

# Arguments
- `ports::Vector{String}`: List of ports to configure for the workflow transitions.
- `impl::Vector{String}`: List of julia files containing the implementations called by the workflow transitions.
- `fnames::Vector{String}`: List of function names to be executed by the workflow transitions.

See also [`PetriNet`](@ref), [`generate_workflow`](@ref), [`compile_workflow`](@ref).
"""
application_config(ports::Vector{String}, impl::Vector{String}, fnames::Vector{String}) = Application_config_many(ports, impl, fnames)

"""
    application_config(ports::Vector{String}, impl::String, fnames::Vector{String})
Convenience constructor for configuring a workflow application with multiple transitions sourcing their implementation details from the same file.

# Arguments
- `ports::Vector{String}`: List of ports to configure for the workflow transitions.
- `impl::String`: Julia file containing the implementations called by the workflow transitions.
- `fnames::Vector{String}`: List of function names to be executed by the workflow transitions.

See also [`PetriNet`](@ref), [`generate_workflow`](@ref), [`compile_workflow`](@ref).
"""
application_config(ports::Vector{String}, impl::String, fnames::Vector{String}) = Application_config_many(ports, [impl], fnames)

"""
    client(workers::Int, nodefile::String, rif_strategy::String, log_host::String, log_port::Int)
Configures and starts a client setting up the workflow execution infrastructure and connects to a logging service.
The nodefile will be automatically populated with the local host name if it doesn't exist in the given location or the `rif_strategy` is `local`.

# Arguments
- `workers::Int`: Number of workers launched per node.
- `nodefile::String`: Location of the nodefile.
- `rif_strategy::String`: Launch mode of the workflow infrastructure. Accepts `ssh` for distributing the workers across multiple nodes or `local` for running on the localhost only.
- `log_host::String`: Host of the logging service.
- `log_port::Int` : Port the logging service is listening on.

See also [`PetriNet`](@ref), [`generate_workflow`](@ref), [`compile_workflow`](@ref).
"""
function client(workers::Int, nodefile::String, rif_strategy::String, log_host::String, log_port::Int)
  if !isfile(nodefile) || rif_strategy=="local"
    run(`touch $nodefile`)
    write(nodefile, gethostname())
    # ToDo: add an else condition for the nodefile
  end
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

"""
    client(workers::Int, nodefile::String, rif_strategy::String)
Configures and starts a client setting up the workflow execution infrastructure.
The nodefile will be automatically populated with the local host name if it doesn't exist in the given location or the `rif_strategy` is `local`.

# Arguments
- `workers::Int`: Number of workers launched per node.
- `nodefile::String`: Location of the nodefile.
- `rif_strategy::String`: Launch mode of the workflow infrastructure. Accepts `ssh` for distributing the workers across multiple nodes or `local` for running on the localhost only.

See also [`PetriNet`](@ref), [`generate_workflow`](@ref), [`compile_workflow`](@ref).
"""
function client(workers::Int, nodefile::String, rif_strategy::String)
  run(`touch $nodefile`)
  if rif_strategy=="local"
    write(nodefile, gethostname())
    # ToDo: add an else condition for the nodefile
  end
  worker = string("worker:", workers)
  gspc_home = string("--gspc-home=", readchomp(`spack location -i gpi-space`))
  nodefile = string("--nodefile=", nodefile)
  rif_strategy = string("--rif-strategy=", rif_strategy)
  # app_search_path = string("--application-search-path=", ENV["GSPC_APPLICATION_SEARCH_PATH"])
  app_search_path = string("--application-search-path=", config["workflow_path"])
  client_config = string(gspc_home, " " , app_search_path, " ", nodefile, " ", rif_strategy, " --worker-env-copy-current")

  DistributedWorkflow.Client(worker, client_config)
end

"""
    input_pair(port_name::String, path::String)
Convenience key-value pair wrapper for function signature clarity and readability.

# Arguments
- `port_name::String`: Name of the port to contain the path string.
- `path::String`: Path to an input data file.

See also [`PetriNet`](@ref), [`generate_workflow`](@ref), [`compile_workflow`](@ref), [`port_info`](@ref).
"""
input_pair(port_name::String, path::String) = KeyValuePair(port_name, path)

"""
    implementation(port_name::String, path::String)
Convenience key-value pair wrapper for function signature clarity and readability.

# Arguments
- `port_name::String`: Name of the port to contain the path string.
- `path::String`: Path to a julia source file.

See also [`PetriNet`](@ref), [`generate_workflow`](@ref), [`compile_workflow`](@ref), [`port_info`](@ref).
"""
implementation(port_name::String, path::String) = KeyValuePair(port_name, path)

"""
    port_info(KV)
Wrapper function for KeyValuePair.

"""
function port_info(KV)
  port = CxxWrap.CxxWrapCore.dereference_argument(DistributedWorkflow.get_port(KV))
  value = CxxWrap.CxxWrapCore.dereference_argument(DistributedWorkflow.get_value(KV))

  return port, value
end

"""
    submit_workflow(client, workflow, input_params::Vector)
Submit a configured workflow to a client instance.

# Arguments
- `client`: A workflow client instance.
- `workflow`: A configured workflow object.
- `input_params::Vector`: List of inputs for the workflow execution.

See also [`PetriNet`](@ref), [`generate_workflow`](@ref), [`compile_workflow`](@ref).
"""
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

"""
    workflow_config(workflow::String, output_dir::String, app_config::Application_config)
Configures a workflow for execution by a client instance.

# Arguments
- `workflow::String`: Name of the workflow.
- `output_dir::String`: Location to store any output data generated during the workflow execution.
- `app_config::Application_config`: Application configuration for the workflow exeuction.

See also [`PetriNet`](@ref), [`generate_workflow`](@ref), [`compile_workflow`](@ref).
"""
function workflow_config(workflow::String, output_dir::String, app_config::Application_config)
  run(`mkdir -p $output_dir`)
  portname = app_config.port
  executor_file = joinpath(pkgdir(DistributedWorkflow), "utils/executor.jl")
  workflow_cfg = [DistributedWorkflow.implementation(portname, "julia $executor_file $(app_config.impl) $(app_config.fname) $output_dir")]

  workflow_config = StdVector(workflow_cfg)
  workflow_path = joinpath(DistributedWorkflow.config["workflow_path"], workflow)
  DistributedWorkflow.Workflow(workflow_path, workflow_config)
end

"""
    workflow_config(workflow::String, output_dir::String, app_config::Vector{Application_config})
Configures a workflow for execution by a client instance.

# Arguments
- `workflow::String`: Name of the workflow.
- `output_dir::String`: Location to store any output data generated during the workflow execution.
- `app_config::Vector{Application_config}`: List of application configurations for the workflow exeuction.

See also [`PetriNet`](@ref), [`generate_workflow`](@ref), [`compile_workflow`](@ref).
"""
function workflow_config(workflow::String, output_dir::String, app_config::Vector{Application_config})
  run(`mkdir -p $output_dir`)
  executor_file = joinpath(pkgdir(DistributedWorkflow), "utils/executor.jl")
  n = length(app_config)
  workflow_cfg = Vector{DistributedWorkflow.KeyValuePairAllocated}(undef, n)
  for i in 1:n
    portname = app_config[i].port
    workflow_cfg[i] = DistributedWorkflow.implementation(portname, "julia $executor_file $(app_config[i].impl) $(app_config[i].fname) $output_dir")
  end
  workflow_config = StdVector(workflow_cfg)
  workflow_path = joinpath(DistributedWorkflow.config["workflow_path"], workflow)
  DistributedWorkflow.Workflow(workflow_path, workflow_config)
end

"""
    workflow_config(workflow::String, output_dir::String, app_config::Application_config_many)
Configures a workflow for execution by a client instance.

# Arguments
- `workflow::String`: Name of the workflow.
- `output_dir::String`: Location to store any output data generated during the workflow execution.
- `app_config::Application_config_many`: Application configurations for the workflow exeuction.

See also [`PetriNet`](@ref), [`generate_workflow`](@ref), [`compile_workflow`](@ref).
"""
function workflow_config(workflow::String, output_dir::String, app_config::Application_config_many)
  run(`mkdir -p $output_dir`)
  executor_file = joinpath(pkgdir(DistributedWorkflow), "utils/executor.jl")
  n = length(app_config.ports)
  m = length(app_config.fnames)
  @assert n == m "The number of $(app_config.ports) should match the number of $(app_config.fnames), since each port gets a function name in the order they occur in the struct."
  workflow_cfg = Vector{DistributedWorkflow.KeyValuePairAllocated}(undef, n)
  for i in 1:n
    impl = ""
    if length(app_config.impl) == 1
      impl = app_config.impl[1]
    else
     impl = app_config.impl[i]
    end
    portname = app_config.ports[i]
    fname = app_config.fnames[i]
    workflow_cfg[i] = DistributedWorkflow.implementation(portname, "julia $executor_file $(impl) $fname $output_dir")
  end

  workflow_config = StdVector(workflow_cfg)
  workflow_path = joinpath(DistributedWorkflow.config["workflow_path"], workflow)
  DistributedWorkflow.Workflow(workflow_path, workflow_config)
end
