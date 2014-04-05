varying lowp vec4 vertex_color;

void main()
{
    // Simple per-vertex colouring: the colour of each pixel is based entirely on the colour of the nearby vertices.
	gl_FragColor = vertex_color;
}
