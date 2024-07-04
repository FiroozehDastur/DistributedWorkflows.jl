# ================================================================
# hello julia Petri net
# ================================================================
using DistributedWorkflow, CxxWrap

compile_workflow("/root/tmp/hello_julia.xpnet")
# new version
impl_port = "implementation_1"
jl_impl = "/root/DistributedWorkflow.jl/examples/applications/hello_julia.jl"
fname = "test_func"
app = DistributedWorkflow.application_config(impl_port, jl_impl, fname)
out_dir = "/root/tmp/output_dir_hello"

workflow_N2M_jl = DistributedWorkflow.workflow_config("hello_julia.pnet", out_dir, app)

input_1 = DistributedWorkflow.input_pair("input_file1", "/root/DistributedWorkflow.jl/examples/serialized_data/int1_julia_nativefmt")

input_2 = DistributedWorkflow.input_pair("input_file2", "/root/DistributedWorkflow.jl/examples/serialized_data/int2_julia_nativefmt")

input_vars = [input_1, input_2];
# no of workers per node should match --ntasks-per-node in the beehive_launch_scaript
client = client(1, ARG[1], "ssh", ARG[2], ARG[3])

DistributedWorkflow.submit_workflow(client, workflow_N2M_jl, input_vars)