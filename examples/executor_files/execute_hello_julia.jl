# ================================================================
# hello julia Petri net
# ================================================================
using DistributedWorkflows

# Change the paths to locate the files according to system settings
include(joinpath(ENV["HOME"], "DistributedWorkflows.jl/examples/petri_nets/hello_julia_net.jl"))

tmp_dir = joinpath(ENV["HOME"], "tmp")
DistributedWorkflows.compile_workflow(joinpath(tmp_dir, "hello_julia.xpnet"))
client = DistributedWorkflows.client(1, joinpath(tmp_dir, "nodefile"), "local")
# client = DistributedWorkflows.client(1, joinpath(tmp_dir, "nodefile"), "local"), "localhost", 6789)

# new version
impl_port = "implementation_1"
jl_impl = joinpath(ENV["HOME"], "DistributedWorkflows.jl/examples/applications/hello_julia.jl")
fname = "test_func"
app = DistributedWorkflows.application_config(impl_port, jl_impl, fname)
out_dir = joinpath(tmp_dir, "output_dir_hello")

workflow_N2M_jl = DistributedWorkflows.workflow_config("hello_julia.pnet", out_dir, app)

input_1 = DistributedWorkflows.input_pair("input_file1", joinpath(ENV["HOME"], "DistributedWorkflows.jl/examples/serialized_data/int1_julia_nativefmt"))

input_2 = DistributedWorkflows.input_pair("input_file2", joinpath(ENV["HOME"], "DistributedWorkflows.jl/examples/serialized_data/int2_julia_nativefmt"))

input_vars = [input_1, input_2];

submit_func = DistributedWorkflows.submit_workflow(client, workflow_N2M_jl, input_vars)
