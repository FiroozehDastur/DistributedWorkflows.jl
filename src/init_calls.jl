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

function __init__()
  path = joinpath(ENV["HOME"], ".distributedworkflows")
  run(`mkdir -p $path`)

  config_file = joinpath(path, "config.toml")
  if !isfile(config_file)
    data = Dict(
                "version" => "0.1",
                "workflow_path" => joinpath(ENV["HOME"], ".distributedworkflows/workflows"),
    );
    open(config_file, "w") do io
      TOML.print(io, data)
    end
  end
  global config = TOML.parsefile(config_file)
  workflow_path = config["workflow_path"]
  run(`mkdir -p $workflow_path`)

  if check_dependency()    
    base_path = readchomp(`spack location -i distributedworkflow`)
    lib_path = joinpath(base_path, "lib")
    lib64_path = joinpath(base_path, "lib64")
    if isdir(lib_path)
      @wrapmodule(() -> joinpath(lib_path, "libzeda-distributedworkflow.so"), :define_module_interface)
    elseif isdir(lib64_path)
      @wrapmodule(() -> joinpath(lib64_path, "libzeda-distributedworkflow.so"), :define_module_interface)
    end
    @initcxx
  else
    @warn "Spack not found, will proceed without it.\nThis will cause an error while launching a client and submitting workflows."
  end
  
  # Banner printing that respects the -q and --banner flag
  allowbanner = Base.JLOptions().banner
  if !(allowbanner == 0)
    # package banner
    function print_banner()
      println("                _          ___      | DistributedWorkflows - a task-based distributed")
      println("               | |        /   \\     | workflow management system.")
      println("   ___         | |<----->(  \e[34mo\e[0m  )    |")
      println("  / \e[32mo\e[0m \\        | |        \\___/     | Version $(pkg_version) ...")
      println(" ( \e[31mo\e[0m \e[35mo\e[0m )------>| |         ___      | ... which comes with absolutely no warranty whatsoever.")
      println("  \\___/        | |        /   \\     |")
      println("               | |======>(     )    | by Firoozeh Dastur, Max Zeyen, and Mirko Rahn.")
      println("               |_|        \\___/     |")
    end
    print_banner()
  end
end
