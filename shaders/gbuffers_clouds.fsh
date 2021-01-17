#version 120

uniform sampler2D texture;

uniform vec3 fogColor;
uniform float blindness;
uniform int isEyeInWater;

varying vec4 color;
varying vec3 vert;
varying vec2 coord0;

float hash(vec2 c)
{
    return fract(cos(mod(dot(floor(c+.01),vec2(89.4,93.5)),999.))*378.4)-.5;
}

void main()
{
    vec3 light = vec3(1.-blindness);
    vec4 tex = texture2D(texture,coord0);
    vec4 col = color * vec4(light, tex.a);
    vec2 c = coord0*1024.;

    float h = hash(c)+.5;
    col.rgb *= mix(vec3(.4+h/.1),vec3(.53,.37,.25)*(.3+.7*pow(h,.6)),min(h/.05,1.))*.9+.1;

    float fog = (isEyeInWater>0) ? 1.-exp(-gl_FogFragCoord * gl_Fog.density):
    clamp((gl_FogFragCoord-gl_Fog.start) * gl_Fog.scale, 0., 1.);
    float gray = dot(gl_Fog.color,vec4(.299,.587,.114,0))*.8;
    col.rgb = mix(col.rgb, vec3(0.65, 0.45, 0.3)*fogColor.b, fog); //gl_Fog.color.rgb

    gl_FragData[0] = col;
}
