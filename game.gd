extends Node2D

@onready var game_over_layer = %GameOverLayer
@export var collectible_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	game_over_layer.hide()
	SignalBus.collectible_entered.connect(_on_collectible_entered)
	SignalBus.game_over.connect(_on_game_over)

func _on_collectible_entered(area: Area2D):
	spawn_collectible()

func spawn_collectible() -> void:
	var collectible : Node2D = collectible_scene.instantiate()
	call_deferred("add_child", collectible)
	
func _on_game_over():
	game_over_layer.show()
