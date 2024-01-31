# ================================================================
# hello julia Petri net
# ================================================================
using DistributedWorkflow, CxxWrap
initiate_connection()

compile_workflow("/root/zeda-examples/hello_julia/hello_julia.xpnet", "/root/tmp/build_dir")
client = client_init(1, "/root/tmp/nodefile", "local")#, "localhost", 6789)
impl_path = "./utils/executor.jl"
impl = implementation("implementation", impl_path)

jl_impl = julia_implementation("julia_impl", "./examples/applications/hello_julia.jl")

fname = function_name("fname", "test_func")

out_dir = output_dir("output_dir", "/root/tmp/output_dir_hello")

workflow_N2M_jl = Workflow("hello_julia.pnet", StdVector([impl, jl_impl, fname, out_dir]))

input_1 = input_pair("input_file1", "/root/DistributedWorkflow.jl/examples/serialized_data/int1_julia_nativefmt")

input_2 = input_pair("input_file2", "/root/DistributedWorkflow.jl/examples/serialized_data/int2_julia_nativefmt")

input_vars = StdVector([input_1, input_2]);

submit_func = submit_workflow(client, workflow_N2M_jl, input_vars)
