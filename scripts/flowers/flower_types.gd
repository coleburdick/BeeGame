class_name FlowerTypes
extends RefCounted
## Wild flower types and which area grows them (see DESIGN.md > Flowers, World).
## Colours are placeholders until the designer's recipe table lands in `data/flowers` (milestone 3).

const WILD: Array[StringName] = [
	&"wild_01", &"wild_02", &"wild_03", &"wild_04",
	&"wild_05", &"wild_06", &"wild_07", &"wild_08",
]

## Placeholder colour per wild type: tints HUD pollen and the bee's pollen dots.
const COLORS := {
	&"wild_01": Color("e04848"), # red
	&"wild_02": Color("f2d64b"), # yellow
	&"wild_03": Color("4a7fe0"), # blue
	&"wild_04": Color("f4f4ee"), # white
	&"wild_05": Color("9a5ad6"), # purple
	&"wild_06": Color("f08ac0"), # pink
	&"wild_07": Color("47c9c9"), # cyan
	&"wild_08": Color("e8873a"), # orange
}

## Two wild types per flower area.
const AREA_TYPES := {
	MapLayout.Area.AREA_1: [&"wild_01", &"wild_02"],
	MapLayout.Area.AREA_2: [&"wild_03", &"wild_04"],
	MapLayout.Area.AREA_3: [&"wild_05", &"wild_06"],
	MapLayout.Area.AREA_4: [&"wild_07", &"wild_08"],
}


static func color(id: StringName) -> Color:
	return COLORS.get(id, Color.WHITE)


static func texture(id: StringName) -> Texture2D:
	return load("res://assets/art/flowers/%s.png" % id)
