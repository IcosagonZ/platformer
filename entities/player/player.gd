# Player.gd
extends CharacterBody2D

# Movement speeds
@export var move_speed_walk = 200
@export var move_speed_run = 300
@onready var move_speed_current = move_speed_walk

@export var jump_height = 400
@export var gravity = 400

# Internal variables for movement logic
var _current_speed = 0
var _jumping = false

# Animation controller
func update_sprite() -> void:
	_current_speed = abs(velocity.x)
	
	if(!self.is_on_floor()): # when player is on air
		$AnimatedSprite.play("jump_air")
	else:
		if(_current_speed>move_speed_walk): # if current speed greater than walking speed
			$AnimatedSprite.play("run")
		elif(_current_speed>0):
			$AnimatedSprite.play("walk")
		else:
			$AnimatedSprite.play("idle")

# Movement code
func _physics_process(delta: float) -> void:
	var horizontal_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	velocity.y += gravity * delta # gravity logic
	velocity.x = horizontal_input * move_speed_current # movement logic
	move_and_slide()
	update_sprite()

# Input code
func _input(event: InputEvent) -> void:
	# flip horizontally based on movement
	if(Input.is_action_just_pressed("move_left")):
		$AnimatedSprite.flip_h=true
	if(Input.is_action_just_pressed("move_right")):
		$AnimatedSprite.flip_h=false

	if(Input.is_action_pressed("move_jump")):
		if(self.is_on_floor()): # jump only if player is on a floor
			velocity.y = -jump_height

	# set movement speed to walking speed or sprinting speed
	if(Input.is_action_just_pressed("move_sprint")):
		move_speed_current = move_speed_run
	if(Input.is_action_just_released("move_sprint")):
		move_speed_current = move_speed_walk
