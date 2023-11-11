@tool
extends Container

func _on_resized():
	var container_size = get_size()
	$Ypivot.set_position(Vector2(0, container_size.y))
	$Ypivot/Ylabel.set_size(Vector2(container_size.y, container_size.x))


func _on_ylabel_minimum_size_changed():
	var label_size = $Ypivot/Ylabel.get_minimum_size()
	set_custom_minimum_size(Vector2(label_size.y, label_size.x))
