function _exec(cmd::Base.AbstractCmd, input="")
    in_pipe = Pipe()
    out_pipe = Pipe()
    err_pipe = Pipe()

    process = run(pipeline(cmd, stdin=in_pipe, stdout=out_pipe, stderr=err_pipe), wait=false)
    close(out_pipe.in)
    close(err_pipe.in)

    stdout = @async String(read(out_pipe))
    stderr = @async String(read(err_pipe))
    write(in_pipe, input)
    close(in_pipe)
    wait(process)
    if process isa Base.ProcessChain
        exitcode = maximum([p.exitcode for p in process.processes])
    else
        exitcode = process.exitcode
    end

    return (stdout = fetch(stdout), stderr = fetch(stderr), code = exitcode)
end
