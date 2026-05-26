@tool
extends Node

const EPSILON: float = 1e-6

var _lines: Array = []

var _immediate_points: PackedVector3Array = PackedVector3Array()
var _immediate_colors: PackedColorArray = PackedColorArray()

var _mesh: ImmediateMesh
var _instance: RID
var _material: StandardMaterial3D

func _ready() -> void:
	set_process(false)
	
	if not OS.is_debug_build():
		return
	
	_mesh = ImmediateMesh.new()
	
	_material = StandardMaterial3D.new()
	_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_material.vertex_color_use_as_albedo = true
	_material.no_depth_test = true
	
	_instance = RenderingServer.instance_create()
	RenderingServer.instance_set_base(_instance, _mesh.get_rid())
	
	set_process(true)

func _exit_tree() -> void:
	if _instance.is_valid():
		RenderingServer.free_rid(_instance)

func _process(delta: float) -> void:
	var world: World3D = get_viewport().find_world_3d()
	if world:
		RenderingServer.instance_set_scenario(_instance, world.scenario)
	
	_mesh.clear_surfaces()
	
	var i: int = _lines.size() - 1
	while i >= 0:
		_lines[i].time -= delta
		if _lines[i].time <= 0.0:
			_lines.remove_at(i)
		i -= 1
	
	if _lines.is_empty() and _immediate_points.is_empty():
		return
		
	_mesh.surface_begin(Mesh.PRIMITIVE_LINES, _material)
	
	if not _immediate_points.is_empty():
		var arrays: Array = []
		arrays.resize(Mesh.ARRAY_MAX)
		arrays[Mesh.ARRAY_VERTEX] = _immediate_points
		arrays[Mesh.ARRAY_COLOR] = _immediate_colors
		
		for pt_idx: int in range(_immediate_points.size()):
			_mesh.surface_set_color(_immediate_colors[pt_idx])
			_mesh.surface_add_vertex(_immediate_points[pt_idx])
			
	for line: Dictionary in _lines:
		_mesh.surface_set_color(line.color)
		_mesh.surface_add_vertex(line.p1)
		_mesh.surface_set_color(line.color)
		_mesh.surface_add_vertex(line.p2)
		
	_mesh.surface_end()
	
	_immediate_points.clear()
	_immediate_colors.clear()


func _add_line(p1: Vector3, p2: Vector3, color: Color, lifetime: float) -> void:
	if lifetime <= 0.0:
		_immediate_points.append(p1)
		_immediate_points.append(p2)
		_immediate_colors.append(color)
		_immediate_colors.append(color)
	else:
		_lines.append({
			"p1": p1,
			"p2": p2,
			"color": color,
			"time": lifetime
		})


func line(p1: Vector3, p2: Vector3, color: Color = Color.WHITE, lifetime: float = 0.0) -> void:
	if not OS.is_debug_build(): return
	_add_line(p1, p2, color, lifetime)


func cube(position: Vector3, size: Vector3, color: Color = Color.WHITE, lifetime: float = 0.0) -> void:
	if not OS.is_debug_build(): return
	
	var hs: Vector3 = size / 2.0
	var p0: Vector3 = position + Vector3(-hs.x, -hs.y, -hs.z)
	var p1: Vector3 = position + Vector3( hs.x, -hs.y, -hs.z)
	var p2: Vector3 = position + Vector3( hs.x, -hs.y,  hs.z)
	var p3: Vector3 = position + Vector3(-hs.x, -hs.y,  hs.z)
	var p4: Vector3 = position + Vector3(-hs.x,  hs.y, -hs.z)
	var p5: Vector3 = position + Vector3( hs.x,  hs.y, -hs.z)
	var p6: Vector3 = position + Vector3( hs.x,  hs.y,  hs.z)
	var p7: Vector3 = position + Vector3(-hs.x,  hs.y,  hs.z)
	
	var edges: Array[Array] = [
		[p0, p1], [p1, p2], [p2, p3], [p3, p0],
		[p4, p5], [p5, p6], [p6, p7], [p7, p4],
		[p0, p4], [p1, p5], [p2, p6], [p3, p7]
	]
	
	for edge: Array in edges:
		_add_line(edge[0], edge[1], color, lifetime)


