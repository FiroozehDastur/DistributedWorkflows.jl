import Pkg; Pkg.activate("../")
using Documenter, DistributedWorkflow

makedocs(
    modules = [DistributedWorkflow],
    sitename = "DistributedWorkflow.jl",
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
    repo = "github.com/FiroozehDastur/DistributedWorkflow.jl",
    devbranch = "main"
)