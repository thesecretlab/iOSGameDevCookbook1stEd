varying lowp vec4 vertex_color;
varying lowp vec2 vertex_texcoords;
varying lowp vec4 vertex_normal;

uniform sampler2D texture0;

void main()
{
	gl_FragColor = texture2D(texture0, vertex_texcoords) * vertex_color;
}
