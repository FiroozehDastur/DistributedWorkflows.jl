import Pkg; Pkg.activate("../")
using Documenter, DistributedWorkflows

makedocs(
    modules = [DistributedWorkflows],
    sitename = "DistributedWorkflows.jl",
    format = Documenter.HTML(prettyurls = true),
    pages = [
        "Introduction" => "index.md",
        "API" => "api.md",
        "Cluster" => "./Cluster/cluster.md",
        "PetriNet" => "./PetriNet/PetriNet.md",
        "Scripting" => "./Scripting/scripting.md",
        "Serialization" => "./Serialization/custom_serializer.md"
    ]
)


deploydocs(
    repo = "github.com/FiroozehDastur/DistributedWorkflows.jl",
    devbranch = "main"
)