uniform mediump mat4 modelViewMatrix;
uniform mediump mat3 normalMatrix;

varying mediump vec4 vertex_color;
varying mediump vec2 vertex_texcoords;
varying mediump vec4 vertex_normal;
varying mediump vec4 vertex_position;

uniform sampler2D texture0;

uniform lowp vec3 lightPosition;
uniform lowp vec4 lightColor;
uniform lowp vec4 ambientLightColor;

void main()
{
    
    // Get the normal supplied by the vertex shader
    mediump vec3 normal = vec3(normalize(vertex_normal));
    
    // Convert the normal from object space to world space.
    normal = normalMatrix * normal;
    
    // Get the position of this fragment.
    mediump vec3 modelViewVertex = vec3(modelViewMatrix * vertex_position);
    
    // Work out the direction of the fragment to the point on the surface
    mediump vec3 lightVector = normalize(lightPosition - modelViewVertex);
    
    // Work out how much light is reflected
    mediump float diffuse = clamp(dot(normal, lightVector), 0.0, 1.0);
    
    // Combine everything together!
    gl_FragColor = texture2D(texture0, vertex_texcoords) * vertex_color * diffuse * lightColor  + ambientLightColor;
    
}