using Oscar, Serialization
function Serialization.serialize(filename::String, value)
    Oscar.save(filename, value)
end
    
function Serialization.deserialize(filename::String)
    Oscar.load(filename)
end
  
function test_oscar_impl(In1, In2)
    # In1 = deserialize(In1)
    # In2 = deserialize(In2)
    a1 = In1 + 42;
    a2 = In2 * 9;
    str = ["if you are reading this, then your application worked..."]
    arr = [a1, a2]
    g = gcd(arr)
    ar = [(In1, In2, a1, a2, g)] # test for N2M transition
    return [str, ar]
end