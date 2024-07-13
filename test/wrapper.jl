@testset "Testing wrapper functions" begin
    @test fieldcount(DistributedWorkflows.Application_config) == fieldcount(DistributedWorkflows.Application_config_many)

    # client = DistributedWorkflows.client()# requires mocking

    impl_port = "implementation_1"
    path = joinpath(@__DIR__, "tmp")
    jl_impl = joinpath(path, "test.jl")
    fname = "test_func"
    app = DistributedWorkflows.application_config(impl_port, jl_impl, fname)
    @test app.fname == fname
    @test app.impl == jl_impl
    @test app.port == impl_port

    out_dir = joinpath(path,"tmp/output_dir")

    @test typeof(DistributedWorkflows.workflow_config("test_net.pnet", out_dir, app)) == DistributedWorkflows.WorkflowAllocated
    

    input_1 = DistributedWorkflows.input_pair("input_file1", joinpath(@__DIR__,"examples/serialized_data/int1_julia_nativefmt"))
    @test typeof(input_1) == DistributedWorkflows.KeyValuePairAllocated

    input_2 = DistributedWorkflows.input_pair("input_file2", joinpath(@__DIR__,"examples/serialized_data/int2_julia_nativefmt"))
    @test typeof(input_2) == DistributedWorkflows.KeyValuePairAllocated

    # @test submit_workflow()# requires mocking

end
