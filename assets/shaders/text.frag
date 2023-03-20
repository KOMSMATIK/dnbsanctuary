#pragma header
uniform float amount;
void main(void) {
	gl_FragColor = flixel_texture2D(bitmap, openfl_TextureCoordv);
	gl_FragColor.r += amount;
}