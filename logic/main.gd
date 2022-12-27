extends Node

var current_user_dir
var current_user
var current_group_id

signal save

func _ready():
	if not _check_data_folder():
		_create_dir("prode_data")
	if not _check_users_list():
		_save_data([], "users_info.dat")
		$AddUser.hide_cancel()
		$AddUser.show()
	else:
		_main_menu()

func _user_added(user_name):
	$AddUser.hide()
	current_user = user_name
	current_user_dir = current_user.to_snake_case() + "/"
	var users_list = _load_data("users_info.dat")
	if users_list.all(func(user): return user != current_user):
		users_list.append(current_user)
		_save_data(users_list, "users_info.dat")
		_create_user_default_data()
	_stage_selection()

func _on_add_user_cancel():
	$AddUser.hide()
	$MainMenu.show()
	
func _main_menu():
	$MainMenu.set_users_list(_load_data("users_info.dat"))
	$MainMenu.show()

func _on_main_menu_request_add():
	$MainMenu.hide()
	$AddUser.show()

func _on_main_menu_user_selected(user_name):
	current_user = user_name
	current_user_dir = current_user.to_snake_case() + "/"
	$MainMenu.hide()
	_stage_selection()

func _stage_selection():
	$StageSelector.set_user_name(current_user)
	$StageSelector.set_stages_state(_load_data(current_user_dir + "stages.dat"))
	$StageSelector.show()

func _on_stage_selector_go_to_menu():
	$StageSelector.hide()
	_main_menu()

func _on_stage_selector_groups():
	$StageSelector.hide()
	_groups_selector()

func _groups_selector():
	$Groups.set_groups_state(_load_data(current_user_dir + "groups.dat")["already_setted"])
	$Groups.show()

func _on_groups_back_to_stage_selector():
	$Groups.hide()
	_stage_selection()

func _on_groups_group_selected(group_id):
	current_group_id = group_id
	$Groups.hide()
	$GroupControl.show()
	$GroupControl.set_group(_load_data(current_user_dir + "groups.dat")["groups"][group_id])

func _on_groups_all_groups_setted():
	$Groups.hide()
	var stages = _load_data(current_user_dir + "stages.dat")
	stages = [false, true, false, false] 
	_save_data(stages, current_user_dir + "stages.dat")
	_stage_selection()

func _on_group_control_save_group_data(group_data):
	var groups = _load_data(current_user_dir + "groups.dat")
	groups["groups"][current_group_id] = group_data
	_save_data(groups, current_user_dir + "groups.dat")

func _on_group_control_back_to_group_selection():
	$GroupControl.hide()
	_groups_selector()

func _on_group_control_group_confirmed():
	$GroupControl.hide()
	var groups = _load_data(current_user_dir + "groups.dat")
	groups["already_setted"][current_group_id] = true
	_save_data(groups, current_user_dir + "groups.dat")
	_groups_selector()

func _exit():
	get_tree().quit()

func _create_user_default_data():
	_create_dir("prode_data/" + current_user_dir)
	_save_data([true, false, false, false], current_user_dir + "stages.dat")
	var teams_names = [
		["Qatar", "Ecuador", "Senegal", "Países Bajos"],
		["Inglaterra", "Irán", "Estados Unidos", "Gales"],
		["Argentina", "Arabia Saudita", "México", "Polonia"],
		["Francia", "Australia", "Dinamarca", "Túnez"],
		["España", "Costa Rica", "Alemania", "Japón"],
		["Bélgica", "Canadá", "Marruecos", "Croacia"],
		["Brasil", "Serbia", "Suiza", "Camerún"],
		["Portugal", "Ghana", "Uruguay", "Corea del Sur"]
	]
	var groups_array = []
	for group in teams_names:	
		var teams_array = []
		for i in range(4):
			teams_array.append({
			"value": i,
			"name": group[i],
			"points": 0,
			"gf": 0,
			"ga": 0,
			"dif": 0,
			"matches": [0, 0, 0, 0],
			"match_goals": [0, 0, 0, 0],
			"against_goals": [0, 0, 0, 0],
			"match_setted": [false, false, false, false],
			"priority": 0
			})
		groups_array.append(teams_array)

	_save_data({
		"already_setted": [false, false, false, false, false, false, false, false],
		"groups": groups_array
	}, current_user_dir + "groups.dat")

func _check_dir_existence(path):
	var dir = DirAccess.open("user://")
	if dir.dir_exists(path):
		return true
	else:
		return false

func _check_file_existence(path_to_file):
	return FileAccess.file_exists("user://prode_data/" + path_to_file)

func _check_data_folder():
	return _check_dir_existence("prode_data")

func _check_users_list():
	return _check_file_existence("users_info.dat")

func _create_dir(dir_name):
	var dir = DirAccess.open("user://")
	dir.make_dir(dir_name)
	
func _save_data(data, file_path, password = OS.get_unique_id()):
	var file = FileAccess.open_encrypted_with_pass("user://prode_data/" + file_path, FileAccess.WRITE, password)
	file.store_var(data)
	file = null

func _load_data(path, password = OS.get_unique_id()):
	var file = FileAccess.open_encrypted_with_pass("user://prode_data/" + path, FileAccess.READ, password)
	var data = file.get_var()
	file = null
	return data

