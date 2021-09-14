extends Area2D

var direction
var last_position
var sprite_size
var parent_body_part
signal moved

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_size = $Sprite.texture.get_size() * $Sprite.scale
	sprite_size = sprite_size.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_parent_moved():
	last_position = position
	position = parent_body_part.position - parent_body_part.direction * sprite_size
	if position != last_position:
		direction = position - last_position
	direction = direction.normalized()
	emit_signal("moved")
