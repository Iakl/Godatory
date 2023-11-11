@tool
extends PanelContainer

const xTick_scn = preload("res://Scenes/Plot/Scenes/xtick.tscn")
const yTick_scn = preload("res://Scenes/Plot/Scenes/ytick.tscn")

@export_category("Plot")
@export_group("Title")
@export_multiline var _title: String = " ":
	set(value):
		_title = value
		set_title(value)

@export_group("X Axis")
@export_multiline var _x_label: String = " ":
	set(value):
		_x_label = value
		set_x_label(value)
@export var _x_ticks_number: int = 0:
	set(value):
		if value >= 0:
			_x_ticks_number = value
			set_x_ticks_number(value)
@export var _x_ticks_rotation: float = 0:
	set(value):
		_x_ticks_rotation = value
		set_x_ticks_rotation(value)

@export_group("Y Axis")
@export_multiline var _y_label: String = " ":
	set(value):
		_y_label = value
		set_y_label(value)
@export var _y_ticks_number: int = 0:
	set(value):
		if value >= 0:
			_y_ticks_number = value
			set_y_ticks_number(value)
@export var _y_ticks_rotation: float = 0:
	set(value):
		_y_ticks_rotation = value
		set_y_ticks_rotation(value)

func escape_bbcode(bbcode_text):
	return bbcode_text.replace("[", "[lb]")

func plot(data_name:String, y_data:Array):
	var plot_area = $Grid/PlotArea
	var max_y = y_data.max()
	var min_y = y_data.min()
	var scaled_data:PackedVector2Array
	var x_count = 0
	for y in y_data:
		scaled_data.append(Vector2(plot_area.get_size().x / (len(y_data) - 1) * x_count, y * plot_area.get_size().y / (min_y - max_y) + plot_area.size.y))
		x_count += 1
	var line = Line2D.new()
	line.set_default_color(Color(1, 0.443, 0.38))
	line.set_width(2)
	line.set_points(scaled_data)
	line.set_name(data_name)
	plot_area.add_child(line)


func set_title(title:String):
	$Grid/Title.set_text("[center]%s[/center]" % [escape_bbcode(title)])
	_on_resized()

func set_x_label(label:String):
	$Grid/X/Xlabel.set_text(label)
	_on_resized()
	
func set_x_ticks_number(value:int):
	var ticks_container = $Grid/X/Xaxis/Ticks
	var plot_area = $Grid/PlotArea
	var ticks_number = ticks_container.get_child_count() - 1
	if value > ticks_number:
		for i in value - ticks_number:
			var tick = xTick_scn.instantiate()
			ticks_container.add_child(tick)
			tick.set_name(str(i + 1))
			tick.set_label("")
	elif value < ticks_number:
		for i in ticks_number - value:
			ticks_container.get_child(ticks_number - i).queue_free()
	var tick_separation = plot_area.get_size().x / (value + 1)
	for i in value:
		ticks_container.get_child(i + 1).set_position(Vector2(tick_separation * (i + 1), 0))

func set_x_ticks_rotation(value:float):
	var x_ticks = $Grid/X/Xaxis/Ticks
	for child in x_ticks.get_children():
		child.set_tick_rotation(value)

func set_y_ticks_number(value:int):
	var ticks_container = $Grid/Y/Yaxis/Ticks
	var plot_area = $Grid/PlotArea
	var ticks_number = ticks_container.get_child_count()
	if value > ticks_number:
		for i in value - ticks_number:
			var tick = yTick_scn.instantiate()
			ticks_container.add_child(tick)
			tick.set_name(str(i + 1))
			tick.set_label("")
	elif value < ticks_number:
		for i in ticks_number - value:
			ticks_container.get_child(ticks_number - i - 1).queue_free()
	var tick_separation = plot_area.get_size().y / (value + 1)
	for i in value:
		ticks_container.get_child(i).set_position(Vector2(0, plot_area.get_size().y - tick_separation * (i + 1)))

func set_y_ticks_rotation(value:float):
	var x_ticks = $Grid/X/Xaxis/Ticks
	for child in x_ticks.get_children():
		child.set_tick_rotation(value)

func set_y_label(label:String):
	$Grid/Y/YlabelContainer/Ypivot/Ylabel.set_text(label)
	_on_resized()

func _on_resized():
	var plot_area_size = $Grid/PlotArea.get_size()
	$Grid/Y/Yaxis/ArrowLine.set_points([Vector2(0,0), Vector2(0, plot_area_size.y)])
	$Grid/X/Xaxis/ArrowLine.set_points([Vector2(0,0), Vector2(plot_area_size.x, 0)])
	$Grid/X/Xaxis/Arrow.set_position(Vector2(plot_area_size.x, 0))
	plot("demo", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
