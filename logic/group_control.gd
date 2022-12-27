extends Control

signal save_group_data
signal enable
signal disable
signal back_to_group_selection
signal group_confirmed
signal set_priority

var group

func set_group(group_data):
	if group_data[0]["priority"] == 0:
		emit_signal("set_priority")
	else:
		emit_signal("disable")
		group = group_data
		$Match1.set_teams(group_data[0], group_data[1])
		$Match2.set_teams(group_data[2], group_data[3])
		$Match3.set_teams(group_data[0], group_data[2])
		$Match4.set_teams(group_data[3], group_data[1])
		$Match5.set_teams(group_data[3], group_data[0])
		$Match6.set_teams(group_data[1], group_data[2])
		_update_group_data()

func _show_positions(group_data):
	var sorted_teams = group_data.duplicate()
	sorted_teams.sort_custom(_sorting)
	$Pos1.set_team(sorted_teams[0])
	$Pos2.set_team(sorted_teams[1])
	$Pos3.set_team(sorted_teams[2])
	$Pos4.set_team(sorted_teams[3])
	
func _sorting(team_a, team_b):
	if team_a["points"] > team_b["points"]:
		return true
	elif team_a["points"] == team_b["points"]:
		if team_a["dif"] > team_b["dif"]:
			return true
		elif team_a["dif"] == team_b["dif"]:
			if team_a["gf"] > team_b["gf"]:
				return true
			elif team_a["gf"] == team_b["gf"]:
				if team_a["matches"][team_b["value"]] > team_b["matches"][team_a["value"]]:
					return true
				elif team_a["matches"][team_b["value"]] < team_b["matches"][team_a["value"]]:
					return false
				else:
					return team_a["priority"] < team_b["priority"]
			else:
				return false
		else:
			return false
	else:
		return false

func _check_match(team_a, team_b):
	if team_a["match_setted"][team_b["value"]] and team_b["match_setted"][team_a["value"]]:
		return true
	else:
		return false

func _check_score(team_a, team_b):
	if team_a["match_goals"][team_b["value"]] > team_a["against_goals"][team_b["value"]]:
		return 3
	elif team_a["match_goals"][team_b["value"]] == team_a["against_goals"][team_b["value"]]:
		return 1
	else:
		return 0

func _all_matches_setted(count):
	if count == 12:
		emit_signal("enable")

func get_sorted_group(group):
	var sorted = group.duplicate()
	sorted.sort_custom(_sorting)
	if _sorting(sorted[3], sorted[0]):
		sorted.sort_custom(func(team_a, team_b): team_a["priority"] < team_b["priority"])
	elif _sorting(sorted[2], sorted[0]):
		sorted.pop_back()
		sorted.sort_custom(func(team_a, team_b): team_a["priority"] < team_b["priority"])
	return sorted

func _update_group_data():
	var count = 0
	for team in group:
		team["gf"] = 0
		team["ga"] = 0
		team["points"] = 0
		for i in range(4):
			if _check_match(team, group[i]):
				team["gf"] += team["match_goals"][i]
				team["ga"] += team["against_goals"][i]
				team["points"] += _check_score(team, group[i])
				count += 1	
		team["dif"] = team["gf"] - team["ga"]
	_show_positions(group)
	_all_matches_setted(count)
	emit_signal("save_group_data", group)

func _on_match_goals_setted(team_a, team_b):
	group[team_a["value"]] = team_a
	group[team_b["value"]] = team_b
	_update_group_data()

func _on_back_pressed():
	emit_signal("back_to_group_selection")

func _on_accept_pressed():
	var sorted_group = get_sorted_group(group)
	emit_signal("save_group_data", sorted_group)
	emit_signal("group_confirmed")
