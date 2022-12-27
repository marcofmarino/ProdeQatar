extends Control

signal goals_setted
signal change_team

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

func _on_team_1_goals_goals_setted(goals, setted):
	match_data[0]["goals"] = goals
	match_data[0]["setted"] = setted
	emit_signal("goals_setted", stage_id, match_id, match_data)

func _on_team_2_goals_goals_setted(goals, setted):
	match_data[1]["goals"] = goals
	match_data[1]["setted"] = setted
	emit_signal("goals_setted", stage_id, match_id, match_data)	

func update_team(team_id, team):
	if team_id == 0:
		$Team1.text = team
	else:
		$Team2.text = team

func _on_button_team_1_pressed():
	emit_signal("change_team", 0, match_id, match_data, stage_id)

func _on_button_team_2_pressed():
	emit_signal("change_team", 1, match_id, match_data, stage_id)
