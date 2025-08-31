extends Area2D

@export var label: Label

@export var object_name: String = "Unspecified"
@export var object_id: int = 0

func _ready() -> void:
	label.hide()

func body_entered(body: Node2D) -> void:
	core.player_add_inrange(self)
	label.show()

func body_exited(body: Node2D) -> void:
	core.player_remove_inrange(self)
	label.hide()

func destroy() -> void:
	self.queue_free()
