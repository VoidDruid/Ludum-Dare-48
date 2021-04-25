extends KinematicBody2D

export var speed = 400
export var boost = 1.6
export (Material) var outline;
export var coins = 5

var screen_size

var interactible = null
var status_bar = null
var coin_label = null


func _init():
	add_to_group("Player")


func _ready():
	screen_size = get_viewport_rect().size
	
	$AnimatedSprite.play()

	for node in get_tree().get_nodes_in_group("StatusBar"):
		status_bar = node
	
	for node in get_tree().get_nodes_in_group("CoinLabel"):
		coin_label = node
	refresh_coins()

	for node in get_tree().get_nodes_in_group("Interactibles"):
		node.get_node("Trigger").connect("body_entered", self, "on_trigger_entered", [node])
		node.get_node("Trigger").connect("body_exited", self, "on_trigger_exited", [node])


func has_player_entered(body, trigger):
	if ("is_active" in trigger) and not trigger.is_active:
		return false
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


func set_status(text):
	if status_bar == null:
		return
	status_bar.text = text


func clear_status():
	if status_bar == null:
		return
	status_bar.text = ""


func add_coins(amount):
	coins += amount
	if coin_label == null:
		return
	refresh_coins()


func refresh_coins():
	coin_label.text = "x" + str(coins)


func try_spend(amount):
	if amount > coins:
		return false
	coins -= amount
	refresh_coins()
	return true


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

	var real_speed = speed
	if Input.is_action_pressed("ui_accent"):
		real_speed *= boost

	if velocity.length() > 0:
		velocity = velocity.normalized() * real_speed

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
