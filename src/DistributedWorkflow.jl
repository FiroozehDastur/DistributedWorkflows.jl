module DistributedWorkflow
  using CxxWrap, LightXML, Markdown, Serialization, TOML
  import Pkg
  export application_config,
         arc,
         client,
         compile_workflow, 
         connect,
         create_xpnet,
         function_name, 
         implementation, 
         input_pair, 
         julia_implementation, 
         output_dir,
         PetriNet, 
         place,
         port,
         port_info,
         remove,
         set_workflow_env, 
         submit_workflow, 
         transition,
         workflow_config,
         workflow_generator
  
  include("config.jl")
  include("cxxwrap_calls.jl")
  include("petri_net.jl")
  include("workflow_compiler.jl")
  include("wrapper.jl")
  include("xml_generator.jl")

  # function to determine version number at compile time
  function _get_version()
    return VersionNumber(Pkg.TOML.parsefile(joinpath(dirname(@__DIR__), "Project.toml"))["version"])
  end
  const pkg_version = _get_version()

  # Banner printing that respects the -q and --banner flag
  allowbanner = Base.JLOptions().banner
  if !(allowbanner == 0)
    function print_banner()
      println("                _          ___      | DistributedWorkflow - a task-based distributed")
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
