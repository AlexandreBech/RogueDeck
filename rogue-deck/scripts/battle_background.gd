extends Control

const STONE_DARK := Color("#17191d")
const STONE_MID := Color("#29292b")
const MORTAR := Color("#111216")
const WOOD_DARK := Color("#29140d")
const WOOD_MID := Color("#5b3018")
const WOOD_LIGHT := Color("#8b5128")
const FELT_DARK := Color("#182d29")
const FELT_MID := Color("#285146")
const PARCHMENT := Color("#caa96d")
const GOLD := Color("#c9953d")


func _ready() -> void:
	resized.connect(queue_redraw)
	queue_redraw()


func _draw() -> void:
	var canvas := size
	if canvas.x <= 0.0 or canvas.y <= 0.0:
		return

	_draw_stone_wall(canvas)
	_draw_table(canvas)
	_draw_playing_field(canvas)
	_draw_candle_glow(canvas)


func _draw_stone_wall(canvas: Vector2) -> void:
	draw_rect(Rect2(Vector2.ZERO, canvas), STONE_DARK)
	var course_height := maxf(54.0, canvas.y * 0.105)
	var stone_width := maxf(110.0, canvas.x * 0.14)
	var row := 0
	var y := 0.0
	while y < canvas.y * 0.44:
		var offset := -stone_width * 0.5 if row % 2 == 1 else 0.0
		var x := offset
		while x < canvas.x:
			var stone := Rect2(x + 3.0, y + 3.0, stone_width - 6.0, course_height - 6.0)
			var shade := STONE_MID.lightened(0.035 * float((row + int(x / stone_width)) % 3))
			draw_rect(stone, shade)
			draw_line(stone.position, Vector2(stone.end.x, stone.position.y), shade.lightened(0.12), 2.0)
			x += stone_width
		y += course_height
		row += 1
	draw_rect(Rect2(0.0, canvas.y * 0.41, canvas.x, 12.0), MORTAR)


func _draw_table(canvas: Vector2) -> void:
	var table_top := canvas.y * 0.34
	draw_colored_polygon(PackedVector2Array([
		Vector2(0.0, table_top),
		Vector2(canvas.x, table_top),
		Vector2(canvas.x, canvas.y),
		Vector2(0.0, canvas.y),
	]), WOOD_DARK)
	var plank_height := maxf(46.0, canvas.y * 0.09)
	var y := table_top + 10.0
	var plank := 0
	while y < canvas.y:
		var color := WOOD_MID.lerp(WOOD_LIGHT, 0.1 * float(plank % 3))
		draw_rect(Rect2(0.0, y, canvas.x, plank_height - 4.0), color)
		draw_line(Vector2(0.0, y + 3.0), Vector2(canvas.x, y + 3.0), color.lightened(0.12), 2.0)
		y += plank_height
		plank += 1


func _draw_playing_field(canvas: Vector2) -> void:
	var margin_x := canvas.x * 0.105
	var field := Rect2(margin_x, canvas.y * 0.405, canvas.x - margin_x * 2.0, canvas.y * 0.53)
	_draw_panel(field.grow(12.0), WOOD_DARK, GOLD.darkened(0.35), 22.0)
	_draw_panel(field, FELT_DARK, GOLD, 16.0)
	var inner := field.grow(-18.0)
	draw_rect(inner, FELT_MID, true)
	draw_rect(inner, Color("#779079"), false, 2.0)

	var center_y := inner.get_center().y
	draw_line(Vector2(inner.position.x + 24.0, center_y), Vector2(inner.end.x - 24.0, center_y), Color(0.78, 0.67, 0.43, 0.34), 2.0)
	draw_circle(inner.get_center(), minf(inner.size.x, inner.size.y) * 0.105, Color(0.08, 0.16, 0.14, 0.45))
	draw_arc(inner.get_center(), minf(inner.size.x, inner.size.y) * 0.105, 0.0, TAU, 48, PARCHMENT.darkened(0.15), 3.0)

	var banner_width := minf(310.0, canvas.x * 0.3)
	var banner := Rect2(canvas.x * 0.5 - banner_width * 0.5, canvas.y * 0.08, banner_width, canvas.y * 0.19)
	_draw_panel(banner, Color("#5c1f24"), GOLD, 12.0)
	draw_line(Vector2(banner.position.x + 22.0, banner.end.y - 16.0), Vector2(banner.end.x - 22.0, banner.end.y - 16.0), GOLD.darkened(0.2), 3.0)


func _draw_panel(rect: Rect2, fill: Color, border: Color, radius: float) -> void:
	draw_style_box(_style_box(fill, border, radius), rect)


func _style_box(fill: Color, border: Color, radius: float) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.set_border_width_all(4)
	style.set_corner_radius_all(int(radius))
	return style


func _draw_candle_glow(canvas: Vector2) -> void:
	for x in [canvas.x * 0.055, canvas.x * 0.945]:
		var flame_center := Vector2(x, canvas.y * 0.34)
		for radius in range(58, 8, -8):
			var alpha := 0.008 * float(66 - radius)
			draw_circle(flame_center, float(radius), Color(1.0, 0.55, 0.16, alpha))
		draw_rect(Rect2(flame_center + Vector2(-5.0, 9.0), Vector2(10.0, 38.0)), PARCHMENT.darkened(0.15))
		draw_colored_polygon(PackedVector2Array([
			flame_center + Vector2(0.0, -18.0),
			flame_center + Vector2(-8.0, 4.0),
			flame_center + Vector2(0.0, 12.0),
			flame_center + Vector2(8.0, 4.0),
		]), Color("#ffc85c"))
