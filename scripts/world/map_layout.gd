class_name MapLayout
extends RefCounted
## Single source of truth for the map's geometry (see DESIGN.md > World).

const TILE := 16
const WORLD := Rect2(0, 0, 1920, 1080)
const HUB := Rect2(640, 360, 640, 360)
const BARRIER_THICKNESS := 16

const GARDEN_COLS := 6
const GARDEN_ROWS := 4
const GARDEN := Rect2(
	960 - GARDEN_COLS * TILE / 2, 540 - GARDEN_ROWS * TILE / 2,
	GARDEN_COLS * TILE, GARDEN_ROWS * TILE)

const BEE_START := Vector2(960, 620)

enum Area { HUB, AREA_1, AREA_2, AREA_3, AREA_4 }

## Quadrant per flower area. The hub sits on top of their shared corner.
const AREA_RECTS := {
	Area.AREA_1: Rect2(0, 0, 960, 540),
	Area.AREA_2: Rect2(960, 0, 960, 540),
	Area.AREA_3: Rect2(0, 540, 960, 540),
	Area.AREA_4: Rect2(960, 540, 960, 540),
}

const AREA_NAMES := {
	Area.HUB: "Garden",
	Area.AREA_1: "Area 1",
	Area.AREA_2: "Area 2",
	Area.AREA_3: "Area 3",
	Area.AREA_4: "Area 4",
}


static func area_at(point: Vector2) -> Area:
	if HUB.has_point(point):
		return Area.HUB
	for area in AREA_RECTS:
		if AREA_RECTS[area].has_point(point):
			return area
	return Area.HUB
