extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Snake = preload("res://Snake/Snake.tscn")
var current_snake = null
var snake_dead = false

var mute = false
var unmuted_icon = preload("res://Sprites/audioOn.png")
var muted_icon = preload("res://Sprites/audioOff.png")

var score = 0

# Snake move timer wait times
const SUPER_SLOW = 0.3
const SLOW = 0.225
const NORMAL = 0.125
const FAST = 0.09
const SUPER_FAST = 0.063

# Called when the node enters the scene tree for the first time.
func _ready():
	snake_dead = true
	get_tree().paused = true
	current_snake = $Snake
	$CanvasLayer/StartMenu/MenuList/OptionsColumns/OptionsSelections/SpeedSlider.grab_focus()
	
	$CanvasLayer/MuteButton.focus_mode = Control.FOCUS_NONE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CanvasLayer/FPSLabel.text = "FPS: " + str(Engine.get_frames_per_second())


func _on_StartButton_pressed():	
	if snake_dead == true:
		snake_dead = false
		current_snake.queue_free()
		var new_snake = Snake.instance()
		add_child(new_snake)
		new_snake.connect("died", self, "_on_Snake_died")
		current_snake = new_snake
		
	match $CanvasLayer/StartMenu/MenuList/OptionsColumns/OptionsSelections/SpeedSlider.value as int:
		0:
			current_snake.get_node("MoveTimer").wait_time = SUPER_SLOW
		50:
			current_snake.get_node("MoveTimer").wait_time = SLOW
		100:
			current_snake.get_node("MoveTimer").wait_time = NORMAL
		150:
			current_snake.get_node("MoveTimer").wait_time = FAST
		200:
			current_snake.get_node("MoveTimer").wait_time = SUPER_FAST
	
	$CanvasLayer/StartMenu.visible = false
	get_tree().paused = false
	
	score = 0
	$CanvasLayer/Score.text = "Score: " + str(score)

func _on_Snake_died():
	get_tree().paused = true
	snake_dead = true
	$DeathDelayTimer.start()
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") || event.is_action_pressed("ui_accept"):
		if snake_dead == false: # If snake not dead
			get_tree().paused = !get_tree().paused
			$CanvasLayer/PauseScreen.visible = !$CanvasLayer/PauseScreen.visible
		elif $CanvasLayer/StartMenu.visible == true:
			_on_StartButton_pressed() # Trigger start button press
	
	if event.is_action_pressed("mute"):
		_on_MuteButton_pressed()


func _on_Pickup_area_entered(area):
	score += 1
	$CanvasLayer/Score.text = "Score: " + str(score)

func _on_DeathDelayTimer_timeout():
	$CanvasLayer/StartMenu.visible = true
	$CanvasLayer/StartMenu/MenuList/OptionsColumns/OptionsSelections/SpeedSlider.grab_focus()

func _on_MuteButton_pressed():
	mute = !mute
	AudioServer.set_bus_mute(0, mute)
	
	if mute == true:
		$CanvasLayer/MuteButton.icon = muted_icon
	else:
		$CanvasLayer/MuteButton.icon = unmuted_icon
