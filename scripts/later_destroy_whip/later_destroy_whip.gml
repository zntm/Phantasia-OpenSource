function later_destroy_whip()
{
	instance_destroy(obj_Whip);
	
	layer_sequence_destroy(global.sequence_whips);
	
	global.sequence_whips = -1;
}