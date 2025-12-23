@tool
extends EditorPlugin

var undo_redo: EditorUndoRedoManager
var inspector_plugin: EditorInspectorPlugin

func _enter_tree() -> void:
	
	undo_redo = get_undo_redo()
	
	inspector_plugin = preload("res://addons/csg_mirror/inspector.gd").new(self)
	add_inspector_plugin(inspector_plugin)
	
	# Register Custom Node
	add_custom_type(
		"SimpleCSGMirror",          
		"CSGCombiner3D",                
		preload("res://addons/csg_mirror/csg_mirror.gd"),
		load("res://addons/csg_mirror/SimpleCSGMirrorIcon.png")
	)

func _exit_tree() -> void:
	remove_inspector_plugin(inspector_plugin)

func mirror_x(target: SimpleCSGMirror) -> void:
	_apply_mirror(target, "apply_mirror_x", "Mirror CSG X Axis")

func mirror_y(target: SimpleCSGMirror) -> void:
	_apply_mirror(target, "apply_mirror_y", "Mirror CSG Y Axis")

func mirror_z(target: SimpleCSGMirror) -> void:
	_apply_mirror(target, "apply_mirror_z", "Mirror CSG Z Axis")

func _apply_mirror(target: SimpleCSGMirror, method_name: String, action_name: String) -> void:
	
	var before: Dictionary = target.capture_state()
	
	undo_redo.create_action(action_name)
	
	undo_redo.add_do_method(target, method_name)
	undo_redo.add_undo_method(target, "restore_state", before)
	
	undo_redo.commit_action()
