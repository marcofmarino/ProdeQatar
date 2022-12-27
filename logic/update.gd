extends Control

signal save_update_data
signal update_confirmed
signal back_from_update

var update_data
var groups = [
	[
		["Qatar", "Ecuador", "Senegal", "Países Bajos"], 
		["Inglaterra", "Irán", "Estados Unidos", "Gales"]
	],
	[
		["Argentina", "Arabia Saudita", "México", "Polonia"], 
		["Francia", "Australia", "Dinamarca", "Túnez"]
	],
	[
		["España", "Costa Rica", "Alemania", "Japón"], 
		["Bélgica", "Canadá", "Marruecos", "Croacia"]
	],
	[
		["Brasil", "Serbia", "Suiza", "Camerún"], 
		["Portugal", "Ghana", "Uruguay", "Corea del Sur"]
	],
	[
		["Inglaterra", "Irán", "Estados Unidos", "Gales"], 
		["Qatar", "Ecuador", "Senegal", "Países Bajos"]
	],
	[
		["Francia", "Australia", "Dinamarca", "Túnez"], 
		["Argentina", "Arabia Saudita", "México", "Polonia"]
	],
	[
		["Bélgica", "Canadá", "Marruecos", "Croacia"], 
		["España", "Costa Rica", "Alemania", "Japón"]
	],
	[
		["Portugal", "Ghana", "Uruguay", "Corea del Sur"], 
		["Brasil", "Serbia", "Suiza", "Camerún"]
	]
]
var current_match
var current_team_id
var stage
var current_match_data

func set_update_data(knockout_data):
	update_data = knockout_data
	$RoundOf16.set_games(knockout_data["round_of_16"])
	$Quarters.set_quarters(knockout_data["quarter_finals"])

func _on_match_goals_setted(stage_id, match_id, match_data):
	update_data[stage_id][match_id] = match_data
	emit_signal("save_update_data", update_data)


func _on_match_1_change_team(team_group_id, match_id, match_data, stage_id):
	stage = stage_id
	current_match = match_id
	current_team_id = team_group_id
	current_match_data = match_data
	if stage_id== "round_of_16":
		$UpdateBack/Button.text = groups[match_id][team_group_id][0]
		$UpdateBack/Button2.text = groups[match_id][team_group_id][1]
		$UpdateBack/Button3.text = groups[match_id][team_group_id][2]
		$UpdateBack/Button4.text = groups[match_id][team_group_id][3]
	elif stage == "quarter_finals":
		$UpdateBack/Button.text = ""
		$UpdateBack/Button2.text = update_data["round_of_16"][match_id * 2 + team_group_id][0]["name"]
		$UpdateBack/Button3.text = update_data["round_of_16"][match_id * 2 + team_group_id][1]["name"]
		$UpdateBack/Button4.text = ""
	$UpdateBack.show()


func _on_button_pressed():
	$UpdateBack.hide()
	if stage == "round_of_16":
		$RoundOf16.get_children()[current_match].update_team(current_team_id, $UpdateBack/Button.text)
	elif stage == "quarter_finals":
		$Quarters.get_children()[current_match].update_team(current_team_id, $UpdateBack/Button.text)
	current_match_data[current_team_id]["name"] = $UpdateBack/Button.text
	update_data[stage][current_match] = current_match_data
	emit_signal("save_update_data", update_data)

func _on_button_2_pressed():
	$UpdateBack.hide()
	if stage == "round_of_16":
		$RoundOf16.get_children()[current_match].update_team(current_team_id, $UpdateBack/Button2.text)
	elif stage == "quarter_finals":
		$Quarters.get_children()[current_match].update_team(current_team_id, $UpdateBack/Button2.text)
	current_match_data[current_team_id]["name"] = $UpdateBack/Button2.text
	update_data[stage][current_match] = current_match_data
	emit_signal("save_update_data", update_data)

func _on_button_3_pressed():
	$UpdateBack.hide()
	if stage == "round_of_16":
		$RoundOf16.get_children()[current_match].update_team(current_team_id, $UpdateBack/Button3.text)
	elif stage == "quarter_finals":
		$Quarters.get_children()[current_match].update_team(current_team_id, $UpdateBack/Button3.text)
	current_match_data[current_team_id]["name"] = $UpdateBack/Button3.text
	update_data[stage][current_match] = current_match_data
	emit_signal("save_update_data", update_data)

func _on_button_4_pressed():
	$UpdateBack.hide()
	if stage == "round_of_16":
		$RoundOf16.get_children()[current_match].update_team(current_team_id, $UpdateBack/Button4.text)
	elif stage == "quarter_finals":
		$Quarters.get_children()[current_match].update_team(current_team_id, $UpdateBack/Button4.text)
	current_match_data[current_team_id]["name"] = $UpdateBack/Button4.text
	update_data[stage][current_match] = current_match_data
	emit_signal("save_update_data", update_data)

func _on_accept_pressed():
	emit_signal("update_confirmed")

func _on_back_pressed():
	emit_signal("back_from_update")
