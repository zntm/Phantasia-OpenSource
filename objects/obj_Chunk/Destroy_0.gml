save_chunk(id);

var i = 0;

repeat (CHUNK_SIZE_Z)
{
	surface_free_existing(surface[i++]);
}