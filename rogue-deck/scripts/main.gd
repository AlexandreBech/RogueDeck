extends Control


func _ready() -> void:
	$Center/Content/Quit.grab_focus()
	# The export smoke check must prove this scene reached its ready callback.
	if "--smoke-test" in OS.get_cmdline_user_args():
		print("ROGUEDECK_SMOKE_OK")
		get_tree().quit(0)


func _on_quit_pressed() -> void:
	get_tree().quit()
