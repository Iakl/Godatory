extends Control

@onready var plot = $Plot

var x = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_button_pressed():
	plot.plot("demo", x)
