RSRC                    VisualShader            ��������                                            q      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    input_name    script    op_type 	   function 	   operator    parameter_name 
   qualifier    texture_type    color_default    texture_filter    texture_repeat    texture_source    source    texture 	   constant    default_value_enabled    default_value    code    graph_offset    mode    modes/blend    modes/depth_draw    modes/cull    modes/diffuse    modes/specular    flags/depth_prepass_alpha    flags/depth_test_disabled    flags/sss_mode_skin    flags/unshaded    flags/wireframe    flags/skip_vertex_transform    flags/world_vertex_coords    flags/ensure_correct_normals    flags/shadows_disabled    flags/ambient_light_disabled    flags/shadow_to_opacity    flags/vertex_lighting    flags/particle_trails    flags/alpha_to_coverage     flags/alpha_to_coverage_and_one    flags/debug_shadow_splits    flags/fog_disabled    nodes/vertex/0/position    nodes/vertex/2/node    nodes/vertex/2/position    nodes/vertex/3/node    nodes/vertex/3/position    nodes/vertex/4/node    nodes/vertex/4/position    nodes/vertex/5/node    nodes/vertex/5/position    nodes/vertex/6/node    nodes/vertex/6/position    nodes/vertex/7/node    nodes/vertex/7/position    nodes/vertex/8/node    nodes/vertex/8/position    nodes/vertex/9/node    nodes/vertex/9/position    nodes/vertex/10/node    nodes/vertex/10/position    nodes/vertex/11/node    nodes/vertex/11/position    nodes/vertex/12/node    nodes/vertex/12/position    nodes/vertex/13/node    nodes/vertex/13/position    nodes/vertex/14/node    nodes/vertex/14/position    nodes/vertex/15/node    nodes/vertex/15/position    nodes/vertex/16/node    nodes/vertex/16/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/4/node    nodes/fragment/4/position    nodes/fragment/5/node    nodes/fragment/5/position    nodes/fragment/6/node    nodes/fragment/6/position    nodes/fragment/7/node    nodes/fragment/7/position    nodes/fragment/8/node    nodes/fragment/8/position    nodes/fragment/9/node    nodes/fragment/9/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections        $   local://VisualShaderNodeInput_fqktb _      .   local://VisualShaderNodeVectorDecompose_120fw �      (   local://VisualShaderNodeFloatFunc_gwc2f �      $   local://VisualShaderNodeInput_8mgw2 &      '   local://VisualShaderNodeVectorOp_e3kxw _      1   local://VisualShaderNodeTexture2DParameter_0qryj �      &   local://VisualShaderNodeTexture_2rbrn �      '   local://VisualShaderNodeVectorOp_pqc5e       %   local://VisualShaderNodeUVFunc_v6ol4 :      $   local://VisualShaderNodeInput_8pqcf �      $   local://VisualShaderNodeInput_6yvjl �      .   local://VisualShaderNodeVectorDecompose_l7frd       ,   local://VisualShaderNodeVectorCompose_llul1 B      '   local://VisualShaderNodeVectorOp_2jgen |      '   local://VisualShaderNodeVectorOp_sfbjs �      ,   local://VisualShaderNodeVectorCompose_qqffx V      ,   local://VisualShaderNodeFloatConstant_7xihr �      $   local://VisualShaderNodeInput_det2h �      .   local://VisualShaderNodeVectorDecompose_786uo #      (   local://VisualShaderNodeFloatFunc_ng5uj       "   local://VisualShaderNodeMix_72h7o �      -   local://VisualShaderNodeColorParameter_ughc7 9      -   local://VisualShaderNodeColorParameter_pqxgy �         local://VisualShader_khsn0          VisualShaderNodeInput             uv           VisualShaderNodeVectorDecompose                    
                              VisualShaderNodeFloatFunc                      VisualShaderNodeInput             vertex          VisualShaderNodeVectorOp          #   VisualShaderNodeTexture2DParameter    
      
   WindNoise          VisualShaderNodeTexture                      VisualShaderNodeVectorOp    	                  VisualShaderNodeUVFunc                   
   ���=���=      
                    VisualShaderNodeInput             time          VisualShaderNodeInput             node_position_world           VisualShaderNodeVectorDecompose             VisualShaderNodeVectorCompose                       VisualShaderNodeVectorOp                    
                 
                              VisualShaderNodeVectorOp                                            ���=���=���=	                  VisualShaderNodeVectorCompose                                      �?                      VisualShaderNodeFloatConstant             VisualShaderNodeInput             uv           VisualShaderNodeVectorDecompose                    
                              VisualShaderNodeFloatFunc                      VisualShaderNodeMix                                              �?  �?  �?            ?   ?   ?                  VisualShaderNodeColorParameter    
      
   BaseColor                ���=s��>�� =  �?         VisualShaderNodeColorParameter    
         GrassColor                ��h>��?���=  �?         VisualShader 6         �  shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_toon, specular_schlick_ggx;

