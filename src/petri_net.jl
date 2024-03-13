# =============================================================================
# Creation of type Place for Petri nets
# =============================================================================
struct Place
  name::String
  type::Symbol
end

"""
    place(name::String)
    place(name::String, type::Symbol)
Creates an object of type Place for the Petri net object.
Note: acceptable place types are:
  :string, :control, :control_init, :counter

Also, note that an input or output place cannot be of type :control.

# Examples
```julia-repl
julia> place("new_place", :string)
Place "new_place" created.

julia> place("in_place", :control)
Place "in_place" with control token created.
```

See also [`transition`](@ref), [`arc`](@ref), [`port`](@ref), [`PetriNet`](@ref), [`connect`](@ref), [`remove`](@ref).
"""
function place(name::String, token_type::Symbol=:string)
  possible_tokens = [:string, :control, :counter, :control_init]
  if !(token_type in possible_tokens)
    error("Token type \":$(token_type)\" invalid. Please provide either :string, :control, :control_init, or :counter as a token type.")
  end
  Place(name, token_type)
end

function Base.show(io::IO, P::Place)
  if P.type in [:control, :control_init]
    return println(io,"Place \"$(P.name)\" with control token created.")
  elseif P.type == :counter 
    return println(io,"Place \"$(P.name)\" with counter created.")
  else
    return println(io,"Place \"$(P.name)\" created.")
  end
end

# =============================================================================
# Creation of type Transition for Petri nets
# =============================================================================
struct Transition
  name::String
  condition::String
  type::Symbol
end

"""
    transition(name::String)
    transition(name::String, type::Symbol, condition::String)
Creates an object of type Transition for the Petri net object. If a condition string is given, the the transition is a condiational transition.

Note: the condition string should be a regex.


# Examples
```julia-repl
julia> transition("transition1")
Transition "transition1" created.

julia> transition("do_stuff", "counter :eq: 0UL")
A conditional transition "do_stuff" created.

```

See also [`place`](@ref), [`arc`](@ref), [`PetriNet`](@ref), [`connect`](@ref), [`remove`](@ref), [`map_transition`](@ref), [`reduce_transition`](@ref), [`mapreduce_transition`](@ref), [`counter_transition`](@ref).
"""
function transition(name::String, type::Symbol=:mod, condition::String="")
  if type == :mod
    Transition(name, condition, type)
  elseif type == :exp
    Transition(name, condition, type)
  else
    error("Possible transition types are :exp or :mod")
  end
end



# ToDo: Add special transitions with counter, parallel-reduce, and weighted transitions
"""
    parallel_reduce_transition(name::String, condition::String)
Creates an object of type Transition for the Petri net.

# Examples
```julia-repl
julia> transition("transition1")
Transition "transition1" created.
```

See also [`place`](@ref), [`arc`](@ref), [`PetriNet`](@ref), [`connect`](@ref), [`remove`](@ref), [`map_transition`](@ref), [`transition`](@ref), [`mapreduce_transition`](@ref), [`counter_transition`](@ref).
"""
# function parallel_reduce_transition(name::String, condition::String="")
#   type = :reduce
# end

"""
    counter_transition(name::String, count::Symbol, n::Int, condition::String)
Creates an object of type Transition for the Petri net.

# Examples
```julia-repl
julia> transition("transition1")
Transition "transition1" created.
```

See also [`place`](@ref), [`arc`](@ref), [`PetriNet`](@ref), [`connect`](@ref), [`remove`](@ref), [`map_transition`](@ref), [`reduce_transition`](@ref), [`mapreduce_transition`](@ref), [`transition`](@ref).
"""
# function counter_transition(name::String, count::Symbol, n::Int, condition::String="")
#   type = :counter
# # count == :up, :down
# end

"""
    weighted_transition(name::String, weight::Int, condition::String)
Creates an object of type Transition for the Petri net.

# Examples
```julia-repl
julia> transition("transition1")
Transition "transition1" created.
```

See also [`place`](@ref), [`arc`](@ref), [`PetriNet`](@ref), [`connect`](@ref), [`remove`](@ref), [`map_transition`](@ref), [`reduce_transition`](@ref), [`mapreduce_transition`](@ref), [`transition`](@ref).
"""
# function weighted_transition(name::String, weight::Int, condition::String="")
#   return Transition(name, condition, Symbol(weight))
# end

