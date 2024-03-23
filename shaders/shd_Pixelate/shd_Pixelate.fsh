varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4 pixel;
// Width, Height, Pixel Width, Pixel Height

void main()
{
	vec2 ts = vec2(pixel.z * (1.0 / pixel.x), pixel.w * (1.0 / pixel.y));
	vec2 coord = vec2(ts.x * floor(v_vTexcoord.x / ts.x), ts.y * floor(v_vTexcoord.y / ts.y));
	
	gl_FragColor = texture2D(gm_BaseTexture, coord);
}
