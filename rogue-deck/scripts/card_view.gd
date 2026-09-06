extends PanelContainer
## Presentation reads the definition; it never spends mana or changes card stats.

@export var definition: CardDefinition:
	set(value):
		definition = value
		if is_node_ready():
			refresh()


func _ready() -> void:
	refresh()


func refresh() -> void:
	$Content/Header/Title.text = definition.display_name if definition else ""
	$Content/Header/Mana.text = "%d MANA" % definition.mana_cost if definition else ""
	$Content/Effect.text = "Deal %d damage." % definition.damage if definition else ""
