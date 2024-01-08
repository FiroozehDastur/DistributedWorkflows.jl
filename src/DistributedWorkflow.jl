module DistributedWorkflow
using CxxWrap

greet() = print("Hello World!")

include("foo.jl")
end # module
