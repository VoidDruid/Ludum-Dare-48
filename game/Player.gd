extends KinematicBody2D

export var speed = 400
export (Material) var outline;

var interactible = null
var screen_size


func _init():
	add_to_group("Player")


func _ready():
	screen_size = get_viewport_rect().size
	
	$AnimatedSprite.play()

	for node in get_tree().get_nodes_in_group("Interactibles"):
		node.get_node("Trigger").connect("body_entered", self, "on_trigger_entered", [node])
		node.get_node("Trigger").connect("body_exited", self, "on_trigger_exited", [node])


func has_player_entered(body, trigger):
	return body == self and trigger.is_in_group("Interactibles")


func on_trigger_entered(body, trigger):
	if has_player_entered(body, trigger):
		interactible = trigger
		interactible.get_node("Sprite").material = outline;


func on_trigger_exited(body, trigger):
	if has_player_entered(body, trigger):
		interactible.get_node("Sprite").material = null;
		interactible = null


func on_interactible():
	if interactible == null:
		return
	interactible.action(self)


func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		on_interactible()
		return

	var velocity = Vector2()  # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y > 0:
		$AnimatedSprite.animation = "down"
	elif velocity.y < 0:
		$AnimatedSprite.animation = "up"
	else:
		$AnimatedSprite.animation = "idle"
		$AnimatedSprite.flip_h = false
	
	var _collision = move_and_collide(velocity * delta)
