# reading command line arguments
@assert length(ARGS) >= 2 "There should be 2 or more command line arguments"
julia_impl = ARGS[1]
fname = ARGS[2]

if length(ARGS) > 2
    input_file = Vector{String}()
    for i in 3:length(ARGS)
        push!(input_file, ARGS[i])
    end
end

# jl_executor
include(julia_impl)
const f = getfield(Main, Symbol(fname))

In = Vector()
for i in 1:length(input_file)
   push!(In, deserialize(input_file[i]))
end

# execute file
output = f(In...)
multiplicity = map(x -> length(x), output)

# create output files and store data in serialised form
out_file_list = Vector{Vector{String}}()
for i in 1:length(output)
    push!(out_file_list, [])
    for j in 1:multiplicity[i]
        out_file = string("/home/agaf/JLAPI/julia_gpispace/prototype/examples/prototype2/output_files/output_file_", fname, "_", i,"_", j,"_",time_ns())
        push!(out_file_list[i], out_file)
        serialize(out_file_list[i][j], output[i][j])
    end
end

println("################################# YOUR OUTPUT FILES ARE #################################")
for i in 1:length(out_file_list)
    println(length(out_file_list[i]))
    for j in 1:length(out_file_list[i])
        println(out_file_list[i][j])
    end
end
