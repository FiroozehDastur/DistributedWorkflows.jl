using Serialization

# reading command line arguments
@assert length(ARGS) >= 3 "There should be 3 or more configuration parameters"
julia_impl = ARGS[1]
fname = ARGS[2]
output_dir = ARGS[3]

if length(ARGS) > 3
    input_file = Vector{String}()
    for i in 4:length(ARGS)
        push!(input_file, ARGS[i])
    end
end

# executor
include(julia_impl)
const f = getfield(Main, Symbol(fname))

In = Vector()
for i in 1:length(input_file)
   push!(In, deserialize(input_file[i]))
end

output = f(In...)
multiplicity = map(x -> length(x), output)

out_file_list = Vector{Vector{String}}()
for i in 1:length(output)
    push!(out_file_list, [])
    for j in 1:multiplicity[i]
        out_file = joinpath(output_dir, string("output_file_", fname, "_", i,"_", j,"_",time_ns()))
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
