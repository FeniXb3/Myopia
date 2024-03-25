extends Sprite2D

@export var delay : FloatVariable
@export var player_position : Vector2Variable
@export var player_direction : Vector2Variable

@onready var area_2d = %Area2D
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

var tone_tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	var collision_enable_tween = create_tween()
	collision_enable_tween.tween_callback(func(): area_2d.collision_mask = 2).set_delay(delay.value*5)
	delay.value_changed.connect(_on_delay_changed)
	play_tone()
	setup_tone_tween()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	SignalBus.body_collided.emit(area)
	print("Body collided!")

func setup_tone_tween() -> void:
	if tone_tween:
		tone_tween.kill()
	tone_tween = create_tween().set_loops()
	tone_tween.tween_callback(play_tone).set_delay(delay.value)
	#pass

func play_tone():
	
	var tmp1 := (player_direction.value.orthogonal() * position)
	var tmp2 := (player_direction.value.orthogonal() * player_position.value)
	print("Player direction: %v x %v"  % [tmp1, tmp2])

	if not tmp1.is_equal_approx(tmp2):
		audio_stream_player_2d.play()

func _on_delay_changed(value : float) -> void:
	if is_node_ready():
		setup_tone_tween()
