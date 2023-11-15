@tool
extends PanelContainer

const xTick_scn = preload("res://Scenes/Plot/Scenes/xtick.tscn")
const yTick_scn = preload("res://Scenes/Plot/Scenes/ytick.tscn")

@export_category("Plot")
@export var plottest: int = 0:
	set(value):
		plot("demo", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
		set_x_ticks_labels([00, 10, 20, 30, 40, 50, 60, 70, 80, 900])

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
	var data_length = len(y_data)
	var scaled_data = scale_data(y_data, 1)
	var line = Line2D.new()
	line.set_default_color(Color(1, 0.443, 0.38))
	line.set_width(2)
	line.set_points(scaled_data)
	line.set_name(data_name)
	plot_area.add_child(line)

func resize_lines():
	var plot_area = $Grid/PlotArea
	for line in plot_area.get_children():
		var y_coords = []
		for point in line.get_points():
			y_coords.append(point.y)
		line.set_points(scale_data(y_coords))

func scale_data(data:Array, invert=-1):
	var plot_area = $Grid/PlotArea
	var plot_size = plot_area.get_size()
	var data_length = len(data)
	var max_data = data.max()
	var min_data = data.min()
	var scaled_data:PackedVector2Array
	var x_count = 0
	for d in data:
		scaled_data.append(Vector2(plot_size.x / (data_length - 1) * x_count, invert*d * plot_size.y / (min_data - max_data) + 0*plot_size.y))
		x_count += 1
	print(scaled_data)
	return scaled_data

func set_title(title:String):
	$Grid/Title.set_text("[center]%s[/center]" % [escape_bbcode(title)])
	_on_resized()

func set_x_label(label:String):
	$Grid/X/Xlabel.set_text(label)
	_on_resized()

func set_x_axis_height(h):
	var x_axis_container = $Grid/X/Xaxis
	print(h)
	x_axis_container.set_custom_minimum_size(Vector2(0, h))
	
func set_x_ticks_labels(labels:Array):
	var ticks_container = $Grid/X/Xaxis/Ticks
	var labels_number = len(labels)
	_x_ticks_number = labels_number - 1
	for i in labels_number:
		ticks_container.get_child(i).set_label(str(labels[i]))
	
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
	var tick_separation = plot_area.get_size().x / value
	for i in value:
		ticks_container.get_child(i + 1).set_position(Vector2(tick_separation * (i + 1), 0))

func set_x_ticks_rotation(value:float):
	var x_ticks = $Grid/X/Xaxis/Ticks
	var max_h = 0
	for child in x_ticks.get_children():
		child.set_tick_rotation(value)
		var h = child.get_height()
		if h > max_h:
			max_h = h
	set_x_axis_height(max_h)

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
	var tick_separation = plot_area.get_size().y / value
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
	$Grid/Y/Yaxis/ArrowLine.set_points([Vector2(0,-4), Vector2(0, plot_area_size.y)])
	$Grid/X/Xaxis/ArrowLine.set_points([Vector2(0,0), Vector2(plot_area_size.x + 4, 0)])
	$Grid/X/Xaxis/Arrow.set_position(Vector2(plot_area_size.x, 0))
	resize_lines()
