//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4 area;
uniform vec4 create;

void main()
{
	vec4 base = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
	
	if (v_vTexcoord.x >= area.r && v_vTexcoord.x < area.b)
	{
		if (v_vTexcoord.y >= area.g && v_vTexcoord.y < area.a)
		{
			base.a *= pow(abs(abs(((area.g + area.a) / 2.0) - v_vTexcoord.y) - 1.0), 22.0) * 200.0;
		}
		else if (v_vTexcoord.x < create.r || v_vTexcoord.x >= create.b || v_vTexcoord.y <= create.g || v_vTexcoord.y > create.a)
		{
			base.a = 0.0;
		}
	}
	
    gl_FragColor = base;
}
