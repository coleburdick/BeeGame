class_name FlowerTypes
extends RefCounted
## All 36 flowers: 8 wild types and 28 hybrids (see DESIGN.md > Flowers).
## Names and colours come from the designer's recipe table, `data/flowers/flowers.csv`.
## Which pair makes which flower is fixed by the IDs: wild_AA × wild_BB = hybrid_AA_BB (lower first).

const TABLE_PATH := "res://data/flowers/flowers.csv"
const WILD_COUNT := 8

const WILD: Array[StringName] = [
	&"wild_01", &"wild_02", &"wild_03", &"wild_04",
	&"wild_05", &"wild_06", &"wild_07", &"wild_08",
]

## Two wild types per flower area.
const AREA_TYPES := {
	MapLayout.Area.AREA_1: [&"wild_01", &"wild_02"],
	MapLayout.Area.AREA_2: [&"wild_03", &"wild_04"],
	MapLayout.Area.AREA_3: [&"wild_05", &"wild_06"],
	MapLayout.Area.AREA_4: [&"wild_07", &"wild_08"],
}

## id -> { "name": String, "color": Color }, loaded on first use.
static var _table := {}


## Every flower ID: the 8 wild types, then the 28 hybrids in table order.
static func all() -> Array[StringName]:
	var out: Array[StringName] = []
	out.assign(_rows().keys())
	return out


static func display_name(id: StringName) -> String:
	return _rows().get(id, {}).get("name", String(id))


static func color(id: StringName) -> Color:
	return _rows().get(id, {}).get("color", Color.WHITE)


static func texture(id: StringName) -> Texture2D:
	return load("res://assets/art/flowers/%s.png" % id)


static func is_wild(id: StringName) -> bool:
	return id in WILD


## The flower that two wild pollens make. Order does not matter.
static func recipe(a: StringName, b: StringName) -> StringName:
	var na := _wild_number(a)
	var nb := _wild_number(b)
	assert(na > 0 and nb > 0, "recipe() takes two wild types, got %s + %s" % [a, b])
	if na == nb:
		return a
	return StringName("hybrid_%02d_%02d" % [mini(na, nb), maxi(na, nb)])


## Every ID the design calls for, in table order. Used to check the table.
static func expected_ids() -> Array[StringName]:
	var out: Array[StringName] = WILD.duplicate()
	for i in range(1, WILD_COUNT + 1):
		for j in range(i + 1, WILD_COUNT + 1):
			out.append(StringName("hybrid_%02d_%02d" % [i, j]))
	return out


static func _wild_number(id: StringName) -> int:
	if not is_wild(id):
		return 0
	return String(id).trim_prefix("wild_").to_int()


static func _rows() -> Dictionary:
	if _table.is_empty():
		_table = _load_table()
	return _table


static func _load_table() -> Dictionary:
	var table := {}
	var file := FileAccess.open(TABLE_PATH, FileAccess.READ)
	if file == null:
		push_error("Cannot open %s" % TABLE_PATH)
		return table
	var header := file.get_csv_line()
	var col_id := header.find("id")
	var col_name := header.find("name")
	var col_color := header.find("color")
	if col_id < 0 or col_name < 0 or col_color < 0:
		push_error("%s needs the columns id, name, color" % TABLE_PATH)
		return table
	while not file.eof_reached():
		var row := file.get_csv_line()
		if row.size() <= maxi(col_id, maxi(col_name, col_color)) or row[col_id].strip_edges() == "":
			continue
		var id := StringName(row[col_id].strip_edges())
		var hex := row[col_color].strip_edges()
		if not Color.html_is_valid(hex):
			push_error("%s: bad colour '%s' for %s" % [TABLE_PATH, hex, id])
		table[id] = {"name": row[col_name].strip_edges(), "color": Color.html(hex)}
	for id in expected_ids():
		if not table.has(id):
			push_error("%s is missing %s" % [TABLE_PATH, id])
	for id in table:
		if not id in expected_ids():
			push_error("%s has unknown flower %s" % [TABLE_PATH, id])
	return table
