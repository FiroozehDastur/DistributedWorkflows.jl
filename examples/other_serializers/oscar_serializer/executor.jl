# ================================================================
# hello julia Petri net using Oscar serializer
# ================================================================
using DistributedWorkflow, CxxWrap, Oscar

# Change the paths to locate the files according to system settings
include("/path/to/DistributedWorkflow.jl/examples/other_serializers/oscar_serializer/workflow.jl")

tmp_dir = joinpath(@__DIR__, "tmp")
DistributedWorkflow.compile_workflow(joinpath(tmp_dir, "hello_julia_oscar.xpnet"))

# new version
impl_port = "implementation_1"
jl_impl = "/path/to/DistributedWorkflow.jl/examples/other_serializers/oscar_serializer/application.jl"
fname = "test_oscar_impl"
app = DistributedWorkflow.application_config(impl_port, jl_impl, fname)
out_dir = joinpath(tmp_dir, "output_dir_hello_oscar")

workflow_N2M_jl = DistributedWorkflow.workflow_config("hello_julia_oscar.pnet", out_dir, app)

input_1 = DistributedWorkflow.input_pair("input_file1", "/path/to/DistributedWorkflow.jl/examples/serialized_data/int1_julia_oscarfmt")

input_2 = DistributedWorkflow.input_pair("input_file2", "/path/to/DistributedWorkflow.jl/examples/serialized_data/int2_julia_oscarfmt")

input_vars = [input_1, input_2];

client = DistributedWorkflow.client(1, joinpath(tmp_dir, "nodefile"), "local", "localhost", 6789)

submit_func = DistributedWorkflow.submit_workflow(client, workflow_N2M_jl, input_vars)
