//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float time;

void main()
{
	float si = cos(time * 0.03) * 0.0005;
	
    gl_FragColor = v_vColour * vec4(
		texture2D(gm_BaseTexture, v_vTexcoord + si).r,
		texture2D(gm_BaseTexture, v_vTexcoord).g,
		texture2D(gm_BaseTexture, v_vTexcoord - si).b,
		1.0
	);
}
