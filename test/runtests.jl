# [test/runtests.jl]
using DistributedWorkflow
using Test, Mocking

# Test scripts
include("foo_test.jl")
include("petri_net.jl")
# include("config_tests.jl")
