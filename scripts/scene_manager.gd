extends Node

var current_scene: Node = null

var scene_data: Dictionary = {}

var is_changing_scene := false


func _ready():
	var root = get_tree().root
	if root.get_child_count() > 0:
		current_scene = root.get_child(root.get_child_count() - 1)


func change_scene(
	scene_path: String,
	data: Dictionary = {},
	keep_data := false
) -> void:
	if is_changing_scene:
		return

	is_changing_scene = true

	if not keep_data:
		scene_data = data

	await _fade_out()

	await _free_current_scene()
	_load_new_scene(scene_path)

	await _fade_in()

	is_changing_scene = false



func _free_current_scene() -> void:
	if current_scene and is_instance_valid(current_scene):
		current_scene.queue_free()
		await get_tree().process_frame
		current_scene = null


func _load_new_scene(scene_path: String) -> void:
	var packed_scene := load(scene_path)
	if packed_scene == null:
		push_error("SceneManager: Failed to load " + scene_path)
		return

	current_scene = packed_scene.instantiate()
	get_tree().root.add_child(current_scene)


func _fade_out() -> void:
	await get_tree().process_frame

func _fade_in() -> void:
	await get_tree().process_frame


func reload_scene() -> void:
	if current_scene:
		change_scene(current_scene.scene_file_path, scene_data, true)

func quit_game() -> void:
	get_tree().quit()
