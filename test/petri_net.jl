include("mocked_functions.jl")
# test functions related to petri nets
@testset "Petri net generation" begin
  pn = PetriNet("hello_jl")
  @test typeof(pn) == PetriNet
  @test fieldcount(typeof(pn)) == 5
  @test pn.name == "hello_jl"
  @test isempty(pn.arcs) == true
  @test isempty(pn.places) == true
  @test isempty(pn.ports) == true
  @test isempty(pn.transitions) == true

  # test for places, transitions, arcs, connect, remove, port,
end

@testset "Workflow viewer" begin
  # test for view_workflow()

end

@testset "Workflow compiler" begin

  # test for workflow_generator, compile_workflow. Probably requires mock tests
end
