extends Node2D

@export var step : IntVariable
@export var delay : FloatVariable
@export var player_position : Vector2Variable
@export var tween_movement : BoolVariable
var current_direction := Vector2.RIGHT
var next_direction := Vector2.RIGHT
var move_tween : Tween
@onready var head = %Head
@onready var body_container = %BodyContainer
var body_parts : Array = Array()

@export var grid_size := Vector2(1920, 1080)
@onready var area_2d = %Area2D
@onready var collected_audio_steam_player = %CollectedAudioSteamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	player_position.value = head.position
	delay.value_changed.connect(_on_delay_changed)
	SignalBus.collectible_entered.connect(_on_collectible_entered)
	setup_move_tween()
	for part in body_container.get_children():
		body_parts.append(part)
		
	pass
	
	
func setup_move_tween() -> void:
	if move_tween:
		move_tween.kill()
		
	if tween_movement.value:
		move_tween = create_tween()
		move_tween.tween_property(head, "position", player_position.value, delay.value).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
		#move_tween.set_parallel(true)
		for i in body_parts.size():
			var target : Node2D = body_parts[i-1] if i > 0 else head
			move_tween.parallel().tween_property(body_parts[i], "position", target.position, delay.value).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
			
		move_tween.tween_callback(move)
	else:
		move_tween = create_tween().set_loops()
		move_tween.tween_callback(move).set_delay(delay.value)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("move_left"):
		next_direction = Vector2.LEFT
	elif Input.is_action_just_pressed("move_right"):
		next_direction = Vector2.RIGHT
	elif Input.is_action_just_pressed("move_up"):
		next_direction = Vector2.UP
	elif Input.is_action_just_pressed("move_down"):
		next_direction = Vector2.DOWN
		
func move() -> void:
	if next_direction != current_direction and  current_direction.dot(next_direction) != -1:
		var angle_radians := current_direction.angle_to(next_direction)
		current_direction = next_direction
		head.rotate(angle_radians)
	
	var tmp_position = head.position;
	
	tmp_position += current_direction * step.value
	#tmp_position.x = fposmod(tmp_position.x, grid_size.x)
	#tmp_position.y = fposmod(tmp_position.y, grid_size.y)
	
	tmp_position = tmp_position.snapped(Vector2(step.value, step.value))
	player_position.value = tmp_position
	
	if tween_movement.value:
		setup_move_tween()
	else:
		var last_part : Sprite2D = body_parts.pop_back()
		last_part.position = head.position
		body_parts.insert(0, last_part)
		head.position = player_position.value
		#position = player_position.value

func _on_delay_changed(value : float) -> void:
	if is_node_ready():
		setup_move_tween()

func _on_collectible_entered(area: Area2D):
	if area != area_2d:
		return
		
	collected_audio_steam_player.play()
	print("Collected!")
