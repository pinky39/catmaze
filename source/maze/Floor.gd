extends TileMap

const TILE_SIZE = 16.0
const LAYER_FLOOR = 8

func get_tile(point):
	var space = get_world_2d().direct_space_state
	var shapes = space.intersect_point(point, 1, [], LAYER_FLOOR)
	
	if shapes:		
		return map_to_world(shapes[0].metadata) + Vector2(TILE_SIZE/2, TILE_SIZE/2)
	
	return null
