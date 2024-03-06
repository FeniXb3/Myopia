extends Resource
class_name GameData

@export var step : int:
	set(value):
		step = value
		step_changed.emit(value)
@export var delay : float:
	set(value):
		delay = value
		delay_changed.emit(value)

signal step_changed(value: float)
signal delay_changed(value: float)

