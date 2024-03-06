extends Node2D

@onready var game_over_layer = %GameOverLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	game_over_layer.hide()
	SignalBus.collectible_entered.connect(_on_collectible_entered)

func _on_collectible_entered(area: Area2D):
	game_over_layer.show()
