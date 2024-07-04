using HDF5, Serialization
function Serialization.serialize(filename::String, value)
    # jldsave(filename; val=value)
    h5write(filename, "val", value)
end
    
function Serialization.deserialize(filename::String)
    # JLD2.load(filename)["val"]
    h5read(filename, "val")
end
  
function test_hdf5_impl(In1, In2)
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