class_name SpriteStrips
extends RefCounted
## Builds SpriteFrames from horizontal-strip PNGs (see ART_SPEC.md).
## Frame count is derived from the image width, so the artist can change it freely.


## animations: { name: { "path": String, "fps": float, "loop": bool } }
static func build(animations: Dictionary, frame_size: Vector2i) -> SpriteFrames:
	var frames := SpriteFrames.new()
	frames.remove_animation(&"default")
	for anim_name in animations:
		var spec: Dictionary = animations[anim_name]
		var tex: Texture2D = load(spec.path)
		var count := maxi(1, tex.get_width() / frame_size.x)
		frames.add_animation(anim_name)
		frames.set_animation_speed(anim_name, spec.get("fps", 8.0))
		frames.set_animation_loop(anim_name, spec.get("loop", true))
		for i in count:
			var atlas := AtlasTexture.new()
			atlas.atlas = tex
			atlas.region = Rect2(i * frame_size.x, 0, frame_size.x, frame_size.y)
			frames.add_frame(anim_name, atlas)
	return frames
