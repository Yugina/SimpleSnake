extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var sprite_size
var max_screen_size
var rng

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_size = $Sprite.texture.get_size() * $Sprite.scale
	var screen_size = get_viewport().get_visible_rect().size
	max_screen_size = Vector2(screen_size.x - sprite_size.x * 2, screen_size.y - sprite_size.y * 2)
	
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	set_new_rand_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_FlashTimer_timeout():
	visible = !visible


func _on_Pickup_area_entered(area):
	$FlashTimer.start()
	visible = false
	set_new_rand_position()


func set_new_rand_position():
	var body_parts = get_tree().get_nodes_in_group("bodyparts")
	var empty_space_found = false
	var temp_position
	
	while empty_space_found == false:
		
		empty_space_found = true
		
		var rand_x = rng.randi_range(sprite_size.x, max_screen_size.x)
		var rand_y = rng.randi_range(sprite_size.y, max_screen_size.y)

		temp_position = Vector2(rand_x, rand_y).snapped(sprite_size)
		temp_position += sprite_size / 2
		
		for body_part in body_parts:
			var body_part_rect = Rect2(body_part.position, sprite_size)
			
			if body_part_rect.has_point(temp_position):
				empty_space_found = false
				break
				
	if temp_position != null:
		position = temp_position
	else:
		position = Vector2(-100,-100)
