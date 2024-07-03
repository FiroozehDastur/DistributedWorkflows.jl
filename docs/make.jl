using Documenter, DistributedWorkflow

makedocs(
    sitename = "DistributedWorkflow.jl",
    format = Documenter.HTML(prettyurls = false),
    pages = [
        "Introduction" => "index.md",
        "API" => "api.md"
        "Application Design" => "application.md"
        "Designing Workflows" => "workflow.md"
        "Local Testing" => "local_launch.md"
        "Serialization" => "serialization.md"
        "Examples" => "examples.md"
        "Troubleshooting" => "troubleshooting.md"
    ]
)

deploydocs(
    repo = "github.com/FiroozehDastur/DistributedWorkflow.jl",
    devbranch = "main"
)