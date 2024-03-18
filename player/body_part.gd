extends Sprite2D

@export var delay : FloatVariable
@onready var area_2d = %Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var collision_enable_tween = create_tween()
	collision_enable_tween.tween_callback(func(): area_2d.collision_mask = 2).set_delay(delay.value*5)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	SignalBus.body_collided.emit(area)
	print("Body collided!")
