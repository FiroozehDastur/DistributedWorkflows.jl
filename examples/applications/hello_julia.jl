# Be mindful of types that can be serialised by a specific serialiser
# Here we use native Julia serializer
function test_func(In1, In2)
  a1 = In1 + 43;
  a2 = In2 - 76;
  str = ["if you are reading this, then your application worked..."]
  arr = [a1, a2]
  g = gcd(arr)
  ar = [(In1, In2, a1, a2, g)] # test for N2M* transition
  return [str, ar]
end
