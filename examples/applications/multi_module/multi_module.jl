# julia implementation file
# using Hecke
# using Oscar
# function Serialization.serialize(filename::String, value)
#   save(filename, value)
# end
  
# function Serialization.deserialize(filename::String)
#   load(filename)
# end

# this is fname0
function gen_N(N)
    T = typeof(N)
    if T==String
      N = parse(Int, N)
    end
  
    ran = [rand(Int, N)];
    str = ["Sanity check # 1: random integers are generated."];
    return [str, ran]
  end
  
  # this is fname1
  function gcd_computation(arr)
    g = gcd(arr)
    san_check = [string("this is the final sanity check: ", arr)]  
    ar = [(arr, g)]
    return [san_check, ar]
  end
