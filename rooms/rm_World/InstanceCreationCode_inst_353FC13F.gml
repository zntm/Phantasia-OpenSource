on_layer = "BG_Parallax";

var _layer;
var _layers = layer_get_all();
var _length = array_length(_layers);

var i = 0;

repeat (_length)
{
	_layer = _layers[i++];
	
	if (string_starts_with(layer_get_name(_layer), "Menu_"))
	{
		instance_deactivate_layer(_layer);
	}
}