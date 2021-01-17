#version 130

uniform sampler2D texture;

uniform float blindness;
uniform int isEyeInWater;

varying vec4 color;
varying vec2 coord0;

float hash(vec2 c)
{
    return fract(cos(mod(dot(floor(c+.01),vec2(89.4,93.5)),999.))*378.4)-.5;
}
void main()
{
    vec3 light = vec3(1.-blindness);
    vec4 tex = texture2D(texture,coord0);
    float gray = dot(tex,vec4(.299,.587,.114,0));
    vec4 col = color * vec4(light,1) * tex;

    vec2 c = coord0*vec2(textureSize(texture,0));

    float h = hash(c)+.5;
    col.rgb = mix(vec3(.3+h/.1),vec3(.43,.3,.2)*(.25+.75*pow(h,.6)),min(h/.05,1.));

    gl_FragData[0] = col*vec4(1,1,1,gray/.5);
}
