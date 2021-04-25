extends StaticBody2D

export (String) var task;
var task_dialog;


func load_json_file(path):
	var file = File.new()
	file.open(path, file.READ)
	var text = file.get_as_text()
	var result_json = JSON.parse(text)
	if result_json.error != OK:
		print("[load_json_file] Error loading JSON file '" + str(path) + "'.")
		print("\tError: ", result_json.error)
		print("\tError Line: ", result_json.error_line)
		print("\tError String: ", result_json.error_string)
		return null
	var obj = result_json.result
	return obj


func action(player: KinematicBody2D):
	if task == null or task == "":
		print("Task not setup!")
		return
	
	if task_dialog == null:
		print("TaskDialog not setup!")

	var task_data = load_json_file("res://tasks/" + task + ".json")
	if task_data == null:
		print("Error loading task " + task)
		return

	task_dialog.activate(player, task_data)


func _init():
	add_to_group("Interactibles")


func _ready():
	# Must be single node
	for node in get_tree().get_nodes_in_group("TaskDialog"):
		task_dialog = node
