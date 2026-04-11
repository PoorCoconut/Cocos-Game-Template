shader_type canvas_item;

// Ranges from 0 to 1 over the entire transition (In AND Out).
uniform float progress : hint_range(0, 1);

// Size of each diamond, in pixels.
uniform float diamondPixelSize = 10.0;

void fragment() {
    float xFraction = fract(FRAGCOORD.x / diamondPixelSize);
    float yFraction = fract(FRAGCOORD.y / diamondPixelSize);
    float xDistance = abs(xFraction - 0.5);
    float yDistance = abs(yFraction - 0.5);
    
    float val = xDistance + yDistance + UV.x + UV.y;
    
    // First half of the animation: Transition IN (Cover the screen)
    if (progress <= 0.5) {
        // Multiply by 2.0 to scale the 0.0-0.5 range to 0.0-1.0
        float t = progress * 2.0; 
        
        if (val > t * 4.0) {
            discard;
        }
    } 
    // Second half of the animation: Transition OUT (Reveal the screen)
    else {
        // Subtract 0.5 to reset to 0, then multiply by 2.0 to scale to 0.0-1.0
        float t = (progress - 0.5) * 2.0; 
        
        if (val < t * 4.0) {
            discard;
        }
    }
}