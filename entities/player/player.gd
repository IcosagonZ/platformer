# Player.gd
extends CharacterBody2D

# Movement speeds
@export var move_speed_walk = 200
@export var move_speed_run = 300
@export var move_speed_dash = 500
@export var move_speed_down = 600

@onready var move_speed_current = move_speed_walk

@export var jump_height = 400
@export var gravity = 400
@onready var gravity_current = gravity

# Energy system
@onready var energy:float  = energy_max
var energy_float:float  = 1.0
var energy_inuse = false

@export var energy_max:float = 100
@export var energy_regen = 2

@export var energy_jump = 15
@export var energy_sprint = 1
@export var energy_dash = 10
@export var energy_down = 1

# Internal variables for movement logic
var _current_speed = 0
var _jumping = false

func energy_deplete(deplete) -> bool:
	if(energy-deplete<0):
		return false
	else:
		energy -= deplete
		return true

func energy_replenish():
	if(!energy_inuse):
		if(energy<=95):
			energy+=energy_regen
		elif(energy>95 and energy<100):
			energy = energy_max

func energy_float_calculate():
	energy_float = energy / energy_max

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
	
	velocity.y += gravity_current * delta # gravity logic
	velocity.x = horizontal_input * move_speed_current # movement logic
	move_and_slide()
	update_sprite()

# Input code
#afunc _input(event: InputEvent) -> void:
	# flip horizontally based on movement
	if(Input.is_action_just_pressed("move_left")):
		$AnimatedSprite.flip_h=true
	if(Input.is_action_just_pressed("move_right")):
		$AnimatedSprite.flip_h=false

	if(Input.is_action_pressed("move_down")):
		if(energy_deplete(energy_down)):
			velocity.y = move_speed_down
	#	gravity_current = move_speed_down
	#else:
	#	gravity_current = gravity

	if(Input.is_action_pressed("move_jump")):
		if(self.is_on_floor()): # jump only if player is on a floor
			energy_deplete(energy_jump)
			velocity.y = -(jump_height*energy_float)

	# set movement speed to walking speed or sprinting speed
	if(Input.is_action_pressed("move_sprint")):
		if(self.is_on_floor()):
			if(energy_deplete(energy_sprint)):
				move_speed_current = move_speed_run
		else:
			if(energy_deplete(energy_dash)):
				move_speed_current = move_speed_dash
	else:
		move_speed_current = move_speed_walk

func timer_timeout() -> void:
	energy_replenish()
	core.hud_update_energy(energy)
	energy_float_calculate()
