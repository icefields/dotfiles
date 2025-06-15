#version 330 core

out vec4 FragColor;
in vec2 TexCoords;

uniform sampler2D tex;

void main() {
    vec4 color = texture(tex, TexCoords);

    // Reduce blue, boost red/yellow
    float red = color.r;
    float green = color.g * 0.9;
    float blue = color.b * 0.7;

    FragColor = vec4(red, green, blue, color.a);
}

