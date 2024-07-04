# ================================================================
# multi-module Petri net
# ================================================================
using DistributedWorkflow, CxxWrap

# Change the paths to locate the files according to system settings
include("/root/DistributedWorkflow.jl/examples/petri_nets/multi_module_net.jl")# add code for multi_module.jl

compile_workflow("/root/tmp/multi_module.xpnet")
# client = client(1, "/path/to/nodefile", "local")

impl_port0 = "implementation_1"
impl_port1 = "implementation_2"

jl_impl = "/root/DistributedWorkflow.jl/examples/applications/multi_module/multi_module.jl"

fname0 = "gen_N"
fname1 = "gcd_computation"

app = application_config([impl_port0, impl_port1], jl_impl, [fname0, fname1])
out_dir = "/root/tmp/output_dir_mm"

workflow_mm_jl = workflow_config("multi_module.pnet", out_dir, app)
 
input_mm = input_pair("input_file", "/root/DistributedWorkflow.jl/examples/serialized_data/int1_julia_nativefmt")

input_var = [input_mm];

submit_func_mm = submit_workflow(client, workflow_mm_jl, input_var)