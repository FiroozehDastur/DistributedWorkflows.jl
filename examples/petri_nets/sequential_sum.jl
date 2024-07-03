pn = PetriNet("aggregate_sum")

p1 = place("value")
p2 = place("sum")
t = transition("Reduce")

connect(pn, [(p1, :in), (p2, :out)], t)

connect(pn, [(p1, :in), (p2, :out)])

workflow_generator(pn)
