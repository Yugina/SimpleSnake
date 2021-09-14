extends Node

signal died

var SnakeBodyPart = preload("res://Snake/SnakeBody.tscn")

var starting_body_parts = 2
var starting_direction = Vector2.RIGHT

var new_body_part_to_be_added = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(0, starting_body_parts):
		add_new_body_part()

func _on_SnakeHead_eaten():
	new_body_part_to_be_added = true # Delay adding body part until move timer triggered
	#$MoveTimer.wait_time = $MoveTimer.wait_time - 0.0025 # Make the game faster
	
func add_new_body_part():
	var new_snake_body_part = SnakeBodyPart.instance()
	
	var body_parts = $BodyParts.get_children()
	new_snake_body_part.parent_body_part = body_parts[-1] # Last child/element in the array
	if starting_direction == null:
		new_snake_body_part.direction = new_snake_body_part.parent_body_part.direction
	else:
		new_snake_body_part.direction = starting_direction
	new_snake_body_part.position = body_parts[-1].position - new_snake_body_part.direction * body_parts[-1].sprite_size
	
	body_parts[-1].connect("moved", new_snake_body_part, "_on_parent_moved")
	
	$BodyParts.add_child(new_snake_body_part)

func _on_SnakeHead_moved():
	$MoveTimer.start()
	if new_body_part_to_be_added == true:
		new_body_part_to_be_added = false
		add_new_body_part()
		
func _unhandled_input(event):
	var new_direction = null

	if event.is_action_pressed("ui_left"):
		new_direction = Vector2.LEFT
	elif event.is_action_pressed("ui_right"):
		new_direction = Vector2.RIGHT
	elif event.is_action_pressed("ui_up"):
		new_direction = Vector2.UP
	elif event.is_action_pressed("ui_down"):
		new_direction = Vector2.DOWN
	
	if new_direction != null:
		if new_direction != starting_direction:
			$BodyParts/SnakeHead.direction = starting_direction
			
		$BodyParts/SnakeHead.move_in_direction(new_direction)

	if $MoveTimer.is_stopped() != true:
		set_process_unhandled_input(false)
		$BodyParts/SnakeHead.set_process_unhandled_input(true)
		starting_direction = null

func _on_SnakeHead_hit():
	$MoveTimer.stop()
	
	var body_parts = $BodyParts.get_children()
	
	for i in range(body_parts.size()-1, -1, -1): # Reverse loop
		body_parts[i].position -= body_parts[i].direction * body_parts[i].sprite_size
		
	emit_signal("died")
