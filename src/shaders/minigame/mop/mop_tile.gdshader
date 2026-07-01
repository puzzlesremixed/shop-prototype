shader_type canvas_item;

// The texture we want to transition to
uniform sampler2D texture2 : source_color; 

// The percentage of the transition (0.0 is 0%, 1.0 is 100%)
uniform float blend_amount : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    // Get the pixel colors from both textures at the current coordinate
    vec4 color1 = texture(TEXTURE, UV);
    vec4 color2 = texture(texture2, UV);
    
    // Mix them together based on the blend_amount
    COLOR = mix(color1, color2, blend_amount);
}