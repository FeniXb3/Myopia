extends Node2D

@onready var game_over_layer = %GameOverLayer
@export var collectible_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	game_over_layer.hide()
	SignalBus.collectible_entered.connect(_on_collectible_entered)

func _on_collectible_entered(area: Area2D):
	#game_over_layer.show()
	spawn_collectible()

func spawn_collectible() -> void:
	var collectible : Node2D = collectible_scene.instantiate()
	call_deferred("add_child", collectible)
