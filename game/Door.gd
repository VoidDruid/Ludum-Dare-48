extends StaticBody2D

export var is_active = true
export (String) var config_path
var cost = 0


func _init():
	add_to_group("Interactibles")


func _ready():
	if config_path == null or config_path == "":
		print("Config not setup!")
		return
	var config = Utils.load_json_file("res://tasks/doors/" + config_path + ".json")
	cost = config["cost"]


func action(player):
	if not is_active:
		return

	var success = player.try_spend(cost)
	if not success:
		player.set_status("Not enough coins - needs " + str(cost) + "!")
		return

	deactivate(player)	


func deactivate(player):
	

	$Sprite.playing = true
	$CollisionShape2D.queue_free()

	if player.interactible == self:
		player.interactible = null

	is_active = false
	$Sprite.material = null
