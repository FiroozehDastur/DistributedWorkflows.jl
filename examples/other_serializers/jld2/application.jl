using JLD2, Serialization
function Serialization.serialize(filename::String, value)
    jldsave(filename; val=value)
end
    
function Serialization.deserialize(filename::String)
    JLD2.load(filename)["val"]
end
  
function test_jld2_impl(In1, In2)
    a1 = In1 + 42;
    a2 = In2 * 9;
    str = ["if you are reading this, then your application worked..."]
    arr = [a1, a2]
    g = gcd(arr)
    ar = [(In1, In2, a1, a2, g)] # test for N2M transition
    return [str, ar]
end