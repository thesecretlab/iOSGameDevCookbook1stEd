uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform mat3 normalMatrix;

attribute vec3 position;
attribute vec4 color;
attribute vec3 normal;
attribute vec2 texcoords;

varying lowp vec4 vertex_color;
varying lowp vec2 vertex_texcoords;
varying lowp vec3 vertex_normal;

void main()
{
    
    // "position" is in model space. We need to convert it to camera space by multiplying it by the modelViewProjection matrix.
    gl_Position = (projectionMatrix* modelViewMatrix) * vec4(position,1.0);
    
    // Next, we pass the color, normal and texture coordinates of this vertex to the fragment shader by putting them in varying variables.
    vertex_color = color;
    vertex_texcoords = texcoords;
    
    // Convert the normal to model-view space by multiplying it with the normal matrix
    vertex_normal = normalMatrix * normal;
}
