# ================================================================
# hello julia Petri net
# ================================================================
using DistributedWorkflow, CxxWrap

# Change the paths to locate the files according to system settings
include("/path/to/DistributedWorkflow.jl/examples/petri_nets/hello_julia_net.jl")

tmp_dir = joinpath(@__DIR__, "tmp")
DistributedWorkflow.compile_workflow(joinpath(tmp_dir, "hello_julia.xpnet"))
client = DistributedWorkflow.client(1, joinpath(tmp_dir, "nodefile"), "local", "localhost", 6789)

# new version
impl_port = "implementation_1"
jl_impl = "/path/to/DistributedWorkflow.jl/examples/applications/hello_julia.jl"
fname = "test_func"
app = DistributedWorkflow.application_config(impl_port, jl_impl, fname)
out_dir = joinpath(tmp_dir, "output_dir_hello")

workflow_N2M_jl = DistributedWorkflow.workflow_config("hello_julia.pnet", out_dir, app)

input_1 = DistributedWorkflow.input_pair("input_file1", "/path/to/DistributedWorkflow.jl/examples/serialized_data/int1_julia_nativefmt")

input_2 = DistributedWorkflow.input_pair("input_file2", "/path/to/DistributedWorkflow.jl/examples/serialized_data/int2_julia_nativefmt")

input_vars = [input_1, input_2];

submit_func = DistributedWorkflow.submit_workflow(client, workflow_N2M_jl, input_vars)
