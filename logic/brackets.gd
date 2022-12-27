extends Control
signal save_knockout_data
signal back_from_knockout
signal knockout_setted
var knockout

var empty_team = {
				"name": "",
				"goals": 0,
				"penalty_winner": false,
				"setted": false
			}

func set_knockout_data(knockout_data):
	knockout = knockout_data
	$RoundOf16.set_games(knockout_data["round_of_16"])
	_update_games()

func _on_back_pressed():
	emit_signal("back_from_knockout")

func _check_game(team_a, team_b):
	if team_a["setted"] and team_b["setted"]:
		if team_a["goals"] > team_b["goals"]:
			return [team_a, team_b]
		elif team_a["goals"] < team_b["goals"]:
			return [team_b, team_a]
		elif team_a["penalty_winner"]:
			return [team_a, team_b]
		elif team_b["penalty_winner"]:
			return [team_b, team_a]
		else:
			return [empty_team, empty_team]
	else:
		return [empty_team, empty_team]

func _update_quarters():
	var quarter_games = []
	for i in range(0, 8, 2):
		quarter_games.append([_check_game(knockout["round_of_16"][i][0], knockout["round_of_16"][i][1])[0], _check_game(knockout["round_of_16"][i + 1][0], knockout["round_of_16"][i + 1][1])[0]])
	for i in range(4):
		knockout["quarter_finals"][i][0]["name"] = quarter_games[i][0]["name"]
		knockout["quarter_finals"][i][1]["name"] = quarter_games[i][1]["name"]
	$Quarters.set_quarters(knockout["quarter_finals"])

func _update_semis():
	var semi_games = []
	for i in range(0, 4, 2):
		semi_games.append([_check_game(knockout["quarter_finals"][i][0], knockout["quarter_finals"][i][1])[0], _check_game(knockout["quarter_finals"][i + 1][0], knockout["quarter_finals"][i + 1][1])[0]])
	for i in range(2):
		knockout["semi_finals"][i][0]["name"] = semi_games[i][0]["name"]
		knockout["semi_finals"][i][1]["name"] = semi_games[i][1]["name"]
	$Semis.set_semis(knockout["semi_finals"])

func _update_final():
	knockout["final"][0]["name"] = _check_game(knockout["semi_finals"][0][0], knockout["semi_finals"][0][1])[0]["name"]
	knockout["final"][1]["name"] = _check_game(knockout["semi_finals"][1][0], knockout["semi_finals"][1][1])[0]["name"]
	$Final.set_final(knockout["final"])

func _update_third():
	knockout["3_place"][0]["name"] = _check_game(knockout["semi_finals"][0][0], knockout["semi_finals"][0][1])[1]["name"]
	knockout["3_place"][1]["name"] = _check_game(knockout["semi_finals"][1][0], knockout["semi_finals"][1][1])[1]["name"]
	$Third.set_third(knockout["3_place"])

func _update_positions():
	$Pos1/Team1.text = _check_game(knockout["final"][0], knockout["final"][1])[0]["name"]
	$Pos2/Team1.text = _check_game(knockout["final"][0], knockout["final"][1])[1]["name"]
	$Pos3/Team1.text = _check_game(knockout["3_place"][0], knockout["3_place"][1])[0]["name"]

func _update_games():
	_update_quarters()
	_update_semis()
	_update_third()
	_update_final()
	_check_final_and_third()
	_update_positions()

func _on_match_goals_setted(stage_id, match_id, match_data):
	knockout[stage_id][match_id] = match_data
	_update_games()
	emit_signal("save_knockout_data", knockout)

func _check_final_and_third():
	if _check_game(knockout["final"][0], knockout["final"][1])[0]["name"] != "" and _check_game(knockout["3_place"][0], knockout["3_place"][1])[0]["name"] != "":
		$BackAccept/BackAcceptContainer/Accept.disabled = false
	else:
		$BackAccept/BackAcceptContainer/Accept.disabled = true

func _on_final_goals_setted(stage_id, match_id, match_data):
	knockout[stage_id] = match_data
	_update_games()
	emit_signal("save_knockout_data", knockout)

func _on_accept_pressed():
	emit_signal("knockout_setted")