uniform sampler2D WindNoise;
uniform vec4 BaseColor : source_color = vec4(0.109804, 0.250980, 0.039216, 1.000000);
uniform vec4 GrassColor : source_color = vec4(0.227451, 0.592157, 0.066667, 1.000000);



void vertex() {
// Input:5
	vec3 n_out5p0 = VERTEX;


// Input:12
	vec3 n_out12p0 = NODE_POSITION_WORLD;


// VectorDecompose:13
	float n_out13p0 = n_out12p0.x;
	float n_out13p1 = n_out12p0.y;
	float n_out13p2 = n_out12p0.z;


// VectorCompose:14
	vec2 n_out14p0 = vec2(n_out13p0, n_out13p2);


// Input:11
	float n_out11p0 = TIME;


// VectorOp:15
	vec2 n_out15p0 = n_out14p0 + vec2(n_out11p0);


// UVFunc:10
	vec2 n_in10p1 = vec2(0.10000, 0.10000);
	vec2 n_out10p0 = n_out15p0 * n_in10p1 + UV;


	vec4 n_out8p0;
// Texture2D:8
	n_out8p0 = texture(WindNoise, n_out10p0);


// Input:2
	vec2 n_out2p0 = UV;


// VectorDecompose:3
	float n_out3p0 = n_out2p0.x;
	float n_out3p1 = n_out2p0.y;


// FloatFunc:4
	float n_out4p0 = 1.0 - n_out3p1;


// VectorOp:9
	vec3 n_out9p0 = vec3(n_out8p0.xyz) * vec3(n_out4p0);


// VectorOp:16
	vec3 n_in16p1 = vec3(0.10000, 0.10000, 0.10000);
	vec3 n_out16p0 = n_out9p0 * n_in16p1;


// VectorOp:6
	vec3 n_out6p0 = n_out5p0 + n_out16p0;


// Output:0
	VERTEX = n_out6p0;


}

void fragment() {
// ColorParameter:8
	vec4 n_out8p0 = BaseColor;


// ColorParameter:9
	vec4 n_out9p0 = GrassColor;


// Input:4
	vec2 n_out4p0 = UV;


// VectorDecompose:5
	float n_out5p0 = n_out4p0.x;
	float n_out5p1 = n_out4p0.y;


// FloatFunc:6
	float n_out6p0 = 1.0 - n_out5p1;


// Mix:7
	vec3 n_out7p0 = mix(vec3(n_out8p0.xyz), vec3(n_out9p0.xyz), vec3(n_out6p0));


// FloatConstant:3
	float n_out3p0 = 0.000000;


// VectorCompose:2
	float n_in2p0 = 0.00000;
	float n_in2p1 = 1.00000;
	float n_in2p2 = 0.00000;
	vec3 n_out2p0 = vec3(n_in2p0, n_in2p1, n_in2p2);


// Output:0
	ALBEDO = n_out7p0;
	ROUGHNESS = n_out3p0;
	NORMAL = n_out2p0;
	NORMAL_MAP = n_out2p0;


}
                   /   
     \C  �B0             1   
     ��  �C2            3   
     W�  �C4            5   
      �  �C6            7   
     ��  ��8            9   
         ��:            ;   
     ��  ��<            =   
     �   �>            ?   
     ��  ��@            A   
     R�  ��B         	   C   
    ���  ��D         
   E   
    ���  �F            G   
     ��  �H            I   
     ��  �J            K   
    ���  �L            M   
     H�  �N       @                                                                               	              	      
                                                                                        
      	                           O   
     �C  ��P            Q   
     ��  HCR            S   
     pB  �BT            U   
     �    V            W   
     ��  ��X            Y   
     p�    Z            [   
      C  4�\            ]   
     H�  ��^            _   
     H�  \�`       $                            	                                                                                      	                   RSRC