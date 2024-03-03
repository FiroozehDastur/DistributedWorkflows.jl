# A Petri net with 2 input places and one output place
pn = PetriNet("hello_julia")
p1 = place("input1", :string)
p2 = place("input2", :string)
p3 = place("output_result", :string)
t = transition("initial_transition")

connect(pn,[(p1, :in),(p2, :read),(p3, :out_many)], t)
connect(pn, p1, :in)
connect(pn, p2, :in)
connect(pn, p3, :out)

workflow_generator(pn)
