module DistributedWorkflow
using CxxWrap, Formatting, Serialization
  # export # functions from the driver file
  export initiate_connection

#   include("cxxwrap_calls.jl")
  include("wrapper.jl")
end # module
