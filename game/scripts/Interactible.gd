extends StaticBody2D

export var is_active = true;
export (String) var task;
# TODO: set from those params and bind to size. For now - manually in scene editor
export (Texture) var object_texture = null;
export (SpriteFrames) var object_animation = null;

var task_dialog;


func action(player: KinematicBody2D):
	if not is_active:
		return

	if task == null or task == "":
		print("Task not setup!")
		return
	
	if task_dialog == null:
		print("TaskDialog not setup!")

	var task_data = Utils.load_json_file("res://ingame/tasks/" + task + ".json")
	if task_data == null:
		print("Error loading task " + task)
		return

	task_dialog.activate(self, player, task_data)


func deactivate(player, hard = false):
	if player.interactible == self:
		player.interactible = null
	$Sprite.material = null

	if hard:
		if ("playing" in $Sprite):
			$Sprite.playing = false
			$Sprite.frame = 0
		is_active = false


func _init():
	add_to_group("Interactibles")


func _ready():
	# Must be single node
	for node in get_tree().get_nodes_in_group("TaskDialog"):
		task_dialog = node
