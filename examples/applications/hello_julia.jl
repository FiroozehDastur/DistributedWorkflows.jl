# Be mindful of types that can be serialised by a specific serialiser
function test_func(In1, In2)
  a1 = In1; # when using pure Julia serializer
  a2 = In2; # when using pure Julia serializer
  str = ["if you are reading this, then your application worked..."]
  arr = [a1, a2]
  g = gcd(arr)
  ar = [(In1, In2, a1, a2, g)] # test for N2M* transition
  return [str, ar]
end
