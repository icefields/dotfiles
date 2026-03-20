#version 320 es
precision mediump float;

out vec4 FragColor;
uniform sampler2D tex;

void main() {
    vec2 resolution = vec2(textureSize(tex, 0)); vec2(1920.0, 1080.0);
    vec2 uv = gl_FragCoord.xy / resolution;

    vec4 color = texture(tex, uv);

    FragColor = vec4(
        color.r,
        color.g * 0.9,
        color.b * 0.7,
        color.a
    );
}

