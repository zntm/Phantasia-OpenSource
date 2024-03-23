varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// width, height, radius
uniform vec3 size;

#define tau 6.283185307176

#define quality 8.0
#define direction 16.0

void main()
{
	vec2 radius = size.z / size.xy;
	vec4 base = texture2D(gm_BaseTexture, v_vTexcoord);

	for (float d = 0.0; d < tau; d += tau / direction)
	{
		vec2 offset = vec2(cos(d), sin(d)) * radius;
		
		for (float i = 1.0 / quality; i <= 1.0; i += 1.0 / quality)
		{
			base += texture2D(gm_BaseTexture, v_vTexcoord + (offset * i));
		}
	}
	
	gl_FragColor = base / ((quality * direction) + 1.0) * v_vColour;
}