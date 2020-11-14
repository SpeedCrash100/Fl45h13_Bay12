/obj/item/integrated_circuit/logic
	name = "logic gate"
	desc = "This tiny chip will decide for you!"
	extended_desc = "Logic circuits will treat a null, 0, and a \"\" string value as FALSE and anything else as TRUE."
	complexity = 3
	outputs = list("result")
	activators = list("compare", "on true result")
	category = /obj/item/integrated_circuit/logic

/obj/item/integrated_circuit/logic/do_work(var/activator_pin)
	if(activator_pin != activators[1])
		return

	var/datum/integrated_io/output/O = outputs[1]
	O.push_data()
	if(O.data)
		activate_pin(2)

/obj/item/integrated_circuit/logic/binary
	inputs = list("A","B")
	category = /obj/item/integrated_circuit/logic/binary

/obj/item/integrated_circuit/logic/binary/do_work()
	var/datum/integrated_io/A = inputs[1]
	var/datum/integrated_io/B = inputs[2]
	set_pin_data(IC_OUTPUT, 1, !!do_compare(A, B))
	..()

/obj/item/integrated_circuit/logic/binary/proc/do_compare(var/datum/integrated_io/A, var/datum/integrated_io/B)
	return FALSE

/obj/item/integrated_circuit/logic/unary
	inputs = list("A")
	category = /obj/item/integrated_circuit/logic/unary

/obj/item/integrated_circuit/logic/unary/do_work()
	var/datum/integrated_io/A = inputs[1]
	set_pin_data(IC_OUTPUT, 1, !!do_check(A))
	..()

/obj/item/integrated_circuit/logic/unary/proc/do_check(var/datum/integrated_io/A)
	return FALSE

/obj/item/integrated_circuit/logic/binary/equals
	name = "equal gate"
	desc = "This gate compares two values, and outputs the number one if both are the same."
	icon_state = "equal"

/obj/item/integrated_circuit/logic/binary/equals/do_compare(var/datum/integrated_io/A, var/datum/integrated_io/B)
	return A.get_data() == B.get_data()

/obj/item/integrated_circuit/logic/binary/and
	name = "and gate"
	desc = "This gate will output 'one' if both inputs evaluate to true."
	icon_state = "and"

/obj/item/integrated_circuit/logic/binary/and/do_compare(var/datum/integrated_io/A, var/datum/integrated_io/B)
	return A.get_data() && B.get_data()

/obj/item/integrated_circuit/logic/binary/or
	name = "or gate"
	desc = "This gate will output 'one' if one of the inputs evaluate to true."
	icon_state = "or"

/obj/item/integrated_circuit/logic/binary/or/do_compare(var/datum/integrated_io/A, var/datum/integrated_io/B)
	return A.get_data() || B.get_data()

/obj/item/integrated_circuit/logic/binary/less_than
	name = "less than gate"
	desc = "This will output 'one' if the first input is less than the second input."
	icon_state = "less_than"

/obj/item/integrated_circuit/logic/binary/less_than/do_compare(var/datum/integrated_io/A, var/datum/integrated_io/B)
	return A.get_data() < B.get_data()

/obj/item/integrated_circuit/logic/binary/less_than_or_equal
	name = "less than or equal gate"
	desc = "This will output 'one' if the first input is less than, or equal to the second input."
	icon_state = "less_than_or_equal"

/obj/item/integrated_circuit/logic/binary/less_than_or_equal/do_compare(var/datum/integrated_io/A, var/datum/integrated_io/B)
	return A.get_data() <= B.get_data()

/obj/item/integrated_circuit/logic/binary/greater_than
	name = "greater than gate"
	desc = "This will output 'one' if the first input is greater than the second input."
	icon_state = "greater_than"

/obj/item/integrated_circuit/logic/binary/greater_than/do_compare(var/datum/integrated_io/A, var/datum/integrated_io/B)
	return A.get_data() > B.get_data()

/obj/item/integrated_circuit/logic/binary/greater_than_or_equal
	name = "greater_than or equal gate"
	desc = "This will output 'one' if the first input is greater than, or equal to the second input."
	icon_state = "greater_than_or_equal"

/obj/item/integrated_circuit/logic/binary/greater_than_or_equal/do_compare(var/datum/integrated_io/A, var/datum/integrated_io/B)
	return A.get_data() >= B.get_data()

/obj/item/integrated_circuit/logic/unary/not
	name = "not gate"
	desc = "This gate inverts what's fed into it."
	icon_state = "not"

/obj/item/integrated_circuit/logic/unary/not/do_check(var/datum/integrated_io/A)
	return !A.get_data()

