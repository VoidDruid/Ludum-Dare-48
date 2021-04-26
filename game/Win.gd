extends StaticBody2D

export var is_active = true


func _init():
	add_to_group("Interactibles")


func action(player):
	if not is_active:
		return

	player.set_status("YOU WON")
	$Audio.playing = true


func deactivate(player, _hard = false):
	queue_free()

	if player.interactible == self:
		player.interactible = null

	is_active = false
	$Sprite.material = null
