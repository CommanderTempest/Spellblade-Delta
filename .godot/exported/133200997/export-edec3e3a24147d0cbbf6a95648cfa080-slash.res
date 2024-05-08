RSRC                    VisualShader            ��������                                            h      resource_local_to_scene    resource_name    interpolation_mode    interpolation_color_space    offsets    colors    script 	   gradient    width    use_hdr    output_port_for_preview    default_input_values    expanded_output_ports    source    texture    texture_type    input_name 	   function    parameter_name 
   qualifier    hint    min    max    step    default_value_enabled    default_value    op_type 	   operator    height    fill 
   fill_from    fill_to    repeat    code    graph_offset    mode    modes/blend    modes/depth_draw    modes/cull    modes/diffuse    modes/specular    flags/depth_prepass_alpha    flags/depth_test_disabled    flags/sss_mode_skin    flags/unshaded    flags/wireframe    flags/skip_vertex_transform    flags/world_vertex_coords    flags/ensure_correct_normals    flags/shadows_disabled    flags/ambient_light_disabled    flags/shadow_to_opacity    flags/vertex_lighting    flags/particle_trails    flags/alpha_to_coverage     flags/alpha_to_coverage_and_one    flags/debug_shadow_splits    flags/fog_disabled    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/4/node    nodes/fragment/4/position    nodes/fragment/5/node    nodes/fragment/5/position    nodes/fragment/6/node    nodes/fragment/6/position    nodes/fragment/7/node    nodes/fragment/7/position    nodes/fragment/8/node    nodes/fragment/8/position    nodes/fragment/9/node    nodes/fragment/9/position    nodes/fragment/10/node    nodes/fragment/10/position    nodes/fragment/11/node    nodes/fragment/11/position    nodes/fragment/12/node    nodes/fragment/12/position    nodes/fragment/13/node    nodes/fragment/13/position    nodes/fragment/14/node    nodes/fragment/14/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections           local://Gradient_dvbgy Z          local://GradientTexture1D_nqsax �      &   local://VisualShaderNodeTexture_ay2jm       $   local://VisualShaderNodeInput_23dr0 E      %   local://VisualShaderNodeUVFunc_c0x4j z      -   local://VisualShaderNodeFloatParameter_npbji �      '   local://VisualShaderNodeVectorOp_fbae6 "      $   local://VisualShaderNodeInput_sqjh7 �      -   local://VisualShaderNodeFloatParameter_508tw �      '   local://VisualShaderNodeVectorOp_56wuj       %   local://VisualShaderNodeUVFunc_5l2rv �         local://Gradient_f0dx2 �          local://GradientTexture2D_jkuvj ~      &   local://VisualShaderNodeTexture_do3s2 �      '   local://VisualShaderNodeVectorOp_smc2d �      '   local://VisualShaderNodeVectorOp_gx70e m      -   local://VisualShaderNodeColorParameter_kfgpq �         local://VisualShader_wwfbi #      	   Gradient       !          !W�>��?<�L?   $                    �?  �?  �?  �?  �?  �?  �?  �?  �?              �?         GradientTexture1D                          VisualShaderNodeTexture                         VisualShaderNodeInput             uv          VisualShaderNodeUVFunc                   
     �?          
                    VisualShaderNodeFloatParameter             Gradient_1_Slider          VisualShaderNodeVectorOp                    
                 
   ��L>                                VisualShaderNodeInput             uv          VisualShaderNodeFloatParameter             Gradient_2_Slider          VisualShaderNodeVectorOp                    
                 
     �?  �>                            VisualShaderNodeUVFunc                   
         �?      
                 	   Gradient       !          ��L>���>   ?��?   $                    �?  �?  �?  �?  �?  �?  �?  �?  �?              �?              �?         GradientTexture2D                   
         �?         VisualShaderNodeTexture                         VisualShaderNodeVectorOp                    
                 
     �?  �?                            VisualShaderNodeVectorOp                    
                 
     �?  �?                            VisualShaderNodeColorParameter             Color          VisualShader    !      �  shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx;

uniform vec4 Color : source_color;
uniform float Gradient_1_Slider;
uniform sampler2D tex_frg_2;
uniform float Gradient_2_Slider;
uniform sampler2D tex_frg_11;



void fragment() {
// ColorParameter:14
	vec4 n_out14p0 = Color;


// Input:3
	vec2 n_out3p0 = UV;


// VectorOp:6
	vec2 n_in6p1 = vec2(0.20000, 0.00000);
	vec2 n_out6p0 = n_out3p0 * n_in6p1;


// FloatParameter:5
	float n_out5p0 = Gradient_1_Slider;


// UVFunc:4
	vec2 n_in4p1 = vec2(1.00000, 0.00000);
	vec2 n_out4p0 = vec2(n_out5p0) * n_in4p1 + n_out6p0;


// Texture2D:2
	vec4 n_out2p0 = texture(tex_frg_2, n_out4p0);


// Input:7
	vec2 n_out7p0 = UV;


// VectorOp:9
	vec2 n_in9p1 = vec2(1.00000, 0.25000);
	vec2 n_out9p0 = n_out7p0 * n_in9p1;


// FloatParameter:8
	float n_out8p0 = Gradient_2_Slider;


// UVFunc:10
	vec2 n_in10p1 = vec2(0.00000, 1.00000);
	vec2 n_out10p0 = vec2(n_out8p0) * n_in10p1 + n_out9p0;


// Texture2D:11
	vec4 n_out11p0 = texture(tex_frg_11, n_out10p0);


// VectorOp:12
	vec2 n_out12p0 = vec2(n_out2p0.xy) * vec2(n_out11p0.xy);


// Output:0
	ALBEDO = vec3(n_out14p0.xyz);
	ALPHA = n_out12p0.x;


}
 <   
     D  HC=            >   
      �  �C?            @   
     ��  �CA            B   
     ��  �CC            D   
     W�  �CE            F   
     *�  HCG            H   
     k�  DI            J   
     R�  /DK         	   L   
     �  DM         
   N   
     ��  *DO            P   
      �  DQ            R   
     �B  �CS            T   
     �C   BU            V   
     p�  pBW       8                                                                 	       	       
              
      
                                                                                                       RSRC