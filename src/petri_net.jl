# a wrapper to create and compile Petri nets for managing workflow
# =============================================================================
# Creation of type Place for Petri nets
# =============================================================================
struct Place{T <: Union{AbstractString, Integer}}
  name::String
  token::T
end

"""
    place(name::String, token::Union{AbstractString, Unsigned, Integer})
Creates an object of type Place for the Petri net.

# Examples
```julia-repl
julia> place()

```
"""
function place(name::String, token::Union{AbstractString, Unsigned, Integer})
  if typeof(token)<:Integer && token < 0
    throw("Token value cannot be negative.")
  end
  Place(name, token)
end

function Base.show(io::IO, P::Place)
  return println(io,"Place with token type: $(typeof(P.token)).")
end

# =============================================================================
# Creation of type Transtion for Petri nets
# =============================================================================
struct Arc
  sym::Symbol
end

"""
    arc(A::Symbol)
Creates an object of type Arc that joins a place to a transition in a Petri net.

# Examples
```julia-repl
julia> arc()

```
"""
function arc(A::Symbol)
  Arc(A)
end

function Base.show(io::IO, A::Arc)
  return println(io,"")
end

struct Transition{T <: Union{Arc, Symbol}}
  name::String
  condition::String
  arcs::Vector{T}
end

"""
    transition(name::String, arcs::Vector{Arc} , condition::String)
Creates an object of type Transition for the Petri net.

# Examples
```julia-repl
julia> transition()

```
"""
function transition(name::String, arcs::Vector{Arc} , condition::String="")
  possible_arcs = [:in, :read, :inout, :out, :out_many]
  for arc in arcs
    if !(arc.sym in possible_arcs)
      throw("Arc $(arc) doesn't match any of the types acceptable by the Petri net.\n Please replace arc $(arc) with one of the following possible arcs: \n $(possible_arcs).")
    end
  end
  Transition(name, condition, arcs)
end

function Base.show(io::IO, T::Transition)
  if isempty(T.condition)
    return println(io,"A transition with $(length(T.arcs)) arcs.")
  else
    return println(io,"A conditional transition with $(length(T.arcs)) arcs.")
  end
end

# =============================================================================
# Creation of type Net as an elementary net for Petri nets
# =============================================================================
struct Net
  places::Vector{Place}
  transition::Transition
  relation::Vector{Tuple{Place, Arc}}
end

"""
    net(P::Vector{Place}, T::Transition)
Creates an object of type Net, which is an elementary net for the Petri net.

# Examples
```julia-repl
julia> net()

```
"""
function net(P::Vector{Place}, T::Transition) 
  @assert length(P) == length(T.arcs) "Number of places should match the number of arcs in transition $(T.name)."
  n = length(P)
  pt = Vector{Tuple{Place, Arc}}(undef, n)
  for i in 1:n
    pt[i] = P[i], T.arcs[i]
  end  
  Net(P, T, pt)
end

"""
    net(T::Transition, P::Vector{Place})
Creates an object of type Net, which is an elementary net for the Petri net.

# Examples
```julia-repl
julia> net()

```
"""
function net(T::Transition, P::Vector{Place})
  net(P, T)
end

function Base.show(io::IO, N::Net)
  P = Vector()
  for p in N.places
    push!(P, p.name)
  end
  return println(io,"An elementary net connecting place(s) $(P) to the transition $(N.transition.name).")
end

# =============================================================================
# Creating Petri nets
# =============================================================================
struct PetriNet
  places::Vector{Place}
  transitions::Vector{Transition}
end

"""
    PetriNet(workflow::Vector{Net})
Creates a Petri net object.

# Examples
```julia-repl
julia> Petri_net()

```
"""
function Petri_net(workflow::Vector{Net})

end

# =============================================================================
# Generate xml file from the Petri net 
# =============================================================================


# =============================================================================
# 
# =============================================================================

function __net(P::Place, T::Transition, A::Arc)
  return Connect(P, T, A)
end

function __net(P::Place, TA::Vector{Tuple{Transition, Arc}})
  flow_vector = []
  for (t, a) in TA
    push!(flow_vector, Connect(P, t, a))
  end

  return flow_vector
end

function __net(PA::Vector{Tuple{Place, Arc}}, T::Transition)
  flow_vector = []
  for (p, a) in PA
    push!(flow_vector, Connect(p, T, a))
  end

  return flow_vector
end

function __net(PT::Vector{Tuple{Place, Transition}}, A::Arc)
  flow_vector = []
  for (p, t) in PT
    push!(flow_vector, Connect(p, t, A))
  end

  return flow_vector
end
