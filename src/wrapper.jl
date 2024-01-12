include("./cxxwrap_calls.jl")
# using Serialization

# function initiate_connection(path_to_lib::String, client)

# end

input_pair(port_name::String, path::String) = KeyValuePair(port_name, path)

implementation(port_name::String, path::String) = KeyValuePair(port_name, path)

julia_implementation(port_name::String, path::String) = KeyValuePair(port_name, path)

function_name(port_name::String, path::String) = KeyValuePair(port_name, path)
