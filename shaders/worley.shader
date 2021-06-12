
shader_type canvas_item;

uniform float scale = 1;
uniform float worley_strength = .2f;
uniform float worley_min = .8f;

varying vec2 vert;

vec2 random(vec2 uv) {
    return vec2(fract(sin(dot(uv.xy,
        vec2(5.3654564,7.1465))) * 58.564));
}

float worley(vec2 uv, float columns, float rows) {
    
    vec2 index_uv = floor(vec2(uv.x * columns, uv.y * rows));
    vec2 fract_uv = fract(vec2(uv.x * columns, uv.y * rows));
    
    float minimum_dist = 1.0;  
    
    for (int y= -1; y <= 1; y++) {
        for (int x= -1; x <= 1; x++) {
            vec2 neighbor = vec2(float(x),float(y));
            vec2 point = random(index_uv + neighbor);
            
            vec2 diff = neighbor + point - fract_uv;
            float dist = length(diff);
            minimum_dist = min(minimum_dist, dist);
        }
    }
    
    return minimum_dist;
}

vec2 findTiledUV(vec2 uv, vec2 tps){
    vec2 tileSize = vec2(12, 12) * tps;
    vec2 tileUV = mod(uv, tileSize);
    vec2 tileOrigin = uv - tileUV;
    
    return tileOrigin + mod(tileUV * tileSize, tileSize);
}

void vertex(){
    vert = VERTEX.xy;
}

void fragment(){
    
    vec2 tiledUV = findTiledUV(UV, TEXTURE_PIXEL_SIZE);
    
    float worley = worley(vert * (scale / 3.0), 1.2, 1.2);
    worley = 1f - worley;
    worley = min(worley, worley_min);
    COLOR.xyz = (COLOR.xyz * (1f - worley_strength)) + (COLOR.xyz * worley * worley_strength);
    COLOR.xyz = floor(COLOR.xyz * 8f) / 8f;
}