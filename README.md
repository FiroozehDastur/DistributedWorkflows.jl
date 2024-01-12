# DistributedWorkflow.jl - a Julia interface to a task-based workflow manager system for parallel applications

[![CI](https://github.com/FiroozehDastur/DistributedWorkflow.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/FiroozehDastur/DistributedWorkflow.jl/actions/workflows/CI.yml)
[![codecov](https://codecov.io/gh/FiroozehDastur/DistributedWorkflow.jl/graph/badge.svg?token=9JIYL7YJYK)](https://codecov.io/gh/FiroozehDastur/DistributedWorkflow.jl)
[![](https://img.shields.io/badge/docs-stable-blue.svg)](http://bjack205.github.io/DistributedWorkflow.jl/dev)

<!-- # DistributedWorkflow.jl-Interface to task-based workflow manager -->

## Abstract

In this talk, we present a serializer-independent interface to a task-based workflow management system. This package aims at simplifying the process of writing a distributed application. Given a workflow pattern as a Petri net and the code for the tasks in the workflow, DistributedWorkflow.jl can be used with a cluster manager, like Slurm, to automate the application. Hence, DistributedWorkflow.jl will be an invaluable addition to the growing high-performance computing packages in Julia.

## Description
Introduction to parallel computing
* Parallelism in Julia
* hpc is becoming an interesting side in julia package developement.
* Likewise, Julia gaining traction in the hpc community.
* DistributedWorkflow.jl - a Julia interface to a task-based workflow manager system for parallel applications.
* How to use? a simple example demo
* How the package will grow? a more complex example
* What to look forward to next?

## Installation
* spack
  - Spack - Getting Started
  - Spack - Basic Usage

* julia package
  - ```spack install distributed-workflow```
  - see the appendix for different variants of this package.

* DistributedWorkflow.jl
  - Open a julia REPL and go to the package env
  - add ```github repo```
  - activate package

## How to use DistributedWorkflow.jl
* Add hostname is a share location to use in the project: ```hostname > nodefile```
* write and compile your Petri net
* ```using DistributedWorkflow```
* Prepare your input parameters
* Prepare workflow code
* initiate connection to gpispace and it's client
* launch an executor script 

## See also
* [More Examples]( ./examples)
* [XPNET Format Schema](https://github.com/cc-hpc-itwm/gpispace/blob/v23.06/share/xml/xsd/pnet.xsd)
* [GPI-Space database on Petri nets](https://github.com/cc-hpc-itwm/gpispace/tree/v23.06/share/doc/example)

## ToDo...
* Adding new features.
* Improving API and UI.
* Add new examples.

# How to cite DistributedWorkflow.jl
Please cite this package as follows if you use it in your Julia application:

```
@misc{DistributedWorkflow,
  author    = {Dastur, Firoozeh and Zeyen, Max and Rahn, Mirko},
  title     = {DistributedWorkflow.jl - a Julia interface to a task-based 
               workflow manager system for parallel applications},
  year     = {2024},
  month    = {January},
  howpublished     = {\url{https://github.com/FiroozehDastur/DistributedWorkflow.jl}}
}
```

# Appendix
## Spack variants of DistributedWorkflow.jl
If you only need the package and don't want to install julia then use ```[+|~]julia``` to enable or disable installing julia. This feature is enabled by default.

At the moment DistributedWorkflow.jl is using GPI-Space as the underlying workflow management system, which has a couple of variants. The first one is the GSPC monitor and the next one is the IML. The following options can be used to enable or disable the respective features. 

### GSPC Monitor
The ```gspc-monitor``` application for execution monitoring is based on and requires Qt5. 

* Use ```[+|~]monitor``` to enable or disable this feature. This feature is enabled by default.

<!-- ### IML
The Independent Memory Layer (```IML```) is an abstraction layer for easy distributed memory management, allowing applications to cache data, or to prepare and extract data independent of GPI-Space across runs. 

* Use ```[+|~]iml``` to enable or disable this feature. This feature is enabled by default. -->
