# import Pkg; Pkg.activate("./docs")
using Documenter, DistributedWorkflows

makedocs(
    modules = [DistributedWorkflows],
    sitename = "DistributedWorkflows.jl",
    format = Documenter.HTML(prettyurls = true),
    pages = [
        "Introduction" => "index.md",
        "Available Features" => "api.md",
        "Serialization" => "./Serialization/custom_serializer.md",
        "Troubleshooting" => "troubleshooting.md"
    ]
)


deploydocs(
    repo = "github.com/FiroozehDastur/DistributedWorkflows.jl.git",
)
