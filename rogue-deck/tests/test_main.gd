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
	scene.queue_free()
	await process_frame
	await _check_attack_card()
	if failures == 0:
		print("ROGUEDECK_TESTS_OK: %d checks" % checks)
	else:
		push_error("%d of %d checks failed" % [failures, checks])
	quit(1 if failures > 0 else 0)


func _check_attack_card() -> void:
	var definition = load("res://cards/attack.tres")
	check(definition is CardDefinition, "Attack must load as a typed card definition")
	if not definition is CardDefinition:
		return
	check(definition.id == &"attack" and definition.display_name == "Attack", "Attack identity must match the ticket")
	check(definition.mana_cost == 1, "Attack must cost 1 mana")
	check(definition.damage == 1, "Attack must deal 1 damage")
	var packed = load("res://scenes/card_preview.tscn")
	check(packed is PackedScene, "Card preview must load independently")
	if not packed is PackedScene:
		return
	root.size = Vector2i(1280, 720)
	var preview = packed.instantiate()
	root.add_child(preview)
	await process_frame
	await process_frame
	var card = preview.get_node("Center/AttackCard")
	var title = card.get_node("Content/Header/Title")
	var mana = card.get_node("Content/Header/Mana")
	var effect = card.get_node("Content/Effect")
	var artwork = card.get_node("Content/Artwork")
	check(card.definition == definition, "Preview must use the canonical Attack resource")
	check(title.text == "Attack" and title.is_visible_in_tree(), "Card must visibly name Attack")
	check(mana.text == "1 MANA" and mana.is_visible_in_tree(), "Card must visibly cost 1 mana")
	check(effect.text == "Deal 1 damage." and effect.is_visible_in_tree(), "Card must visibly deal 1 damage")
	check(artwork.texture is Texture2D and artwork.texture.get_width() > 0, "Sword artwork must import and load")
	var card_rect: Rect2 = card.get_global_rect()
	check(preview.get_global_rect().encloses(card_rect), "Card must fit the preview viewport")
	check(card_rect.get_center().is_equal_approx(preview.get_global_rect().get_center()), "Card must be centered")
	for label in [title, mana, effect]:
		check(card_rect.encloses(label.get_global_rect()), "Card text must remain inside its frame")
	check(not title.get_global_rect().intersects(mana.get_global_rect()), "Title and mana must not overlap")
	check(not artwork.get_global_rect().intersects(effect.get_global_rect()), "Artwork and effect must not overlap")
	var alternate = definition.duplicate()
	alternate.mana_cost = 2
	alternate.damage = 3
	card.definition = alternate
	check(mana.text == "2 MANA" and effect.text == "Deal 3 damage.", "Presentation must derive statistics from the assigned definition")
	check(definition.mana_cost == 1 and definition.damage == 1, "Preview must not mutate base Attack statistics")
	card.definition = definition
	check(mana.text == "1 MANA" and effect.text == "Deal 1 damage.", "Restoring Attack must restore its displayed statistics")
	preview.queue_free()
	await process_frame
