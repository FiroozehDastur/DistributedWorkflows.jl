# Available Features

This documentation is divided into two main sections:

- **Public API** — methods from GPI-Space made accessible in Julia.
- **Workflow** — tools and utilities for defining, compiling, and visualizing workflows.

---

## Public API

This section presents a collection of methods originating from GPI-Space (the underlying workflow management system) and made accessible in Julia through simple wrappers.

For functionality related to workflow generation, see the Workflow section below.

```@meta
CurrentModule = DistributedWorkflows
```

```@autodocs
Modules = [DistributedWorkflows]
Pages = ["wrapper.jl"]
```

## Workflow

This section documents the workflow-related API: generation, compilation, rendering, and XML export.


```@autodocs
Modules = [DistributedWorkflows]
Pages = ["petri_net.jl", "workflow_compiler.jl", "workflow_renderer.jl", "xml_generator.jl"]
```
