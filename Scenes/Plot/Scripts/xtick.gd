@tool
extends Node2D

signal height_changed(height)

@onready var tick_label = $Label

@export var label: String = "0":
	set(value):
		label = value
		set_label(value)

func get_new_height():
	var tick_size = tick_label.get_minimum_size()
	var new_h = tick_size.x * abs(sin(tick_label.get_rotation()))
	tick_label.set_position(Vector2(tick_label.get_position().x, new_h / 2))

func set_label(value:String):
	tick_label.set_text(value)

func set_tick_rotation(value:float):
	tick_label.set_rotation(value)
	get_new_height()

func _ready():
	set_label("0")

func _on_label_minimum_size_changed():
	var label_size = tick_label.get_minimum_size()
	tick_label.set_pivot_offset(Vector2(label_size.x/2, label_size.y/2))
	get_new_height()