function Base.show(io::IO, T::Transition)
  if isempty(T.condition)
    return println(io,"Transition \"$(T.name)\" created.")
  else
    return println(io,"A conditional transition \"$(T.name)\" created.")
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
Note: acceptable arcs are one of the following:
    :in, :read, :inout, :out, :out_many

# Examples
```julia-repl
julia> p1 = place("place1", "input_place")
Place "place1" created.


julia> t1 = transition("transition1")
Transition "transition1" created.


julia> arc(p1, t1, :in)
An arc of type "in", connecting the place: place1 to the transition: transition1.

```

See also [`place`](@ref), [`transition`](@ref), [`PetriNet`](@ref), [`connect`](@ref), [`remove`](@ref).
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
# Creating ports for Petri nets
# =============================================================================
struct Port
  name::String
  type::Symbol
  place::Place
end

"""
    port(type::Symbol, place::Place)
Creates a port connecting to the given place with respect to the arc type.
Note: the allowed port types are one of the following:
    :in, :out, :inout

# Examples
```julia-repl
julia> p1 = place("input1", :string)
Place "input1" created.


julia> port(:in, p1)
A port of type "in" connected to place "input1".

```

See also [`place`](@ref), [`PetriNet`](@ref), [`connect`](@ref), [`remove`](@ref).
"""
function port(type::Symbol, place::Place)
  possible_ports = [:in, :out, :inout]
  if !(type in possible_ports)
    error("The port type should match one of the following types:\n :in, :out, or :inout.")
  end
  if !(place.type == :string)
    error("Invalid place type. Place needs to be of type :string.")
  end
  
  Port(place.name, type, place)
end

function Base.show(io::IO, x::Port)
  return println(io,"A port of type \"$(x.type)\" connected to place \"$(x.place.name)\".")
end

# =============================================================================
# Creating Petri nets
# =============================================================================
"""
    PetriNet(workflow_name::String)
A struct creating an empty Petri net named: "workflow_name". Throws an error, if workflow name is not provided.

Use the `connect()` function to populate the Petri net, and `remove()` function to remove Petri net components.


# Examples
```julia-repl
julia> pn = PetriNet("hello_julia")
A Petri net with name "hello_julia", having 0 ports, 0 places, and 0 transitions.


julia> p1 = place("input1", :string)
Place "input1" created.


julia> p2 = place("input2",:string)
Place "input2" created.


julia> p3 = place("output",:string)
Place "output" created.


julia> t = transition("trans")
Transition trans created.


julia> connect(pn, p1, t, :in)
A Petri net with name "hello_julia", having 0 ports, 1 places, and 1 transitions.


julia> connect(pn, p2, t, :read)
A Petri net with name "hello_julia", having 0 ports, 2 places, and 1 transitions.


julia> connect(pn, p3, t, :out_many)
A Petri net with name "hello_julia", having 0 ports, 3 places, and 1 transitions.


julia> connect(pn, p1, :in)
A Petri net with name "hello_julia", having 1 ports, 3 places, and 1 transitions.


julia> connect(pn, :in, p2)
A Petri net with name "hello_julia", having 2 ports, 3 places, and 1 transitions.


julia> connect(pn, :out, p3)
A Petri net with name "hello_julia", having 3 ports, 3 places, and 1 transitions.

```

See also [`place`](@ref), [`transition`](@ref), [`arc`](@ref), [`port`](@ref), [`connect`](@ref), [`remove`](@ref), [`workflow_generator`](@ref), [`compile_workflow`](@ref).
"""
struct PetriNet
  name::String
  places::Vector{Place}
  transitions::Vector{Transition}
  arcs::Vector{Arc}
  ports::Vector{Port}
  function PetriNet(name::String)
    if isempty(name)
      error("An empty string as Petri net name is not allowed. Please provide a name for the Petri net.")
    end
    new(name, [], [], [], [])
  end
