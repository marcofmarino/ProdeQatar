extends Control

func set_team(team):
	$Team.text = team["name"]
	$Pts.text = String.num_int64(team["points"])
	$Gf.text = String.num_int64(team["gf"])
	$Gc.text = String.num_int64(team["ga"])
	$Dif.text = String.num_int64(team["dif"])
