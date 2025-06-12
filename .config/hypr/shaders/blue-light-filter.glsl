#version 320 es
precision mediump float;

out vec4 FragColor;
uniform sampler2D tex;

//uniform float brightness = 0.5;
//uniform float gamma = 1.0;

void main() {
    float brightness = 0.5;
    float gamma = 1.0;

    vec2 resolution = vec2(textureSize(tex, 0));
    vec2 uv = gl_FragCoord.xy / resolution;

    vec4 color = texture(tex, uv);

    color.r *= 1.0;
    color.g *= 0.6;
    color.b *= 0.4;

    // Gamma correction
    color.rgb = pow(color.rgb, vec3(1.0 / gamma));

    // Apply brightness
    color.rgb *= brightness;

    FragColor = color;
}

