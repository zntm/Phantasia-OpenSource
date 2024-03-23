varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// Used for the for loop to draw the amount of base textures
const int BLOOM_DRAW_AMOUNT = 16;

// Used to multiply the xy offset because just by adding 1 causes it to draw offscreen somehow
const float BLOOM_POS_OFFSET = 0.01;

// Used to multiply the base textures so its a smooth glow instead of it looking weird
const float BLOOM_ALPHA = 0.01;

const float PI = 3.14159;
const float TWO_PI = PI * 2.0;

const float CONTRAST_STRENGTH = 1.2;

void main()
{
	vec4 texture = texture2D(gm_BaseTexture, v_vTexcoord);

	for (int i = 0; i < BLOOM_DRAW_AMOUNT; ++i)
	{
		float angle = (float(i) * TWO_PI) / float(BLOOM_DRAW_AMOUNT);
		
		vec4 bloom = texture2D(gm_BaseTexture, v_vTexcoord + (vec2(cos(angle) / 2.0, sin(angle)) * BLOOM_POS_OFFSET)) * BLOOM_ALPHA;
		float ave = (bloom.r + bloom.g + bloom.b) / 3.0;
		
		if (ave > 0.5)
		{
			texture += bloom;
		}
		else if (ave > 0.2)
		{
			bloom.a = 0.5 / (ave - 0.2);
			
			texture += bloom;
		}
	}
	
	// texture.rgb = mix(vec3(0.5), texture.rgb, CONTRAST_STRENGTH);
	
	gl_FragColor = v_vColour * texture;
}