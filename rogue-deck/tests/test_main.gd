extends SceneTree

var failures: int = 0
var checks: int = 0


func _initialize() -> void:
	call_deferred("_run")


func check(condition: bool, message: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error(message)


func _run() -> void:
	check(ProjectSettings.get_setting("application/run/main_scene") == "res://scenes/main.tscn", "Main scene must be configured")
	check(ProjectSettings.get_setting("rendering/renderer/rendering_method") == "gl_compatibility", "Compatibility renderer must be configured")
	var packed = load("res://scenes/main.tscn")
	if not packed is PackedScene:
		push_error("Main scene could not be loaded")
		quit(1)
		return
	var scene = packed.instantiate()
	root.add_child(scene)
	await process_frame
	check(scene is Control, "Main scene must be a UI root")
	var title = scene.get_node_or_null("Center/Content/Title")
	check(title is Label and title.text == "RogueDeck", "Title must be visible and correct")
	var button = scene.get_node_or_null("Center/Content/Quit")
	check(button is Button, "Quit button must exist")
	if button is Button:
		check(button.has_focus(), "Keyboard focus must start on Quit")
		check(button.pressed.is_connected(Callable(scene, "_on_quit_pressed")), "Quit button must be connected")
	scene.queue_free()
	await process_frame
	if failures == 0:
		print("ROGUEDECK_TESTS_OK: %d checks" % checks)
	else:
		push_error("%d of %d checks failed" % [failures, checks])
	quit(1 if failures > 0 else 0)
