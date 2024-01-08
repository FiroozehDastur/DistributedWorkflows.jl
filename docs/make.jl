using Documenter, DistributedWorkflow

makedocs(
    sitename = "DistributedWorkflow.jl",
    format = Documenter.HTML(prettyurls = false),
    pages = [
        "Introduction" => "index.md",
        "API" => "api.md"
    ]
)

deploydocs(
    repo = "github.com/FiroozehDastur/DistributedWorkflow.jl",
    devbranch = "main"
)