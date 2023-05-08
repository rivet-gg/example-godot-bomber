@tool
extends EditorPlugin

const AUTO_LOAD_NAME = "RivetClient"

func _enter_tree():
	add_autoload_singleton(AUTO_LOAD_NAME, "res://addons/rivet_api/rivet_client.gd")


func _exit_tree():
	remove_autoload_singleton(AUTO_LOAD_NAME)

