extends Area3D

@export var notice: Control

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void: if body is Player: notice.show()
func _on_body_exited (body: Node3D) -> void: if body is Player: notice.hide()
