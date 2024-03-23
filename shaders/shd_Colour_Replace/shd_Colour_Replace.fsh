//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform int match[64];
uniform int replace[64];
uniform int amount;

const float range = 1.0 / 255.0;

void main()
{
	vec4 base = texture2D(gm_BaseTexture, v_vTexcoord);
	
	float b_r = base.r;
	float b_g = base.g;
	float b_b = base.b;
	
	for (int i = 0; i < amount; ++i)
	{
		float ma = float(match[i]);
		
		if (abs(b_r - floor(mod(ma, 256.0)) / 255.0) <= range && abs(b_g - floor(mod(ma / 256.0, 256.0)) / 255.0) <= range && abs(b_b - floor(mod(ma / 65536.0, 256.0)) / 255.0) <= range)
		{
			float re = float(replace[i]);
			
			base.rgb = vec3(
			    floor(mod(re, 256.0)) / 255.0,
			    floor(mod(re / 256.0, 256.0)) / 255.0,
			    floor(mod(re / 65536.0, 256.0)) / 255.0
			);
			
			break;
		}
	}
	
    gl_FragColor = base;
}
