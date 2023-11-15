@tool
extends Node2D

signal height_changed(height)

@onready var tick_label = $Label

@export var label: String = "":
	set(value):
		label = value
		set_label(value)

func adjust_position():
	tick_label.set_position(Vector2(tick_label.get_position().x, get_height() / 2))

func get_height():
	var tick_size = tick_label.get_minimum_size()
	var height = tick_size.x * abs(sin(tick_label.get_rotation()))
	return height

func set_label(value:String):
	tick_label.set_text(value)

func set_tick_rotation(value:float):
	tick_label.set_rotation(value)
	adjust_position()

func _ready():
	set_label("0")

func _on_label_minimum_size_changed():
	var label_size = tick_label.get_minimum_size()
	tick_label.set_pivot_offset(Vector2(label_size.x/2, label_size.y/2))
	adjust_position()
