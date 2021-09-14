extends Area2D

var direction = Vector2.ZERO
var sprite_size
signal hit
signal eaten
signal moved


# Called when the node enters the scene tree for the first time.
func _ready():
	#direction = Vector2.RIGHT
	sprite_size = $Sprite.texture.get_size() * $Sprite.scale
	sprite_size = sprite_size.x
	set_process_unhandled_input(false)


func _unhandled_input(event):
	#var temp_direction = null
	
#	if direction == Vector2.UP or direction == Vector2.DOWN:
#		if event.is_action_pressed("ui_left"):
#			temp_direction = Vector2.LEFT
#		if event.is_action_pressed("ui_right"):
#			temp_direction = Vector2.RIGHT
#	elif direction == Vector2.LEFT or direction == Vector2.RIGHT:
#		if event.is_action_pressed("ui_up"):
#			temp_direction = Vector2.UP
#		if event.is_action_pressed("ui_down"):
#			temp_direction = Vector2.DOWN
			
	if event.is_action_pressed("ui_left"):
		move_in_direction(Vector2.LEFT)
	elif event.is_action_pressed("ui_right"):
		move_in_direction(Vector2.RIGHT)
	elif event.is_action_pressed("ui_up"):
		move_in_direction(Vector2.UP)
	elif event.is_action_pressed("ui_down"):
		move_in_direction(Vector2.DOWN)
		
#	if temp_direction != null:
#		direction = temp_direction
#		position += direction * sprite_size
#		emit_signal("moved")
		#$"../MoveTimer".start()
		
func move_in_direction(new_direction):
	
	var change_direction = false
	var direction_sound = null

	if new_direction == Vector2.LEFT:
		if direction != Vector2.LEFT and direction != Vector2.RIGHT:
			change_direction = true
			direction_sound = $Sounds/Directions/LeftSound
	if new_direction == Vector2.RIGHT:
		if direction != Vector2.RIGHT and direction != Vector2.LEFT:
			change_direction = true
			direction_sound = $Sounds/Directions/RightSound
	if new_direction == Vector2.UP:
		if direction != Vector2.UP and direction != Vector2.DOWN:
			change_direction = true
			direction_sound = $Sounds/Directions/UpSound
	if new_direction == Vector2.DOWN:
		if direction != Vector2.DOWN and direction != Vector2.UP:
			change_direction = true
			direction_sound = $Sounds/Directions/DownSound
	
	if change_direction == true:
		direction = new_direction
		position += direction * sprite_size
		direction_sound.play()
		emit_signal("moved")
	
func _on_MoveTimer_timeout():			
	position += direction * sprite_size
	emit_signal("moved")


func _on_SnakeHead_area_entered(area):
	if area.is_in_group("pickups"):
		emit_signal("eaten")
		$Sounds/PickupSound.play()
	elif area.is_in_group("bodyparts") || area.is_in_group("walls"):
		emit_signal("hit")
		$Sounds/HitSound.play()
