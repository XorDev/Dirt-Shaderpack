#version 130

uniform sampler2D texture;
uniform sampler2D lightmap;

uniform vec4 entityColor;
uniform vec3 fogColor;
uniform float blindness;
uniform int isEyeInWater;

varying vec4 color;
varying vec3 vert;
varying vec2 coord0;
varying vec2 coord1;

float hash(vec2 c)
{
    return fract(cos(mod(dot(floor(c),vec2(89.4,93.5)),999.))*378.4)-.5;
}
void main()
{
    vec3 light = (1.-blindness) * texture2D(lightmap,coord1).rgb;

    vec2 c = coord0*vec2(textureSize(texture,0));
    float s = clamp(length(fwidth(c))/2.,0.,5.);
    c += dot(floor(vert),vec3(3,-5,4))*vec2(1,7);
    float s1 = exp2(floor(s));
    c /= s1;

    float h = mix(hash(c), hash(c/2.), fract(s))/exp2(s)+.5;
    vec4 tex = color * texture2D(texture,coord0);
    tex.rgb = color.a*mix(vec3(.4+h/.1),vec3(.53,.37,.25)*(.3+.7*pow(h,.6)),min(h/.05,1.));

    vec4 col = vec4(light,1) * tex;
    col.rgb = mix(col.rgb,entityColor.rgb,entityColor.a);

    float fog = (isEyeInWater>0) ? 1.-exp(-gl_FogFragCoord * gl_Fog.density):
    clamp((gl_FogFragCoord-gl_Fog.start) * gl_Fog.scale, 0., 1.);
    float gray = dot(gl_Fog.color,vec4(.299,.587,.114,0))*.8;
    col.rgb = mix(col.rgb, vec3(0.65, 0.45, 0.3)*fogColor.b, fog); //gl_Fog.color.rgb

    gl_FragData[0] = col;
}
