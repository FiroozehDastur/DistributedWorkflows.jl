# ================================================================
# multi-module Petri net
# ================================================================
using DistributedWorkflow
initiate_connection()

compile_workflow("/path/to/zeda-examples/multi_module/multi_module.xpnet", "/path/to/build_dir")
client = DistributedWorkflow.client(1, "/path/to/nodefile", "local")

impl_path = "/path/to/DistributedWorkflow/utils/executor.jl"
impl0 = implementation("implementation0", impl_path)
impl1 = implementation("implementation1", impl_path)

jl_impl0 = julia_implementation("julia_impl0", "/path/to/examples/applications/multi_module/multi_module_1.jl")
jl_impl1 = julia_implementation("julia_impl1", "/path/to/examples/applications/multi_module/multi_module_2.jl")

fname0 = function_name("fname0", "test_func_1")
fname1 = function_name("fname1", "test_func_2")

workflow_mm_jl = Workflow("multi_module.xpnet", StdVector([impl0, impl1, jl_impl0, jl_impl1, fname0, fname1]))
 
input_mm = input_pair("input_file", "/path/to/examples/serialized_data/int0_julia_nativefmt")

input_var = StdVector([input_mm]);

submit_func = submit_workflow(client, workflow_mm_jl, input_var)