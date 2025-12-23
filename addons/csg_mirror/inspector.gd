@tool
extends EditorInspectorPlugin

var plugin: EditorPlugin

func _init(p_plugin: EditorPlugin) -> void:
	plugin = p_plugin

func _can_handle(object: Object) -> bool:
	return object is SimpleCSGMirror

func _parse_begin(object: Object) -> void:
	
	var target: SimpleCSGMirror = object
	
	var container: VBoxContainer = VBoxContainer.new()
	container.add_theme_constant_override("separation", 6)
	
	var title: RichTextLabel = RichTextLabel.new()
	title.bbcode_enabled = true
	title.fit_content = true
	title.scroll_active = false
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	title.text = "[center][b][font_size=16]CSG Mirror Tool[/font_size][/b][/center]"

	container.add_child(title)

	var separator: HSeparator = HSeparator.new()
	container.add_child(separator)
	
	# Mirror X
	var mirror_x_button: Button = Button.new()
	mirror_x_button.text = "Mirror X-axis"
	mirror_x_button.pressed.connect(func():
		plugin.mirror_x(target)
	)
	container.add_child(mirror_x_button)
	
	# Mirror Y
	var mirror_y_button: Button = Button.new()
	mirror_y_button.text = "Mirror Y-axis"
	mirror_y_button.pressed.connect(func():
		plugin.mirror_y(target)
	)
	container.add_child(mirror_y_button)
	
	# Mirror Z
	var mirror_z_button: Button = Button.new()
	mirror_z_button.text = "Mirror Z-axis"
	mirror_z_button.pressed.connect(func():
		plugin.mirror_z(target)
	)
	container.add_child(mirror_z_button)
	
	container.add_child(HSeparator.new())
	
	var spacer: Control = Control.new()
	spacer.custom_minimum_size = Vector2(0, 1)
	container.add_child(spacer)
	
	add_custom_control(container)
