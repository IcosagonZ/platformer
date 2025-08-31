extends CanvasLayer

# Player variables
var player_energy:float = 100.0
var hud_energy:float = 100.0

# Player inventory and collectible variables
@export var player_inrange = []

func menu_hideall() -> void:
	$GameOver.hide()
	$Pause.hide()

func game_pause() -> void:
	get_tree().paused = true

func game_unpause() -> void:
	get_tree().paused = false

func game_quit() -> void:
	get_tree().quit()

func menu_gameover() -> void:
	$GameOver.show()

func menu_pause() -> void:
	$HUD.hide()
	$Pause.show()
	game_pause()

func button_reload_pressed() -> void:
	menu_hideall()
	get_tree().reload_current_scene()
	game_unpause()

func button_pause_pressed() -> void:
	menu_pause()

func button_resume_pressed() -> void:
	$Pause.hide()
	$HUD.show()
	game_unpause()

func button_quit_pressed() -> void:
	game_quit()

func hud_update_energy(value:float) -> void:
	player_energy = value
	#$HUD/Container/Container/Progress_Energy.set_value_no_signal(float(value))

func player_add_inrange(object):
	player_inrange.append(object)

func player_remove_inrange(object):
	player_inrange.erase(object)

func _ready() -> void:
	menu_hideall()

func _process(delta: float) -> void:
	if(get_tree().paused==false):
		hud_energy = lerp(hud_energy, player_energy, 0.1)
		$HUD/Container/Container/Progress_Energy.set_value_no_signal(hud_energy)

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("game_pause")):
		if(get_tree().paused):
			button_resume_pressed()
		else:
			button_pause_pressed()
	if(event.is_action_pressed("game_quit")):
		game_quit()
	if(event.is_action_pressed("game_retry")):
		button_reload_pressed()
