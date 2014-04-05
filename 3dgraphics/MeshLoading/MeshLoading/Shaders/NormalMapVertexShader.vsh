uniform mediump mat4 modelViewMatrix;
uniform mediump mat4 projectionMatrix;
uniform mediump mat3 normalMatrix;

attribute vec3 position;
attribute vec4 color;
attribute vec3 normal;
attribute vec2 texcoords;

varying mediump vec4 vertex_color;
varying mediump vec2 vertex_texcoords;
varying mediump vec4 vertex_normal;

varying mediump vec4 vertex_position;

void main()
{
    
    // "position" is in model space. We need to convert it to camera space by multiplying it by the modelViewProjection matrix.
    gl_Position = (projectionMatrix* modelViewMatrix) * vec4(position,1.0);
    
    vertex_color = color;
    vertex_position = modelViewMatrix * vec4(position, 1.0);
    
    // Next, we pass the color, normal and texture coordinates of this vertex to the fragment shader by putting them in varying variables.
    vertex_normal = vec4(normal, 0.0);
    vertex_texcoords = texcoords;
    
}
