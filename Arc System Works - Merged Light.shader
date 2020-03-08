// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader ".Aerthas/Arc System Works/Merged Light"
{
	Properties
	{
		_Base("Base", 2D) = "white" {}
		_ILM("ILM", 2D) = "white" {}
		_SSS("SSS", 2D) = "white" {}
		_DetailRequiresUVtobeonasecondUVChannel("Detail (Requires UV to be on a second UV Channel)", 2D) = "white" {}
		_OutlineColor("Outline Color", Color) = (0,0,0,0)
		_OutlineThickness("Outline Thickness", Float) = 2
		[Toggle]_MetalEnable("Metal Enable", Float) = 0
		_Metal("Metal", 2D) = "white" {}
		_MetalAIntensity("Metal A Intensity", Float) = 1
		_MetalBIntensity("Metal B Intensity", Float) = 5
		_AmbMin("AmbMin", Float) = 0.2
		_AmbMax("AmbMax", Float) = 0.7
		_LightColor("Light Color", Color) = (1,1,1,0)
		_LightDir("Light Dir", Color) = (1,1,1,0)
		_LightIntensity("Light Intensity", Float) = 1.33
		_LightLayer1Push("Light Layer 1 Push", Range( 0 , 1)) = 0
		_LightLayer2Push("Light Layer 2 Push", Range( 0 , 1)) = 0
		_ShineSize("Shine Size", Float) = 4
		_ShineIntensity("Shine Intensity", Float) = 1
		_ShadowIntensity("Shadow Intensity", Float) = 2
		_ShadowTint("Shadow Tint", Color) = (0,0,0,0)
		_FinalColorIntensity("Final Color Intensity", Float) = 3
		_VertexColorOpacity("Vertex Color Opacity", Range( 0 , 1)) = 1
		_VertexColorScale("Vertex Color Scale", Range( 0 , 0.9999)) = 0.7
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ }
		Cull Front
		CGPROGRAM
		#pragma target 3.0
		#pragma surface outlineSurf Outline nofog  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc 
		void outlineVertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float outlineVar = ( 1E-05 * _OutlineThickness );
			v.vertex.xyz += ( v.normal * outlineVar );
		}
		inline half4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return half4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			o.Emission = _OutlineColor.rgb;
		}
		ENDCG
		

		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float2 uv2_texcoord2;
			float3 worldNormal;
			float3 worldPos;
			float4 vertexColor : COLOR;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _Base;
		uniform float4 _Base_ST;
		uniform sampler2D _ILM;
		uniform float4 _ILM_ST;
		uniform sampler2D _DetailRequiresUVtobeonasecondUVChannel;
		uniform float _AmbMin;
		uniform float _AmbMax;
		uniform float4 _ShadowTint;
		uniform sampler2D _SSS;
		uniform float4 _SSS_ST;
		uniform float _LightIntensity;
		uniform float _LightLayer2Push;
		uniform float4 _LightDir;
		uniform float _VertexColorOpacity;
		uniform float _VertexColorScale;
		uniform float _ShadowIntensity;
		uniform float _LightLayer1Push;
		uniform float _FinalColorIntensity;
		uniform float _ShineSize;
		uniform float _ShineIntensity;
		uniform float4 _LightColor;
		uniform float _MetalEnable;
		uniform float _MetalAIntensity;
		uniform sampler2D _Metal;
		uniform float _MetalBIntensity;
		uniform float _OutlineThickness;
		uniform float4 _OutlineColor;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 outline159 = 0;
			v.vertex.xyz += outline159;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 uv_SSS = i.uv_texcoord * _SSS_ST.xy + _SSS_ST.zw;
			float4 temp_cast_3 = (_LightIntensity).xxxx;
			float temp_output_222_0 = ( 2.0 - ( 1.0 - _LightLayer2Push ) );
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float temp_output_114_0 = (( ( (( abs( ase_worldlightDir ).x > float3( 0,0,0 ) ) ? 1.0 :  0.0 ) + (( ase_lightColor.a > 0.0 ) ? 1.0 :  0.0 ) ) > 0.0 ) ? 1.0 :  0.0 );
			float4 mergedRealFakeLightDir142 = (( temp_output_114_0 > 0.0 ) ? float4( ase_worldlightDir , 0.0 ) :  ( _LightDir * 0.57 ) );
			float dotResult4 = dot( float4( ase_worldNormal , 0.0 ) , ( temp_output_222_0 * mergedRealFakeLightDir142 ) );
			float blendOpSrc210 = ( 1.0 - _VertexColorOpacity );
			float blendOpDest210 = i.vertexColor.g;
			float temp_output_3_0_g1 = ( _VertexColorScale - i.vertexColor.r );
			float lerpBlendMode210 = lerp(blendOpDest210,min( blendOpSrc210 , blendOpDest210 ),saturate( ( temp_output_3_0_g1 / fwidth( temp_output_3_0_g1 ) ) ));
			float vertexColorShading205 = ( saturate( lerpBlendMode210 ));
			float clampResult9 = clamp( ( temp_output_222_0 * dotResult4 * vertexColorShading205 ) , 0.0 , 1.0 );
			float temp_output_224_0 = ( 2.0 - _LightLayer1Push );
			float dotResult26 = dot( float4( ase_worldNormal , 0.0 ) , ( mergedRealFakeLightDir142 * temp_output_224_0 ) );
			float clampResult7 = clamp( floor( ( dotResult26 * temp_output_224_0 * vertexColorShading205 ) ) , 0.0 , 1.0 );
			float lerpResult18 = lerp( -_ShadowIntensity , 1.0 , clampResult7);
			float dotResult14 = dot( float4( ase_worldNormal , 0.0 ) , mergedRealFakeLightDir142 );
			float2 uv_ILM = i.uv_texcoord * _ILM_ST.xy + _ILM_ST.zw;
			float4 tex2DNode58 = tex2D( _ILM, uv_ILM );
			float ILMB255 = tex2DNode58.b;
			float blendOpSrc270 = ILMB255;
			float blendOpDest270 = 1.0;
			float clampResult25 = clamp( ( dotResult14 * vertexColorShading205 * ( ( saturate( ( blendOpSrc270 + blendOpDest270 - 1.0 ) )) * _ShineSize ) ) , 0.0 , 1.0 );
			float clampResult23 = clamp( floor( clampResult25 ) , 0.0 , 1.0 );
			float lightDotProduct127 = ( ( floor( clampResult9 ) + lerpResult18 ) + _FinalColorIntensity + ( clampResult23 * _ShineIntensity ) );
			float4 lerpResult61 = lerp( ( 1.3 * tex2D( _SSS, uv_SSS ) ) , temp_cast_3 , ( lightDotProduct127 * 0.15 ));
			float4 LightMultInformation273 = lerpResult61;
			float hasWorldLight115 = temp_output_114_0;
			float4 temp_output_63_0 = ( LightMultInformation273 * (( hasWorldLight115 > 0.0 ) ? float4( ase_lightColor.rgb , 0.0 ) :  _LightColor ) );
			float3 worldToViewDir106 = mul( UNITY_MATRIX_V, float4( ase_worldNormal, 0 ) ).xyz;
			float4 tex2DNode75 = tex2D( _Metal, ( 0.5 + ( 0.5 * (worldToViewDir106).xy ) ) );
			float metalMatCap126 = ( lightDotProduct127 * ( ( _MetalAIntensity * tex2DNode75.r ) + ( tex2DNode75.b * _MetalBIntensity ) ) );
			float4 temp_cast_12 = (metalMatCap126).xxxx;
			float2 uv_Base = i.uv_texcoord * _Base_ST.xy + _Base_ST.zw;
			float ILMA149 = tex2DNode58.a;
			float4 temp_output_305_0 = ( tex2D( _Base, uv_Base ) * ILMA149 );
			float4 tex2DNode83 = tex2D( _DetailRequiresUVtobeonasecondUVChannel, i.uv2_texcoord2 );
			float4 finalCustomLighting101 = ( temp_output_63_0 * (( _MetalEnable )?( temp_cast_12 ):( temp_output_63_0 )) * temp_output_305_0 * tex2DNode83 );
			c.rgb = finalCustomLighting101.rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			float2 uv_Base = i.uv_texcoord * _Base_ST.xy + _Base_ST.zw;
			float2 uv_ILM = i.uv_texcoord * _ILM_ST.xy + _ILM_ST.zw;
			float4 tex2DNode58 = tex2D( _ILM, uv_ILM );
			float ILMA149 = tex2DNode58.a;
			float4 temp_output_305_0 = ( tex2D( _Base, uv_Base ) * ILMA149 );
			float4 tex2DNode83 = tex2D( _DetailRequiresUVtobeonasecondUVChannel, i.uv2_texcoord2 );
			float4 temp_cast_0 = (_AmbMin).xxxx;
			float4 temp_cast_1 = (_AmbMax).xxxx;
			float4 clampResult290 = clamp( UNITY_LIGHTMODEL_AMBIENT , temp_cast_0 , temp_cast_1 );
			float4 shadowTinting292 = ( clampResult290 * _ShadowTint );
			float4 FinalEmission99 = ( temp_output_305_0 * tex2DNode83 * shadowTinting292 );
			o.Emission = FinalEmission99.rgb;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack1.zw = customInputData.uv2_texcoord2;
				o.customPack1.zw = v.texcoord1;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				surfIN.uv2_texcoord2 = IN.customPack1.zw;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				surfIN.vertexColor = IN.color;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