end


function Base.show(io::IO, Pnet::PetriNet)
  k = length(Pnet.ports)
  n = length(Pnet.places)
  m = length(Pnet.transitions)
  return println(io,"A Petri net with name \"$(Pnet.name)\", having $k ports, $n places, and $m transitions.")
end

"""
    connect(pnet::PetriNet, place::Place, transition::Transition, arc_type::Symbol)
    connect(pnet::PetriNet, transition::Transition, place::Place, arc_type::Symbol)
Given a Petri net connects the place to the transition with the given arc type. 

# Examples
```julia-repl
# initiating an empty Petri net.
julia> pn = PetriNet("hello_julia")
A Petri net with name "hello_julia", having 0 ports, 0 places, and 0 transitions.


julia> p1 = place("input1", :string)
Place "input1" created.


julia> p2 = place("input2",:string)
Place "input2" created.


julia> p3 = place("output",:string)
Place "output" created.


julia> t = transition("transition1")
Transition "transition1" created.


julia> connect(pn, p1,t, :in)
A Petri net with name "hello_julia", having 0 ports, 1 places, and 1 transitions.


julia> connect(pn, p2,t, :read)
A Petri net with name "hello_julia", having 0 ports, 2 places, and 1 transitions.


julia> connect(pn, p3,t, :out_many)
A Petri net with name "hello_julia", having 0 ports, 3 places, and 1 transitions.


julia> connect(pn, p1, :in)
A Petri net with name "hello_julia", having 1 ports, 3 places, and 1 transitions.


julia> connect(pn, :in, p2)
A Petri net with name "hello_julia", having 2 ports, 3 places, and 1 transitions.


julia> connect(pn, :out, p3)
A Petri net with name "hello_julia", having 3 ports, 3 places, and 1 transitions.

```

See also [`place`](@ref), [`transition`](@ref), [`arc`](@ref), [`port`](@ref), [`PetriNet`](@ref), [`remove`](@ref).
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

connect(pnet::PetriNet, transition::Transition, place::Place, arc_type::Symbol) = connect(pnet, place, transition, arc_type)


"""
    connect(pnet::PetriNet, places_arcs::Vector{Tuple{Place, Symbol}}, transition::Transition)
    connect(pnet::PetriNet, transition::Transition, places_arcs::Vector{Tuple{Place, Symbol}})
Given a Petri net, connects the vector of tuples (places, arc_types) to the given transition. 

# Examples
```julia-repl
julia> pn = PetriNet("hello_julia")
A Petri net with name "hello_julia", having 0 ports, 0 places, and 0 transitions.


julia> p1 = place("input1", :string)
Place "input1" created.


julia> p2 = place("input2", :string)
Place "input2" created.


julia> p3 = place("output_result", :string)
Place "output_result" created.


julia> t = transition("initial_transition")
Transition "initial_transition" created.


julia> connect(pn,[(p1, :in),(p2, :read),(p3, :out_many)], t)
A Petri net with name "hello_julia", having 0 ports, 3 places, and 1 transitions.


```

See also [`place`](@ref), [`transition`](@ref), [`arc`](@ref), [`port`](@ref), [`PetriNet`](@ref), [`remove`](@ref).
"""
function connect(pnet::PetriNet, places_arcs::Vector{Tuple{Place, Symbol}}, transition::Transition)
  connect_list = Vector{Arc}()
  for (p, a) in places_arcs
    connect(pnet, p, transition, a)
  end
  return pnet
end

connect(pnet::PetriNet, transition::Transition, places_arcs::Vector{Tuple{Place, Symbol}}) = connect(pnet, places_arcs, transition)


"""
    connect(pnet::PetriNet, place::Place, port::Port)
    connect(pnet::PetriNet, port::Port, place::Place)
Given a Petri net, connects the given place to the given port. 

