shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;
uniform float pixelation : hint_range(1.0, 10.0) = 4.0;
uniform float brightness_boost : hint_range(1.0, 3.0) = 1.5;
uniform float contrast : hint_range(0.5, 2.0) = 1.2;

void fragment() {
    // Pixelisation (baisse de résolution)
    vec2 uv = UV;
    uv = floor(uv * SCREEN_PIXEL_SIZE.zw / pixelation) * pixelation / SCREEN_PIXEL_SIZE.zw;
    
    // Récupérer la couleur de l'écran
    vec3 color = texture(SCREEN_TEXTURE, uv).rgb;
    
    // Accentuer les lumières
    color *= brightness_boost;
    
    // Ajouter du contraste
    color = (color - 0.5) * contrast + 0.5;
    
    COLOR = vec4(color, 1.0);
}