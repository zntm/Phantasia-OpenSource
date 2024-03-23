//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform int type;

void main()
{
	// Protanopia
	if (type == 1)
	{
		gl_FragColor = vec4(mat3(0.170556992, 0.170556991, -0.004517144, 0.829443014, 0.829443008, 0.004517144, 0.0, 0.0, 1.0) * texture2D(gm_BaseTexture, v_vTexcoord).rgb, 1.0);
	}
	// Deuteranopia
	else if (type == 2)
	{
		gl_FragColor = vec4(mat3(0.33066007, 0.33066007, -0.02785538, 0.66933993, 0.66933993, 0.02785538, 0.0, 0.0, 1.0) * texture2D(gm_BaseTexture, v_vTexcoord).rgb, 1.0);
	}
	// Tritanopia
	else if (type == 3)
	{
		gl_FragColor = vec4(mat3(1.0, 0.0, 0.0, 0.1273989, 0.8739093, 0.8739093, -0.1273989, 0.1260907, 0.1260907) * texture2D(gm_BaseTexture, v_vTexcoord).rgb, 1.0);
	}
	// Achromatopsia
	else if (type == 4)
	{
		gl_FragColor = vec4(texture2D(gm_BaseTexture, v_vTexcoord).rgb * mat3(0.2126, 0.7152, 0.0722, 0.2126, 0.7152, 0.0722, 0.2126, 0.7152, 0.0722), 1.0);
	}
	// Protanopaly
	else if (type == 5)
	{
		gl_FragColor = vec4(mat3(0.817, 0.183, 0.0, 0.333, 0.667, 0.0, 0.0, 0.125, 0.875) * texture2D(gm_BaseTexture, v_vTexcoord).rgb, 1.0);
	}
	// Deuteranomaly
	else if (type == 6)
	{
		gl_FragColor = vec4(mat3(0.8, 0.2, 0.0, 0.258, 0.742, 0.0, 0.0, 0.142, 0.858) * texture2D(gm_BaseTexture, v_vTexcoord).rgb, 1.0);
	}
	// Tritanomaly
	else if (type == 7)
	{
		gl_FragColor = vec4(mat3(0.967, 0.033, 0.0, 0.0, 0.733, 0.267, 0.0, 0.183, 0.817) * texture2D(gm_BaseTexture, v_vTexcoord).rgb, 1.0);
	}
	// Achromatomaly
	else if (type == 8)
	{
		gl_FragColor = vec4(texture2D(gm_BaseTexture, v_vTexcoord).rgb * mat3(0.618, 0.32 , 0.062, 0.163, 0.775, 0.062, 0.163, 0.32 , 0.516), 1.0);
	}
}