extends Control

signal goals_setted

var team_1
var team_2

func set_teams(team_a, team_b):
	$Team1.text = team_a["name"]
	$Team2.text = team_b["name"]
	team_1 = team_a
	team_2 = team_b
	$Team1Goals.reset()
	$Team2Goals.reset()
	if team_a["match_setted"][team_b["value"]]:
		$Team1Goals.text = String.num_int64(team_a["match_goals"][team_b["value"]])
	if team_b["match_setted"][team_a["value"]]:
		$Team2Goals.text = String.num_int64(team_b["match_goals"][team_a["value"]])

func _on_team_1_goals_goals_setted(goals, setted):
	team_1["match_goals"][team_2["value"]] = goals
	team_1["match_setted"][team_2["value"]] = setted
	team_2["against_goals"][team_1["value"]] = goals
	emit_signal("goals_setted", team_1, team_2)
	
func _on_team_2_goals_goals_setted(goals, setted):
	team_2["match_goals"][team_1["value"]] = goals
	team_2["match_setted"][team_1["value"]] = setted
	team_1["against_goals"][team_2["value"]] = goals
	emit_signal("goals_setted", team_2, team_1)


func _on_team_1_goals_text_changed(new_text):
	pass # Replace with function body.
