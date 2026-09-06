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
	var background_packed = load("res://scenes/battle_background.tscn")
	check(background_packed is PackedScene, "Battle background must be a reusable scene")
	if background_packed is PackedScene:
		var background_instance = background_packed.instantiate()
		check(background_instance is Control, "Battle background must use a scalable Control root")
		if background_instance is Control:
			check(background_instance.mouse_filter == Control.MOUSE_FILTER_IGNORE, "Battle background must not intercept UI input")
			check(background_instance.anchor_right == 1.0 and background_instance.anchor_bottom == 1.0, "Battle background must fill its parent")
		background_instance.free()
	var packed = load("res://scenes/main.tscn")
	if not packed is PackedScene:
		push_error("Main scene could not be loaded")
		quit(1)
		return
	var scene = packed.instantiate()
	root.add_child(scene)
	await process_frame
	check(scene is Control, "Main scene must be a UI root")
	var background = scene.get_node_or_null("BattleBackground")
	check(background is Control, "Main scene must display the battle background")
	if background is Control:
		check(scene.get_child(0) == background, "Battle background must render behind title controls")
	var title = scene.get_node_or_null("Center/Content/Title")
	check(title is Label and title.text == "RogueDeck", "Title must be visible and correct")
	var start_button = scene.get_node_or_null("Center/Content/Start")
	check(start_button is Button and start_button.text == "Start", "Start button must be visible and correctly labeled")
	if start_button is Button:
		check(start_button.get_index() < scene.get_node("Center/Content/Quit").get_index(), "Start button must appear before Quit")
		check(start_button.has_focus(), "Keyboard focus must start on Start")
	var quit_button = scene.get_node_or_null("Center/Content/Quit")
	check(quit_button is Button, "Quit button must exist")
	if quit_button is Button:
		check(quit_button.pressed.is_connected(Callable(scene, "_on_quit_pressed")), "Quit button must be connected")
	var options_button = scene.get_node_or_null("Center/Content/Options")
	check(options_button is Button and options_button.text == "Options", "Options button must exist with the correct label")
	if options_button is Button and start_button is Button and quit_button is Button:
		check(options_button.is_visible_in_tree() and not options_button.disabled, "Options must be visible and enabled")
		check(start_button.get_index() < options_button.get_index() and options_button.get_index() < quit_button.get_index(), "Options must appear between Start and Quit")
		check(options_button.size == start_button.size and options_button.size == quit_button.size, "All menu buttons must have matching dimensions")
		check(options_button.get_theme_font_size("font_size") == start_button.get_theme_font_size("font_size"), "Options typography must match Start")
		check(start_button.get_global_rect().end.y <= options_button.global_position.y and options_button.get_global_rect().end.y <= quit_button.global_position.y, "Menu buttons must not overlap")
		check(scene.get_global_rect().encloses(scene.get_node("Center/Content").get_global_rect()), "Menu content must fit inside the viewport")
		await navigate_focus(false)
		check(options_button.has_focus(), "Tab from Start must focus Options")
		await navigate_focus(false)
		check(scene.get_node("Center/Content/SeeDeck").has_focus(), "Tab from Options must focus See Deck")
		await navigate_focus(false)
		check(quit_button.has_focus(), "Tab from See Deck must focus Quit")
		await navigate_focus(true)
		check(scene.get_node("Center/Content/SeeDeck").has_focus(), "Shift+Tab from Quit must focus See Deck")
		await navigate_focus(true)
		check(options_button.has_focus(), "Shift+Tab from See Deck must focus Options")
	var see_deck = scene.get_node_or_null("Center/Content/SeeDeck")
	var deck = scene.get_node_or_null("Deck")
	var back = scene.get_node_or_null("Deck/Content/Back")
	check(see_deck is Button and see_deck.text == "See Deck" and not see_deck.disabled, "Menu must offer See Deck")
	check(deck is Control and not deck.is_visible_in_tree(), "Deck must initially be hidden")
	check(back is Button and back.text == "Back", "Deck must offer Back")
	if see_deck is Button and deck is Control and back is Button:
		check(start_button.get_index() < see_deck.get_index() and see_deck.get_index() < quit_button.get_index(), "See Deck must appear between Start and Quit")
		for visit in range(2):
			see_deck.pressed.emit()
			await process_frame
			check(deck.is_visible_in_tree() and not scene.get_node("Center").is_visible_in_tree(), "See Deck must open the deck and hide the menu")
			check(back.has_focus(), "Deck entry must focus Back")
			check(scene.get_node("Deck/Content/EmptyState").text == "No cards designed yet.", "Deck must explain the empty state")
			check(scene.get_node("Deck/Content/DeckSize").text == "Your starting deck will contain 20 cards.", "Deck must explain the planned size")
			check(scene.get_node("Deck/Content").get_child_count() == 4, "Empty deck must contain only heading, explanation, size, and Back; no invented cards")
			back.pressed.emit()
			await process_frame
			check(not deck.is_visible_in_tree() and scene.get_node("Center").is_visible_in_tree(), "Back must restore the main menu")
			check(see_deck.has_focus(), "Back must restore focus to See Deck")
	scene.queue_free()
	await process_frame
	if failures == 0:
		print("ROGUEDECK_TESTS_OK: %d checks" % checks)
	else:
		push_error("%d of %d checks failed" % [failures, checks])
	quit(1 if failures > 0 else 0)


func navigate_focus(backwards: bool) -> void:
	var event := InputEventKey.new()
	event.keycode = KEY_TAB
	event.shift_pressed = backwards
	event.pressed = true
	Input.parse_input_event(event)
	await process_frame
	event = event.duplicate()
	event.pressed = false
	Input.parse_input_event(event)
	await process_frame