# Examples
```julia-repl
julia> pn = PetriNet("hello_julia")
A Petri net with name "hello_julia", having 0 ports, 0 places, and 0 transitions.


julia> p1 = place("input1", :string)
Place "input1" created.


julia> p2 = place("input2", :string)
Place "input2" created.


julia> p3 = place("output_result", :string)
Place "output_result" created.


julia> t = transition("initial_transition")
Transition "initial_transition" created.


julia> connect(pn,[(p1, :in),(p2, :read),(p3, :out_many)], t)
A Petri net with name "hello_julia", having 0 ports, 3 places, and 1 transitions.


julia> connect(pn, p1, :in)
A Petri net with name "hello_julia", having 1 ports, 3 places, and 1 transitions.


julia> connect(pn, p2, :in)
A Petri net with name "hello_julia", having 2 ports, 3 places, and 1 transitions.


julia> connect(pn, p3, :out)
A Petri net with name "hello_julia", having 3 ports, 3 places, and 1 transitions.

```

See also [`place`](@ref), [`transition`](@ref), [`arc`](@ref), [`port`](@ref), [`PetriNet`](@ref), [`remove`](@ref).
"""
function connect(pnet::PetriNet, place::Place, port::Port)
  if !(place in pnet.places)
    push!(pnet.places, place)
  end
  if !(port in pnet.ports)
    push!(pnet.ports, port)
  end
  return pnet
end

connect(pnet::PetriNet, port::Port, place::Place) = connect(pnet, place, port) 

"""
    connect(pnet::PetriNet, port_type::Symbol, place::Place)
    connect(pnet::PetriNet, place::Place, port_type::Symbol)
Given a Petri net, connects the given place to a port of name port_name and type port_type. 

# Examples
```julia-repl
julia> pn = PetriNet("hello_julia")
A Petri net with name "hello_julia", having 0 ports, 0 places, and 0 transitions.


julia> p1 = place("input1", :string)
Place "input1" created.


julia> p2 = place("input2", :string)
Place "input2" created.


julia> p3 = place("output_result", :string)
Place "output_result" created.


julia> t = transition("initial_transition")
Transition "initial_transition" created.


julia> connect(pn,[(p1, :in),(p2, :read),(p3, :out_many)], t)
A Petri net with name "hello_julia", having 0 ports, 3 places, and 1 transitions.

julia> prt = port(:in, p1)
A port of type "in", connected to place "input1".


julia> connect(pn, p1, prt)
A Petri net with name "hello_julia", having 1 ports, 3 places, and 1 transitions.


```

See also [`place`](@ref), [`transition`](@ref), [`arc`](@ref), [`port`](@ref), [`PetriNet`](@ref), [`remove`](@ref).
"""
function connect(pnet::PetriNet, port_type::Symbol, place::Place)
  pt = port(port_type, place)
  return connect(pnet, place, pt)
end

connect(pnet::PetriNet, place::Place, port_type::Symbol) = connect(pnet, port_type, place)

"""
    connect(pnet::PetriNet, place_port::Vector{Tuple{Place, Symbol}})
    connect(pnet::PetriNet, port_place::Vector{Tuple{Symbol, Place}})
Given a Petri net, connects the given places to a port of name port_name and type port_type. 

See also [`place`](@ref), [`transition`](@ref), [`arc`](@ref), [`port`](@ref), [`PetriNet`](@ref), [`remove`](@ref).
"""
function connect(pnet::PetriNet, place_port::Vector{Tuple{Place, Symbol}})
  for (p, s) in place_port
    connect(pnet, p, s)
  end
  return pnet
end

function connect(pnet::PetriNet, port_place::Vector{Tuple{Symbol, Place}})
  for (s, p) in place_port
    connect(pnet, p, s)
  end
  return pnet
end


"""
    remove(pnet::PetriNet, place::Place)
Remove the place from the given Petri net.  

