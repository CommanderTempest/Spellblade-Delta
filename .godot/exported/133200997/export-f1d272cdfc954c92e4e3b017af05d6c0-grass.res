RSRC                    VisualShader            ��������                                            a      resource_local_to_scene    resource_name    noise_type    seed 
   frequency    offset    fractal_type    fractal_octaves    fractal_lacunarity    fractal_gain    fractal_weighted_strength    fractal_ping_pong_strength    cellular_distance_function    cellular_jitter    cellular_return_type    domain_warp_enabled    domain_warp_type    domain_warp_amplitude    domain_warp_frequency    domain_warp_fractal_type    domain_warp_fractal_octaves    domain_warp_fractal_lacunarity    domain_warp_fractal_gain    script    width    height    invert    in_3d_space    generate_mipmaps 	   seamless    seamless_blend_skirt    as_normal_map    bump_strength 
   normalize    color_ramp    noise    output_port_for_preview    default_input_values    expanded_output_ports    source    texture    texture_type    interpolation_mode    interpolation_color_space    offsets    colors 	   gradient    use_hdr    code    graph_offset    mode    modes/blend    modes/depth_draw    modes/cull    modes/diffuse    modes/specular    flags/depth_prepass_alpha    flags/depth_test_disabled    flags/sss_mode_skin    flags/unshaded    flags/wireframe    flags/skip_vertex_transform    flags/world_vertex_coords    flags/ensure_correct_normals    flags/shadows_disabled    flags/ambient_light_disabled    flags/shadow_to_opacity    flags/vertex_lighting    flags/particle_trails    flags/alpha_to_coverage     flags/alpha_to_coverage_and_one    flags/debug_shadow_splits    flags/fog_disabled    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections           local://FastNoiseLite_22kfc e
         local://NoiseTexture2D_y31wn �
      &   local://VisualShaderNodeTexture_231ro �
         local://Gradient_ncc46           local://GradientTexture1D_47oir G      &   local://VisualShaderNodeTexture_2wl2k y         local://VisualShader_f8v1b �         FastNoiseLite          ��L=         NoiseTexture2D             #                      VisualShaderNodeTexture    (                  	   Gradient    -   $          /7>:
�3  �?    �Y�=      �?         GradientTexture1D    .                     VisualShaderNodeTexture    (                     VisualShader    0      s  shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx;

uniform sampler2D tex_frg_2;
uniform sampler2D tex_frg_3;



void fragment() {
// Texture2D:2
	vec4 n_out2p0 = texture(tex_frg_2, UV);


// Texture2D:3
	vec4 n_out3p0 = texture(tex_frg_3, vec2(n_out2p0.xy));


// Output:0
	ALBEDO = vec3(n_out3p0.xyz);


}
 L            M   
     ��  \CN            O   
      C  HCP                                             RSRC