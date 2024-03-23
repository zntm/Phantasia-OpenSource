function item_update_leaves(_x, _y, _sprite)
{
	if (!chance(0.01 * global.delta_time)) exit;
		
	spawn_particle(_x * TILE_SIZE, _y * TILE_SIZE, CHUNK_DEPTH_DEFAULT, new Particle()
		.set_sprite(_sprite)
		.set_speed(1, 1)
		.set_rotation(-3, 3)
		.set_collision()
		.set_life(40, 80)
		.set_speed_on_collision(0, 0)
		.set_fade_out(true));
}