#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

const vec3 sky_color = vec3(130.0f / 255.0f, 202.0f / 255.0f, 255.0f / 255.0f);

uniform sampler2D texture;
uniform sampler2D shadowMap;

varying vec4 vertTexCoord;

uniform float fraction;

varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;

varying vec4 ShadowCoord;

in float frag_distance;

in vec4 vertex_color;

void main() {

    vec4 fragColor = texture2D(texture, vertTexCoord.st);

    

    if(fragColor.w == 0.0f){
        discard;
    }
    

    gl_FragColor = vec4(mix(fragColor.xyz * vertex_color.xyz, sky_color, min(1.0f, frag_distance / 10496)), fragColor.w);
    


}

