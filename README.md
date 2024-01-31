# DistributedWorkflow.jl - A Julia interface to a distributed task-based workflow management system

[![CI](https://github.com/FiroozehDastur/DistributedWorkflow.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/FiroozehDastur/DistributedWorkflow.jl/actions/workflows/CI.yml)
[![codecov](https://codecov.io/gh/FiroozehDastur/DistributedWorkflow.jl/graph/badge.svg?token=9JIYL7YJYK)](https://codecov.io/gh/FiroozehDastur/DistributedWorkflow.jl)
[![](https://img.shields.io/badge/docs-stable-blue.svg)](http://bjack205.github.io/DistributedWorkflow.jl/dev)


# How to cite DistributedWorkflow.jl
Please cite this package as follows if you use it in your work:

```
@misc{DistributedWorkflow,
  author    = {Dastur, Firoozeh and Zeyen, Max and Rahn, Mirko},
  title     = {DistributedWorkflow.jl - A Julia interface to a distributed 
               task-based workflow management system},
  year     = {2024},
  month    = {January},
  howpublished     = {\url{https://github.com/FiroozehDastur/DistributedWorkflow.jl}}
}
```

## Installation
> **Note**
Detailed instructions on the installation will follow soon.

* Install 
* spack
  - Spack - Getting Started
  - Spack - Basic Usage

* DistributedWorkflow.jl
  - add instructions to install this package

## How to use DistributedWorkflow.jl
> **Note**
Detailed instructions on the usage, as well as more examples, will follow soon.

Before starting a Julia session, please set the following environment variable:
```export GSPC_APPLICATION_SEARCH_PATH=$HOME/.distributedworkflow/workflows```

Next, when testing the application locally set the hostname as follows:
```hostname > <path-to-a-nodefile>```

Start a Julia session and load the package with ```using DistributedWorkflow``` and initiate the connection by using the following function:
```initiate_connection()```

Assuming that you have a workflow Petri net stored in an accessible location, use ```compile_workflow(<workflow-name>.xpnet, "/path/to/build/location")``` function to compile the workflow.

Next, start the client using ```client(<number-of-workers>, "/path/to/nodefile", "rif-strategy")```

As a next step, it is advisible to create a script with your workflow configuration (see the executor files in the examples folder), and submit your application using the ```submit_workflow()``` function.

Once your application runs through, the output files will be stored in your desired output location.


## See also
* [More Examples]( ./examples)
* [XPNET Format Schema](https://github.com/cc-hpc-itwm/gpispace/blob/v23.06/share/xml/xsd/pnet.xsd)
* [GPI-Space database on Petri nets](https://github.com/cc-hpc-itwm/gpispace/tree/v23.06/share/doc/example)

## ToDo...
* Add example for a cluster run
* Improve UI
* Extend the interface 


# Appendix
The underlying workflow management system is called (GPI-Space)[https://www.gpi-space.de/] which is a a task-based workflow management system for parallel applications developed at Fraunhofer ITWM by the CC-HPC group.
# References
* (GPI-Space)[https://www.gpi-space.de/]
