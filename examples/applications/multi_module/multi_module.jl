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
  
    ran = rand(Int, N);
    # ran = [4,16,6,70,18,10];
    str = ["Sanity check # 1: random integers are generated."];
    # str = [length(ran) - 1]
    return [str, ran], [length(str), length(ran)] #[1,2,3,4]# ran
  end
  
  # this is fname1
  function gcd_N(a, b)
    # a_de = deserialise(a)
    # b_de = deserialise(b)
    g = 1
    in_vec = [a, b]
    if !(1 in in_vec)
      g = gcd(in_vec)
    end
    # san_check = [string("this is a sanity check: ", in_vec)]
    res = [g]
    return [res], [length(res)]
  end
  
  # this is fname2
  function result_gcd(final_result)
    str = ["Sanity check # 2: application worked..."]
    res = [final_result]
    return [str, res], [length(str), length(res)]
  end
  
  # =================================================================
  # Currently type SetElem cannot be serialized using Oscar serialiser
  # Be mindful of types that can be serialised by a specific serialiser
  # for example: the Oscar serialiser
  # for testing.xpnet workflow
  # =================================================================
  function gcd_computation(In0, In1, In2, In3, In4)
    str = ["if you are reading this, then your application worked..."]
    arr = [In0, In1, In2, In3, In4]
    g = 1
    if !(1 in arr)
      i1 = arr[1]
      i2 = arr[2]
      g = gcd(i1, i2)
      if length(arr) >= 3
        for i in 3:length(arr)
          g = gcd(g, arr[i])
        end
      end
    end
    san_check = [string("this is a sanity check: ", arr)]  
    ar = [(arr, g)]
    return [san_check, ar], [length(san_check), length(ar)]
  end
   