/obj/item/integrated_circuit/logic/multiplexer
	name = "multiplexer"
	desc = "This is what those in the business tend to refer to as a 'mux' or data selector. It moves data from one of the selected inputs to the output."
	extended_desc = "The first input pin is used to select which of the other input pins which has its data moved to the output. If the input selection is outside the valid range then no output is given."
	complexity = 2
	icon_state = "mux2"
	inputs = list("input selection")
	activators = list("select")
	category = /obj/item/integrated_circuit/logic
	var/number_of_inputs = 2

/obj/item/integrated_circuit/logic/multiplexer/New()
	for(var/i = 1 to number_of_inputs)
		inputs += "input [i]"
	complexity = number_of_inputs
	..()
	desc += " It has [number_of_inputs] input pins."
	extended_desc += " This multiplexer has a range from 1 to [inputs.len - 1]."

/obj/item/integrated_circuit/logic/multiplexer/do_work()
	var/input_index = get_pin_data(IC_INPUT, 1)
	var/output = null

	if(isnum(input_index) && (input_index >= 1 && input_index < inputs.len))
		output = get_pin_data(IC_INPUT, input_index + 1)
	set_pin_data(IC_OUTPUT, 1, output)

/obj/item/integrated_circuit/logic/multiplexer/medium
	number_of_inputs = 4
	icon_state = "mux4"

/obj/item/integrated_circuit/logic/multiplexer/large
	number_of_inputs = 8
	icon_state = "mux8"

/obj/item/integrated_circuit/logic/multiplexer/huge
	icon_state = "mux16"
	number_of_inputs = 16

/obj/item/integrated_circuit/logic/demultiplexer
	name = "demultiplexer"
	desc = "This is what those in the business tend to refer to as a 'demux'. It moves data from the input to one of the selected outputs."
	extended_desc = "The first input pin is used to select which of the output pins is given the data from the second input pin. If the output selection is outside the valid range then no output is given."
	complexity = 2
	icon_state = "dmux2"
	inputs = list("output selection","input")
	outputs = list()
	activators = list("select")
	category = /obj/item/integrated_circuit/logic
	var/number_of_outputs = 2

/obj/item/integrated_circuit/logic/demultiplexer/New()
	for(var/i = 1 to number_of_outputs)
		outputs += "output [i]"
	complexity = number_of_outputs

	..()
	desc += " It has [number_of_outputs] output pins."
	extended_desc += " This demultiplexer has a range from 1 to [outputs.len]."

/obj/item/integrated_circuit/logic/demultiplexer/do_work()
	var/output_index = get_pin_data(IC_INPUT, 1)
	var/output = get_pin_data(IC_INPUT, 2)

	for(var/i = 1 to outputs.len)
		set_pin_data(IC_OUTPUT, i, i == output_index ? output : null)

/obj/item/integrated_circuit/logic/demultiplexer/medium
	icon_state = "dmux4"
	number_of_outputs = 4

/obj/item/integrated_circuit/logic/demultiplexer/large
	icon_state = "dmux8"
	number_of_outputs = 8

/obj/item/integrated_circuit/logic/demultiplexer/huge
	icon_state = "dmux16"
	number_of_outputs = 16

/obj/item/integrated_circuit/logic/unary/access_verifier
	name = "access verification"
	desc = "This circuit checks if the given input access fulfills the current access requirements."
	icon_state = "access_check"
	var/list/checked_accesses
	var/list/available_accesses
	var/requires_one = FALSE
	var/locked = TRUE
	var/last_configurator = ""
	inputs = list("accesses")

	category = /obj/item/integrated_circuit/logic/unary/access_verifier
	var/cached_ui_data

/obj/item/integrated_circuit/logic/unary/access_verifier/New()
	..()
	checked_accesses = list()
	available_accesses = available_accesses || list()

/obj/item/integrated_circuit/logic/unary/access_verifier/station/New()
	available_accesses = get_all_station_access()
	..()

/obj/item/integrated_circuit/logic/unary/access_verifier/attack_self(var/mob/user)
	ui_interact(user)

/obj/item/integrated_circuit/logic/unary/access_verifier/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = hands_state)
	var/list/data = ui_data()

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "airlock_electronics.tmpl", src.name, 1000, 500, null, null, state)
		ui.set_initial_data(data)
		ui.open()

