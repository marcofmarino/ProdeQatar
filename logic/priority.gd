extends Control

signal back
signal priority_setted

var priority_array = [1, 2, 3, 4]
var return_value

func set_group_priority(group):
	priority_array = [1, 2, 3, 4]
	$Buttons.get_child(2).disabled = true
	$TeamsContainer.get_child(0).get_child(1).reset_value()
	$TeamsContainer.get_child(1).get_child(1).reset_value()
	$TeamsContainer.get_child(2).get_child(1).reset_value()
	$TeamsContainer.get_child(3).get_child(1).reset_value()
	
	$TeamsContainer.get_child(0).get_child(0).text = group[0]["name"]
	$TeamsContainer.get_child(1).get_child(0).text = group[1]["name"]
	$TeamsContainer.get_child(2).get_child(0).text = group[2]["name"]
	$TeamsContainer.get_child(3).get_child(0).text = group[3]["name"]

func give_priority(old_value):
		priority_array.sort()
		if priority_array.is_empty() or old_value > priority_array[0]:
			priority_array.append(old_value)
			return 0
		else:
			return_value = priority_array[0]
			priority_array.pop_front()
			if old_value != -1 and old_value != 0:
				priority_array.append(old_value)
			return return_value

func _on_priority_num_check():
	var yes = 0
	if $TeamsContainer/Team1/PriorityNum.get_priority_value() != 0 and $TeamsContainer/Team1/PriorityNum.get_priority_value() != -1:
		yes += 1
	if $TeamsContainer/Team2/PriorityNum.get_priority_value() != 0 and $TeamsContainer/Team2/PriorityNum.get_priority_value() != -1:
		yes += 1
	if $TeamsContainer/Team3/PriorityNum.get_priority_value() != 0 and $TeamsContainer/Team3/PriorityNum.get_priority_value() != -1:
		yes += 1
	if $TeamsContainer/Team4/PriorityNum.get_priority_value() != 0 and $TeamsContainer/Team4/PriorityNum.get_priority_value() != -1:
		yes += 1
	if yes == 4:
		$Buttons/Accept.disabled = false
	else:
		$Buttons/Accept.disabled = true

func _on_back_pressed():
	emit_signal("back")

func _on_accept_pressed():
	emit_signal("priority_setted", [
		$TeamsContainer/Team1/PriorityNum.get_priority_value(), 
		$TeamsContainer/Team2/PriorityNum.get_priority_value(),
		$TeamsContainer/Team3/PriorityNum.get_priority_value(),
		$TeamsContainer/Team4/PriorityNum.get_priority_value()
		])
