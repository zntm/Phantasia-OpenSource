function surface_free_existing(_surface)
{
	if (surface_exists(_surface))
	{
		surface_free(_surface);
	}
}