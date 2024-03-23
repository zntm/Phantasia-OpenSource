/// @desc  Function to calculate the progress (value from 0 to 1) given a result.
/// @param {Real} val The value used to get the range,
/// @param {Real} min The minimum value.
/// @param {Real} max The maximum value.
function normalize(_val, _min, _max)
{
	if (DEV_COMPILATION_INLINE)
	{
		gml_pragma("forceinline");
	}
	
	if (_val >= _max)
	{
		return 1;
	}
	
	if (_val < _min)
	{
		return 0;
	}
	
	return (_val - _min) / (_max - _min);
}