# Examples
```julia-repl
julia> pn = PetriNet("hello_julia")
A Petri net with name "hello_julia", having 0 ports, 0 places, and 0 transitions.


julia> p1 = place("input1", :string)
Place "input1" created.


julia> p2 = place("input2", :string)
Place "input2" created.


julia> p3 = place("output_result", :string)
Place "output_result" created.


julia> t = transition("initial_transition")
Transition "initial_transition" created.


julia> connect(pn,[(p1, :in),(p2, :read),(p3, :out_many)], t)
A Petri net with name "hello_julia", having 0 ports, 3 places, and 1 transitions.


julia> connect(pn, p1, :in)
A Petri net with name "hello_julia", having 1 ports, 3 places, and 1 transitions.


julia> connect(pn, p2, :in)
A Petri net with name "hello_julia", having 2 ports, 3 places, and 1 transitions.


julia> connect(pn, p3, :out)
A Petri net with name "hello_julia", having 3 ports, 3 places, and 1 transitions.


julia> pn.places
3-element Vector{DistributedWorkflow.Place}:
 Place "input1" created.

 Place "input2" created.

 Place "output_result" created.


julia> remove(pn, p1)
A Petri net with name "hello_julia", having 2 ports, 2 places, and 1 transitions.


julia> pn.places
2-element Vector{DistributedWorkflow.Place}:
 Place "input2" created.

 Place "output_result" created.


```

See also [`place`](@ref), [`transition`](@ref), [`arc`](@ref), [`port`](@ref), [`PetriNet`](@ref), [`connect`](@ref).
"""
function remove(pnet::PetriNet, place::Place)
  if place in pnet.places
    deleteat!(pnet.places, findall(x->x==place, pnet.places))
  end
  arc_list = []
  for i in 1:length(pnet.arcs)
    arc = pnet.arcs[i]
    if place == arc.place
      push!(arc_list, arc)
    end
  end
  for a in arc_list
    deleteat!(pnet.arcs, findall(x->x==a, pnet.arcs))
  end
  port_list = []
  for i in 1:length(pnet.ports)
    prt = pnet.ports[i]
    if place == pnet.ports[i].place
      push!(port_list, prt)
    end
  end
  for pt in port_list
    deleteat!(pnet.ports, findall(x->x==pt, pnet.ports))
  end
  return pnet
end

"""
    remove(pnet::PetriNet,  transition::Transition)
Remove the transition from the given Petri net.  

# Examples
```julia-repl
julia> pn = PetriNet("hello_julia")
A Petri net with name "hello_julia", having 0 ports, 0 places, and 0 transitions.


julia> p1 = place("input1", :string)
Place "input1" created.


julia> p2 = place("input2", :string)
Place "input2" created.


julia> p3 = place("output_result", :string)
Place "output_result" created.


julia> t = transition("initial_transition")
Transition "initial_transition" created.


julia> connect(pn,[(p1, :in),(p2, :read),(p3, :out_many)], t)
A Petri net with name "hello_julia", having 0 ports, 3 places, and 1 transitions.


julia> connect(pn, p1, :in)
A Petri net with name "hello_julia", having 1 ports, 3 places, and 1 transitions.


julia> connect(pn, p2, :in)
A Petri net with name "hello_julia", having 2 ports, 3 places, and 1 transitions.


julia> connect(pn, p3, :out)
A Petri net with name "hello_julia", having 3 ports, 3 places, and 1 transitions.


julia> pn.transitions
1-element Vector{DistributedWorkflow.Transition}:
 Transition "initial_transition" created.


julia> remove(pn, t)
A Petri net with name "hello_julia", having 2 ports, 2 places, and 0 transitions.


julia> pn.transitions
DistributedWorkflow.Transition[]


```

See also [`place`](@ref), [`transition`](@ref), [`arc`](@ref), [`port`](@ref), [`PetriNet`](@ref), [`connect`](@ref).
"""
function remove(pnet::PetriNet, transition::Transition)
  if transition in pnet.transitions
    deleteat!(pnet.transitions, findall(x->x==transition, pnet.transitions))
  end
  arc_list = []
  for i in 1:length(pnet.arcs)
    arc = pnet.arcs[i]
    if transition == arc.transition
      push!(arc_list, arc)
    end
  end
  for a in arc_list
    deleteat!(pnet.arcs, findall(x->x==a, pnet.arcs))
  end
  return pnet
end

"""
    remove(pnet::PetriNet, arc::Arc)
Remove the arc from the given Petri net.  

