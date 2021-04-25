extends PanelContainer

export var MAX_BUTTONS_PER_ROW = 2
export (PackedScene) var answer_button
var answer_buttons = {}
var player = null
var interactible = null
var task_data = {}


func _init():
	add_to_group("TaskDialog")


func clear():
	for button in answer_buttons:
		button.queue_free()


func activate(interactible_, player_, task_data_):
	interactible = interactible_
	player = player_
	task_data = task_data_

	visible = true
	get_tree().paused = true

	clear()

	$VBox/TaskTextContainer/TaskText.text = task_data["text"]
	
	var button_rows = [
		$VBox/AnswersContainer/VBox/AnswersFirstLine/HBox,
		$VBox/AnswersContainer/VBox/AnswersSecondLine/HBox,
	]
	var button_row = 0
	var answer_num = 0
	var max_x = 0
	var max_y = 0
	for answer in task_data["answers"]:
		var row = button_rows[button_row]
		
		var button = answer_button.instance()
		answer_buttons[button] = answer
		if answer["type"] == "text":
			button.text = answer["text"]
		elif answer["type"] == "image":
			print("res://tasks/answers" + answer["name"] + ".png")
			var texture = load("res://tasks/answers/" + answer["name"] + ".png")
			print(texture)
			button.icon = texture
		button.connect("toggled", self, "on_button_checked", [button])
		if button.rect_size.x > max_x:
			max_x = button.rect_size.x
		if button.rect_size.y > max_y:
			max_y = button.rect_size.y

		row.add_child(button)

		answer_num += 1
		if answer_num == MAX_BUTTONS_PER_ROW:
			answer_num = 0
			button_row += 1

	for button in answer_buttons:
		button.rect_size.x = max_x
		button.rect_size.y = max_y


func on_button_checked(button_pressed, button):
	if not button_pressed:
		return

	for other_button in answer_buttons:
		if other_button == button:
			continue
		other_button.pressed = false


func get_checked_button():
	for button in answer_buttons:
		if button.pressed:
			return button
	return null


func on_help_pressed():
	pass # Replace with function body.


func on_ok_pressed():
	var selected_button = get_checked_button()
	if selected_button != null:
		var answer_data = answer_buttons[selected_button]
		if answer_data.get("correct", false):
			player.add_coins(task_data["prize"])
			player.clear_status()
		else:
			player.set_status("WRONG")

	interactible.deactivate(player)
	clear()
	answer_buttons = {}
	get_tree().paused = false
	visible = false
