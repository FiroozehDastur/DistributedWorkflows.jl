# ================================================================
# parallel_reduce Petri net
# ================================================================
using DistributedWorkflow
initiate_connection()

compile_workflow("/path/to/zeda-examples/parallel_reduce/parallel_reduce.xpnet", "/path/to/build_dir")
client = client(1, "/path/to/nodefile", "local")

impl = "/path/to/DistributedWorkflow/utils/executor.jl"
impl0 = implementation("implementation0", impl)
impl1 = implementation("implementation1", impl)
impl2 = implementation("implementation2", impl)

jl_impl = "/path/to/examples/applications/parallel_reduce.jl"
jl_impl0 = julia_implementation("julia_impl0", jl_impl)
jl_impl1 = julia_implementation("julia_impl1", jl_impl)
jl_impl2 = julia_implementation("julia_impl2", jl_impl)

fname0 = function_name("fname0", "gen_N")
fname1 = function_name("fname1", "gcd_N")
fname2 = function_name("fname2", "result_gcd")
workflow_gcd = Workflow("parallel_reduce.xpnet", StdVector([impl0, impl1, impl2, jl_impl0, jl_impl1, jl_impl2, fname0, fname1, fname2]))

# NOTE: make sure the input file is serialised...
input0 = input_pair("input_file", "/path/to/examples/serialized_data/int4_julia_nativefmt")

submit_func = submit_workflow(client, workflow_gcd, StdVector([input0]))