# Examples
```julia-repl
julia> pn = PetriNet("hello_julia")
A Petri net with name "hello_julia", having 0 ports, 0 places, and 0 transitions.


julia> p1 = place("input1", :string)
Place "input1" created.


julia> p2 = place("input2", :string)
Place "input2" created.


julia> p3 = place("output_result", :string)
Place "output_result" created.


julia> t = transition("initial_transition")
Transition "initial_transition" created.


julia> connect(pn,[(p1, :in),(p2, :read),(p3, :out_many)], t)
A Petri net with name "hello_julia", having 0 ports, 3 places, and 1 transitions.


julia> connect(pn, p1, :in)
A Petri net with name "hello_julia", having 1 ports, 3 places, and 1 transitions.


julia> connect(pn, p2, :in)
A Petri net with name "hello_julia", having 2 ports, 3 places, and 1 transitions.


julia> connect(pn, p3, :out)
A Petri net with name "hello_julia", having 3 ports, 3 places, and 1 transitions.


julia> a1 = arc(p1,t,:in)
An arc of type "in", connecting the place: input1 to the transition: initial_transition.


julia> pn.arcs
3-element Vector{DistributedWorkflow.Arc}:
 An arc of type "in", connecting the place: input1 to the transition: initial_transition.

 An arc of type "read", connecting the place: input2 to the transition: initial_transition.

 An arc of type "out_many", connecting the place: output_result to the transition: initial_transition.


julia> remove(pn, a1)
A Petri net with name "hello_julia", having 3 ports, 3 places, and 1 transitions.


julia> pn.arcs
2-element Vector{DistributedWorkflow.Arc}:
 An arc of type "read", connecting the place: input2 to the transition: initial_transition.

 An arc of type "out_many", connecting the place: output_result to the transition: initial_transition.


```

See also [`place`](@ref), [`transition`](@ref), [`arc`](@ref), [`port`](@ref), [`PetriNet`](@ref), [`connect`](@ref).
"""
function remove(pnet::PetriNet, arc::Arc)
  if arc in pnet.arcs
    deleteat!(pnet.arcs, findall(x->x==arc, pnet.arcs))
  end
  return pnet
end

"""
    remove(pnet::PetriNet, port::Port)
Remove the port from the given Petri net.  

# Examples
```julia-repl
julia> pn = PetriNet("hello_julia")
A Petri net with name "hello_julia", having 0 ports, 0 places, and 0 transitions.


julia> p1 = place("input1", :string)
Place "input1" created.


julia> p2 = place("input2", :string)
Place "input2" created.


julia> p3 = place("output_result", :string)
Place "output_result" created.


julia> t = transition("initial_transition")
Transition "initial_transition" created.


julia> connect(pn,[(p1, :in),(p2, :read),(p3, :out_many)], t)
A Petri net with name "hello_julia", having 0 ports, 3 places, and 1 transitions.


julia> connect(pn, p1, :in)
A Petri net with name "hello_julia", having 1 ports, 3 places, and 1 transitions.


julia> connect(pn, p2, :in)
A Petri net with name "hello_julia", having 2 ports, 3 places, and 1 transitions.


julia> connect(pn, p3, :out)
A Petri net with name "hello_julia", having 3 ports, 3 places, and 1 transitions.


julia> pn.ports
3-element Vector{DistributedWorkflow.Port}:
 A port of type "in" connected to place "input1".

 A port of type "in" connected to place "input2".

 A port of type "out" connected to place "output_result".


julia> prt = port(:in, p1)
A port of type "in" connected to place "input1".


julia> remove(pn, prt)
A Petri net with name "hello_julia", having 2 ports, 3 places, and 1 transitions.


julia> pn.ports
2-element Vector{DistributedWorkflow.Port}:
 A port of type "in" connected to place "input2".

 A port of type "out" connected to place "output_result".


```

See also [`place`](@ref), [`transition`](@ref), [`arc`](@ref), [`port`](@ref), [`PetriNet`](@ref), [`connect`](@ref).
"""
function remove(pnet::PetriNet, port::Port)
  if port in pnet.ports
    deleteat!(pnet.ports, findall(x->x==port, pnet.ports))
  end
  return pnet
end

# =============================================================================
# Petri net viewer using GraphViz
# =============================================================================
"""
    workflow_viewer(pnet::PetriNet, file_format::Symbol=:png, path::String="")
