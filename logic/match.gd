extends Control

signal goals_setted

var stage_id
var match_id
var match_data

func set_match_data(stage_identifier, match_identifier, game_data):
	stage_id = stage_identifier
	match_data = game_data
	match_id = match_identifier
	$Team1.text = match_data[0]["name"]
	$Team2.text = match_data[1]["name"]
	$Team1Goals.reset()
	$Team2Goals.reset()
	if $Team1.text != "" and $Team2.text != "":
		$Team1Goals.visible = true
		$Team2Goals.visible = true
	if match_data[0]["setted"]:
		$Team1Goals.text = String.num_int64(match_data[0]["goals"])
	if match_data[1]["setted"]:
		$Team2Goals.text = String.num_int64(match_data[1]["goals"])
	check_match()

func _on_team_1_goals_goals_setted(goals, setted):
	match_data[0]["goals"] = goals
	match_data[0]["setted"] = setted
	check_match()
	emit_signal("goals_setted", stage_id, match_id, match_data)

func _on_team_2_goals_goals_setted(goals, setted):
	match_data[1]["goals"] = goals
	match_data[1]["setted"] = setted
	check_match()
	emit_signal("goals_setted", stage_id, match_id, match_data)
	
func check_match():
	if match_data[0]["setted"] and match_data[1]["setted"]:
		if match_data[0]["goals"] == match_data[1]["goals"]:
			$ButtonTeam1.disabled = false
			$ButtonTeam2.disabled = false
		else:
			$ButtonTeam1.disabled = true
			$ButtonTeam2.disabled = true
			match_data[0]["penalty_winner"] = false
			match_data[1]["penalty_winner"] = false
	else:
		match_data[0]["penalty_winner"] = false
		match_data[1]["penalty_winner"] = false
		$ButtonTeam1.disabled = true
		$ButtonTeam2.disabled = true

func _on_button_team_1_pressed():
	match_data[0]["penalty_winner"] = true
	match_data[1]["penalty_winner"] = false
	emit_signal("goals_setted", stage_id, match_id, match_data)

func _on_button_team_2_pressed():
	match_data[0]["penalty_winner"] = false
	match_data[1]["penalty_winner"] = true
	emit_signal("goals_setted", stage_id, match_id, match_data)
