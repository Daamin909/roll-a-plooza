extends Node2D


func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	pass


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_play_pressed() -> void:
	SceneManager.change_scene("res://scenes/world.tscn") # Replace with function body.
