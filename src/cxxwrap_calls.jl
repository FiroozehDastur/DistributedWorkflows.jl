# Initiate a GPI-Space instance
function initiate_connection(path_to_lib::String)
    @wrapmodule(() -> joinpath(path_to_lib, "libDistributedWorkflow.so"), :define_module_interface)
    
    function __init__()
      @initcxx
    end
  end
  