# a wrapper to create and compile Petri nets for managing workflow
# =============================================================================
# Creation of type Place for Petri nets
# =============================================================================
struct Place{T <: Union{AbstractString, Symbol}}
  name::String
  type::T
end

"""
    place(name::String, token::Union{AbstractString, Symbol})
Creates an object of type Place for the Petri net.

# Examples
```julia-repl
julia> place("new_place", "input_place")
Place new_place created.

julia> place("place3",:control)
Place place3 with control token created.
```
"""
function place(name::String, token_type::Union{AbstractString, Symbol})
  if typeof(token_type) == Symbol && !(token_type == :control)
    error("A place with control token cannot be created. Please make sure your token type is the symbol :control.")
  end
  Place(name, token_type)
end

function Base.show(io::IO, P::Place)
  if typeof(P.type)==Symbol
    return println(io,"Place $(P.name) with control token created.")
  else
    return println(io,"Place $(P.name) created.")
  end
end

# =============================================================================
# Creation of type Transtion for Petri nets
# =============================================================================
struct Transition
  name::String
  condition::String
end

"""
    transition(name::String, condition::String)
Creates an object of type Transition for the Petri net.

# Examples
```julia-repl
julia> transition("transition1")
Transition transition1 created.
```
"""
function transition(name::String, condition::String="")
  Transition(name, condition)
end

function Base.show(io::IO, T::Transition)
  if isempty(T.condition)
    return println(io,"Transition $(T.name) created.")
  else
    return println(io,"A conditional transition $(T.name) created.")
  end
end

# =============================================================================
# Creation of type Arc for Petri nets
# =============================================================================
struct Arc
  place::Place
  transition::Transition
  type::Symbol
end

"""
    arc(place::Place, transition::Transition, type::Symbol)
Creates an object of type Arc that joins a place to a transition in a Petri net.

# Examples
```julia-repl
julia> p1 = place("place1", "input_place")
Place place1 created.


julia> t1 = transition("transition1")
Transition transition1 created.


julia> arc(p1,t1,:in)
An arc of type "in", connecting the place: place1 to the transition: transition1.

```
"""
function arc(place::Place, transition::Transition, arc_type::Symbol)
  possible_arcs = [:in, :read, :inout, :out, :out_many]
  if !(arc_type in possible_arcs) 
    error("Arc type doesn't match any of the types acceptable by the Petri net.\n Please replace the arc type \"$(arc_type)\" with one of the following possible arcs: \n $(possible_arcs).")
  end
  Arc(place, transition, arc_type)
end

function Base.show(io::IO, A::Arc)
  return println(io,"An arc of type \"$(A.type)\", connecting the place: $(A.place.name) to the transition: $(A.transition.name).")
end

# =============================================================================
# Creating Petri nets
# =============================================================================
struct PetriNet
  places::Vector{Place}
  transitions::Vector{Transition}
  arcs::Vector{Arc}
  
  PetriNet() = new([], [], [])
end

"""
connect(pnet::PetriNet, place::Place, transition::Transition, arc_type::Symbol)
Given a Petri net connects the place to the transition with the given arc type. 

# Examples
```julia-repl
# initiating an empty Petri net.
julia> net = PetriNet()
A Petri net with 0 places and 0 transitions.


julia> p1 = place("place1", "input_place")
Place place1 created.


julia> p2 = place("place2", "output_place")
Place place2 created.


julia> t1 = transition("transition1")
Transition transition1 created.


julia> connect(net, p1, t1, :in)
A Petri net with 1 places and 1 transitions.


julia> connect(net, p2, t1, :out)
A Petri net with 2 places and 1 transitions.


julia> net.places
2-element Vector{Place}:
 Place place1 created.

 Place place2 created.


julia> net.transitions
1-element Vector{Transition}:
 Transition transition1 created.


julia> net.arcs
2-element Vector{Arc}:
 An arc of type "in", connecting the place: place1 to the transition: transition1.

 An arc of type "out", connecting the place: place2 to the transition: transition1.


```
"""
function connect(pnet::PetriNet, place::Place, transition::Transition, arc_type::Symbol)
  connect_arc = arc(place, transition, arc_type)
  if !(connect_arc in pnet.arcs)
    push!(pnet.arcs, connect_arc)
    if !(place in pnet.places)
      push!(pnet.places, place)
    end
    if !(transition in pnet.transitions)
      push!(pnet.transitions, transition)
    end  
  end

  return pnet
end

"""
    connect(pnet::PetriNet, transition::Transition, place::Place, arc_type::Symbol)
Given a Petri net connects the place to the transition with the given arc type. 

# Examples
```julia-repl
# initiating an empty Petri net.
julia> net = PetriNet()
A Petri net with 0 places and 0 transitions.


julia> p1 = place("place1", "input_place")
Place place1 created.


julia> p2 = place("place2", "output_place")
Place place2 created.


julia> t1 = transition("transition1")
Transition transition1 created.


julia> connect(net, t1, p1, :in)
A Petri net with 1 places and 1 transitions.


julia> connect(net, t1, p2, :out)
A Petri net with 2 places and 1 transitions.


julia> net.places
2-element Vector{Place}:
 Place place1 created.

 Place place2 created.


julia> net.transitions
1-element Vector{Transition}:
 Transition transition1 created.


julia> net.arcs
2-element Vector{Arc}:
 An arc of type "in", connecting the place: place1 to the transition: transition1.

 An arc of type "out", connecting the place: place2 to the transition: transition1.


```
"""
function connect(pnet::PetriNet, transition::Transition, place::Place, arc_type::Symbol)
  return connect(pnet, place, transition, arc_type)
end

"""
    connect(pnet::PetriNet, places_arcs::Vector{Tuple{Place, Symbol}}, transition::Transition)
Given a Petri net, connects the vector of tuples (places, arc types) to the given transition. 

# Examples
```julia-repl
# initiating an empty Petri net.
julia> net = PetriNet()
A Petri net with 0 places and 0 transitions.


julia> p1 = place("place1", "input_place")
Place place1 created.


julia> p2 = place("place2", "output_place")
Place place2 created.


julia> p3 = place("place3",:control)
Place place3 with control token created.


julia> t1 = transition("transition1")
Transition transition1 created.


julia> connect(net, [(p1,:in), (p2,:out_many), (p3, :read)], t1)

julia> net.places
3-element Vector{Place}:
 Place place1 created.

 Place place2 created.

 Place place3 with control token created.


julia> net.transitions
1-element Vector{Transition}:
 Transition transition1 created.


julia> net.arcs
3-element Vector{Arc}:
 An arc of type "in", connecting the place: place1 to the transition: transition1.

 An arc of type "out_many", connecting the place: place2 to the transition: transition1.

 An arc of type "read", connecting the place: place3 to the transition: transition1.


```
"""
function connect(pnet::PetriNet, places_arcs::Vector{Tuple{Place, Symbol}}, transition::Transition)
  connect_list = Vector{Arc}()
  for (p, a) in places_arcs
    connect(pnet, p, transition, a)
  end
end

function Base.show(io::IO, Pnet::PetriNet)
  n = length(Pnet.places)
  m = length(Pnet.transitions)
  return println(io,"A Petri net with $n places and $m transitions.")
end

# =============================================================================
# Generate xml file from the Petri net 
# =============================================================================
"""
    create_xpnet(filename::String, pnet::PetriNet)
Given a Petri net anda path to an accessible location, creates and stores an xml Petri net.

# Examples
```julia-repl
julia> 


```
"""
# function create_xpnet(filename::String, pnet::PetriNet)


# end