func sphere(position: Vector3, radius: float, color: Color = Color.WHITE, lifetime: float = 0.0) -> void:
	if not OS.is_debug_build(): return
	
	const SEGMENTS: int = 32
	
	for i: int in range(SEGMENTS):
		var a1: float = (i * TAU) / SEGMENTS
		var a2: float = ((i + 1) * TAU) / SEGMENTS
		
		var cos1: float = cos(a1) * radius
		var sin1: float = sin(a1) * radius
		var cos2: float = cos(a2) * radius
		var sin2: float = sin(a2) * radius
		
		_add_line(position + Vector3(cos1, 0.0, sin1), position + Vector3(cos2, 0.0, sin2), color, lifetime)
		_add_line(position + Vector3(cos1, sin1, 0.0), position + Vector3(cos2, sin2, 0.0), color, lifetime)
		_add_line(position + Vector3(0.0, cos1, sin1), position + Vector3(0.0, cos2, sin2), color, lifetime)


func cylinder(p_start: Vector3, p_end: Vector3, radius: float, color: Color = Color.WHITE, lifetime: float = 0.0) -> void:
	if not OS.is_debug_build(): return
	
	const SEGMENTS: int = 32
	var axis: Vector3 = (p_end - p_start).normalized()
	if axis.is_zero_approx(): return
	
	var ref: Vector3 = Vector3.UP if abs(axis.dot(Vector3.UP)) < 0.99 else Vector3.RIGHT
	var tangent: Vector3 = axis.cross(ref).normalized() * radius
	var bitangent: Vector3 = axis.cross(tangent).normalized() * radius

	for i: int in range(SEGMENTS):
		var a1: float = (i * TAU) / SEGMENTS
		var a2: float = ((i + 1) * TAU) / SEGMENTS
		
		var vec1: Vector3 = (tangent * cos(a1)) + (bitangent * sin(a1))
		var vec2: Vector3 = (tangent * cos(a2)) + (bitangent * sin(a2))
		
		_add_line(p_start + vec1, p_start + vec2, color, lifetime)
		_add_line(p_end + vec1, p_end + vec2, color, lifetime)

	var angles: Array[float] = [0.0, PI / 2.0, PI, 3.0 * PI / 2.0]
	for angle: float in angles:
		var offset: Vector3 = (tangent * cos(angle)) + (bitangent * sin(angle))
		_add_line(p_start + offset, p_end + offset, color, lifetime)


