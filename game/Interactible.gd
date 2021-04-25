extends StaticBody2D

export (String) var task;
var task_dialog;
export var is_active = true;


func action(player: KinematicBody2D):
	if not is_active:
		return

	if task == null or task == "":
		print("Task not setup!")
		return
	
	if task_dialog == null:
		print("TaskDialog not setup!")

	var task_data = Utils.load_json_file("res://tasks/" + task + ".json")
	if task_data == null:
		print("Error loading task " + task)
		return

	task_dialog.activate(self, player, task_data)


func deactivate(player):
	if player.interactible == self:
		player.interactible = null
	is_active = false
	$Sprite.material = null
	if ("playing" in $Sprite):
		$Sprite.playing = false
		$Sprite.frame = 0


func _init():
	add_to_group("Interactibles")


func _ready():
	# Must be single node
	for node in get_tree().get_nodes_in_group("TaskDialog"):
		task_dialog = node