By default this method generates a png file after compiling the Petri net into an XML workflow and compiling the workflow.
If path is not given then the workflow image is stored in your home directory in \"tmp\" folder.
Note: supported file formats: :png, :svg


# Examples
```julia-repl


```
"""
# function workflow_viewer(pnet::PetriNet, file_format::Symbol=:png, path::String="")
#   install_dir = DistributedWorkflow.config["workflow_path"]
#   xml_wf = workflow_generator(pn, path)
#   xml_location = joinpath(xml_wf.path, xml_wf.name)
#   compile_workflow(xml_location, path)
#   Graphviz.load()
#   pnet2dot /root/.distributedworkflow/workflows/hello_julia.pnet --signature=OFF | dot -Tjpg > /root/tmp/hello_julia.jpg
# end

# required packages GraphViz, FileIO, Cairo
# Make this optional dependency
# types required for Graphviz
# net shape => box
# transition => box but light blue
# places = ellipse
# arrow/arc styles:
#   in arc => normal
#   out arc => normal
#   inout arc => arrow head and arrow tail. If not possible then add one arrow in and one arrow out
#   read arc => dashed

struct XML_renderer
  net::PetriNet
  port::Dict
  place::Dict
  transition::Dict
  arc::Dict
  location::String
end

function render_net(pnet::PetriNet)
  # label: place.name, transition.name, port.name
  # nodes: place, transition, ports
  # shapes: places,transitions. ports
  # arrowhead styles: all arc styles
  labels = Dict{Symbol, String}()
  prt_nodes = Dict{}()
  # for p in pnet.ports
    
  p_nodes = Dict{}()
  t_nodes = Dict{}()
  shapes = Dict{}()
  arrows = Dict{}()
  for p in pnet.ports
    port_dict[p.name]
  end

  port_dict = Dict{String, Symbol}()
  for p in pnet.ports
    if p.type == :in
      port_dict[p] = :house
    elseif p.type == :out
      port_dict[p] = :invhouse
    else
      port_dict[p] = :diamond
    end
  end

  place_dict = Dict{Place, Symbol}()
  for p in pnet.places
    place_dict[p] = :ellipse
  end

  transition_dict = Dict{Transition, Symbol}()
  for t in pnet.transitions
    transition_dict[t] = :box
  end

  arc_dict = Dict{Arc, Symbol}()
  for a in pnet.arcs
    if a.type == :read
      arc_dict[a] = :dashed
    else
      arc_dict[a] = a.type
    end
  end

  return XML_renderer(pnet, port_dict, place_dict, transition_dict, arc_dict, "")
end

# using GraphViz

# gv = dot"""
# digraph G {
#     // Define nodes with different shapes and colors
#     node [shape=ellipse, style=filled, color=lightblue]
#     A [shape=box, color=lightpink]
#     B [shape=diamond, color=lightgreen]
#     C [shape=triangle, color=lightyellow]

#     // Define edges
#     A -> B
#     B -> C
#     C -> A
# }
# """
# FileIO.save("filename.png", gv)

# # Define your graph
# g = SimpleGraph(5)

# # Add some edges
# add_edge!(g, 1, 2)
# add_edge!(g, 2, 3)
# add_edge!(g, 3, 4)
# add_edge!(g, 4, 5)
# add_edge!(g, 5, 1)

# # Define node shapes and colors
# node_shapes = Dict(1 => "box", 2 => "ellipse", 3 => "diamond", 4 => "parallelogram", 5 => "triangle")
# node_colors = Dict(1 => "red", 2 => "green", 3 => "blue", 4 => "orange", 5 => "purple")

# # Generate DOT code
# dot_code = GraphViz.dot(g, node_attrs=Dict("shape" => node_shapes, "color" => node_colors))

# # Write DOT code to a file
# open("graph.dot", "w") do io
#     println(io, dot_code)
# end

# # Convert DOT code to an image
# run(`dot -Tpng -o graph.png graph.dot`)
