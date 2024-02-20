# a wrapper to create and compile Petri nets for managing workflow

struct Place
  P::String
end

struct Transition
  T::String
end

struct Join
  C::String
end

struct Flow
  place::Place
  transition::Transition
  connection::Join
end

function __half_net(P::Place, T::Transition, C::Join)
  return Flow(P, T, C)
end

function __half_net(P::Place, TC::Vector{Tuple{Transition, Join}})
  flow_vector = []
  for (t, c) in TC
    push!(flow_vector, Flow(P, t, c))
  end

  return flow_vector
end

function __half_net(PC::Vector{Tuple{Place, Join}}, T::Transition)
  flow_vector = []
  for (p, c) in PC
    push!(flow_vector, Flow(p, T, c))
  end

  return flow_vector
end

function __half_net(PT::Vector{Tuple{Place, Transition}}, C::Join)
  flow_vector = []
  for (p, t) in PT
    push!(flow_vector, Flow(p, t, C))
  end

  return flow_vector
end

# create a dictionary for the connection type
# connection types: IN = {in, read-only}, OUT = {out, out-many}, INOUT = {inout}

struct PetriNet
  places::Vector{Place}
  transitions::Vector{Transition}
  flow::Vector{Flow}
end

function Net(flow::Vector{Flow})
  net = Net()
  if flow==string(in)
    net.in = flow
  elseif
end



struct PetriNet
  places::Vector{Place}
  transitions::Vector{Transition}
  connections::Vector{Flow}

  function PetriNet
    return new()
  end
end

function PetriNet(P::Vector{String}, T::Vector{String}, C::Vector{Flow})

end
