extends Node2D


@export var game_data : GameData
var current_direction := Vector2.RIGHT
var next_direction := Vector2.RIGHT
var move_tween : Tween
@onready var sprite_2d = $Sprite2D
@export var grid_size := Vector2(1920, 1080)
@onready var area_2d = %Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	game_data.delay_changed.connect(_on_delay_changed)
	SignalBus.collectible_entered.connect(_on_collectible_entered)
	setup_move_tween()
	
	
func setup_move_tween() -> void:
	if move_tween:
		move_tween.kill()
	move_tween = create_tween().set_loops()
	move_tween.tween_callback(move).set_delay(game_data.delay)
	#pass

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
		rotate(angle_radians)
	
	position += current_direction * game_data.step
	position.x = fposmod(position.x, grid_size.x)
	position.y = fposmod(position.y, grid_size.y)
	
	position.snapped(Vector2(game_data.step, game_data.step))


func _on_delay_changed(value : float) -> void:
	if is_node_ready():
		setup_move_tween()

func _on_collectible_entered(area: Area2D):
	if area != area_2d:
		return
		
	print("Collected!")
