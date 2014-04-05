uniform mediump mat4 modelViewMatrix;
uniform mediump mat3 normalMatrix;

varying mediump vec4 vertex_color;
varying mediump vec2 vertex_texcoords;
varying mediump vec4 vertex_normal;
varying mediump vec4 vertex_position;

uniform sampler2D texture0; // diffuse map
uniform sampler2D texture1; // normal map

uniform lowp vec3 lightPosition;
uniform lowp vec4 lightColor;
uniform lowp vec4 ambientLightColor;


void main()
{
    
    mediump vec3 normal = normalize(texture2D(texture1, vertex_texcoords).rgb * 2.0 - 1.0);
    
    // Convert the normal from object space to world space.
    normal = normalMatrix * normal;
    
    // Get the position of this fragment.
    mediump vec3 modelViewVertex = vec3(modelViewMatrix * vertex_position);
    
    // Work out the direction of the fragment to the point on the surface
    mediump vec3 lightVector = normalize(lightPosition - modelViewVertex);
    
    // Work out how much light is reflected
    mediump float diffuse = clamp(dot(normal, lightVector), 0.0, 1.0);
    
    // Group the lighting into 3 bands: one with diffuse lighting at 1.0,
    // another at 0.75, and another at 0.25. Because there's no smooth
    // transition between each band, hard lines will be visible between them.
    
    if (diffuse > 0.75)
        diffuse = 1.0;
    else if (diffuse > 0.5)
        diffuse = 0.75;
    else
        diffuse = 0.5;
    
    // Combine everything together!
    gl_FragColor = texture2D(texture0, vertex_texcoords) * vertex_color * diffuse * lightColor  + ambientLightColor;

    
}
