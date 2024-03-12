extends Node2D

var tone_tween : Tween

@export var player_position : Vector2Variable
@export var step : IntVariable
@export var delay : FloatVariable
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	delay.value_changed.connect(_on_delay_changed)
	setup_tone_tween()
	position.x = randi_range(0, 1920)
	position.y = randi_range(0, 1024)
	position = position.snapped(Vector2(step.value, step.value))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setup_tone_tween() -> void:
	if tone_tween:
		tone_tween.kill()
	tone_tween = create_tween().set_loops()
	tone_tween.tween_callback(play_tone).set_delay(delay.value)
	#pass

func play_tone():
	var min_pitch := 0.1
	var max_pitch := 1.9
	var pitch_max_distance := 0.9
	
	var y_difference := clampf((player_position.value.y - position.y) / step.value, -9, 9)
	audio_stream_player_2d.pitch_scale = 1 + y_difference/10
	print(audio_stream_player_2d.pitch_scale)
	audio_stream_player_2d.play()

func _on_area_2d_area_entered(area):
	SignalBus.collectible_entered.emit(area)
	audio_stream_player_2d.stop()
	queue_free()

func _on_delay_changed(value : float) -> void:
	if is_node_ready():
		setup_tone_tween()
