using Serialization, Revise, Markdown

data = Vector()
for i in 1:length(ARGS)
    push!(data, parse(Int, ARGS[i]))
end

function create_input(insert_data::Vector)
    n = length(insert_data)
    Out_files = Vector()
    for i in 1:n
        out_file = string("/home/agaf/JLAPI/julia_gpispace/prototype/examples/prototype2/output_files/test_output_file_",i, "_",time_ns())
        serialize(out_file, insert_data[i])
        push!(Out_files, out_file)
    end
    return Out_files
end

create_input(data)

function test_input_files(in_vec::Vector)
    n = length(in_vec)
    out_files = Vector()
    for i in 1:n
        out_file = string("/home/agaf/JLAPI/julia_gpispace/prototype/examples/prototype1/output_files/input_file_", i, "_",time_ns())
        serialize(out_file, in_vec[i])
        push!(out_files, out_file)
    end
    return out_files
end