769;247;1167;724;6171.096;514.9749;1.3;True;True
Node;AmplifyShaderEditor.CommentaryNode;276;-7716.736,-3560.511;Inherit;False;1889.843;538.0769;Real or Fake light;13;108;110;109;112;111;113;114;115;8;96;116;142;303;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;108;-7667.736,-3503.555;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LightColorNode;109;-7617.047,-3318.409;Inherit;True;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.AbsOpNode;110;-7426.243,-3501.454;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCCompareGreater;111;-7299.367,-3496.775;Inherit;False;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareGreater;112;-7295.469,-3292.956;Inherit;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;113;-7060.96,-3316.488;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;96;-6801.086,-3200.582;Float;False;Property;_LightDir;Light Dir;14;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;302;-6598.165,-3103.671;Inherit;False;Constant;_Float1;Float 1;25;0;Create;True;0;0;False;0;0.57;0.57;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;218;-7562.533,-1040.654;Inherit;False;1274.417;550.1586;Vertex Color Shading;10;193;215;210;196;195;213;214;205;208;220;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;303;-6401.366,-3139.469;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;8;-6586.868,-3343.114;Inherit;True;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TFHCCompareGreater;114;-6895.329,-3337.128;Inherit;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;279;-7532.123,-1573.589;Inherit;False;938.4316;447.5515;ILM Information;7;58;149;255;52;53;133;260;;1,1,1,1;0;0
Node;AmplifyShaderEditor.VertexColorNode;193;-7493.533,-888.7579;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;58;-7482.123,-1387.334;Inherit;True;Property;_ILM;ILM;1;0;Create;True;0;0;False;0;-1;None;a3305d71b40ac3a47a0a610eb6f22383;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;208;-7370.783,-982.6536;Inherit;False;Property;_VertexColorOpacity;Vertex Color Opacity;23;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;214;-7303.194,-901.5725;Inherit;False;Property;_VertexColorScale;Vertex Color Scale;24;0;Create;True;0;0;False;0;0.7;0.7;0;0.9999;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareGreater;116;-6273.311,-3297.64;Inherit;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;272;-7750.05,-2988.096;Inherit;False;2526.533;856.7749;Light DOT Production;36;223;221;224;269;143;265;270;225;2;222;17;187;22;26;266;14;4;12;20;25;3;5;16;7;9;13;250;18;254;6;23;268;264;24;27;127;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;142;-6047.893,-3304.293;Float;False;mergedRealFakeLightDir;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;223;-7675.998,-2494.249;Float;False;Property;_LightLayer1Push;Light Layer 1 Push;16;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;221;-7700.05,-2924.224;Float;False;Property;_LightLayer2Push;Light Layer 2 Push;17;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;213;-7017.441,-850.1107;Inherit;False;Step Antialiasing;-1;;1;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;215;-7045.122,-955.149;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;255;-6978.32,-1330.341;Inherit;False;ILMB;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;224;-7312.702,-2528.071;Inherit;False;2;0;FLOAT;2;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;265;-7317.556,-2366;Inherit;False;255;ILMB;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;210;-6799.003,-793.1508;Inherit;False;Darken;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;269;-7432.579,-2913.293;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;143;-7561.202,-2632.135;Inherit;False;142;mergedRealFakeLightDir;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;270;-7134.346,-2362.728;Inherit;False;LinearBurn;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-7122.309,-2585.428;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldNormalVector;17;-7253.465,-2725.686;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;222;-7276.65,-2938.096;Inherit;False;2;0;FLOAT;2;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;205;-6546.116,-793.7397;Float;False;vertexColorShading;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;225;-7289.391,-2247.321;Float;False;Property;_ShineSize;Shine Size;18;0;Create;True;0;0;False;0;4;48;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;26;-6919.608,-2664.927;Inherit;False;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;266;-6934.993,-2305.465;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;187;-7043.727,-2764.868;Inherit;False;205;vertexColorShading;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-7146.275,-2853.669;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;14;-6965.91,-2489.298;Inherit;True;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-6750.152,-2462.22;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;4;-6968.118,-2863.616;Inherit;False;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-6753.359,-2615.358;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-6584.757,-2740.567;Float;False;Property;_ShadowIntensity;Shadow Intensity;20;0;Create;True;0;0;False;0;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;25;-6606.73,-2454.993;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;3;-6590.167,-2611.385;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-6790.939,-2867.147;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;153;-7559.391,-2118.31;Inherit;False;2074.331;483.6988;Metal Matcap;15;69;106;71;73;72;74;75;79;78;76;77;80;81;131;126;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ClampOpNode;7;-6446.511,-2618.504;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;69;-7509.391,-1899.111;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ClampOpNode;9;-6645.922,-2872.975;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;13;-6436.871,-2448.426;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;250;-6357.221,-2729.382;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;6;-6467.44,-2882.234;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;23;-6290.728,-2448.391;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;254;-6246.888,-2293.055;Inherit;False;Property;_ShineIntensity;Shine Intensity;19;0;Create;True;0;0;False;0;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TransformDirectionNode;106;-7318.445,-1903.609;Inherit;True;World;View;False;Fast;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;18;-6136.66,-2767.871;Inherit;True;3;0;FLOAT;-0.9;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;268;-5850.091,-2832.407;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-7028.391,-1986.111;Float;False;Constant;_Float41;Float 41;8;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-5876.729,-2626.969;Float;False;Property;_FinalColorIntensity;Final Color Intensity;22;0;Create;True;0;0;False;0;3;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;71;-7090.391,-1903.111;Inherit;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;264;-5995.854,-2448.149;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-5714.647,-2650.816;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-6865.391,-1920.111;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;274;-7529.822,-383.2127;Inherit;False;961.1257;648.75;Lighting Mult Information;9;57;56;263;130;55;59;60;61;273;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;127;-5452.517,-2556.974;Float;False;lightDotProduct;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;74;-6708.391,-1948.111;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;57;-7474.608,-211.5406;Inherit;True;Property;_SSS;SSS;2;0;Create;True;0;0;False;0;-1;None;2042a78391260c944b982f99c34b9298;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;263;-7341.684,149.536;Inherit;False;Constant;_Float0;Float 0;26;0;Create;True;0;0;False;0;0.15;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-6506.388,-2066.212;Float;False;Property;_MetalAIntensity;Metal A Intensity;8;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;130;-7479.822,33.65985;Inherit;False;127;lightDotProduct;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;75;-6567.391,-1975.111;Inherit;True;Property;_Metal;Metal;7;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;79;-6486.087,-1749.611;Float;False;Property;_MetalBIntensity;Metal B Intensity;9;0;Create;True;0;0;False;0;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-7461.761,-333.2127;Float;False;Constant;_ShadeOffsetMult;Shade Offset Mult;25;0;Create;True;0;0;False;0;1.3;1.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-7223.832,-5.591212;Float;False;Property;_LightIntensity;Light Intensity;15;0;Create;True;0;0;False;0;1.33;1.33;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-7094.735,-236.8425;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;294;-6261.178,-1026.133;Inherit;False;947.6294;460.1959;Shadow Tinting;7;289;290;291;292;287;288;293;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;-6230.383,-1801.411;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-7169.837,111.17;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-6235.089,-1969.012;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;115;-6635.315,-3510.511;Float;False;hasWorldLight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;61;-7002.981,59.99482;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;287;-6205.893,-840.722;Float;False;Property;_AmbMax;AmbMax;11;0;Create;True;0;0;False;0;0.7;0.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;131;-6174.475,-2068.31;Inherit;False;127;lightDotProduct;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;288;-6207.883,-910.765;Float;False;Property;_AmbMin;AmbMin;10;0;Create;True;0;0;False;0;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;278;-6462.066,-411.5697;Inherit;False;1696.932;874.1938;Final Color Information;18;64;120;118;121;275;132;65;84;150;63;82;83;68;101;99;90;299;305;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;80;-6071.188,-1899.011;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FogAndAmbientColorsNode;293;-6211.178,-976.133;Inherit;False;UNITY_LIGHTMODEL_AMBIENT;0;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;273;-6800.848,61.17829;Inherit;False;LightMultInformation;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;64;-6417.71,-114.0757;Float;False;Property;_LightColor;Light Color;13;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;289;-6202.618,-767.9371;Float;False;Property;_ShadowTint;Shadow Tint;21;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;118;-6407.066,-330.9675;Inherit;False;115;hasWorldLight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;290;-5912.618,-968.938;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;120;-6396.074,-246.3805;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-5915.187,-1917.411;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;126;-5728.06,-1915.593;Float;False;metalMatCap;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;149;-7094.325,-1241.438;Float;False;ILMA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;291;-5709.619,-940.938;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;275;-6079.889,-372.424;Inherit;False;273;LightMultInformation;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCCompareGreater;121;-6164.961,-277.0504;Inherit;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;160;-6463.784,-1569.01;Inherit;False;832.2299;472.6832;Outline;6;92;93;94;91;95;159;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;92;-6400.151,-1315.188;Float;False;Constant;_Float46;Float 46;17;0;Create;True;0;0;False;0;1E-05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;132;-5839.745,-164.1326;Inherit;False;126;metalMatCap;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;150;-5995.509,105.5414;Inherit;False;149;ILMA;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;65;-6115.66,-97.1734;Inherit;True;Property;_Base;Base;0;0;Create;True;0;0;False;0;-1;None;f527e23ef6fd0e645a3818a274d691fe;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;292;-5537.549,-936.0731;Float;False;shadowTinting;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;93;-6413.784,-1212.327;Float;False;Property;_OutlineThickness;Outline Thickness;5;0;Create;True;0;0;False;0;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-5762.247,-361.5696;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;84;-5985.924,278.9711;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;-6221.697,-1313.948;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;305;-5611.787,-8.522278;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;91;-6356.775,-1519.01;Float;False;Property;_OutlineColor;Outline Color;4;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;83;-5691.727,184.1927;Inherit;True;Property;_DetailRequiresUVtobeonasecondUVChannel;Detail (Requires UV to be on a second UV Channel);3;0;Create;True;0;0;False;0;-1;None;cbe340ebf127f6946b2b6d43527259b8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;82;-5618.586,-187.4585;Float;False;Property;_MetalEnable;Metal Enable;6;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;299;-5383.34,242.8264;Inherit;False;292;shadowTinting;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-5131.93,139.4931;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OutlineNode;95;-6084.138,-1503.561;Inherit;False;0;True;None;0;0;Front;3;0;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-5283.841,-172.5186;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;161;-5148.352,-1322.828;Inherit;False;564.9398;497;Output;4;97;0;158;100;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;159;-5855.554,-1505.826;Inherit;False;outline;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;99;-4989.934,142.5827;Float;False;FinalEmission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;101;-5104.13,-176.7775;Float;False;finalCustomLighting;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;-5098.352,-1046.593;Inherit;False;101;finalCustomLighting;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;220;-7210.457,-718.0759;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;260;-7175.565,-1523.589;Inherit;False;ILMR;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;97;-5096.257,-1225.873;Inherit;False;99;FinalEmission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;196;-7478.525,-692.5731;Inherit;False;127;lightDotProduct;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-7162.134,-1441.746;Float;False;Property;_ILMDetailScale;ILM Detail Scale;12;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;133;-6818.491,-1439.483;Float;False;ILMG;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;195;-7456.079,-606.495;Inherit;False;133;ILMG;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;158;-5077.332,-963.6299;Inherit;False;159;outline;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-6968.468,-1437.135;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-4838.412,-1272.827;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;.Aerthas/Arc System Works/Merged Light;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;110;0;108;0
WireConnection;111;0;110;0
WireConnection;112;0;109;2
WireConnection;113;0;111;0
WireConnection;113;1;112;0
WireConnection;303;0;96;0
WireConnection;303;1;302;0
WireConnection;114;0;113;0
WireConnection;116;0;114;0
WireConnection;116;2;8;0
WireConnection;116;3;303;0
WireConnection;142;0;116;0
WireConnection;213;1;193;1
WireConnection;213;2;214;0
WireConnection;215;0;208;0
WireConnection;255;0;58;3
WireConnection;224;1;223;0
WireConnection;210;0;215;0
WireConnection;210;1;193;2
WireConnection;210;2;213;0
WireConnection;269;0;221;0
WireConnection;270;0;265;0
WireConnection;2;0;143;0
WireConnection;2;1;224;0
WireConnection;222;1;269;0
WireConnection;205;0;210;0
WireConnection;26;0;17;0
WireConnection;26;1;2;0
WireConnection;266;0;270;0
WireConnection;266;1;225;0
WireConnection;22;0;222;0
WireConnection;22;1;143;0
WireConnection;14;0;17;0
WireConnection;14;1;143;0
WireConnection;20;0;14;0
WireConnection;20;1;187;0
WireConnection;20;2;266;0
WireConnection;4;0;17;0
WireConnection;4;1;22;0
WireConnection;12;0;26;0
WireConnection;12;1;224;0
WireConnection;12;2;187;0
WireConnection;25;0;20;0
WireConnection;3;0;12;0
WireConnection;5;0;222;0
WireConnection;5;1;4;0
WireConnection;5;2;187;0
WireConnection;7;0;3;0
WireConnection;9;0;5;0
WireConnection;13;0;25;0
WireConnection;250;0;16;0
WireConnection;6;0;9;0
WireConnection;23;0;13;0
WireConnection;106;0;69;0
WireConnection;18;0;250;0
WireConnection;18;2;7;0
WireConnection;268;0;6;0
WireConnection;268;1;18;0
WireConnection;71;0;106;0
WireConnection;264;0;23;0
WireConnection;264;1;254;0
WireConnection;27;0;268;0
WireConnection;27;1;24;0
WireConnection;27;2;264;0
WireConnection;72;0;73;0
WireConnection;72;1;71;0
WireConnection;127;0;27;0
WireConnection;74;0;73;0
WireConnection;74;1;72;0
WireConnection;75;1;74;0
WireConnection;60;0;56;0
WireConnection;60;1;57;0
WireConnection;78;0;75;3
WireConnection;78;1;79;0
WireConnection;55;0;130;0
WireConnection;55;1;263;0
WireConnection;76;0;77;0
WireConnection;76;1;75;1
WireConnection;115;0;114;0
WireConnection;61;0;60;0
WireConnection;61;1;59;0
WireConnection;61;2;55;0
WireConnection;80;0;76;0
WireConnection;80;1;78;0
WireConnection;273;0;61;0
WireConnection;290;0;293;0
WireConnection;290;1;288;0
WireConnection;290;2;287;0
WireConnection;81;0;131;0
WireConnection;81;1;80;0
WireConnection;126;0;81;0
WireConnection;149;0;58;4
WireConnection;291;0;290;0
WireConnection;291;1;289;0
WireConnection;121;0;118;0
WireConnection;121;2;120;1
WireConnection;121;3;64;0
WireConnection;292;0;291;0
WireConnection;63;0;275;0
WireConnection;63;1;121;0
WireConnection;94;0;92;0
WireConnection;94;1;93;0
WireConnection;305;0;65;0
WireConnection;305;1;150;0
WireConnection;83;1;84;0
WireConnection;82;0;63;0
WireConnection;82;1;132;0
WireConnection;90;0;305;0
WireConnection;90;1;83;0
WireConnection;90;2;299;0
WireConnection;95;0;91;0
WireConnection;95;1;94;0
WireConnection;68;0;63;0
WireConnection;68;1;82;0
WireConnection;68;2;305;0
WireConnection;68;3;83;0
WireConnection;159;0;95;0
WireConnection;99;0;90;0
WireConnection;101;0;68;0
WireConnection;220;0;193;1
WireConnection;220;1;196;0
WireConnection;220;2;195;0
WireConnection;260;0;58;1
WireConnection;133;0;52;0
WireConnection;52;0;53;0
WireConnection;52;1;58;2
WireConnection;0;2;97;0
WireConnection;0;13;100;0
WireConnection;0;11;158;0
ASEEND*/
//CHKSM=585A0614FD87D6A541A530F1B5E28D4D0C044285