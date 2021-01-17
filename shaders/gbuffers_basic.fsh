#version 120

uniform float blindness;
uniform int isEyeInWater;
uniform vec3 fogColor;
uniform vec3 skyColor;

varying vec4 color;

void main()
{
    vec4 col = color;

    float fog = (isEyeInWater>0) ? 1.-exp(-gl_FogFragCoord * gl_Fog.density):
    clamp((gl_FogFragCoord-gl_Fog.start) * gl_Fog.scale, 0., 1.);
    col.rgb = mix(col.rgb, vec3(0.65, 0.45, 0.3)*fogColor.b, fog);

    gl_FragData[0] = col;
}
