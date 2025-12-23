@tool
extends CSGCombiner3D
class_name SimpleCSGMirror

func capture_state() -> Dictionary:
	
	var state: Dictionary = {}
	
	state["__self__"] = {
		"position": position,
		"rotation": rotation,
		"scale": scale
	}
	
	for child: Node in get_children():
		
		if child is CSGPrimitive3D:
			
			state[child] = {
				"position": child.position,
				"rotation": child.rotation,
				"scale": child.scale
			}
			
			if child is CSGPolygon3D:
				state[child]["polygon"] = child.polygon.duplicate()
	
	return state

func apply_mirror_x() -> void:
	
	rotation.z = -rotation.z
	rotation.y = -rotation.y
	
	for child: Node in get_children():
		
		if child is CSGPrimitive3D:
			child.rotation.y = -child.rotation.y
			child.rotation.z = -child.rotation.z
			
			child.position.x = -child.position.x
			
			if child is CSGPolygon3D:
				child.polygon = _invert_polygon_x(child.polygon)

func apply_mirror_y() -> void:
	
	rotation.z = -rotation.z
	rotation.x = -rotation.x
	
	for child: Node in get_children():
		
		if child is CSGPrimitive3D:
			child.rotation.x = -child.rotation.x
			child.rotation.z = -child.rotation.z
			
			child.position.y = -child.position.y
			
			if child is CSGPolygon3D:
				child.polygon = _invert_polygon_y(child.polygon)

func apply_mirror_z() -> void:
	
	rotation.y = -rotation.y + PI
	rotation.z = -rotation.z
	
	for child: Node in get_children():
		
		if child is CSGPrimitive3D:
			child.rotation.y = -child.rotation.y
			child.rotation.z = -child.rotation.z
			
			child.position.x = -child.position.x
			
			if child is CSGPolygon3D:
				child.polygon = _invert_polygon_x(child.polygon)
				child.polygon = _keep_polygon_z(child.polygon)
	
	#rotation.x = -rotation.x
	#rotation.y = -rotation.y
	#
	#for child: Node in get_children():
		#
		#if child is CSGPrimitive3D:
			#child.rotation.z = -child.rotation.z
			##child.rotation.y = -child.rotation.y
			#
			#child.position.z = -child.position.z
			#
			#if child is CSGPolygon3D:
				#child.polygon = _invert_polygon_x(child.polygon)

func restore_state(state: Dictionary) -> void:
	
	if state.has("__self__"):
		position = state["__self__"]["position"]
		rotation = state["__self__"]["rotation"]
		scale = state["__self__"]["scale"]
	
	for key in state.keys():
		
		if typeof(key) != TYPE_OBJECT:
			continue
		
		var node: Node = key
		
		if not is_instance_valid(node):
			continue
		
		if state[node].has("position"):
			node.position = state[node]["position"]
		
		if state[node].has("rotation"):
			node.rotation = state[node]["rotation"]
		
		if state[node].has("scale"):
			node.scale = state[node]["scale"]
		
		if node is CSGPolygon3D and state[node].has("polygon"):
			node.polygon = state[node]["polygon"]

func _invert_polygon_x(points: PackedVector2Array) -> PackedVector2Array:
	
	var result: PackedVector2Array = PackedVector2Array()
	
	for point: Vector2 in points:
		result.append(Vector2(-point.x, point.y))
	
	return result

func _invert_polygon_y(points: PackedVector2Array) -> PackedVector2Array:
	
	var result: PackedVector2Array = PackedVector2Array()
	
	for point: Vector2 in points:
		result.append(Vector2(point.x, -point.y))
	
	return result

func _keep_polygon_z(points: PackedVector2Array) -> PackedVector2Array:
	
	var result: PackedVector2Array = PackedVector2Array()
	
	for point: Vector2 in points:
		result.append(Vector2(point.x, point.y))
	
	return result