func _create_knockout_default_data():
	var groups_data = _load_data(current_user_dir + "groups.dat")
	var jeje = [
				[groups_data["groups"][0][0]["name"], groups_data["groups"][1][1]["name"]],
				[groups_data["groups"][2][0]["name"], groups_data["groups"][3][1]["name"]],
				[groups_data["groups"][4][0]["name"], groups_data["groups"][5][1]["name"]],
				[groups_data["groups"][6][0]["name"], groups_data["groups"][7][1]["name"]],
				[groups_data["groups"][1][0]["name"], groups_data["groups"][0][1]["name"]],
				[groups_data["groups"][3][0]["name"], groups_data["groups"][2][1]["name"]],
				[groups_data["groups"][5][0]["name"], groups_data["groups"][4][1]["name"]],
				[groups_data["groups"][7][0]["name"], groups_data["groups"][6][1]["name"]] 
			]
	var team = {
				"name": "",
				"goals": 0,
				"penalty_winner": false,
				"setted": false
			}
	var knockout = {
		"already_setted": 
			[false, false, false, false, false, false, false, false, 
			false, false, false, false, false, false, false, false],
		"round_of_16": [],
		"quarter_finals": [[team, team], [team, team], [team, team], [team, team]],
		"semi_finals": [[team, team], [team, team]],
		"3_place": [team, team],
		"final": [team, team]
	}
	for game in jeje:
		knockout["round_of_16"].append([
			{
				"name": game[0],
				"goals": 0,
				"penalty_winner": false,
				"setted": false
			}, 
			{
				"name": game[1],
				"goals": 0,
				"penalty_winner": false,
				"setted": false
			}
		])
	_save_data(knockout, current_user_dir + "knockout.dat")
	
func _on_stage_selector_knockout():
	$Groups.hide()
	$StageSelector.hide()
	if not _check_file_existence(current_user_dir + "knockout.dat"):
		_create_knockout_default_data()
	$Knockout.set_knockout_data(_load_data(current_user_dir + "knockout.dat"))
	$Knockout.show()

func _on_group_control_set_priority():
	$GroupControl.hide()
	$Priority.set_group_priority(_load_data(current_user_dir + "groups.dat")["groups"][current_group_id])
	$Priority.show()

func _on_priority_back():
	$Priority.hide()
	_groups_selector()

func _on_priority_priority_setted(priority_array):
	$Priority.hide()
	var group = _load_data(current_user_dir + "groups.dat")["groups"][current_group_id]
	for i in range(4):
		group[i]["priority"] = priority_array[i]
	_on_group_control_save_group_data(group)
	_on_groups_group_selected(current_group_id)

func _on_knockout_back_from_knockout():
	$Knockout.hide()
	_stage_selection()

func _on_knockout_save_knockout_data(knockout_data):
	_save_data(knockout_data, current_user_dir + "knockout.dat")

func _on_knockout_knockout_setted():
	$Knockout.hide()
	var stages = _load_data(current_user_dir + "stages.dat")
	stages = [false, false, true, false] 
	_save_data(stages, current_user_dir + "stages.dat")
	_stage_selection()

func _on_stage_selector_export():
	$FileDialog.set_file_mode(4)
	$FileDialog.set_current_file(current_user.to_snake_case() + ".prodedata")  
	$FileDialog.add_filter("*.prodedata")
	$FileDialog.show()

func _on_save(data):
	var file = FileAccess.open_encrypted_with_pass($FileDialog.get_current_path(), FileAccess.WRITE, "justanotherpassword")
	file.store_var(data)
	file = null

func _on_file_dialog_file_selected(path):
	var data_array = []
	data_array.append(_load_data("users_info.dat"))
	data_array.append(_load_data(current_user_dir + "stages.dat"))
	data_array.append(_load_data(current_user_dir + "groups.dat"))
	data_array.append(_load_data(current_user_dir + "knockout.dat"))
	if _check_file_existence(current_user_dir + "update.dat"):
		data_array.append(_load_data(current_user_dir + "update.dat"))
	emit_signal("save", data_array)

func _create_update_data():
	var default_update_data = _load_data(current_user_dir + "knockout.dat")
	_save_data(default_update_data, current_user_dir + "update.dat")

func _on_stage_selector_update():
	$StageSelector.hide()
	if not _check_file_existence(current_user_dir + "update.dat"):
		_create_update_data()
	$Update.set_update_data(_load_data(current_user_dir + "update.dat"))
	$Update.show()

func _on_update_save_update_data(update_data):
	_save_data(update_data, current_user_dir + "update.dat")

func _on_update_back_from_update():
	$Update.hide()
	_stage_selection()

func _on_update_update_confirmed():
	$Update.hide()
	_save_data([false, false, false, true], current_user_dir + "stages.dat")
	_stage_selection()

func _on_stage_selector_export_update():
	$FileDialog.set_file_mode(4)
	$FileDialog.deselect_all()
	$FileDialog.set_current_file(current_user.to_snake_case() + "_actualizado.prodedata")  
	$FileDialog.add_filter("*.prodedata")
	$FileDialog.show()