/obj/item/integrated_circuit/logic/unary/access_verifier/ui_data()
	var/list/data = list()
	var/list/regions = list()

	for(var/i in ACCESS_REGION_SECURITY to ACCESS_REGION_SUPPLY) //code/game/jobs/_access_defs.dm
		var/list/region = list()
		var/list/accesses = list()
		for(var/j in get_region_accesses(i))
			var/list/access = list()
			access["name"] = get_access_desc(j)
			access["id"] = j
			access["allowed"] = (j in checked_accesses) ? 1 : 0
			accesses[++accesses.len] = access
		region["name"] = get_region_accesses_name(i)
		region["accesses"] = accesses
		regions[++regions.len] = region
	data["regions"] = regions
	data["oneAccess"] = requires_one
	data["locked"] = locked
	data["lockable"] = TRUE

	return data

/obj/item/integrated_circuit/logic/unary/access_verifier/Topic(var/href, var/list/href_list)
	if(..())
		return 1
	if(href_list["unlock"])
		if(!req_access || istype(usr, /mob/living/silicon))
			locked = FALSE
			last_configurator = usr.name
		else
			var/obj/item/weapon/card/id/I = usr.get_active_hand()
			I = I ? I.GetIdCard() : null
			if(!istype(I, /obj/item/weapon/card/id))
				to_chat(usr, "<span class='warning'>[\src] flashes a yellow LED near the ID scanner. Did you remember to scan your ID or PDA?</span>")
				return
			if (check_access(I))
				locked = FALSE
				last_configurator = I.registered_name
			else
				to_chat(usr, "<span class='warning'>[\src] flashes a red LED near the ID scanner, indicating your access has been denied.</span>")
				return
		return 1
	else if(href_list["lock"])
		locked = TRUE
		return 1

	if(href_list["clear"])
		checked_accesses = list()
		requires_one = FALSE
		return 1
	if(href_list["requires_one"])
		requires_one = !requires_one
		return 1
	if(href_list["allowed"])
		var/access_type = text2num(href_list["access_target"])
		var/access_allowed = text2num(href_list["allowed"])
		if(!access_allowed)
			checked_accesses += access_type
		else
			checked_accesses -= access_type
		return 1

/obj/item/integrated_circuit/logic/unary/access_verifier/examine/(var/mob/user)
	. = ..(user, 1)
	if(.)
		to_chat(user, "A small screen displays 'Last configured by: [last_configurator ? last_configurator : "N/A"]'.")
/obj/item/integrated_circuit/logic/unary/access_verifier/do_check(var/datum/integrated_io/access_input)
	var/list/access = access_input.get_data()
	if(isnum(access))
		access = list(access)
	else if(istype(access, /datum/encrypted_ic_data))
		var/datum/encrypted_ic_data/eicd = access
		access = json_decode(eicd.data)
	else if(ismovable(access))
		var/atom/movable/A = access
		access = A.GetAccess()

	return istype(access) && has_access(requires_one ? list() : checked_accesses, requires_one ? checked_accesses : list(), access_input)

/obj/item/integrated_circuit/logic/flip_flop
	name = "flip-flop circuit"
	desc = "A flip-flop or latch circuit. This particular variant is an SR NOR latch."
	extended_desc = "On Set: IF S==TRUE && R==FALSE THEN Q=TRUE - IF S==FALSE && R==TRUE THEN Q=FALSE - IF S==FALSE && R==FALSE THEN Q=Q. S==R==TRUE is invalid input."
	complexity = 3
	icon_state = "sr_nor"
	inputs = list("S", "R")
	outputs = list("Q", "!Q")
	activators = list("set")

/obj/item/integrated_circuit/logic/flip_flop/do_work()
	var/S = get_pin_data(IC_INPUT, 1)
	var/R = get_pin_data(IC_INPUT, 2)

	if(S && !R)
		set_pin_data(IC_OUTPUT, 1, TRUE)
		set_pin_data(IC_OUTPUT, 2, FALSE)
	else if(!S && R)
		set_pin_data(IC_OUTPUT, 1, FALSE)
		set_pin_data(IC_OUTPUT, 2, TRUE)

/obj/item/integrated_circuit/logic/flip_flop/gated_d
	desc = "A flip-flop or latch circuit. This particular variant is a gated D latch."
	extended_desc = "On Set: IF D==TRUE && E==TRUE THEN Q=TRUE - IF D==FALSE && E==TRUE THEN Q=FALSE - IF E==FALSE THEN Q=Q."
	icon_state = "gated_d"
	inputs = list("D", "E")

/obj/item/integrated_circuit/logic/flip_flop/gated_d/do_work()
	var/D = get_pin_data(IC_INPUT, 1)
	var/E = get_pin_data(IC_INPUT, 2)

	if(E)
		set_pin_data(IC_OUTPUT, 1, !!D)
		set_pin_data(IC_OUTPUT, 2, !D)
