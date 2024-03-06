extends Node2D

var tone_tween : Tween

@export var game_data : GameData
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	game_data.delay_changed.connect(_on_delay_changed)
	setup_tone_tween()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setup_tone_tween() -> void:
	if tone_tween:
		tone_tween.kill()
	tone_tween = create_tween().set_loops()
	tone_tween.tween_callback(play_tone).set_delay(game_data.delay)
	#pass

func play_tone():
	audio_stream_player_2d.play()

func _on_area_2d_area_entered(area):
	SignalBus.collectible_entered.emit(area)
	audio_stream_player_2d.stop()
	queue_free()

func _on_delay_changed(value : float) -> void:
	if is_node_ready():
		setup_tone_tween()