func capsule(p_start: Vector3, p_end: Vector3, radius: float, color: Color = Color.WHITE, lifetime: float = 0.0) -> void:
	if not OS.is_debug_build(): return
		
	const SEGMENTS: int = 32
	const HALF_SEGMENTS: int = 16
	
	var to_end: Vector3 = p_end - p_start
	var distance: float = to_end.length()
	var axis: Vector3 = to_end.normalized()
	
	if axis.is_zero_approx(): return
	if distance < radius * 2.0:
		sphere((p_start + p_end) * 0.5, radius, color, lifetime)
		return

	var ref: Vector3 = Vector3.UP if abs(axis.dot(Vector3.UP)) < 0.99 else Vector3.RIGHT
	var tangent: Vector3 = axis.cross(ref).normalized()
	var bitangent: Vector3 = axis.cross(tangent).normalized()
	
	var t_rad: Vector3 = tangent * radius
	var b_rad: Vector3 = bitangent * radius
	var cap_start: Vector3 = p_start + (axis * radius)
	var cap_end: Vector3 = p_end - (axis * radius)

	for i: int in range(SEGMENTS):
		var a1: float = (i * TAU) / SEGMENTS
		var a2: float = ((i + 1) * TAU) / SEGMENTS
		var vec1: Vector3 = (t_rad * cos(a1)) + (b_rad * sin(a1))
		var vec2: Vector3 = (t_rad * cos(a2)) + (b_rad * sin(a2))
		_add_line(cap_start + vec1, cap_start + vec2, color, lifetime)
		_add_line(cap_end + vec1, cap_end + vec2, color, lifetime)

	var angles: Array[float] = [0.0, PI / 2.0, PI, 3.0 * PI / 2.0]
	for angle: float in angles:
		var offset: Vector3 = (t_rad * cos(angle)) + (b_rad * sin(angle))
		_add_line(cap_start + offset, cap_end + offset, color, lifetime)

	for i: int in range(HALF_SEGMENTS):
		var a1: float = (i * PI) / HALF_SEGMENTS
		var a2: float = ((i + 1) * PI) / HALF_SEGMENTS
		
		var arc_t1_start: Vector3 = (t_rad * cos(a1)) - (axis * radius * sin(a1))
		var arc_t2_start: Vector3 = (t_rad * cos(a2)) - (axis * radius * sin(a2))
		_add_line(cap_start + arc_t1_start, cap_start + arc_t2_start, color, lifetime)
		
		var arc_b1_start: Vector3 = (b_rad * cos(a1)) - (axis * radius * sin(a1))
		var arc_b2_start: Vector3 = (b_rad * cos(a2)) - (axis * radius * sin(a2))
		_add_line(cap_start + arc_b1_start, cap_start + arc_b2_start, color, lifetime)

		var arc_t1_end: Vector3 = (t_rad * cos(a1)) + (axis * radius * sin(a1))
		var arc_t2_end: Vector3 = (t_rad * cos(a2)) + (axis * radius * sin(a2))
		_add_line(cap_end + arc_t1_end, cap_end + arc_t2_end, color, lifetime)
		
		var arc_b1_end: Vector3 = (b_rad * cos(a1)) + (axis * radius * sin(a1))
		var arc_b2_end: Vector3 = (b_rad * cos(a2)) + (axis * radius * sin(a2))
		_add_line(cap_end + arc_b1_end, cap_end + arc_b2_end, color, lifetime)


func cross(position: Vector3, size: float, color: Color = Color.WHITE, lifetime: float = 0.0) -> void:
	if not OS.is_debug_build(): return
	var h: float = size / 2.0
	_add_line(position + Vector3(-h, 0.0, 0.0), position + Vector3(h, 0.0, 0.0), color, lifetime)
	_add_line(position + Vector3(0.0, -h, 0.0), position + Vector3(0.0, h, 0.0), color, lifetime)
	_add_line(position + Vector3(0.0, 0.0, -h), position + Vector3(0.0, 0.0, h), color, lifetime)


func circle(position: Vector3, direction: Vector3 = Vector3.FORWARD, radius: float = 1.0, color: Color = Color.WHITE, lifetime: float = 0.0) -> void:
	if not OS.is_debug_build(): return
	
	const SEGMENTS: int = 32
	var normal: Vector3 = direction.normalized()
	if normal.is_zero_approx(): return
	
	var ref: Vector3 = Vector3.UP if abs(normal.dot(Vector3.UP)) < 0.99 else Vector3.RIGHT
	var tangent: Vector3 = normal.cross(ref).normalized() * radius
	var bitangent: Vector3 = normal.cross(tangent).normalized() * radius

	for i: int in range(SEGMENTS):
		var a1: float = (i * TAU) / SEGMENTS
		var a2: float = ((i + 1) * TAU) / SEGMENTS
		var p1: Vector3 = position + (tangent * cos(a1)) + (bitangent * sin(a1))
		var p2: Vector3 = position + (tangent * cos(a2)) + (bitangent * sin(a2))
		_add_line(p1, p2, color, lifetime)
