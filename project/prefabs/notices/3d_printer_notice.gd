extends Panel

@onready var usage_video: VideoStreamPlayer = %UsageVideo
@onready var usage_video_animation_player: AnimationPlayer = %UsageVideoAnimationPlayer
@onready var usage_video_indicator: TextureRect = %UsageVideoIndicator


func _on_usage_video_click(event: InputEvent) -> void:
	if not event is InputEventMouseButton: return
	if event.button_index != MOUSE_BUTTON_LEFT: return
	if not event.pressed: return

	## play/pause the video
	if usage_video.is_playing(): usage_video.paused = not usage_video.paused
	else: usage_video.play()

	## animation
	usage_video_animation_player.play("pause" if usage_video.paused else "play")


func _on_visibility_changed() -> void:
	if not is_node_ready(): return

	# reset stuff when leaving the notice
	if not visible:
		usage_video.stop()
		usage_video.paused = false
		usage_video_indicator.show()
		usage_video_indicator.modulate = Color.WHITE
		usage_video_indicator.texture = preload("res://project/icons/play.png")

	# free/capture mouse by simulating the escape button press
	var cancel_event = InputEventAction.new()
	cancel_event.action = "ui_cancel"
	cancel_event.pressed = true
	Input.parse_input_event(cancel_event)

