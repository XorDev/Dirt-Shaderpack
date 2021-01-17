#version 120

uniform float blindness;
uniform int isEyeInWater;
uniform vec3 fogColor;
uniform vec3 skyColor;

varying vec4 color;
varying vec3 vert;

float hash(vec3 c)
{
    return fract(cos(mod(dot(floor(c),vec3(89.4,93.5,74.7)),999.))*378.4)-.5;
}

void main()
{
    vec4 col = color;

    /*float fog = (isEyeInWater>0) ? 1.-exp(-gl_FogFragCoord * gl_Fog.density):
    clamp((gl_FogFragCoord-gl_Fog.start) * gl_Fog.scale, 0., 1.);
    col.rgb = mix(col.rgb, gl_Fog.color.rgb, fog);
    float gray = dot(col,vec4(.299,.587,.114,0));*/

    vec3 p = normalize(vert);
    vec3 u = abs(p); float m = max(u.x,max(u.y,u.z));
    vec3 d = p/m;

    float h = hash(d*64.+.5)+.5;
    col.rgb = mix(vec3(0.65, 0.45, 0.3)*fogColor.b, vec3(0.5, 0.3, 0.15)*skyColor.b, clamp(d.y/.4,0.,1.));

    gl_FragData[0] = col;
    //vec4(pow(vec3(.86,.75,.68)*gray,vec3(2)) * (1.-blindness),col.a);
}
