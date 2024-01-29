# ================================================================
# two-two Petri net
# ================================================================
using DistributedWorkflow
initiate_connection()

compile_workflow("/path/to/zeda-examples/hello_julia/hello_julia.xpnet", "/path/to/build_dir")
client = DistributedWorkflow.client(1, "/path/to/nodefile", "local")
impl_path = "/path/to/DistributedWorkflow.jl/utils/executor.jl"
impl = DistributedWorkflow.implementation("implementation", impl_path)

jl_impl = julia_implementation("julia_impl", "/path/to/examples/applications/hello_julia.jl")

fname = function_name("fname", "test_func")

out_dir = output_dir("output_dir", "/path/to/output_dir")

workflow_N2M_jl = Workflow("hello_julia.pnet", StdVector([impl, jl_impl, fname, out_dir]))

input_1 = input_pair("input_file1", "/path/to/examples/serialized_data/int1_julia_nativefmt")

input_2 = input_pair("input_file2", "/path/to/examples/serialized_data/int2_julia_nativefmt")

input_vars = StdVector([input_1, input_2]);

submit_func = submit_workflow(client, workflow_N2M_jl, input_vars)
