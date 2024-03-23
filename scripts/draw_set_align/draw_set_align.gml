function draw_set_align(halign, valign)
{
	if (draw_get_halign() != halign)
	{
		draw_set_halign(halign);
	}
	
	if (draw_get_valign() != valign)
	{
		draw_set_valign(valign);
	}
}