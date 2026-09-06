class_name CardDefinition
extends Resource
## Base card statistics. Combat and per-run upgrades are not implemented yet.

@export var id: StringName
@export var display_name: String
@export_range(0, 99) var mana_cost: int = 0
@export_range(0, 999) var damage: int = 0
