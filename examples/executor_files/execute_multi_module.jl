# ================================================================
# multi-module Petri net
# ================================================================
using DistributedWorkflow, CxxWrap

# Test it out
# Change the paths to locate the files according to system settings
include("/root/DistributedWorkflow.jl/examples/petri_nets/multi_module_net.jl")# add code for multi_module.jl

DistributedWorkflow.compile_workflow("/root/tmp/multi_module.xpnet")
# client = client(1, "/path/to/nodefile", "local")

# impl_path = "/path/to/DistributedWorkflow/utils/executor.jl"
impl_port0 = "implementation0"
impl_port1 = "implementation1"

jl_impl = "/root/DistributedWorkflow.jl/examples/applications/multi_module.jl"

fname0 = "test_func_1"
fname1 = "test_func_2"

app = DistributedWorkflow.application_config([impl_port0, impl_port1], jl_impl, [fname0, fname1])
out_dir = "/root/tmp/output_dir_mm"

workflow_mm_jl = DistributedWorkflow.workflow_config("multi_module.pnet", out_dir, app)
 
input_mm = input_pair("input_file", "/root/DistributedWorkflow.jl/examples/serialized_data/int0_julia_nativefmt")

input_var = [input_mm];

submit_func = DistributedWorkflow.submit_workflow(client, workflow_mm_jl, input_var)