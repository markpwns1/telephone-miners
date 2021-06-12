shader_type canvas_item;

uniform vec4 space_colour;
uniform vec4 star_colour;

uniform vec2 resolution = vec2(512, 512);

uniform float front_noise_scale;
uniform float mid_noise_scale;
uniform float back_noise_scale;

uniform float front_parallax_mod;
uniform float mid_parallax_mod;
uniform float back_parallax_mod;

uniform vec2 offset;

varying vec2 pos;

void vertex(){
	pos = VERTEX;
}


vec2 hash2d(vec2 p){
	vec3 p3 = fract(vec3(p.xyx) * vec3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yzx+19.19);
    return fract((p3.xx+p3.yz)*p3.zy);
}

void fragment(){
	COLOR = space_colour;
	
	//front stars
	for(int i = 0; i < 8; i++){
		vec2 ratioScale = vec2(1, 1);
		vec2 uvScale = vec2(float(i)*1.0 + 100.0);
		vec2 uv = ((pos + offset * front_parallax_mod) * ratioScale / resolution) * uvScale;
    
	   // get random 2d cell noise
	    vec2 CellUVs = floor(uv + float(i * 1199));
		vec2 hash = (hash2d(CellUVs) * 2.0 - 1.0) * front_noise_scale;
	    float hash_magnitude =(1.0-length(hash));

	    // calculate uv cell grid.
	    vec2 UVgrid = fract(uv) - 0.5;

	    //
	    float radius = clamp(hash_magnitude - 0.5, 0.0, 1.0);
	    float radialGradient = length(UVgrid - hash) / radius;
	    radialGradient = clamp(1.0 - radialGradient, 0.0, 1.0);
	    radialGradient *= radialGradient;

	    
	    COLOR.xyz += vec3(radialGradient);
    }
	
	//mid stars
	for(int i = 0; i < 8; i++){
		vec2 ratioScale = vec2(1, 1);
		vec2 uvScale = vec2(float(i)*1.0 + 100.0);
		vec2 uv = ((pos + offset * mid_parallax_mod) * ratioScale / resolution) * uvScale;
    
	   // get random 2d cell noise
	    vec2 CellUVs = floor(uv + float(i * 1199));
		vec2 hash = (hash2d(CellUVs) * 2.0 - 1.0) * mid_noise_scale;
	    float hash_magnitude =(1.0-length(hash));

	    // calculate uv cell grid.
	    vec2 UVgrid = fract(uv) - 0.5;

	    //
	    float radius = clamp(hash_magnitude - 0.5, 0.0, 1.0);
	    float radialGradient = length(UVgrid - hash) / radius;
	    radialGradient = clamp(1.0 - radialGradient, 0.0, 1.0);
	    radialGradient *= radialGradient;

	    
	    COLOR.xyz += vec3(radialGradient);
    }
	
	//back stars
	for(int i = 0; i < 8; i++){
		vec2 ratioScale = vec2(1, 1);
		vec2 uvScale = vec2(float(i)*1.0 + 100.0);
		vec2 uv = ((pos + offset * back_parallax_mod) * ratioScale / resolution) * uvScale;
    
	   // get random 2d cell noise
	    vec2 CellUVs = floor(uv + float(i * 1199));
		vec2 hash = (hash2d(CellUVs) * 2.0 - 1.0) * back_noise_scale;
	    float hash_magnitude =(1.0-length(hash));

	    // calculate uv cell grid.
	    vec2 UVgrid = fract(uv) - 0.5;

	    //
	    float radius = clamp(hash_magnitude - 0.5, 0.0, 1.0);
	    float radialGradient = length(UVgrid - hash) / radius;
	    radialGradient = clamp(1.0 - radialGradient, 0.0, 1.0);
	    radialGradient *= radialGradient;

	    
	    COLOR.xyz += vec3(radialGradient);
		COLOR.xyz = vec3(step(COLOR.x, 0.5), step(COLOR.y, 0.5), step(COLOR.z, 0.5));
    }
}