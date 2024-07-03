pn = PetriNet("aggregate_sum")

p1 = place("sum", :control_init)
p2 = place("values")
t1 = transition("Reduce")

connect(pn, [(p1, :inout), (p2, :in)], t1)

workflow_generator(pn)
