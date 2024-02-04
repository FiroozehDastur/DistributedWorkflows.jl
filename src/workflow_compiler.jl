# workflow -> absolute path to the xpnet file
# build_dir -> path to build directory
function compile_workflow(workflow::String, build_dir::String)
  source_dir = joinpath(readchomp(`spack location -i gspcdriver`), "share/zeda-gspcdriver/utils")
  install_dir = DistributedWorkflow.config["workflow_path"]
  # compile
  run(`cmake -D WORKFLOW=$workflow -B $build_dir -S $source_dir`)
  # build
  run(`cmake --build $build_dir -j 8`)
  # install
  run(`cmake --install $build_dir --prefix $install_dir`)
  # cleanup
  run(`rm -rf $build_dir`)
  println("Success: Workflow compiled")
end
