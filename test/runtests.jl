# [test/runtests.jl]
using DistributedWorkflows, Test

function check_dependency()
  try
    readchomp(`spack location -i distributedworkflow`)
    return true
  catch e
    if e isa Base.IOError
      return false
    else
      rethrow(e)
    end
  end
end

include("workflow.jl")
include("wrapper.jl")
