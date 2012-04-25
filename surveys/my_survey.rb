survey "My Survey" do

  section "Section 1" do
    label "This is Section 1 of 'My Survey'"

    q_1 "What is your favorite color?", :pick => :one
    a_1 "red"
    a_2 "blue"
    a_3 "green"
    a_4 "yellow"
    a_5 :other

	end

  section "Section 2" do
    label "This is Section 2 of 'My Survey'"

    q_2 "What colors do you like?", :pick => :any
    a_1 "red"
    a_2 "blue"
    a_3 "green"
    a_4 "yellow"

	end
end

