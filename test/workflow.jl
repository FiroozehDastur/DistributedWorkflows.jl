@testset "Workflow related unit tests" begin
    # A Petri net with 2 input places and 2 output places
    pn = Workflow_PetriNet("test_net")
    @test fieldcount(Workflow_PetriNet) == 5
    p1 = place("input_file1")
    p2 = place("input_file2")
    p3 = place("output_file1")
    p4 = place("output_file2")
    t = transition("hello_jl")

    connect(pn,[(p1, :in),(p2, :in),(p3, :out), (p4, :out)], t)
    connect(pn, p1, :in)
    connect(pn, p2, :in)
    connect(pn, p3, :out)
    connect(pn, p4, :out)
    @test pn.name == "test_net"
    @test length(pn.arcs) == 4
    @test length(pn.places) == 4
    @test length(pn.ports) == 4
    @test length(pn.transitions) == 1

    remove(pn, p1)
    @test length(pn.arcs) == 3
    @test length(pn.places) == 3
    @test length(pn.ports) == 3
    @test length(pn.transitions) == 1

    connect(pn, p1, :in)
    connect(pn,[(p1, :in)], t)
    @test length(pn.arcs) == 4
    @test length(pn.places) == 4
    @test length(pn.ports) == 4
    @test length(pn.transitions) == 1

    path = joinpath(@__DIR__, "tmp/")
    wf = generate_workflow(pn, path)
    vw = view_workflow(pn, path)
    @test isfile(joinpath(path, "test_net.xpnet")) == true
    @test isfile(joinpath(path, "test_net.png")) == true

    @test compile_workflow(joinpath(path, "test_net.xpnet")) === nothing
    
end
