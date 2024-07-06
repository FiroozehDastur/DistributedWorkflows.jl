# ================================================================
# hello julia Petri net using JLD2 serializer
# ================================================================
using DistributedWorkflow, CxxWrap, JLD2

# Change the paths to locate the files according to system settings
include("/path/to/DistributedWorkflow.jl/examples/other_serializers/jld2/workflow.jl")

tmp_dir = joinpath(@__DIR__, "tmp")
DistributedWorkflow.compile_workflow(joinpath(tmp_dir, "hello_julia_jld2.xpnet"))

# new version
impl_port = "implementation_1"
jl_impl = "/path/to/DistributedWorkflow.jl/examples/other_serializers/jld2/application.jl"
fname = "test_jld2_impl"
app = DistributedWorkflow.application_config(impl_port, jl_impl, fname)
out_dir = joinpath(tmp_dir, "output_dir_hello_jld2")

workflow_N2M_jl = DistributedWorkflow.workflow_config("hello_julia_jld2.pnet", out_dir, app)

input_1 = DistributedWorkflow.input_pair("input_file1", "/path/to/DistributedWorkflow.jl/examples/serialized_data/int1_julia_jld2fmt")

input_2 = DistributedWorkflow.input_pair("input_file2", "/path/to/DistributedWorkflow.jl/examples/serialized_data/int2_julia_jld2fmt")

input_vars = [input_1, input_2];

client = DistributedWorkflow.client(1, joinpath(tmp_dir, "nodefile"), "local", "localhost", 6789)

submit_func = DistributedWorkflow.submit_workflow(client, workflow_N2M_jl, input_vars)
