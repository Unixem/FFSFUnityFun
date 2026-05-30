// Made with Amplify Shader Editor v1.9.1.8
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "UltimateDissolveFX_Shader_With_Function"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		_TransitionControlManualAnimationMode("TransitionControl (Manual Animation Mode)", Float) = 0
		_Metallic("Metallic", Range( 0 , 2)) = 0.2
		_Smoothness("Smoothness", Range( 0 , 2)) = 0.2
		[Toggle(_COLORMAP_ON)] _ColorMap("Color / Map", Float) = 1
		[Toggle(_MAPMATCAP_ON)] _MapMatCap("Map / MatCap", Float) = 1
		[NoScaleOffset]_MainColorMap("MainColorMap", 2D) = "white" {}
		_MainColorMult("MainColorMult", Range( 0 , 24)) = 1
		_ColorPow("Color Pow", Range( 0.25 , 5)) = 1
		_Desaturation("Desaturation", Range( 0 , 1)) = 0
		[NoScaleOffset]_MainMap("MainMap", 2D) = "white" {}
		_MaskMap("MaskMap", 2D) = "white" {}
		_Tiling("Tiling", Range( 0 , 4)) = 1
		_Subdivision("Subdivision", Float) = 400
		[Toggle]_CustomTexture("Custom Pattern Shape", Float) = 0
		_Pattern("Pattern", 2D) = "white" {}
		_SizeWhenTransition("SizeWhenTransition", Range( 0 , 3)) = 1
		[Toggle(_MANUALAUTOMATIC_ON)] _ManualAutomatic("Manual / Automatic", Float) = 1
		_Transition("AnimationSpeed", Range( 0 , 1)) = 0.88
		_Exp("Transition Falloff", Range( 0 , 2)) = 1
		[Toggle(_TRANSITIONXVSY_ON)] _TransitionXvsY("Transition Axis : X vs Y", Float) = 0
		[Toggle(_INVERSEDIRECTION_ON)] _InverseDirection("InverseDirection", Float) = 0
		[Toggle(_INVERSEANIMATION1_ON)] _InverseAnimation1("InverseAnimation", Float) = 0
		[Toggle(_INVERSEANIMATION4_ON)] _InverseAnimation4("InverseAnimation", Float) = 0
		[Toggle(_INVERSEANIMATION2_ON)] _InverseAnimation2("InverseAnimation", Float) = 0
		[Toggle(_INVERSEANIMATION3_ON)] _InverseAnimation3("InverseAnimation", Float) = 0
		[Toggle(_USEMAINTEXTURE_ON)] _UseMainTexture("UseMainTexture", Float) = 0
		[HDR]_ColorTransition("ColorTransition", Color) = (1,1,1,0)
		_MainColor("MainColor", Color) = (0.1415094,0.1415094,0.1415094,0)
		_EmissiveFctor("Emissive Mult", Float) = 1
		_SharpTransition("Transition Softness", Range( 0.05 , 2)) = 0.2
		[Toggle]_DETAILES("Outlines (If Possible)", Float) = 0
		_STEP("(Outlines) Steps", Range( 0 , 10)) = 0.3
		_Distortion("Pattern Distortion", Range( 0 , 20)) = 0
		_TransitionFactor("Transition Strength ", Range( -1 , 1)) = 0
		_TilingTransition("TilingTransition", Range( 0 , 10)) = 1
		_NormalizedRotationAxis("Rotation Axis", Vector) = (0.05,0.2,1.1,0)
		_OffsetPivot("Pivot Offset (Obj Pivot Offset)", Vector) = (-16,0,0,1)
		[Toggle(_CUSTOMPIVOT_ON)] _CustomPivot("New Custom Pivot Position", Float) = 0
		_CustomPivotVec("CustomPivotVec", Vector) = (0,0,0,0)
		_Push("Vertices Push Mult", Float) = 0
		[ASEEnd]_Angle("Rotation Angle", Float) = 8
		[HideInInspector] _texcoord( "", 2D ) = "white" {}


		//_TransmissionShadow( "Transmission Shadow", Range( 0, 1 ) ) = 0.5
		//_TransStrength( "Trans Strength", Range( 0, 50 ) ) = 1
		//_TransNormal( "Trans Normal Distortion", Range( 0, 1 ) ) = 0.5
		//_TransScattering( "Trans Scattering", Range( 1, 50 ) ) = 2
		//_TransDirect( "Trans Direct", Range( 0, 1 ) ) = 0.9
		//_TransAmbient( "Trans Ambient", Range( 0, 1 ) ) = 0.1
		//_TransShadow( "Trans Shadow", Range( 0, 1 ) ) = 0.5
		//_TessPhongStrength( "Tess Phong Strength", Range( 0, 1 ) ) = 0.5
		//_TessValue( "Tess Max Tessellation", Range( 1, 32 ) ) = 16
		//_TessMin( "Tess Min Distance", Float ) = 10
		//_TessMax( "Tess Max Distance", Float ) = 25
		//_TessEdgeLength ( "Tess Edge length", Range( 2, 50 ) ) = 16
		//_TessMaxDisp( "Tess Max Displacement", Float ) = 25

		[HideInInspector][ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[HideInInspector][ToggleOff] _EnvironmentReflections("Environment Reflections", Float) = 1.0
		[HideInInspector][ToggleOff] _ReceiveShadows("Receive Shadows", Float) = 1.0

		[HideInInspector] _QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector] _QueueControl("_QueueControl", Float) = -1

        [HideInInspector][NoScaleOffset] unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
	}

	SubShader
	{
		LOD 0

		

		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Opaque" "Queue"="Geometry" "UniversalMaterialType"="Lit" }

		Cull Back
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		AlphaToMask Off

		

		HLSLINCLUDE
		#pragma target 4.5
		#pragma prefer_hlslcc gles
		// ensure rendering platforms toggle list is visible

		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Filtering.hlsl"

		#ifndef ASE_TESS_FUNCS
		#define ASE_TESS_FUNCS
		float4 FixedTess( float tessValue )
		{
			return tessValue;
		}

		float CalcDistanceTessFactor (float4 vertex, float minDist, float maxDist, float tess, float4x4 o2w, float3 cameraPos )
		{
			float3 wpos = mul(o2w,vertex).xyz;
			float dist = distance (wpos, cameraPos);
			float f = clamp(1.0 - (dist - minDist) / (maxDist - minDist), 0.01, 1.0) * tess;
			return f;
		}

		float4 CalcTriEdgeTessFactors (float3 triVertexFactors)
		{
			float4 tess;
			tess.x = 0.5 * (triVertexFactors.y + triVertexFactors.z);
			tess.y = 0.5 * (triVertexFactors.x + triVertexFactors.z);
			tess.z = 0.5 * (triVertexFactors.x + triVertexFactors.y);
			tess.w = (triVertexFactors.x + triVertexFactors.y + triVertexFactors.z) / 3.0f;
			return tess;
		}

		float CalcEdgeTessFactor (float3 wpos0, float3 wpos1, float edgeLen, float3 cameraPos, float4 scParams )
		{
			float dist = distance (0.5 * (wpos0+wpos1), cameraPos);
			float len = distance(wpos0, wpos1);
			float f = max(len * scParams.y / (edgeLen * dist), 1.0);
			return f;
		}

		float DistanceFromPlane (float3 pos, float4 plane)
		{
			float d = dot (float4(pos,1.0f), plane);
			return d;
		}

		bool WorldViewFrustumCull (float3 wpos0, float3 wpos1, float3 wpos2, float cullEps, float4 planes[6] )
		{
			float4 planeTest;
			planeTest.x = (( DistanceFromPlane(wpos0, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[0]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.y = (( DistanceFromPlane(wpos0, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[1]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.z = (( DistanceFromPlane(wpos0, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[2]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.w = (( DistanceFromPlane(wpos0, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[3]) > -cullEps) ? 1.0f : 0.0f );
			return !all (planeTest);
		}

		float4 DistanceBasedTess( float4 v0, float4 v1, float4 v2, float tess, float minDist, float maxDist, float4x4 o2w, float3 cameraPos )
		{
			float3 f;
			f.x = CalcDistanceTessFactor (v0,minDist,maxDist,tess,o2w,cameraPos);
			f.y = CalcDistanceTessFactor (v1,minDist,maxDist,tess,o2w,cameraPos);
			f.z = CalcDistanceTessFactor (v2,minDist,maxDist,tess,o2w,cameraPos);

			return CalcTriEdgeTessFactors (f);
		}

		float4 EdgeLengthBasedTess( float4 v0, float4 v1, float4 v2, float edgeLength, float4x4 o2w, float3 cameraPos, float4 scParams )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;
			tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
			tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
			tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
			tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			return tess;
		}

		float4 EdgeLengthBasedTessCull( float4 v0, float4 v1, float4 v2, float edgeLength, float maxDisplacement, float4x4 o2w, float3 cameraPos, float4 scParams, float4 planes[6] )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;

			if (WorldViewFrustumCull(pos0, pos1, pos2, maxDisplacement, planes))
			{
				tess = 0.0f;
			}
			else
			{
				tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
				tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
				tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
				tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			}
			return tess;
		}
		#endif //ASE_TESS_FUNCS
		ENDHLSL

		
		Pass
		{
			
			Name "Forward"
			Tags { "LightMode"="UniversalForward" }

			Blend One Zero, One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA

			

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma instancing_options renderinglayer
			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define ASE_ABSOLUTE_VERTEX_POS 1
			#define _EMISSION
			#define _ALPHATEST_ON 1
			#define ASE_SRP_VERSION 120112


			#pragma shader_feature_local _RECEIVE_SHADOWS_OFF
			#pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
			#pragma shader_feature_local_fragment _ENVIRONMENTREFLECTIONS_OFF

			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
			#pragma multi_compile_fragment _ _SHADOWS_SOFT
			#pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
			#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
			#pragma multi_compile_fragment _ _LIGHT_LAYERS
			#pragma multi_compile_fragment _ _LIGHT_COOKIES
			#pragma multi_compile _ _CLUSTERED_RENDERING

			#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
			#pragma multi_compile _ SHADOWS_SHADOWMASK
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON
			#pragma multi_compile_fragment _ DEBUG_DISPLAY

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_FORWARD

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(UNITY_INSTANCING_ENABLED) && defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL)
				#define ENABLE_TERRAIN_PERPIXEL_NORMAL
			#endif

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#pragma shader_feature_local _INVERSEDIRECTION_ON
			#pragma shader_feature_local _TRANSITIONXVSY_ON
			#pragma shader_feature_local _INVERSEANIMATION2_ON
			#pragma shader_feature_local _MANUALAUTOMATIC_ON
			#pragma shader_feature_local _INVERSEANIMATION4_ON
			#pragma shader_feature_local _INVERSEANIMATION1_ON
			#pragma shader_feature_local _CUSTOMPIVOT_ON
			#pragma shader_feature_local _INVERSEANIMATION3_ON
			#pragma shader_feature_local _COLORMAP_ON
			#pragma shader_feature_local _MAPMATCAP_ON
			#pragma shader_feature_local _USEMAINTEXTURE_ON


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				ASE_SV_POSITION_QUALIFIERS float4 clipPos : SV_POSITION;
				float4 clipPosV : TEXCOORD0;
				float4 lightmapUVOrVertexSH : TEXCOORD1;
				half4 fogFactorAndVertexLight : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					float4 shadowCoord : TEXCOORD6;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON)
					float2 dynamicLightmapUV : TEXCOORD7;
				#endif
				float4 ase_texcoord8 : TEXCOORD8;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _OffsetPivot;
			float4 _MainColor;
			float4 _ColorTransition;
			float3 _NormalizedRotationAxis;
			float3 _CustomPivotVec;
			float _Push;
			float _SharpTransition;
			float _STEP;
			float _Distortion;
			float _SizeWhenTransition;
			float _Subdivision;
			float _CustomTexture;
			float _DETAILES;
			float _EmissiveFctor;
			float _ColorPow;
			float _Metallic;
			float _Desaturation;
			float _Angle;
			float _Exp;
			float _Transition;
			float _TransitionControlManualAnimationMode;
			float _Tiling;
			float _TransitionFactor;
			float _TilingTransition;
			float _MainColorMult;
			float _Smoothness;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			// Property used by ScenePickingPass
			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			// Properties used by SceneSelectionPass
			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _MaskMap;
			sampler2D _MainMap;
			sampler2D _MainColorMap;
			sampler2D _Pattern;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			float MyCustomExpression147_g93( float _Time, float _Period )
			{
				// Calculate a sine wave value that oscillates between 0 and 1 over time
				float v = (sin(_Time * 2 * 3.14159 / _Period) + 1) * 0.5;
				return v ;
			}
			
			float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
			{
				original -= center;
				float C = cos( angle );
				float S = sin( angle );
				float t = 1 - C;
				float m00 = t * u.x * u.x + C;
				float m01 = t * u.x * u.y - S * u.z;
				float m02 = t * u.x * u.z + S * u.y;
				float m10 = t * u.x * u.y + S * u.z;
				float m11 = t * u.y * u.y + C;
				float m12 = t * u.y * u.z - S * u.x;
				float m20 = t * u.x * u.z - S * u.y;
				float m21 = t * u.y * u.z + S * u.x;
				float m22 = t * u.z * u.z + C;
				float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
				return mul( finalMatrix, original ) + center;
			}
			
			float2 MyCustomExpression159_g93( float3 normal )
			{
				float2 uv_matcap = normal *0.5 + float2(0.5,0.5); float2(0.5,0.5);
				return uv_matcap;
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 texCoord46_g93 = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord43_g93 = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch182_g93 = texCoord43_g93.x;
				#else
				float staticSwitch182_g93 = texCoord43_g93.y;
				#endif
				float clampResult161_g93 = clamp( ( ( tex2Dlod( _MaskMap, float4( (texCoord46_g93*_TilingTransition + 0.0), 0, 0.0) ).r * _TransitionFactor ) + staticSwitch182_g93 ) , 0.0 , 1.0 );
				float2 texCoord44_g93 = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_39_0_g93 = ( pow( tex2Dlod( _MaskMap, float4( (texCoord44_g93*_Tiling + 0.0), 0, 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_33_0_g93 = ( ( 1.0 - ( clampResult161_g93 * float3(1,1,1) ) ) + temp_output_39_0_g93 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch123_g93 = ( 1.0 - temp_output_33_0_g93 );
				#else
				float3 staticSwitch123_g93 = temp_output_33_0_g93;
				#endif
				float lerpResult150_g93 = lerp( 0.0 , 3.14 , _TransitionControlManualAnimationMode);
				float mulTime125_g93 = _TimeParameters.x * _Transition;
				float _Time147_g93 = mulTime125_g93;
				float _Period147_g93 = 2.0;
				float localMyCustomExpression147_g93 = MyCustomExpression147_g93( _Time147_g93 , _Period147_g93 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch180_g93 = localMyCustomExpression147_g93;
				#else
				float staticSwitch180_g93 = sin( lerpResult150_g93 );
				#endif
				#ifdef _INVERSEANIMATION2_ON
				float staticSwitch124_g93 = ( 1.0 - staticSwitch180_g93 );
				#else
				float staticSwitch124_g93 = staticSwitch180_g93;
				#endif
				#ifdef _INVERSEANIMATION4_ON
				float staticSwitch181_g93 = ( _Exp * 2.0 );
				#else
				float staticSwitch181_g93 = _Exp;
				#endif
				float3 temp_cast_0 = (( ( pow( staticSwitch124_g93 , staticSwitch181_g93 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult11_g93 = clamp( (( staticSwitch123_g93 - temp_cast_0 )).z , 0.0 , 1.0 );
				float temp_output_14_0_g93 = ( 1.0 - pow( clampResult11_g93 , 2.0 ) );
				float TransitionMask92_g93 = temp_output_14_0_g93;
				float lerpResult20_g93 = lerp( 0.0 , ( _Push / 100.0 ) , TransitionMask92_g93);
				#ifdef _INVERSEANIMATION1_ON
				float3 staticSwitch63_g93 = ( _NormalizedRotationAxis * -1.0 );
				#else
				float3 staticSwitch63_g93 = _NormalizedRotationAxis;
				#endif
				float MaskMap42_g93 = temp_output_39_0_g93;
				float4 transform191_g93 = mul(GetWorldToObjectMatrix(),float4( 0,0,0,1 ));
				float3 objToWorld192_g93 = mul( GetObjectToWorldMatrix(), float4( transform191_g93.xyz, 1 ) ).xyz;
				float3 clampResult174_g93 = clamp( _CustomPivotVec , float3( -1.5,-1.5,-1.5 ) , float3( 1.5,1.5,1.5 ) );
				#ifdef _CUSTOMPIVOT_ON
				float3 staticSwitch195_g93 = clampResult174_g93;
				#else
				float3 staticSwitch195_g93 = objToWorld192_g93;
				#endif
				#ifdef _INVERSEANIMATION3_ON
				float4 staticSwitch164_g93 = ( _OffsetPivot * -1.0 );
				#else
				float4 staticSwitch164_g93 = _OffsetPivot;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float3 worldToObj52_g93 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 rotatedValue23_g93 = RotateAroundAxis( ( float4( staticSwitch195_g93 , 0.0 ) + ( staticSwitch164_g93 / 100.0 ) ).xyz, worldToObj52_g93, staticSwitch63_g93, ( ( TransitionMask92_g93 * MaskMap42_g93 ) * _Angle ) );
				float3 FinalDisplacement36_g93 = ( ( v.ase_normal * lerpResult20_g93 ) + rotatedValue23_g93 );
				
				o.ase_texcoord8.xy = v.texcoord.xy;
				o.ase_normal = v.ase_normal;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord8.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = FinalDisplacement36_g93;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float3 positionVS = TransformWorldToView( positionWS );
				float4 positionCS = TransformWorldToHClip( positionWS );

				VertexNormalInputs normalInput = GetVertexNormalInputs( v.ase_normal, v.ase_tangent );

				o.tSpace0 = float4( normalInput.normalWS, positionWS.x);
				o.tSpace1 = float4( normalInput.tangentWS, positionWS.y);
				o.tSpace2 = float4( normalInput.bitangentWS, positionWS.z);

				#if defined(LIGHTMAP_ON)
					OUTPUT_LIGHTMAP_UV( v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy );
				#endif

				#if !defined(LIGHTMAP_ON)
					OUTPUT_SH( normalInput.normalWS.xyz, o.lightmapUVOrVertexSH.xyz );
				#endif

				#if defined(DYNAMICLIGHTMAP_ON)
					o.dynamicLightmapUV.xy = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					o.lightmapUVOrVertexSH.zw = v.texcoord.xy;
					o.lightmapUVOrVertexSH.xy = v.texcoord.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif

				half3 vertexLight = VertexLighting( positionWS, normalInput.normalWS );

				#ifdef ASE_FOG
					half fogFactor = ComputeFogFactor( positionCS.z );
				#else
					half fogFactor = 0;
				#endif

				o.fogFactorAndVertexLight = half4(fogFactor, vertexLight);

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = positionCS;
				o.clipPosV = positionCS;
				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_tangent = v.ase_tangent;
				o.texcoord = v.texcoord;
				o.texcoord1 = v.texcoord1;
				o.texcoord2 = v.texcoord2;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				o.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag ( VertexOutput IN
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float2 sampleCoords = (IN.lightmapUVOrVertexSH.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
					float3 WorldNormal = TransformObjectToWorldNormal(normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
					float3 WorldTangent = -cross(GetObjectToWorldMatrix()._13_23_33, WorldNormal);
					float3 WorldBiTangent = cross(WorldNormal, -WorldTangent);
				#else
					float3 WorldNormal = normalize( IN.tSpace0.xyz );
					float3 WorldTangent = IN.tSpace1.xyz;
					float3 WorldBiTangent = IN.tSpace2.xyz;
				#endif

				float3 WorldPosition = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 WorldViewDirection = _WorldSpaceCameraPos.xyz  - WorldPosition;
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				float4 ClipPos = IN.clipPosV;
				float4 ScreenPos = ComputeScreenPos( IN.clipPosV );

				float2 NormalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(IN.clipPos);

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					ShadowCoords = IN.shadowCoord;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
				#endif

				WorldViewDirection = SafeNormalize( WorldViewDirection );

				float2 uv_MainMap171_g93 = IN.ase_texcoord8.xy;
				float4 tex2DNode171_g93 = tex2D( _MainMap, uv_MainMap171_g93 );
				float3 objToViewDir129_g93 = mul( UNITY_MATRIX_IT_MV, float4( IN.ase_normal, 0 ) ).xyz;
				float3 normalizeResult128_g93 = normalize( objToViewDir129_g93 );
				float3 normal159_g93 = normalizeResult128_g93;
				float2 localMyCustomExpression159_g93 = MyCustomExpression159_g93( normal159_g93 );
				float3 desaturateInitialColor142_g93 = tex2D( _MainColorMap, localMyCustomExpression159_g93 ).rgb;
				float desaturateDot142_g93 = dot( desaturateInitialColor142_g93, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar142_g93 = lerp( desaturateInitialColor142_g93, desaturateDot142_g93.xxx, _Desaturation );
				float3 temp_cast_1 = (_ColorPow).xxx;
				#ifdef _MAPMATCAP_ON
				float4 staticSwitch144_g93 = ( float4( pow( desaturateVar142_g93 , temp_cast_1 ) , 0.0 ) * _MainColorMult * _ColorTransition );
				#else
				float4 staticSwitch144_g93 = tex2DNode171_g93;
				#endif
				#ifdef _COLORMAP_ON
				float4 staticSwitch143_g93 = _MainColor;
				#else
				float4 staticSwitch143_g93 = staticSwitch144_g93;
				#endif
				#ifdef _USEMAINTEXTURE_ON
				float4 staticSwitch167_g93 = tex2DNode171_g93;
				#else
				float4 staticSwitch167_g93 = _ColorTransition;
				#endif
				float3 break74_g93 = _WorldSpaceCameraPos;
				float3 appendResult73_g93 = (float3(( break74_g93.x * -1.0 ) , break74_g93.z , break74_g93.y));
				float3 temp_output_75_0_g93 = ( appendResult73_g93 * _Subdivision );
				float3 break67_g93 = WorldPosition;
				float3 appendResult72_g93 = (float3(( break67_g93.x * -1.0 ) , break67_g93.z , break67_g93.y));
				float3 temp_output_71_0_g93 = ( appendResult72_g93 * _Subdivision );
				float3 WP70_g93 = temp_output_71_0_g93;
				float3 temp_output_69_0_g93 = ( WP70_g93 * 1.0 );
				float3 normalizeResult84_g93 = normalize( ( temp_output_75_0_g93 - temp_output_69_0_g93 ) );
				float3 temp_output_1_0_g96 = normalizeResult84_g93;
				float3 temp_output_45_0_g96 = temp_output_75_0_g93;
				float dotResult22_g96 = dot( temp_output_1_0_g96 , temp_output_45_0_g96 );
				float3 temp_cast_3 = (0.5).xxx;
				float3 temp_output_2_0_g96 = ( ( ceil( temp_output_69_0_g93 ) / 1.0 ) - temp_cast_3 );
				float dotResult25_g96 = dot( temp_output_1_0_g96 , temp_output_2_0_g96 );
				float3 temp_output_30_0_g96 = ( WP70_g93 - temp_output_45_0_g96 );
				float dotResult28_g96 = dot( temp_output_1_0_g96 , temp_output_30_0_g96 );
				float temp_output_27_0_g96 = ( ( ( dotResult22_g96 - dotResult25_g96 ) * -1.0 ) / dotResult28_g96 );
				float3 normalizeResult27_g97 = normalize( temp_output_1_0_g96 );
				float3 normalizeResult31_g97 = normalize( float3(0,0.00015,-1) );
				float3 normalizeResult29_g97 = normalize( cross( normalizeResult27_g97 , normalizeResult31_g97 ) );
				float3 temp_output_7_0_g96 = ( normalizeResult29_g97 * float3( 1,1,1 ) );
				float3 temp_output_34_0_g96 = ( temp_output_45_0_g96 + ( temp_output_27_0_g96 * temp_output_30_0_g96 ) );
				float3 temp_output_35_0_g96 = ( temp_output_34_0_g96 - temp_output_2_0_g96 );
				float dotResult11_g96 = dot( temp_output_7_0_g96 , temp_output_35_0_g96 );
				float3 normalizeResult10_g96 = normalize( cross( temp_output_7_0_g96 , normalizeResult27_g97 ) );
				float dotResult12_g96 = dot( normalizeResult10_g96 , temp_output_35_0_g96 );
				float2 appendResult14_g96 = (float2(dotResult11_g96 , dotResult12_g96));
				float2 temp_cast_4 = (0.0).xx;
				float2 temp_cast_5 = (0.0).xx;
				float2 ifLocalVar15_g96 = 0;
				if( temp_output_27_0_g96 <= 0.0 )
				ifLocalVar15_g96 = temp_cast_5;
				else
				ifLocalVar15_g96 = appendResult14_g96;
				float2 texCoord46_g93 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord43_g93 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch182_g93 = texCoord43_g93.x;
				#else
				float staticSwitch182_g93 = texCoord43_g93.y;
				#endif
				float clampResult161_g93 = clamp( ( ( tex2D( _MaskMap, (texCoord46_g93*_TilingTransition + 0.0) ).r * _TransitionFactor ) + staticSwitch182_g93 ) , 0.0 , 1.0 );
				float2 texCoord44_g93 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_39_0_g93 = ( pow( tex2D( _MaskMap, (texCoord44_g93*_Tiling + 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_33_0_g93 = ( ( 1.0 - ( clampResult161_g93 * float3(1,1,1) ) ) + temp_output_39_0_g93 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch123_g93 = ( 1.0 - temp_output_33_0_g93 );
				#else
				float3 staticSwitch123_g93 = temp_output_33_0_g93;
				#endif
				float lerpResult150_g93 = lerp( 0.0 , 3.14 , _TransitionControlManualAnimationMode);
				float mulTime125_g93 = _TimeParameters.x * _Transition;
				float _Time147_g93 = mulTime125_g93;
				float _Period147_g93 = 2.0;
				float localMyCustomExpression147_g93 = MyCustomExpression147_g93( _Time147_g93 , _Period147_g93 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch180_g93 = localMyCustomExpression147_g93;
				#else
				float staticSwitch180_g93 = sin( lerpResult150_g93 );
				#endif
				#ifdef _INVERSEANIMATION2_ON
				float staticSwitch124_g93 = ( 1.0 - staticSwitch180_g93 );
				#else
				float staticSwitch124_g93 = staticSwitch180_g93;
				#endif
				#ifdef _INVERSEANIMATION4_ON
				float staticSwitch181_g93 = ( _Exp * 2.0 );
				#else
				float staticSwitch181_g93 = _Exp;
				#endif
				float3 temp_cast_6 = (( ( pow( staticSwitch124_g93 , staticSwitch181_g93 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult11_g93 = clamp( (( staticSwitch123_g93 - temp_cast_6 )).z , 0.0 , 1.0 );
				float temp_output_14_0_g93 = ( 1.0 - pow( clampResult11_g93 , 2.0 ) );
				float TransitionMask92_g93 = temp_output_14_0_g93;
				float MaskMap42_g93 = temp_output_39_0_g93;
				float lerpResult106_g93 = lerp( 0.0 , _Distortion , TransitionMask92_g93);
				float2 temp_output_107_0_g93 = ( ( ( ifLocalVar15_g96 / ( ( 1.0 - ( TransitionMask92_g93 * float2( 1,1 ) ) ) * _SizeWhenTransition ) ) + 0.5 ) + ( MaskMap42_g93 * lerpResult106_g93 ) );
				float2 temp_cast_7 = (0.5).xx;
				float lerpResult18_g93 = lerp( 1.0 , 0.0 , TransitionMask92_g93);
				float2 temp_output_7_0_g95 = ( ( temp_output_107_0_g93 - temp_cast_7 ) / lerpResult18_g93 );
				float2 temp_cast_8 = (0.5).xx;
				float dotResult2_g95 = dot( temp_output_7_0_g95 , temp_output_7_0_g95 );
				float lerpResult16_g93 = lerp( 1.0 , 0.1 , TransitionMask92_g93);
				float mulTime109_g93 = _TimeParameters.x * 2.0;
				float cos88_g93 = cos( ( mulTime109_g93 + TransitionMask92_g93 ) );
				float sin88_g93 = sin( ( mulTime109_g93 + TransitionMask92_g93 ) );
				float2 rotator88_g93 = mul( temp_output_107_0_g93 - float2( 0.5,0.5 ) , float2x2( cos88_g93 , -sin88_g93 , sin88_g93 , cos88_g93 )) + float2( 0.5,0.5 );
				float clampResult101_g93 = clamp( ( pow( tex2D( _Pattern, rotator88_g93 ).r , 6.0 ) + 0.1 ) , 0.0 , 1.0 );
				float clampResult97_g93 = clamp( ( clampResult101_g93 - TransitionMask92_g93 ) , 0.0 , 1.0 );
				float temp_output_86_0_g93 = ( 1.0 - (( _CustomTexture )?( ( 1.0 - clampResult97_g93 ) ):( pow( saturate( dotResult2_g95 ) , lerpResult16_g93 ) )) );
				float clampResult136_g93 = clamp( ( temp_output_86_0_g93 * _STEP ) , 0.0 , 1.0 );
				float4 temp_output_137_0_g93 = ( ( staticSwitch167_g93 * _EmissiveFctor * 1.0 ) * (( _DETAILES )?( frac( clampResult136_g93 ) ):( 1.0 )) );
				float4 lerpResult139_g93 = lerp( staticSwitch143_g93 , temp_output_137_0_g93 , pow( TransitionMask92_g93 , _SharpTransition ));
				float4 FinalColor157_g93 = lerpResult139_g93;
				
				float4 Emissive212_g93 = ( temp_output_137_0_g93 * TransitionMask92_g93 );
				
				float lerpResult91_g93 = lerp( 1.0 , temp_output_39_0_g93 , temp_output_14_0_g93);
				float lerpResult41_g93 = lerp( lerpResult91_g93 , 0.0 , TransitionMask92_g93);
				float temp_output_120_0_g93 = ( temp_output_86_0_g93 * lerpResult41_g93 );
				float FinalAlpha116_g93 = floor( ceil( temp_output_120_0_g93 ) );
				

				float3 BaseColor = FinalColor157_g93.rgb;
				float3 Normal = float3(0, 0, 1);
				float3 Emission = Emissive212_g93.rgb;
				float3 Specular = 0.5;
				float Metallic = _Metallic;
				float Smoothness = _Smoothness;
				float Occlusion = 1;
				float Alpha = FinalAlpha116_g93;
				float AlphaClipThreshold = 0.1;
				float AlphaClipThresholdShadow = 0.5;
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				float3 Transmission = 1;
				float3 Translucency = 1;

				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = IN.clipPos.z;
				#endif

				#ifdef _CLEARCOAT
					float CoatMask = 0;
					float CoatSmoothness = 0;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				InputData inputData = (InputData)0;
				inputData.positionWS = WorldPosition;
				inputData.viewDirectionWS = WorldViewDirection;

				#ifdef _NORMALMAP
						#if _NORMAL_DROPOFF_TS
							inputData.normalWS = TransformTangentToWorld(Normal, half3x3(WorldTangent, WorldBiTangent, WorldNormal));
						#elif _NORMAL_DROPOFF_OS
							inputData.normalWS = TransformObjectToWorldNormal(Normal);
						#elif _NORMAL_DROPOFF_WS
							inputData.normalWS = Normal;
						#endif
					inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
				#else
					inputData.normalWS = WorldNormal;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					inputData.shadowCoord = ShadowCoords;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					inputData.shadowCoord = TransformWorldToShadowCoord(inputData.positionWS);
				#else
					inputData.shadowCoord = float4(0, 0, 0, 0);
				#endif

				#ifdef ASE_FOG
					inputData.fogCoord = IN.fogFactorAndVertexLight.x;
				#endif
					inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float3 SH = SampleSH(inputData.normalWS.xyz);
				#else
					float3 SH = IN.lightmapUVOrVertexSH.xyz;
				#endif

				#if defined(DYNAMICLIGHTMAP_ON)
					inputData.bakedGI = SAMPLE_GI(IN.lightmapUVOrVertexSH.xy, IN.dynamicLightmapUV.xy, SH, inputData.normalWS);
				#else
					inputData.bakedGI = SAMPLE_GI(IN.lightmapUVOrVertexSH.xy, SH, inputData.normalWS);
				#endif

				#ifdef ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#endif

				inputData.normalizedScreenSpaceUV = NormalizedScreenSpaceUV;
				inputData.shadowMask = SAMPLE_SHADOWMASK(IN.lightmapUVOrVertexSH.xy);

				#if defined(DEBUG_DISPLAY)
					#if defined(DYNAMICLIGHTMAP_ON)
						inputData.dynamicLightmapUV = IN.dynamicLightmapUV.xy;
					#endif
					#if defined(LIGHTMAP_ON)
						inputData.staticLightmapUV = IN.lightmapUVOrVertexSH.xy;
					#else
						inputData.vertexSH = SH;
					#endif
				#endif

				SurfaceData surfaceData;
				surfaceData.albedo              = BaseColor;
				surfaceData.metallic            = saturate(Metallic);
				surfaceData.specular            = Specular;
				surfaceData.smoothness          = saturate(Smoothness),
				surfaceData.occlusion           = Occlusion,
				surfaceData.emission            = Emission,
				surfaceData.alpha               = saturate(Alpha);
				surfaceData.normalTS            = Normal;
				surfaceData.clearCoatMask       = 0;
				surfaceData.clearCoatSmoothness = 1;

				#ifdef _CLEARCOAT
					surfaceData.clearCoatMask       = saturate(CoatMask);
					surfaceData.clearCoatSmoothness = saturate(CoatSmoothness);
				#endif

				#ifdef _DBUFFER
					ApplyDecalToSurfaceData(IN.clipPos, surfaceData, inputData);
				#endif

				half4 color = UniversalFragmentPBR( inputData, surfaceData);

				#ifdef ASE_TRANSMISSION
				{
					float shadow = _TransmissionShadow;

					Light mainLight = GetMainLight( inputData.shadowCoord );
					float3 mainAtten = mainLight.color * mainLight.distanceAttenuation;
					mainAtten = lerp( mainAtten, mainAtten * mainLight.shadowAttenuation, shadow );
					half3 mainTransmission = max(0 , -dot(inputData.normalWS, mainLight.direction)) * mainAtten * Transmission;
					color.rgb += BaseColor * mainTransmission;

					#ifdef _ADDITIONAL_LIGHTS
						int transPixelLightCount = GetAdditionalLightsCount();
						for (int i = 0; i < transPixelLightCount; ++i)
						{
							Light light = GetAdditionalLight(i, inputData.positionWS);
							float3 atten = light.color * light.distanceAttenuation;
							atten = lerp( atten, atten * light.shadowAttenuation, shadow );

							half3 transmission = max(0 , -dot(inputData.normalWS, light.direction)) * atten * Transmission;
							color.rgb += BaseColor * transmission;
						}
					#endif
				}
				#endif

				#ifdef ASE_TRANSLUCENCY
				{
					float shadow = _TransShadow;
					float normal = _TransNormal;
					float scattering = _TransScattering;
					float direct = _TransDirect;
					float ambient = _TransAmbient;
					float strength = _TransStrength;

					Light mainLight = GetMainLight( inputData.shadowCoord );
					float3 mainAtten = mainLight.color * mainLight.distanceAttenuation;
					mainAtten = lerp( mainAtten, mainAtten * mainLight.shadowAttenuation, shadow );

					half3 mainLightDir = mainLight.direction + inputData.normalWS * normal;
					half mainVdotL = pow( saturate( dot( inputData.viewDirectionWS, -mainLightDir ) ), scattering );
					half3 mainTranslucency = mainAtten * ( mainVdotL * direct + inputData.bakedGI * ambient ) * Translucency;
					color.rgb += BaseColor * mainTranslucency * strength;

					#ifdef _ADDITIONAL_LIGHTS
						int transPixelLightCount = GetAdditionalLightsCount();
						for (int i = 0; i < transPixelLightCount; ++i)
						{
							Light light = GetAdditionalLight(i, inputData.positionWS);
							float3 atten = light.color * light.distanceAttenuation;
							atten = lerp( atten, atten * light.shadowAttenuation, shadow );

							half3 lightDir = light.direction + inputData.normalWS * normal;
							half VdotL = pow( saturate( dot( inputData.viewDirectionWS, -lightDir ) ), scattering );
							half3 translucency = atten * ( VdotL * direct + inputData.bakedGI * ambient ) * Translucency;
							color.rgb += BaseColor * translucency * strength;
						}
					#endif
				}
				#endif

				#ifdef ASE_REFRACTION
					float4 projScreenPos = ScreenPos / ScreenPos.w;
					float3 refractionOffset = ( RefractionIndex - 1.0 ) * mul( UNITY_MATRIX_V, float4( WorldNormal,0 ) ).xyz * ( 1.0 - dot( WorldNormal, WorldViewDirection ) );
					projScreenPos.xy += refractionOffset.xy;
					float3 refraction = SHADERGRAPH_SAMPLE_SCENE_COLOR( projScreenPos.xy ) * RefractionColor;
					color.rgb = lerp( refraction, color.rgb, color.a );
					color.a = 1;
				#endif

				#ifdef ASE_FINAL_COLOR_ALPHA_MULTIPLY
					color.rgb *= color.a;
				#endif

				#ifdef ASE_FOG
					#ifdef TERRAIN_SPLAT_ADDPASS
						color.rgb = MixFogColor(color.rgb, half3( 0, 0, 0 ), IN.fogFactorAndVertexLight.x );
					#else
						color.rgb = MixFog(color.rgb, IN.fogFactorAndVertexLight.x);
					#endif
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				return color;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "ShadowCaster"
			Tags { "LightMode"="ShadowCaster" }

			ZWrite On
			ZTest LEqual
			AlphaToMask Off
			ColorMask 0

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#define ASE_FOG 1
			#define ASE_ABSOLUTE_VERTEX_POS 1
			#define _EMISSION
			#define _ALPHATEST_ON 1
			#define ASE_SRP_VERSION 120112


			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW

			#define SHADERPASS SHADERPASS_SHADOWCASTER

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#pragma shader_feature_local _INVERSEDIRECTION_ON
			#pragma shader_feature_local _TRANSITIONXVSY_ON
			#pragma shader_feature_local _INVERSEANIMATION2_ON
			#pragma shader_feature_local _MANUALAUTOMATIC_ON
			#pragma shader_feature_local _INVERSEANIMATION4_ON
			#pragma shader_feature_local _INVERSEANIMATION1_ON
			#pragma shader_feature_local _CUSTOMPIVOT_ON
			#pragma shader_feature_local _INVERSEANIMATION3_ON


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				ASE_SV_POSITION_QUALIFIERS float4 clipPos : SV_POSITION;
				float4 clipPosV : TEXCOORD0;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 worldPos : TEXCOORD1;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord : TEXCOORD2;
				#endif				
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _OffsetPivot;
			float4 _MainColor;
			float4 _ColorTransition;
			float3 _NormalizedRotationAxis;
			float3 _CustomPivotVec;
			float _Push;
			float _SharpTransition;
			float _STEP;
			float _Distortion;
			float _SizeWhenTransition;
			float _Subdivision;
			float _CustomTexture;
			float _DETAILES;
			float _EmissiveFctor;
			float _ColorPow;
			float _Metallic;
			float _Desaturation;
			float _Angle;
			float _Exp;
			float _Transition;
			float _TransitionControlManualAnimationMode;
			float _Tiling;
			float _TransitionFactor;
			float _TilingTransition;
			float _MainColorMult;
			float _Smoothness;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			// Property used by ScenePickingPass
			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			// Properties used by SceneSelectionPass
			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _MaskMap;
			sampler2D _Pattern;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			float MyCustomExpression147_g93( float _Time, float _Period )
			{
				// Calculate a sine wave value that oscillates between 0 and 1 over time
				float v = (sin(_Time * 2 * 3.14159 / _Period) + 1) * 0.5;
				return v ;
			}
			
			float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
			{
				original -= center;
				float C = cos( angle );
				float S = sin( angle );
				float t = 1 - C;
				float m00 = t * u.x * u.x + C;
				float m01 = t * u.x * u.y - S * u.z;
				float m02 = t * u.x * u.z + S * u.y;
				float m10 = t * u.x * u.y + S * u.z;
				float m11 = t * u.y * u.y + C;
				float m12 = t * u.y * u.z - S * u.x;
				float m20 = t * u.x * u.z - S * u.y;
				float m21 = t * u.y * u.z + S * u.x;
				float m22 = t * u.z * u.z + C;
				float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
				return mul( finalMatrix, original ) + center;
			}
			

			float3 _LightDirection;
			float3 _LightPosition;

			VertexOutput VertexFunction( VertexInput v )
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				float2 texCoord46_g93 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord43_g93 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch182_g93 = texCoord43_g93.x;
				#else
				float staticSwitch182_g93 = texCoord43_g93.y;
				#endif
				float clampResult161_g93 = clamp( ( ( tex2Dlod( _MaskMap, float4( (texCoord46_g93*_TilingTransition + 0.0), 0, 0.0) ).r * _TransitionFactor ) + staticSwitch182_g93 ) , 0.0 , 1.0 );
				float2 texCoord44_g93 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_39_0_g93 = ( pow( tex2Dlod( _MaskMap, float4( (texCoord44_g93*_Tiling + 0.0), 0, 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_33_0_g93 = ( ( 1.0 - ( clampResult161_g93 * float3(1,1,1) ) ) + temp_output_39_0_g93 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch123_g93 = ( 1.0 - temp_output_33_0_g93 );
				#else
				float3 staticSwitch123_g93 = temp_output_33_0_g93;
				#endif
				float lerpResult150_g93 = lerp( 0.0 , 3.14 , _TransitionControlManualAnimationMode);
				float mulTime125_g93 = _TimeParameters.x * _Transition;
				float _Time147_g93 = mulTime125_g93;
				float _Period147_g93 = 2.0;
				float localMyCustomExpression147_g93 = MyCustomExpression147_g93( _Time147_g93 , _Period147_g93 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch180_g93 = localMyCustomExpression147_g93;
				#else
				float staticSwitch180_g93 = sin( lerpResult150_g93 );
				#endif
				#ifdef _INVERSEANIMATION2_ON
				float staticSwitch124_g93 = ( 1.0 - staticSwitch180_g93 );
				#else
				float staticSwitch124_g93 = staticSwitch180_g93;
				#endif
				#ifdef _INVERSEANIMATION4_ON
				float staticSwitch181_g93 = ( _Exp * 2.0 );
				#else
				float staticSwitch181_g93 = _Exp;
				#endif
				float3 temp_cast_0 = (( ( pow( staticSwitch124_g93 , staticSwitch181_g93 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult11_g93 = clamp( (( staticSwitch123_g93 - temp_cast_0 )).z , 0.0 , 1.0 );
				float temp_output_14_0_g93 = ( 1.0 - pow( clampResult11_g93 , 2.0 ) );
				float TransitionMask92_g93 = temp_output_14_0_g93;
				float lerpResult20_g93 = lerp( 0.0 , ( _Push / 100.0 ) , TransitionMask92_g93);
				#ifdef _INVERSEANIMATION1_ON
				float3 staticSwitch63_g93 = ( _NormalizedRotationAxis * -1.0 );
				#else
				float3 staticSwitch63_g93 = _NormalizedRotationAxis;
				#endif
				float MaskMap42_g93 = temp_output_39_0_g93;
				float4 transform191_g93 = mul(GetWorldToObjectMatrix(),float4( 0,0,0,1 ));
				float3 objToWorld192_g93 = mul( GetObjectToWorldMatrix(), float4( transform191_g93.xyz, 1 ) ).xyz;
				float3 clampResult174_g93 = clamp( _CustomPivotVec , float3( -1.5,-1.5,-1.5 ) , float3( 1.5,1.5,1.5 ) );
				#ifdef _CUSTOMPIVOT_ON
				float3 staticSwitch195_g93 = clampResult174_g93;
				#else
				float3 staticSwitch195_g93 = objToWorld192_g93;
				#endif
				#ifdef _INVERSEANIMATION3_ON
				float4 staticSwitch164_g93 = ( _OffsetPivot * -1.0 );
				#else
				float4 staticSwitch164_g93 = _OffsetPivot;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float3 worldToObj52_g93 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 rotatedValue23_g93 = RotateAroundAxis( ( float4( staticSwitch195_g93 , 0.0 ) + ( staticSwitch164_g93 / 100.0 ) ).xyz, worldToObj52_g93, staticSwitch63_g93, ( ( TransitionMask92_g93 * MaskMap42_g93 ) * _Angle ) );
				float3 FinalDisplacement36_g93 = ( ( v.ase_normal * lerpResult20_g93 ) + rotatedValue23_g93 );
				
				o.ase_texcoord3.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord3.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = FinalDisplacement36_g93;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.worldPos = positionWS;
				#endif

				float3 normalWS = TransformObjectToWorldDir(v.ase_normal);

				#if _CASTING_PUNCTUAL_LIGHT_SHADOW
					float3 lightDirectionWS = normalize(_LightPosition - positionWS);
				#else
					float3 lightDirectionWS = _LightDirection;
				#endif

				float4 clipPos = TransformWorldToHClip(ApplyShadowBias(positionWS, normalWS, lightDirectionWS));

				#if UNITY_REVERSED_Z
					clipPos.z = min(clipPos.z, UNITY_NEAR_CLIP_VALUE);
				#else
					clipPos.z = max(clipPos.z, UNITY_NEAR_CLIP_VALUE);
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = clipPos;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = clipPos;
				o.clipPosV = clipPos;
				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(	VertexOutput IN
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 WorldPosition = IN.worldPos;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );
				float4 ClipPos = IN.clipPosV;
				float4 ScreenPos = ComputeScreenPos( IN.clipPosV );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float3 break74_g93 = _WorldSpaceCameraPos;
				float3 appendResult73_g93 = (float3(( break74_g93.x * -1.0 ) , break74_g93.z , break74_g93.y));
				float3 temp_output_75_0_g93 = ( appendResult73_g93 * _Subdivision );
				float3 break67_g93 = WorldPosition;
				float3 appendResult72_g93 = (float3(( break67_g93.x * -1.0 ) , break67_g93.z , break67_g93.y));
				float3 temp_output_71_0_g93 = ( appendResult72_g93 * _Subdivision );
				float3 WP70_g93 = temp_output_71_0_g93;
				float3 temp_output_69_0_g93 = ( WP70_g93 * 1.0 );
				float3 normalizeResult84_g93 = normalize( ( temp_output_75_0_g93 - temp_output_69_0_g93 ) );
				float3 temp_output_1_0_g96 = normalizeResult84_g93;
				float3 temp_output_45_0_g96 = temp_output_75_0_g93;
				float dotResult22_g96 = dot( temp_output_1_0_g96 , temp_output_45_0_g96 );
				float3 temp_cast_0 = (0.5).xxx;
				float3 temp_output_2_0_g96 = ( ( ceil( temp_output_69_0_g93 ) / 1.0 ) - temp_cast_0 );
				float dotResult25_g96 = dot( temp_output_1_0_g96 , temp_output_2_0_g96 );
				float3 temp_output_30_0_g96 = ( WP70_g93 - temp_output_45_0_g96 );
				float dotResult28_g96 = dot( temp_output_1_0_g96 , temp_output_30_0_g96 );
				float temp_output_27_0_g96 = ( ( ( dotResult22_g96 - dotResult25_g96 ) * -1.0 ) / dotResult28_g96 );
				float3 normalizeResult27_g97 = normalize( temp_output_1_0_g96 );
				float3 normalizeResult31_g97 = normalize( float3(0,0.00015,-1) );
				float3 normalizeResult29_g97 = normalize( cross( normalizeResult27_g97 , normalizeResult31_g97 ) );
				float3 temp_output_7_0_g96 = ( normalizeResult29_g97 * float3( 1,1,1 ) );
				float3 temp_output_34_0_g96 = ( temp_output_45_0_g96 + ( temp_output_27_0_g96 * temp_output_30_0_g96 ) );
				float3 temp_output_35_0_g96 = ( temp_output_34_0_g96 - temp_output_2_0_g96 );
				float dotResult11_g96 = dot( temp_output_7_0_g96 , temp_output_35_0_g96 );
				float3 normalizeResult10_g96 = normalize( cross( temp_output_7_0_g96 , normalizeResult27_g97 ) );
				float dotResult12_g96 = dot( normalizeResult10_g96 , temp_output_35_0_g96 );
				float2 appendResult14_g96 = (float2(dotResult11_g96 , dotResult12_g96));
				float2 temp_cast_1 = (0.0).xx;
				float2 temp_cast_2 = (0.0).xx;
				float2 ifLocalVar15_g96 = 0;
				if( temp_output_27_0_g96 <= 0.0 )
				ifLocalVar15_g96 = temp_cast_2;
				else
				ifLocalVar15_g96 = appendResult14_g96;
				float2 texCoord46_g93 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord43_g93 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch182_g93 = texCoord43_g93.x;
				#else
				float staticSwitch182_g93 = texCoord43_g93.y;
				#endif
				float clampResult161_g93 = clamp( ( ( tex2D( _MaskMap, (texCoord46_g93*_TilingTransition + 0.0) ).r * _TransitionFactor ) + staticSwitch182_g93 ) , 0.0 , 1.0 );
				float2 texCoord44_g93 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_39_0_g93 = ( pow( tex2D( _MaskMap, (texCoord44_g93*_Tiling + 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_33_0_g93 = ( ( 1.0 - ( clampResult161_g93 * float3(1,1,1) ) ) + temp_output_39_0_g93 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch123_g93 = ( 1.0 - temp_output_33_0_g93 );
				#else
				float3 staticSwitch123_g93 = temp_output_33_0_g93;
				#endif
				float lerpResult150_g93 = lerp( 0.0 , 3.14 , _TransitionControlManualAnimationMode);
				float mulTime125_g93 = _TimeParameters.x * _Transition;
				float _Time147_g93 = mulTime125_g93;
				float _Period147_g93 = 2.0;
				float localMyCustomExpression147_g93 = MyCustomExpression147_g93( _Time147_g93 , _Period147_g93 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch180_g93 = localMyCustomExpression147_g93;
				#else
				float staticSwitch180_g93 = sin( lerpResult150_g93 );
				#endif
				#ifdef _INVERSEANIMATION2_ON
				float staticSwitch124_g93 = ( 1.0 - staticSwitch180_g93 );
				#else
				float staticSwitch124_g93 = staticSwitch180_g93;
				#endif
				#ifdef _INVERSEANIMATION4_ON
				float staticSwitch181_g93 = ( _Exp * 2.0 );
				#else
				float staticSwitch181_g93 = _Exp;
				#endif
				float3 temp_cast_3 = (( ( pow( staticSwitch124_g93 , staticSwitch181_g93 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult11_g93 = clamp( (( staticSwitch123_g93 - temp_cast_3 )).z , 0.0 , 1.0 );
				float temp_output_14_0_g93 = ( 1.0 - pow( clampResult11_g93 , 2.0 ) );
				float TransitionMask92_g93 = temp_output_14_0_g93;
				float MaskMap42_g93 = temp_output_39_0_g93;
				float lerpResult106_g93 = lerp( 0.0 , _Distortion , TransitionMask92_g93);
				float2 temp_output_107_0_g93 = ( ( ( ifLocalVar15_g96 / ( ( 1.0 - ( TransitionMask92_g93 * float2( 1,1 ) ) ) * _SizeWhenTransition ) ) + 0.5 ) + ( MaskMap42_g93 * lerpResult106_g93 ) );
				float2 temp_cast_4 = (0.5).xx;
				float lerpResult18_g93 = lerp( 1.0 , 0.0 , TransitionMask92_g93);
				float2 temp_output_7_0_g95 = ( ( temp_output_107_0_g93 - temp_cast_4 ) / lerpResult18_g93 );
				float2 temp_cast_5 = (0.5).xx;
				float dotResult2_g95 = dot( temp_output_7_0_g95 , temp_output_7_0_g95 );
				float lerpResult16_g93 = lerp( 1.0 , 0.1 , TransitionMask92_g93);
				float mulTime109_g93 = _TimeParameters.x * 2.0;
				float cos88_g93 = cos( ( mulTime109_g93 + TransitionMask92_g93 ) );
				float sin88_g93 = sin( ( mulTime109_g93 + TransitionMask92_g93 ) );
				float2 rotator88_g93 = mul( temp_output_107_0_g93 - float2( 0.5,0.5 ) , float2x2( cos88_g93 , -sin88_g93 , sin88_g93 , cos88_g93 )) + float2( 0.5,0.5 );
				float clampResult101_g93 = clamp( ( pow( tex2D( _Pattern, rotator88_g93 ).r , 6.0 ) + 0.1 ) , 0.0 , 1.0 );
				float clampResult97_g93 = clamp( ( clampResult101_g93 - TransitionMask92_g93 ) , 0.0 , 1.0 );
				float temp_output_86_0_g93 = ( 1.0 - (( _CustomTexture )?( ( 1.0 - clampResult97_g93 ) ):( pow( saturate( dotResult2_g95 ) , lerpResult16_g93 ) )) );
				float lerpResult91_g93 = lerp( 1.0 , temp_output_39_0_g93 , temp_output_14_0_g93);
				float lerpResult41_g93 = lerp( lerpResult91_g93 , 0.0 , TransitionMask92_g93);
				float temp_output_120_0_g93 = ( temp_output_86_0_g93 * lerpResult41_g93 );
				float FinalAlpha116_g93 = floor( ceil( temp_output_120_0_g93 ) );
				

				float Alpha = FinalAlpha116_g93;
				float AlphaClipThreshold = 0.1;
				float AlphaClipThresholdShadow = 0.5;

				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = IN.clipPos.z;
				#endif

				#ifdef _ALPHATEST_ON
					#ifdef _ALPHATEST_SHADOW_ON
						clip(Alpha - AlphaClipThresholdShadow);
					#else
						clip(Alpha - AlphaClipThreshold);
					#endif
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				return 0;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthOnly"
			Tags { "LightMode"="DepthOnly" }

			ZWrite On
			ColorMask 0
			AlphaToMask Off

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#define ASE_FOG 1
			#define ASE_ABSOLUTE_VERTEX_POS 1
			#define _EMISSION
			#define _ALPHATEST_ON 1
			#define ASE_SRP_VERSION 120112


			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#pragma shader_feature_local _INVERSEDIRECTION_ON
			#pragma shader_feature_local _TRANSITIONXVSY_ON
			#pragma shader_feature_local _INVERSEANIMATION2_ON
			#pragma shader_feature_local _MANUALAUTOMATIC_ON
			#pragma shader_feature_local _INVERSEANIMATION4_ON
			#pragma shader_feature_local _INVERSEANIMATION1_ON
			#pragma shader_feature_local _CUSTOMPIVOT_ON
			#pragma shader_feature_local _INVERSEANIMATION3_ON


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				ASE_SV_POSITION_QUALIFIERS float4 clipPos : SV_POSITION;
				float4 clipPosV : TEXCOORD0;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD1;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD2;
				#endif
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _OffsetPivot;
			float4 _MainColor;
			float4 _ColorTransition;
			float3 _NormalizedRotationAxis;
			float3 _CustomPivotVec;
			float _Push;
			float _SharpTransition;
			float _STEP;
			float _Distortion;
			float _SizeWhenTransition;
			float _Subdivision;
			float _CustomTexture;
			float _DETAILES;
			float _EmissiveFctor;
			float _ColorPow;
			float _Metallic;
			float _Desaturation;
			float _Angle;
			float _Exp;
			float _Transition;
			float _TransitionControlManualAnimationMode;
			float _Tiling;
			float _TransitionFactor;
			float _TilingTransition;
			float _MainColorMult;
			float _Smoothness;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			// Property used by ScenePickingPass
			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			// Properties used by SceneSelectionPass
			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _MaskMap;
			sampler2D _Pattern;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			float MyCustomExpression147_g93( float _Time, float _Period )
			{
				// Calculate a sine wave value that oscillates between 0 and 1 over time
				float v = (sin(_Time * 2 * 3.14159 / _Period) + 1) * 0.5;
				return v ;
			}
			
			float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
			{
				original -= center;
				float C = cos( angle );
				float S = sin( angle );
				float t = 1 - C;
				float m00 = t * u.x * u.x + C;
				float m01 = t * u.x * u.y - S * u.z;
				float m02 = t * u.x * u.z + S * u.y;
				float m10 = t * u.x * u.y + S * u.z;
				float m11 = t * u.y * u.y + C;
				float m12 = t * u.y * u.z - S * u.x;
				float m20 = t * u.x * u.z - S * u.y;
				float m21 = t * u.y * u.z + S * u.x;
				float m22 = t * u.z * u.z + C;
				float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
				return mul( finalMatrix, original ) + center;
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 texCoord46_g93 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord43_g93 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch182_g93 = texCoord43_g93.x;
				#else
				float staticSwitch182_g93 = texCoord43_g93.y;
				#endif
				float clampResult161_g93 = clamp( ( ( tex2Dlod( _MaskMap, float4( (texCoord46_g93*_TilingTransition + 0.0), 0, 0.0) ).r * _TransitionFactor ) + staticSwitch182_g93 ) , 0.0 , 1.0 );
				float2 texCoord44_g93 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_39_0_g93 = ( pow( tex2Dlod( _MaskMap, float4( (texCoord44_g93*_Tiling + 0.0), 0, 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_33_0_g93 = ( ( 1.0 - ( clampResult161_g93 * float3(1,1,1) ) ) + temp_output_39_0_g93 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch123_g93 = ( 1.0 - temp_output_33_0_g93 );
				#else
				float3 staticSwitch123_g93 = temp_output_33_0_g93;
				#endif
				float lerpResult150_g93 = lerp( 0.0 , 3.14 , _TransitionControlManualAnimationMode);
				float mulTime125_g93 = _TimeParameters.x * _Transition;
				float _Time147_g93 = mulTime125_g93;
				float _Period147_g93 = 2.0;
				float localMyCustomExpression147_g93 = MyCustomExpression147_g93( _Time147_g93 , _Period147_g93 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch180_g93 = localMyCustomExpression147_g93;
				#else
				float staticSwitch180_g93 = sin( lerpResult150_g93 );
				#endif
				#ifdef _INVERSEANIMATION2_ON
				float staticSwitch124_g93 = ( 1.0 - staticSwitch180_g93 );
				#else
				float staticSwitch124_g93 = staticSwitch180_g93;
				#endif
				#ifdef _INVERSEANIMATION4_ON
				float staticSwitch181_g93 = ( _Exp * 2.0 );
				#else
				float staticSwitch181_g93 = _Exp;
				#endif
				float3 temp_cast_0 = (( ( pow( staticSwitch124_g93 , staticSwitch181_g93 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult11_g93 = clamp( (( staticSwitch123_g93 - temp_cast_0 )).z , 0.0 , 1.0 );
				float temp_output_14_0_g93 = ( 1.0 - pow( clampResult11_g93 , 2.0 ) );
				float TransitionMask92_g93 = temp_output_14_0_g93;
				float lerpResult20_g93 = lerp( 0.0 , ( _Push / 100.0 ) , TransitionMask92_g93);
				#ifdef _INVERSEANIMATION1_ON
				float3 staticSwitch63_g93 = ( _NormalizedRotationAxis * -1.0 );
				#else
				float3 staticSwitch63_g93 = _NormalizedRotationAxis;
				#endif
				float MaskMap42_g93 = temp_output_39_0_g93;
				float4 transform191_g93 = mul(GetWorldToObjectMatrix(),float4( 0,0,0,1 ));
				float3 objToWorld192_g93 = mul( GetObjectToWorldMatrix(), float4( transform191_g93.xyz, 1 ) ).xyz;
				float3 clampResult174_g93 = clamp( _CustomPivotVec , float3( -1.5,-1.5,-1.5 ) , float3( 1.5,1.5,1.5 ) );
				#ifdef _CUSTOMPIVOT_ON
				float3 staticSwitch195_g93 = clampResult174_g93;
				#else
				float3 staticSwitch195_g93 = objToWorld192_g93;
				#endif
				#ifdef _INVERSEANIMATION3_ON
				float4 staticSwitch164_g93 = ( _OffsetPivot * -1.0 );
				#else
				float4 staticSwitch164_g93 = _OffsetPivot;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float3 worldToObj52_g93 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 rotatedValue23_g93 = RotateAroundAxis( ( float4( staticSwitch195_g93 , 0.0 ) + ( staticSwitch164_g93 / 100.0 ) ).xyz, worldToObj52_g93, staticSwitch63_g93, ( ( TransitionMask92_g93 * MaskMap42_g93 ) * _Angle ) );
				float3 FinalDisplacement36_g93 = ( ( v.ase_normal * lerpResult20_g93 ) + rotatedValue23_g93 );
				
				o.ase_texcoord3.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord3.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = FinalDisplacement36_g93;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;
				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.worldPos = positionWS;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = positionCS;
				o.clipPosV = positionCS;
				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(	VertexOutput IN
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );
				float4 ClipPos = IN.clipPosV;
				float4 ScreenPos = ComputeScreenPos( IN.clipPosV );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float3 break74_g93 = _WorldSpaceCameraPos;
				float3 appendResult73_g93 = (float3(( break74_g93.x * -1.0 ) , break74_g93.z , break74_g93.y));
				float3 temp_output_75_0_g93 = ( appendResult73_g93 * _Subdivision );
				float3 break67_g93 = WorldPosition;
				float3 appendResult72_g93 = (float3(( break67_g93.x * -1.0 ) , break67_g93.z , break67_g93.y));
				float3 temp_output_71_0_g93 = ( appendResult72_g93 * _Subdivision );
				float3 WP70_g93 = temp_output_71_0_g93;
				float3 temp_output_69_0_g93 = ( WP70_g93 * 1.0 );
				float3 normalizeResult84_g93 = normalize( ( temp_output_75_0_g93 - temp_output_69_0_g93 ) );
				float3 temp_output_1_0_g96 = normalizeResult84_g93;
				float3 temp_output_45_0_g96 = temp_output_75_0_g93;
				float dotResult22_g96 = dot( temp_output_1_0_g96 , temp_output_45_0_g96 );
				float3 temp_cast_0 = (0.5).xxx;
				float3 temp_output_2_0_g96 = ( ( ceil( temp_output_69_0_g93 ) / 1.0 ) - temp_cast_0 );
				float dotResult25_g96 = dot( temp_output_1_0_g96 , temp_output_2_0_g96 );
				float3 temp_output_30_0_g96 = ( WP70_g93 - temp_output_45_0_g96 );
				float dotResult28_g96 = dot( temp_output_1_0_g96 , temp_output_30_0_g96 );
				float temp_output_27_0_g96 = ( ( ( dotResult22_g96 - dotResult25_g96 ) * -1.0 ) / dotResult28_g96 );
				float3 normalizeResult27_g97 = normalize( temp_output_1_0_g96 );
				float3 normalizeResult31_g97 = normalize( float3(0,0.00015,-1) );
				float3 normalizeResult29_g97 = normalize( cross( normalizeResult27_g97 , normalizeResult31_g97 ) );
				float3 temp_output_7_0_g96 = ( normalizeResult29_g97 * float3( 1,1,1 ) );
				float3 temp_output_34_0_g96 = ( temp_output_45_0_g96 + ( temp_output_27_0_g96 * temp_output_30_0_g96 ) );
				float3 temp_output_35_0_g96 = ( temp_output_34_0_g96 - temp_output_2_0_g96 );
				float dotResult11_g96 = dot( temp_output_7_0_g96 , temp_output_35_0_g96 );
				float3 normalizeResult10_g96 = normalize( cross( temp_output_7_0_g96 , normalizeResult27_g97 ) );
				float dotResult12_g96 = dot( normalizeResult10_g96 , temp_output_35_0_g96 );
				float2 appendResult14_g96 = (float2(dotResult11_g96 , dotResult12_g96));
				float2 temp_cast_1 = (0.0).xx;
				float2 temp_cast_2 = (0.0).xx;
				float2 ifLocalVar15_g96 = 0;
				if( temp_output_27_0_g96 <= 0.0 )
				ifLocalVar15_g96 = temp_cast_2;
				else
				ifLocalVar15_g96 = appendResult14_g96;
				float2 texCoord46_g93 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord43_g93 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch182_g93 = texCoord43_g93.x;
				#else
				float staticSwitch182_g93 = texCoord43_g93.y;
				#endif
				float clampResult161_g93 = clamp( ( ( tex2D( _MaskMap, (texCoord46_g93*_TilingTransition + 0.0) ).r * _TransitionFactor ) + staticSwitch182_g93 ) , 0.0 , 1.0 );
				float2 texCoord44_g93 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_39_0_g93 = ( pow( tex2D( _MaskMap, (texCoord44_g93*_Tiling + 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_33_0_g93 = ( ( 1.0 - ( clampResult161_g93 * float3(1,1,1) ) ) + temp_output_39_0_g93 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch123_g93 = ( 1.0 - temp_output_33_0_g93 );
				#else
				float3 staticSwitch123_g93 = temp_output_33_0_g93;
				#endif
				float lerpResult150_g93 = lerp( 0.0 , 3.14 , _TransitionControlManualAnimationMode);
				float mulTime125_g93 = _TimeParameters.x * _Transition;
				float _Time147_g93 = mulTime125_g93;
				float _Period147_g93 = 2.0;
				float localMyCustomExpression147_g93 = MyCustomExpression147_g93( _Time147_g93 , _Period147_g93 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch180_g93 = localMyCustomExpression147_g93;
				#else
				float staticSwitch180_g93 = sin( lerpResult150_g93 );
				#endif
				#ifdef _INVERSEANIMATION2_ON
				float staticSwitch124_g93 = ( 1.0 - staticSwitch180_g93 );
				#else
				float staticSwitch124_g93 = staticSwitch180_g93;
				#endif
				#ifdef _INVERSEANIMATION4_ON
				float staticSwitch181_g93 = ( _Exp * 2.0 );
				#else
				float staticSwitch181_g93 = _Exp;
				#endif
				float3 temp_cast_3 = (( ( pow( staticSwitch124_g93 , staticSwitch181_g93 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult11_g93 = clamp( (( staticSwitch123_g93 - temp_cast_3 )).z , 0.0 , 1.0 );
				float temp_output_14_0_g93 = ( 1.0 - pow( clampResult11_g93 , 2.0 ) );
				float TransitionMask92_g93 = temp_output_14_0_g93;
				float MaskMap42_g93 = temp_output_39_0_g93;
				float lerpResult106_g93 = lerp( 0.0 , _Distortion , TransitionMask92_g93);
				float2 temp_output_107_0_g93 = ( ( ( ifLocalVar15_g96 / ( ( 1.0 - ( TransitionMask92_g93 * float2( 1,1 ) ) ) * _SizeWhenTransition ) ) + 0.5 ) + ( MaskMap42_g93 * lerpResult106_g93 ) );
				float2 temp_cast_4 = (0.5).xx;
				float lerpResult18_g93 = lerp( 1.0 , 0.0 , TransitionMask92_g93);
				float2 temp_output_7_0_g95 = ( ( temp_output_107_0_g93 - temp_cast_4 ) / lerpResult18_g93 );
				float2 temp_cast_5 = (0.5).xx;
				float dotResult2_g95 = dot( temp_output_7_0_g95 , temp_output_7_0_g95 );
				float lerpResult16_g93 = lerp( 1.0 , 0.1 , TransitionMask92_g93);
				float mulTime109_g93 = _TimeParameters.x * 2.0;
				float cos88_g93 = cos( ( mulTime109_g93 + TransitionMask92_g93 ) );
				float sin88_g93 = sin( ( mulTime109_g93 + TransitionMask92_g93 ) );
				float2 rotator88_g93 = mul( temp_output_107_0_g93 - float2( 0.5,0.5 ) , float2x2( cos88_g93 , -sin88_g93 , sin88_g93 , cos88_g93 )) + float2( 0.5,0.5 );
				float clampResult101_g93 = clamp( ( pow( tex2D( _Pattern, rotator88_g93 ).r , 6.0 ) + 0.1 ) , 0.0 , 1.0 );
				float clampResult97_g93 = clamp( ( clampResult101_g93 - TransitionMask92_g93 ) , 0.0 , 1.0 );
				float temp_output_86_0_g93 = ( 1.0 - (( _CustomTexture )?( ( 1.0 - clampResult97_g93 ) ):( pow( saturate( dotResult2_g95 ) , lerpResult16_g93 ) )) );
				float lerpResult91_g93 = lerp( 1.0 , temp_output_39_0_g93 , temp_output_14_0_g93);
				float lerpResult41_g93 = lerp( lerpResult91_g93 , 0.0 , TransitionMask92_g93);
				float temp_output_120_0_g93 = ( temp_output_86_0_g93 * lerpResult41_g93 );
				float FinalAlpha116_g93 = floor( ceil( temp_output_120_0_g93 ) );
				

				float Alpha = FinalAlpha116_g93;
				float AlphaClipThreshold = 0.1;
				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = IN.clipPos.z;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				return 0;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Meta"
			Tags { "LightMode"="Meta" }

			Cull Off

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#define ASE_ABSOLUTE_VERTEX_POS 1
			#define _EMISSION
			#define _ALPHATEST_ON 1
			#define ASE_SRP_VERSION 120112


			#pragma vertex vert
			#pragma fragment frag

			#pragma shader_feature EDITOR_VISUALIZATION

			#define SHADERPASS SHADERPASS_META

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#pragma shader_feature_local _INVERSEDIRECTION_ON
			#pragma shader_feature_local _TRANSITIONXVSY_ON
			#pragma shader_feature_local _INVERSEANIMATION2_ON
			#pragma shader_feature_local _MANUALAUTOMATIC_ON
			#pragma shader_feature_local _INVERSEANIMATION4_ON
			#pragma shader_feature_local _INVERSEANIMATION1_ON
			#pragma shader_feature_local _CUSTOMPIVOT_ON
			#pragma shader_feature_local _INVERSEANIMATION3_ON
			#pragma shader_feature_local _COLORMAP_ON
			#pragma shader_feature_local _MAPMATCAP_ON
			#pragma shader_feature_local _USEMAINTEXTURE_ON


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 texcoord0 : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord : TEXCOORD1;
				#endif
				#ifdef EDITOR_VISUALIZATION
					float4 VizUV : TEXCOORD2;
					float4 LightCoord : TEXCOORD3;
				#endif
				float4 ase_texcoord4 : TEXCOORD4;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _OffsetPivot;
			float4 _MainColor;
			float4 _ColorTransition;
			float3 _NormalizedRotationAxis;
			float3 _CustomPivotVec;
			float _Push;
			float _SharpTransition;
			float _STEP;
			float _Distortion;
			float _SizeWhenTransition;
			float _Subdivision;
			float _CustomTexture;
			float _DETAILES;
			float _EmissiveFctor;
			float _ColorPow;
			float _Metallic;
			float _Desaturation;
			float _Angle;
			float _Exp;
			float _Transition;
			float _TransitionControlManualAnimationMode;
			float _Tiling;
			float _TransitionFactor;
			float _TilingTransition;
			float _MainColorMult;
			float _Smoothness;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			// Property used by ScenePickingPass
			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			// Properties used by SceneSelectionPass
			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _MaskMap;
			sampler2D _MainMap;
			sampler2D _MainColorMap;
			sampler2D _Pattern;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			float MyCustomExpression147_g93( float _Time, float _Period )
			{
				// Calculate a sine wave value that oscillates between 0 and 1 over time
				float v = (sin(_Time * 2 * 3.14159 / _Period) + 1) * 0.5;
				return v ;
			}
			
			float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
			{
				original -= center;
				float C = cos( angle );
				float S = sin( angle );
				float t = 1 - C;
				float m00 = t * u.x * u.x + C;
				float m01 = t * u.x * u.y - S * u.z;
				float m02 = t * u.x * u.z + S * u.y;
				float m10 = t * u.x * u.y + S * u.z;
				float m11 = t * u.y * u.y + C;
				float m12 = t * u.y * u.z - S * u.x;
				float m20 = t * u.x * u.z - S * u.y;
				float m21 = t * u.y * u.z + S * u.x;
				float m22 = t * u.z * u.z + C;
				float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
				return mul( finalMatrix, original ) + center;
			}
			
			float2 MyCustomExpression159_g93( float3 normal )
			{
				float2 uv_matcap = normal *0.5 + float2(0.5,0.5); float2(0.5,0.5);
				return uv_matcap;
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 texCoord46_g93 = v.texcoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord43_g93 = v.texcoord0.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch182_g93 = texCoord43_g93.x;
				#else
				float staticSwitch182_g93 = texCoord43_g93.y;
				#endif
				float clampResult161_g93 = clamp( ( ( tex2Dlod( _MaskMap, float4( (texCoord46_g93*_TilingTransition + 0.0), 0, 0.0) ).r * _TransitionFactor ) + staticSwitch182_g93 ) , 0.0 , 1.0 );
				float2 texCoord44_g93 = v.texcoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_39_0_g93 = ( pow( tex2Dlod( _MaskMap, float4( (texCoord44_g93*_Tiling + 0.0), 0, 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_33_0_g93 = ( ( 1.0 - ( clampResult161_g93 * float3(1,1,1) ) ) + temp_output_39_0_g93 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch123_g93 = ( 1.0 - temp_output_33_0_g93 );
				#else
				float3 staticSwitch123_g93 = temp_output_33_0_g93;
				#endif
				float lerpResult150_g93 = lerp( 0.0 , 3.14 , _TransitionControlManualAnimationMode);
				float mulTime125_g93 = _TimeParameters.x * _Transition;
				float _Time147_g93 = mulTime125_g93;
				float _Period147_g93 = 2.0;
				float localMyCustomExpression147_g93 = MyCustomExpression147_g93( _Time147_g93 , _Period147_g93 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch180_g93 = localMyCustomExpression147_g93;
				#else
				float staticSwitch180_g93 = sin( lerpResult150_g93 );
				#endif
				#ifdef _INVERSEANIMATION2_ON
				float staticSwitch124_g93 = ( 1.0 - staticSwitch180_g93 );
				#else
				float staticSwitch124_g93 = staticSwitch180_g93;
				#endif
				#ifdef _INVERSEANIMATION4_ON
				float staticSwitch181_g93 = ( _Exp * 2.0 );
				#else
				float staticSwitch181_g93 = _Exp;
				#endif
				float3 temp_cast_0 = (( ( pow( staticSwitch124_g93 , staticSwitch181_g93 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult11_g93 = clamp( (( staticSwitch123_g93 - temp_cast_0 )).z , 0.0 , 1.0 );
				float temp_output_14_0_g93 = ( 1.0 - pow( clampResult11_g93 , 2.0 ) );
				float TransitionMask92_g93 = temp_output_14_0_g93;
				float lerpResult20_g93 = lerp( 0.0 , ( _Push / 100.0 ) , TransitionMask92_g93);
				#ifdef _INVERSEANIMATION1_ON
				float3 staticSwitch63_g93 = ( _NormalizedRotationAxis * -1.0 );
				#else
				float3 staticSwitch63_g93 = _NormalizedRotationAxis;
				#endif
				float MaskMap42_g93 = temp_output_39_0_g93;
				float4 transform191_g93 = mul(GetWorldToObjectMatrix(),float4( 0,0,0,1 ));
				float3 objToWorld192_g93 = mul( GetObjectToWorldMatrix(), float4( transform191_g93.xyz, 1 ) ).xyz;
				float3 clampResult174_g93 = clamp( _CustomPivotVec , float3( -1.5,-1.5,-1.5 ) , float3( 1.5,1.5,1.5 ) );
				#ifdef _CUSTOMPIVOT_ON
				float3 staticSwitch195_g93 = clampResult174_g93;
				#else
				float3 staticSwitch195_g93 = objToWorld192_g93;
				#endif
				#ifdef _INVERSEANIMATION3_ON
				float4 staticSwitch164_g93 = ( _OffsetPivot * -1.0 );
				#else
				float4 staticSwitch164_g93 = _OffsetPivot;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float3 worldToObj52_g93 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 rotatedValue23_g93 = RotateAroundAxis( ( float4( staticSwitch195_g93 , 0.0 ) + ( staticSwitch164_g93 / 100.0 ) ).xyz, worldToObj52_g93, staticSwitch63_g93, ( ( TransitionMask92_g93 * MaskMap42_g93 ) * _Angle ) );
				float3 FinalDisplacement36_g93 = ( ( v.ase_normal * lerpResult20_g93 ) + rotatedValue23_g93 );
				
				o.ase_texcoord4.xy = v.texcoord0.xy;
				o.ase_normal = v.ase_normal;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord4.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = FinalDisplacement36_g93;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.worldPos = positionWS;
				#endif

				o.clipPos = MetaVertexPosition( v.vertex, v.texcoord1.xy, v.texcoord1.xy, unity_LightmapST, unity_DynamicLightmapST );

				#ifdef EDITOR_VISUALIZATION
					float2 VizUV = 0;
					float4 LightCoord = 0;
					UnityEditorVizData(v.vertex.xyz, v.texcoord0.xy, v.texcoord1.xy, v.texcoord2.xy, VizUV, LightCoord);
					o.VizUV = float4(VizUV, 0, 0);
					o.LightCoord = LightCoord;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = o.clipPos;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 texcoord0 : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.texcoord0 = v.texcoord0;
				o.texcoord1 = v.texcoord1;
				o.texcoord2 = v.texcoord2;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.texcoord0 = patch[0].texcoord0 * bary.x + patch[1].texcoord0 * bary.y + patch[2].texcoord0 * bary.z;
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 WorldPosition = IN.worldPos;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float2 uv_MainMap171_g93 = IN.ase_texcoord4.xy;
				float4 tex2DNode171_g93 = tex2D( _MainMap, uv_MainMap171_g93 );
				float3 objToViewDir129_g93 = mul( UNITY_MATRIX_IT_MV, float4( IN.ase_normal, 0 ) ).xyz;
				float3 normalizeResult128_g93 = normalize( objToViewDir129_g93 );
				float3 normal159_g93 = normalizeResult128_g93;
				float2 localMyCustomExpression159_g93 = MyCustomExpression159_g93( normal159_g93 );
				float3 desaturateInitialColor142_g93 = tex2D( _MainColorMap, localMyCustomExpression159_g93 ).rgb;
				float desaturateDot142_g93 = dot( desaturateInitialColor142_g93, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar142_g93 = lerp( desaturateInitialColor142_g93, desaturateDot142_g93.xxx, _Desaturation );
				float3 temp_cast_1 = (_ColorPow).xxx;
				#ifdef _MAPMATCAP_ON
				float4 staticSwitch144_g93 = ( float4( pow( desaturateVar142_g93 , temp_cast_1 ) , 0.0 ) * _MainColorMult * _ColorTransition );
				#else
				float4 staticSwitch144_g93 = tex2DNode171_g93;
				#endif
				#ifdef _COLORMAP_ON
				float4 staticSwitch143_g93 = _MainColor;
				#else
				float4 staticSwitch143_g93 = staticSwitch144_g93;
				#endif
				#ifdef _USEMAINTEXTURE_ON
				float4 staticSwitch167_g93 = tex2DNode171_g93;
				#else
				float4 staticSwitch167_g93 = _ColorTransition;
				#endif
				float3 break74_g93 = _WorldSpaceCameraPos;
				float3 appendResult73_g93 = (float3(( break74_g93.x * -1.0 ) , break74_g93.z , break74_g93.y));
				float3 temp_output_75_0_g93 = ( appendResult73_g93 * _Subdivision );
				float3 break67_g93 = WorldPosition;
				float3 appendResult72_g93 = (float3(( break67_g93.x * -1.0 ) , break67_g93.z , break67_g93.y));
				float3 temp_output_71_0_g93 = ( appendResult72_g93 * _Subdivision );
				float3 WP70_g93 = temp_output_71_0_g93;
				float3 temp_output_69_0_g93 = ( WP70_g93 * 1.0 );
				float3 normalizeResult84_g93 = normalize( ( temp_output_75_0_g93 - temp_output_69_0_g93 ) );
				float3 temp_output_1_0_g96 = normalizeResult84_g93;
				float3 temp_output_45_0_g96 = temp_output_75_0_g93;
				float dotResult22_g96 = dot( temp_output_1_0_g96 , temp_output_45_0_g96 );
				float3 temp_cast_3 = (0.5).xxx;
				float3 temp_output_2_0_g96 = ( ( ceil( temp_output_69_0_g93 ) / 1.0 ) - temp_cast_3 );
				float dotResult25_g96 = dot( temp_output_1_0_g96 , temp_output_2_0_g96 );
				float3 temp_output_30_0_g96 = ( WP70_g93 - temp_output_45_0_g96 );
				float dotResult28_g96 = dot( temp_output_1_0_g96 , temp_output_30_0_g96 );
				float temp_output_27_0_g96 = ( ( ( dotResult22_g96 - dotResult25_g96 ) * -1.0 ) / dotResult28_g96 );
				float3 normalizeResult27_g97 = normalize( temp_output_1_0_g96 );
				float3 normalizeResult31_g97 = normalize( float3(0,0.00015,-1) );
				float3 normalizeResult29_g97 = normalize( cross( normalizeResult27_g97 , normalizeResult31_g97 ) );
				float3 temp_output_7_0_g96 = ( normalizeResult29_g97 * float3( 1,1,1 ) );
				float3 temp_output_34_0_g96 = ( temp_output_45_0_g96 + ( temp_output_27_0_g96 * temp_output_30_0_g96 ) );
				float3 temp_output_35_0_g96 = ( temp_output_34_0_g96 - temp_output_2_0_g96 );
				float dotResult11_g96 = dot( temp_output_7_0_g96 , temp_output_35_0_g96 );
				float3 normalizeResult10_g96 = normalize( cross( temp_output_7_0_g96 , normalizeResult27_g97 ) );
				float dotResult12_g96 = dot( normalizeResult10_g96 , temp_output_35_0_g96 );
				float2 appendResult14_g96 = (float2(dotResult11_g96 , dotResult12_g96));
				float2 temp_cast_4 = (0.0).xx;
				float2 temp_cast_5 = (0.0).xx;
				float2 ifLocalVar15_g96 = 0;
				if( temp_output_27_0_g96 <= 0.0 )
				ifLocalVar15_g96 = temp_cast_5;
				else
				ifLocalVar15_g96 = appendResult14_g96;
				float2 texCoord46_g93 = IN.ase_texcoord4.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord43_g93 = IN.ase_texcoord4.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch182_g93 = texCoord43_g93.x;
				#else
				float staticSwitch182_g93 = texCoord43_g93.y;
				#endif
				float clampResult161_g93 = clamp( ( ( tex2D( _MaskMap, (texCoord46_g93*_TilingTransition + 0.0) ).r * _TransitionFactor ) + staticSwitch182_g93 ) , 0.0 , 1.0 );
				float2 texCoord44_g93 = IN.ase_texcoord4.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_39_0_g93 = ( pow( tex2D( _MaskMap, (texCoord44_g93*_Tiling + 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_33_0_g93 = ( ( 1.0 - ( clampResult161_g93 * float3(1,1,1) ) ) + temp_output_39_0_g93 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch123_g93 = ( 1.0 - temp_output_33_0_g93 );
				#else
				float3 staticSwitch123_g93 = temp_output_33_0_g93;
				#endif
				float lerpResult150_g93 = lerp( 0.0 , 3.14 , _TransitionControlManualAnimationMode);
				float mulTime125_g93 = _TimeParameters.x * _Transition;
				float _Time147_g93 = mulTime125_g93;
				float _Period147_g93 = 2.0;
				float localMyCustomExpression147_g93 = MyCustomExpression147_g93( _Time147_g93 , _Period147_g93 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch180_g93 = localMyCustomExpression147_g93;
				#else
				float staticSwitch180_g93 = sin( lerpResult150_g93 );
				#endif
				#ifdef _INVERSEANIMATION2_ON
				float staticSwitch124_g93 = ( 1.0 - staticSwitch180_g93 );
				#else
				float staticSwitch124_g93 = staticSwitch180_g93;
				#endif
				#ifdef _INVERSEANIMATION4_ON
				float staticSwitch181_g93 = ( _Exp * 2.0 );
				#else
				float staticSwitch181_g93 = _Exp;
				#endif
				float3 temp_cast_6 = (( ( pow( staticSwitch124_g93 , staticSwitch181_g93 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult11_g93 = clamp( (( staticSwitch123_g93 - temp_cast_6 )).z , 0.0 , 1.0 );
				float temp_output_14_0_g93 = ( 1.0 - pow( clampResult11_g93 , 2.0 ) );
				float TransitionMask92_g93 = temp_output_14_0_g93;
				float MaskMap42_g93 = temp_output_39_0_g93;
				float lerpResult106_g93 = lerp( 0.0 , _Distortion , TransitionMask92_g93);
				float2 temp_output_107_0_g93 = ( ( ( ifLocalVar15_g96 / ( ( 1.0 - ( TransitionMask92_g93 * float2( 1,1 ) ) ) * _SizeWhenTransition ) ) + 0.5 ) + ( MaskMap42_g93 * lerpResult106_g93 ) );
				float2 temp_cast_7 = (0.5).xx;
				float lerpResult18_g93 = lerp( 1.0 , 0.0 , TransitionMask92_g93);
				float2 temp_output_7_0_g95 = ( ( temp_output_107_0_g93 - temp_cast_7 ) / lerpResult18_g93 );
				float2 temp_cast_8 = (0.5).xx;
				float dotResult2_g95 = dot( temp_output_7_0_g95 , temp_output_7_0_g95 );
				float lerpResult16_g93 = lerp( 1.0 , 0.1 , TransitionMask92_g93);
				float mulTime109_g93 = _TimeParameters.x * 2.0;
				float cos88_g93 = cos( ( mulTime109_g93 + TransitionMask92_g93 ) );
				float sin88_g93 = sin( ( mulTime109_g93 + TransitionMask92_g93 ) );
				float2 rotator88_g93 = mul( temp_output_107_0_g93 - float2( 0.5,0.5 ) , float2x2( cos88_g93 , -sin88_g93 , sin88_g93 , cos88_g93 )) + float2( 0.5,0.5 );
				float clampResult101_g93 = clamp( ( pow( tex2D( _Pattern, rotator88_g93 ).r , 6.0 ) + 0.1 ) , 0.0 , 1.0 );
				float clampResult97_g93 = clamp( ( clampResult101_g93 - TransitionMask92_g93 ) , 0.0 , 1.0 );
				float temp_output_86_0_g93 = ( 1.0 - (( _CustomTexture )?( ( 1.0 - clampResult97_g93 ) ):( pow( saturate( dotResult2_g95 ) , lerpResult16_g93 ) )) );
				float clampResult136_g93 = clamp( ( temp_output_86_0_g93 * _STEP ) , 0.0 , 1.0 );
				float4 temp_output_137_0_g93 = ( ( staticSwitch167_g93 * _EmissiveFctor * 1.0 ) * (( _DETAILES )?( frac( clampResult136_g93 ) ):( 1.0 )) );
				float4 lerpResult139_g93 = lerp( staticSwitch143_g93 , temp_output_137_0_g93 , pow( TransitionMask92_g93 , _SharpTransition ));
				float4 FinalColor157_g93 = lerpResult139_g93;
				
				float4 Emissive212_g93 = ( temp_output_137_0_g93 * TransitionMask92_g93 );
				
				float lerpResult91_g93 = lerp( 1.0 , temp_output_39_0_g93 , temp_output_14_0_g93);
				float lerpResult41_g93 = lerp( lerpResult91_g93 , 0.0 , TransitionMask92_g93);
				float temp_output_120_0_g93 = ( temp_output_86_0_g93 * lerpResult41_g93 );
				float FinalAlpha116_g93 = floor( ceil( temp_output_120_0_g93 ) );
				

				float3 BaseColor = FinalColor157_g93.rgb;
				float3 Emission = Emissive212_g93.rgb;
				float Alpha = FinalAlpha116_g93;
				float AlphaClipThreshold = 0.1;

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				MetaInput metaInput = (MetaInput)0;
				metaInput.Albedo = BaseColor;
				metaInput.Emission = Emission;
				#ifdef EDITOR_VISUALIZATION
					metaInput.VizUV = IN.VizUV.xy;
					metaInput.LightCoord = IN.LightCoord;
				#endif

				return UnityMetaFragment(metaInput);
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Universal2D"
			Tags { "LightMode"="Universal2D" }

			Blend One Zero, One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#define ASE_ABSOLUTE_VERTEX_POS 1
			#define _EMISSION
			#define _ALPHATEST_ON 1
			#define ASE_SRP_VERSION 120112


			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_2D

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#pragma shader_feature_local _INVERSEDIRECTION_ON
			#pragma shader_feature_local _TRANSITIONXVSY_ON
			#pragma shader_feature_local _INVERSEANIMATION2_ON
			#pragma shader_feature_local _MANUALAUTOMATIC_ON
			#pragma shader_feature_local _INVERSEANIMATION4_ON
			#pragma shader_feature_local _INVERSEANIMATION1_ON
			#pragma shader_feature_local _CUSTOMPIVOT_ON
			#pragma shader_feature_local _INVERSEANIMATION3_ON
			#pragma shader_feature_local _COLORMAP_ON
			#pragma shader_feature_local _MAPMATCAP_ON
			#pragma shader_feature_local _USEMAINTEXTURE_ON


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord : TEXCOORD1;
				#endif
				float4 ase_texcoord2 : TEXCOORD2;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _OffsetPivot;
			float4 _MainColor;
			float4 _ColorTransition;
			float3 _NormalizedRotationAxis;
			float3 _CustomPivotVec;
			float _Push;
			float _SharpTransition;
			float _STEP;
			float _Distortion;
			float _SizeWhenTransition;
			float _Subdivision;
			float _CustomTexture;
			float _DETAILES;
			float _EmissiveFctor;
			float _ColorPow;
			float _Metallic;
			float _Desaturation;
			float _Angle;
			float _Exp;
			float _Transition;
			float _TransitionControlManualAnimationMode;
			float _Tiling;
			float _TransitionFactor;
			float _TilingTransition;
			float _MainColorMult;
			float _Smoothness;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			// Property used by ScenePickingPass
			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			// Properties used by SceneSelectionPass
			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _MaskMap;
			sampler2D _MainMap;
			sampler2D _MainColorMap;
			sampler2D _Pattern;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			float MyCustomExpression147_g93( float _Time, float _Period )
			{
				// Calculate a sine wave value that oscillates between 0 and 1 over time
				float v = (sin(_Time * 2 * 3.14159 / _Period) + 1) * 0.5;
				return v ;
			}
			
			float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
			{
				original -= center;
				float C = cos( angle );
				float S = sin( angle );
				float t = 1 - C;
				float m00 = t * u.x * u.x + C;
				float m01 = t * u.x * u.y - S * u.z;
				float m02 = t * u.x * u.z + S * u.y;
				float m10 = t * u.x * u.y + S * u.z;
				float m11 = t * u.y * u.y + C;
				float m12 = t * u.y * u.z - S * u.x;
				float m20 = t * u.x * u.z - S * u.y;
				float m21 = t * u.y * u.z + S * u.x;
				float m22 = t * u.z * u.z + C;
				float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
				return mul( finalMatrix, original ) + center;
			}
			
			float2 MyCustomExpression159_g93( float3 normal )
			{
				float2 uv_matcap = normal *0.5 + float2(0.5,0.5); float2(0.5,0.5);
				return uv_matcap;
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				float2 texCoord46_g93 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord43_g93 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch182_g93 = texCoord43_g93.x;
				#else
				float staticSwitch182_g93 = texCoord43_g93.y;
				#endif
				float clampResult161_g93 = clamp( ( ( tex2Dlod( _MaskMap, float4( (texCoord46_g93*_TilingTransition + 0.0), 0, 0.0) ).r * _TransitionFactor ) + staticSwitch182_g93 ) , 0.0 , 1.0 );
				float2 texCoord44_g93 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_39_0_g93 = ( pow( tex2Dlod( _MaskMap, float4( (texCoord44_g93*_Tiling + 0.0), 0, 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_33_0_g93 = ( ( 1.0 - ( clampResult161_g93 * float3(1,1,1) ) ) + temp_output_39_0_g93 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch123_g93 = ( 1.0 - temp_output_33_0_g93 );
				#else
				float3 staticSwitch123_g93 = temp_output_33_0_g93;
				#endif
				float lerpResult150_g93 = lerp( 0.0 , 3.14 , _TransitionControlManualAnimationMode);
				float mulTime125_g93 = _TimeParameters.x * _Transition;
				float _Time147_g93 = mulTime125_g93;
				float _Period147_g93 = 2.0;
				float localMyCustomExpression147_g93 = MyCustomExpression147_g93( _Time147_g93 , _Period147_g93 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch180_g93 = localMyCustomExpression147_g93;
				#else
				float staticSwitch180_g93 = sin( lerpResult150_g93 );
				#endif
				#ifdef _INVERSEANIMATION2_ON
				float staticSwitch124_g93 = ( 1.0 - staticSwitch180_g93 );
				#else
				float staticSwitch124_g93 = staticSwitch180_g93;
				#endif
				#ifdef _INVERSEANIMATION4_ON
				float staticSwitch181_g93 = ( _Exp * 2.0 );
				#else
				float staticSwitch181_g93 = _Exp;
				#endif
				float3 temp_cast_0 = (( ( pow( staticSwitch124_g93 , staticSwitch181_g93 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult11_g93 = clamp( (( staticSwitch123_g93 - temp_cast_0 )).z , 0.0 , 1.0 );
				float temp_output_14_0_g93 = ( 1.0 - pow( clampResult11_g93 , 2.0 ) );
				float TransitionMask92_g93 = temp_output_14_0_g93;
				float lerpResult20_g93 = lerp( 0.0 , ( _Push / 100.0 ) , TransitionMask92_g93);
				#ifdef _INVERSEANIMATION1_ON
				float3 staticSwitch63_g93 = ( _NormalizedRotationAxis * -1.0 );
				#else
				float3 staticSwitch63_g93 = _NormalizedRotationAxis;
				#endif
				float MaskMap42_g93 = temp_output_39_0_g93;
				float4 transform191_g93 = mul(GetWorldToObjectMatrix(),float4( 0,0,0,1 ));
				float3 objToWorld192_g93 = mul( GetObjectToWorldMatrix(), float4( transform191_g93.xyz, 1 ) ).xyz;
				float3 clampResult174_g93 = clamp( _CustomPivotVec , float3( -1.5,-1.5,-1.5 ) , float3( 1.5,1.5,1.5 ) );
				#ifdef _CUSTOMPIVOT_ON
				float3 staticSwitch195_g93 = clampResult174_g93;
				#else
				float3 staticSwitch195_g93 = objToWorld192_g93;
				#endif
				#ifdef _INVERSEANIMATION3_ON
				float4 staticSwitch164_g93 = ( _OffsetPivot * -1.0 );
				#else
				float4 staticSwitch164_g93 = _OffsetPivot;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float3 worldToObj52_g93 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 rotatedValue23_g93 = RotateAroundAxis( ( float4( staticSwitch195_g93 , 0.0 ) + ( staticSwitch164_g93 / 100.0 ) ).xyz, worldToObj52_g93, staticSwitch63_g93, ( ( TransitionMask92_g93 * MaskMap42_g93 ) * _Angle ) );
				float3 FinalDisplacement36_g93 = ( ( v.ase_normal * lerpResult20_g93 ) + rotatedValue23_g93 );
				
				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				o.ase_normal = v.ase_normal;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = FinalDisplacement36_g93;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.worldPos = positionWS;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = positionCS;

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 WorldPosition = IN.worldPos;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float2 uv_MainMap171_g93 = IN.ase_texcoord2.xy;
				float4 tex2DNode171_g93 = tex2D( _MainMap, uv_MainMap171_g93 );
				float3 objToViewDir129_g93 = mul( UNITY_MATRIX_IT_MV, float4( IN.ase_normal, 0 ) ).xyz;
				float3 normalizeResult128_g93 = normalize( objToViewDir129_g93 );
				float3 normal159_g93 = normalizeResult128_g93;
				float2 localMyCustomExpression159_g93 = MyCustomExpression159_g93( normal159_g93 );
				float3 desaturateInitialColor142_g93 = tex2D( _MainColorMap, localMyCustomExpression159_g93 ).rgb;
				float desaturateDot142_g93 = dot( desaturateInitialColor142_g93, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar142_g93 = lerp( desaturateInitialColor142_g93, desaturateDot142_g93.xxx, _Desaturation );
				float3 temp_cast_1 = (_ColorPow).xxx;
				#ifdef _MAPMATCAP_ON
				float4 staticSwitch144_g93 = ( float4( pow( desaturateVar142_g93 , temp_cast_1 ) , 0.0 ) * _MainColorMult * _ColorTransition );
				#else
				float4 staticSwitch144_g93 = tex2DNode171_g93;
				#endif
				#ifdef _COLORMAP_ON
				float4 staticSwitch143_g93 = _MainColor;
				#else
				float4 staticSwitch143_g93 = staticSwitch144_g93;
				#endif
				#ifdef _USEMAINTEXTURE_ON
				float4 staticSwitch167_g93 = tex2DNode171_g93;
				#else
				float4 staticSwitch167_g93 = _ColorTransition;
				#endif
				float3 break74_g93 = _WorldSpaceCameraPos;
				float3 appendResult73_g93 = (float3(( break74_g93.x * -1.0 ) , break74_g93.z , break74_g93.y));
				float3 temp_output_75_0_g93 = ( appendResult73_g93 * _Subdivision );
				float3 break67_g93 = WorldPosition;
				float3 appendResult72_g93 = (float3(( break67_g93.x * -1.0 ) , break67_g93.z , break67_g93.y));
				float3 temp_output_71_0_g93 = ( appendResult72_g93 * _Subdivision );
				float3 WP70_g93 = temp_output_71_0_g93;
				float3 temp_output_69_0_g93 = ( WP70_g93 * 1.0 );
				float3 normalizeResult84_g93 = normalize( ( temp_output_75_0_g93 - temp_output_69_0_g93 ) );
				float3 temp_output_1_0_g96 = normalizeResult84_g93;
				float3 temp_output_45_0_g96 = temp_output_75_0_g93;
				float dotResult22_g96 = dot( temp_output_1_0_g96 , temp_output_45_0_g96 );
				float3 temp_cast_3 = (0.5).xxx;
				float3 temp_output_2_0_g96 = ( ( ceil( temp_output_69_0_g93 ) / 1.0 ) - temp_cast_3 );
				float dotResult25_g96 = dot( temp_output_1_0_g96 , temp_output_2_0_g96 );
				float3 temp_output_30_0_g96 = ( WP70_g93 - temp_output_45_0_g96 );
				float dotResult28_g96 = dot( temp_output_1_0_g96 , temp_output_30_0_g96 );
				float temp_output_27_0_g96 = ( ( ( dotResult22_g96 - dotResult25_g96 ) * -1.0 ) / dotResult28_g96 );
				float3 normalizeResult27_g97 = normalize( temp_output_1_0_g96 );
				float3 normalizeResult31_g97 = normalize( float3(0,0.00015,-1) );
				float3 normalizeResult29_g97 = normalize( cross( normalizeResult27_g97 , normalizeResult31_g97 ) );
				float3 temp_output_7_0_g96 = ( normalizeResult29_g97 * float3( 1,1,1 ) );
				float3 temp_output_34_0_g96 = ( temp_output_45_0_g96 + ( temp_output_27_0_g96 * temp_output_30_0_g96 ) );
				float3 temp_output_35_0_g96 = ( temp_output_34_0_g96 - temp_output_2_0_g96 );
				float dotResult11_g96 = dot( temp_output_7_0_g96 , temp_output_35_0_g96 );
				float3 normalizeResult10_g96 = normalize( cross( temp_output_7_0_g96 , normalizeResult27_g97 ) );
				float dotResult12_g96 = dot( normalizeResult10_g96 , temp_output_35_0_g96 );
				float2 appendResult14_g96 = (float2(dotResult11_g96 , dotResult12_g96));
				float2 temp_cast_4 = (0.0).xx;
				float2 temp_cast_5 = (0.0).xx;
				float2 ifLocalVar15_g96 = 0;
				if( temp_output_27_0_g96 <= 0.0 )
				ifLocalVar15_g96 = temp_cast_5;
				else
				ifLocalVar15_g96 = appendResult14_g96;
				float2 texCoord46_g93 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord43_g93 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch182_g93 = texCoord43_g93.x;
				#else
				float staticSwitch182_g93 = texCoord43_g93.y;
				#endif
				float clampResult161_g93 = clamp( ( ( tex2D( _MaskMap, (texCoord46_g93*_TilingTransition + 0.0) ).r * _TransitionFactor ) + staticSwitch182_g93 ) , 0.0 , 1.0 );
				float2 texCoord44_g93 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_39_0_g93 = ( pow( tex2D( _MaskMap, (texCoord44_g93*_Tiling + 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_33_0_g93 = ( ( 1.0 - ( clampResult161_g93 * float3(1,1,1) ) ) + temp_output_39_0_g93 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch123_g93 = ( 1.0 - temp_output_33_0_g93 );
				#else
				float3 staticSwitch123_g93 = temp_output_33_0_g93;
				#endif
				float lerpResult150_g93 = lerp( 0.0 , 3.14 , _TransitionControlManualAnimationMode);
				float mulTime125_g93 = _TimeParameters.x * _Transition;
				float _Time147_g93 = mulTime125_g93;
				float _Period147_g93 = 2.0;
				float localMyCustomExpression147_g93 = MyCustomExpression147_g93( _Time147_g93 , _Period147_g93 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch180_g93 = localMyCustomExpression147_g93;
				#else
				float staticSwitch180_g93 = sin( lerpResult150_g93 );
				#endif
				#ifdef _INVERSEANIMATION2_ON
				float staticSwitch124_g93 = ( 1.0 - staticSwitch180_g93 );
				#else
				float staticSwitch124_g93 = staticSwitch180_g93;
				#endif
				#ifdef _INVERSEANIMATION4_ON
				float staticSwitch181_g93 = ( _Exp * 2.0 );
				#else
				float staticSwitch181_g93 = _Exp;
				#endif
				float3 temp_cast_6 = (( ( pow( staticSwitch124_g93 , staticSwitch181_g93 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult11_g93 = clamp( (( staticSwitch123_g93 - temp_cast_6 )).z , 0.0 , 1.0 );
				float temp_output_14_0_g93 = ( 1.0 - pow( clampResult11_g93 , 2.0 ) );
				float TransitionMask92_g93 = temp_output_14_0_g93;
				float MaskMap42_g93 = temp_output_39_0_g93;
				float lerpResult106_g93 = lerp( 0.0 , _Distortion , TransitionMask92_g93);
				float2 temp_output_107_0_g93 = ( ( ( ifLocalVar15_g96 / ( ( 1.0 - ( TransitionMask92_g93 * float2( 1,1 ) ) ) * _SizeWhenTransition ) ) + 0.5 ) + ( MaskMap42_g93 * lerpResult106_g93 ) );
				float2 temp_cast_7 = (0.5).xx;
				float lerpResult18_g93 = lerp( 1.0 , 0.0 , TransitionMask92_g93);
				float2 temp_output_7_0_g95 = ( ( temp_output_107_0_g93 - temp_cast_7 ) / lerpResult18_g93 );
				float2 temp_cast_8 = (0.5).xx;
				float dotResult2_g95 = dot( temp_output_7_0_g95 , temp_output_7_0_g95 );
				float lerpResult16_g93 = lerp( 1.0 , 0.1 , TransitionMask92_g93);
				float mulTime109_g93 = _TimeParameters.x * 2.0;
				float cos88_g93 = cos( ( mulTime109_g93 + TransitionMask92_g93 ) );
				float sin88_g93 = sin( ( mulTime109_g93 + TransitionMask92_g93 ) );
				float2 rotator88_g93 = mul( temp_output_107_0_g93 - float2( 0.5,0.5 ) , float2x2( cos88_g93 , -sin88_g93 , sin88_g93 , cos88_g93 )) + float2( 0.5,0.5 );
				float clampResult101_g93 = clamp( ( pow( tex2D( _Pattern, rotator88_g93 ).r , 6.0 ) + 0.1 ) , 0.0 , 1.0 );
				float clampResult97_g93 = clamp( ( clampResult101_g93 - TransitionMask92_g93 ) , 0.0 , 1.0 );
				float temp_output_86_0_g93 = ( 1.0 - (( _CustomTexture )?( ( 1.0 - clampResult97_g93 ) ):( pow( saturate( dotResult2_g95 ) , lerpResult16_g93 ) )) );
				float clampResult136_g93 = clamp( ( temp_output_86_0_g93 * _STEP ) , 0.0 , 1.0 );
				float4 temp_output_137_0_g93 = ( ( staticSwitch167_g93 * _EmissiveFctor * 1.0 ) * (( _DETAILES )?( frac( clampResult136_g93 ) ):( 1.0 )) );
				float4 lerpResult139_g93 = lerp( staticSwitch143_g93 , temp_output_137_0_g93 , pow( TransitionMask92_g93 , _SharpTransition ));
				float4 FinalColor157_g93 = lerpResult139_g93;
				
				float lerpResult91_g93 = lerp( 1.0 , temp_output_39_0_g93 , temp_output_14_0_g93);
				float lerpResult41_g93 = lerp( lerpResult91_g93 , 0.0 , TransitionMask92_g93);
				float temp_output_120_0_g93 = ( temp_output_86_0_g93 * lerpResult41_g93 );
				float FinalAlpha116_g93 = floor( ceil( temp_output_120_0_g93 ) );
				

				float3 BaseColor = FinalColor157_g93.rgb;
				float Alpha = FinalAlpha116_g93;
				float AlphaClipThreshold = 0.1;

				half4 color = half4(BaseColor, Alpha );

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				return color;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthNormals"
			Tags { "LightMode"="DepthNormals" }

			ZWrite On
			Blend One Zero
			ZTest LEqual
			ZWrite On

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#define ASE_FOG 1
			#define ASE_ABSOLUTE_VERTEX_POS 1
			#define _EMISSION
			#define _ALPHATEST_ON 1
			#define ASE_SRP_VERSION 120112


			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_DEPTHNORMALSONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#pragma shader_feature_local _INVERSEDIRECTION_ON
			#pragma shader_feature_local _TRANSITIONXVSY_ON
			#pragma shader_feature_local _INVERSEANIMATION2_ON
			#pragma shader_feature_local _MANUALAUTOMATIC_ON
			#pragma shader_feature_local _INVERSEANIMATION4_ON
			#pragma shader_feature_local _INVERSEANIMATION1_ON
			#pragma shader_feature_local _CUSTOMPIVOT_ON
			#pragma shader_feature_local _INVERSEANIMATION3_ON


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				ASE_SV_POSITION_QUALIFIERS float4 clipPos : SV_POSITION;
				float4 clipPosV : TEXCOORD0;
				float3 worldNormal : TEXCOORD1;
				float4 worldTangent : TEXCOORD2;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 worldPos : TEXCOORD3;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord : TEXCOORD4;
				#endif
				float4 ase_texcoord5 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _OffsetPivot;
			float4 _MainColor;
			float4 _ColorTransition;
			float3 _NormalizedRotationAxis;
			float3 _CustomPivotVec;
			float _Push;
			float _SharpTransition;
			float _STEP;
			float _Distortion;
			float _SizeWhenTransition;
			float _Subdivision;
			float _CustomTexture;
			float _DETAILES;
			float _EmissiveFctor;
			float _ColorPow;
			float _Metallic;
			float _Desaturation;
			float _Angle;
			float _Exp;
			float _Transition;
			float _TransitionControlManualAnimationMode;
			float _Tiling;
			float _TransitionFactor;
			float _TilingTransition;
			float _MainColorMult;
			float _Smoothness;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			// Property used by ScenePickingPass
			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			// Properties used by SceneSelectionPass
			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _MaskMap;
			sampler2D _Pattern;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			float MyCustomExpression147_g93( float _Time, float _Period )
			{
				// Calculate a sine wave value that oscillates between 0 and 1 over time
				float v = (sin(_Time * 2 * 3.14159 / _Period) + 1) * 0.5;
				return v ;
			}
			
			float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
			{
				original -= center;
				float C = cos( angle );
				float S = sin( angle );
				float t = 1 - C;
				float m00 = t * u.x * u.x + C;
				float m01 = t * u.x * u.y - S * u.z;
				float m02 = t * u.x * u.z + S * u.y;
				float m10 = t * u.x * u.y + S * u.z;
				float m11 = t * u.y * u.y + C;
				float m12 = t * u.y * u.z - S * u.x;
				float m20 = t * u.x * u.z - S * u.y;
				float m21 = t * u.y * u.z + S * u.x;
				float m22 = t * u.z * u.z + C;
				float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
				return mul( finalMatrix, original ) + center;
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 texCoord46_g93 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord43_g93 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch182_g93 = texCoord43_g93.x;
				#else
				float staticSwitch182_g93 = texCoord43_g93.y;
				#endif
				float clampResult161_g93 = clamp( ( ( tex2Dlod( _MaskMap, float4( (texCoord46_g93*_TilingTransition + 0.0), 0, 0.0) ).r * _TransitionFactor ) + staticSwitch182_g93 ) , 0.0 , 1.0 );
				float2 texCoord44_g93 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_39_0_g93 = ( pow( tex2Dlod( _MaskMap, float4( (texCoord44_g93*_Tiling + 0.0), 0, 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_33_0_g93 = ( ( 1.0 - ( clampResult161_g93 * float3(1,1,1) ) ) + temp_output_39_0_g93 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch123_g93 = ( 1.0 - temp_output_33_0_g93 );
				#else
				float3 staticSwitch123_g93 = temp_output_33_0_g93;
				#endif
				float lerpResult150_g93 = lerp( 0.0 , 3.14 , _TransitionControlManualAnimationMode);
				float mulTime125_g93 = _TimeParameters.x * _Transition;
				float _Time147_g93 = mulTime125_g93;
				float _Period147_g93 = 2.0;
				float localMyCustomExpression147_g93 = MyCustomExpression147_g93( _Time147_g93 , _Period147_g93 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch180_g93 = localMyCustomExpression147_g93;
				#else
				float staticSwitch180_g93 = sin( lerpResult150_g93 );
				#endif
				#ifdef _INVERSEANIMATION2_ON
				float staticSwitch124_g93 = ( 1.0 - staticSwitch180_g93 );
				#else
				float staticSwitch124_g93 = staticSwitch180_g93;
				#endif
				#ifdef _INVERSEANIMATION4_ON
				float staticSwitch181_g93 = ( _Exp * 2.0 );
				#else
				float staticSwitch181_g93 = _Exp;
				#endif
				float3 temp_cast_0 = (( ( pow( staticSwitch124_g93 , staticSwitch181_g93 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult11_g93 = clamp( (( staticSwitch123_g93 - temp_cast_0 )).z , 0.0 , 1.0 );
				float temp_output_14_0_g93 = ( 1.0 - pow( clampResult11_g93 , 2.0 ) );
				float TransitionMask92_g93 = temp_output_14_0_g93;
				float lerpResult20_g93 = lerp( 0.0 , ( _Push / 100.0 ) , TransitionMask92_g93);
				#ifdef _INVERSEANIMATION1_ON
				float3 staticSwitch63_g93 = ( _NormalizedRotationAxis * -1.0 );
				#else
				float3 staticSwitch63_g93 = _NormalizedRotationAxis;
				#endif
				float MaskMap42_g93 = temp_output_39_0_g93;
				float4 transform191_g93 = mul(GetWorldToObjectMatrix(),float4( 0,0,0,1 ));
				float3 objToWorld192_g93 = mul( GetObjectToWorldMatrix(), float4( transform191_g93.xyz, 1 ) ).xyz;
				float3 clampResult174_g93 = clamp( _CustomPivotVec , float3( -1.5,-1.5,-1.5 ) , float3( 1.5,1.5,1.5 ) );
				#ifdef _CUSTOMPIVOT_ON
				float3 staticSwitch195_g93 = clampResult174_g93;
				#else
				float3 staticSwitch195_g93 = objToWorld192_g93;
				#endif
				#ifdef _INVERSEANIMATION3_ON
				float4 staticSwitch164_g93 = ( _OffsetPivot * -1.0 );
				#else
				float4 staticSwitch164_g93 = _OffsetPivot;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float3 worldToObj52_g93 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 rotatedValue23_g93 = RotateAroundAxis( ( float4( staticSwitch195_g93 , 0.0 ) + ( staticSwitch164_g93 / 100.0 ) ).xyz, worldToObj52_g93, staticSwitch63_g93, ( ( TransitionMask92_g93 * MaskMap42_g93 ) * _Angle ) );
				float3 FinalDisplacement36_g93 = ( ( v.ase_normal * lerpResult20_g93 ) + rotatedValue23_g93 );
				
				o.ase_texcoord5.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord5.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = FinalDisplacement36_g93;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;
				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float3 normalWS = TransformObjectToWorldNormal( v.ase_normal );
				float4 tangentWS = float4(TransformObjectToWorldDir( v.ase_tangent.xyz), v.ase_tangent.w);
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.worldPos = positionWS;
				#endif

				o.worldNormal = normalWS;
				o.worldTangent = tangentWS;

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = positionCS;
				o.clipPosV = positionCS;
				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_tangent = v.ase_tangent;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(	VertexOutput IN
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 WorldPosition = IN.worldPos;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );
				float3 WorldNormal = IN.worldNormal;
				float4 WorldTangent = IN.worldTangent;

				float4 ClipPos = IN.clipPosV;
				float4 ScreenPos = ComputeScreenPos( IN.clipPosV );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float3 break74_g93 = _WorldSpaceCameraPos;
				float3 appendResult73_g93 = (float3(( break74_g93.x * -1.0 ) , break74_g93.z , break74_g93.y));
				float3 temp_output_75_0_g93 = ( appendResult73_g93 * _Subdivision );
				float3 break67_g93 = WorldPosition;
				float3 appendResult72_g93 = (float3(( break67_g93.x * -1.0 ) , break67_g93.z , break67_g93.y));
				float3 temp_output_71_0_g93 = ( appendResult72_g93 * _Subdivision );
				float3 WP70_g93 = temp_output_71_0_g93;
				float3 temp_output_69_0_g93 = ( WP70_g93 * 1.0 );
				float3 normalizeResult84_g93 = normalize( ( temp_output_75_0_g93 - temp_output_69_0_g93 ) );
				float3 temp_output_1_0_g96 = normalizeResult84_g93;
				float3 temp_output_45_0_g96 = temp_output_75_0_g93;
				float dotResult22_g96 = dot( temp_output_1_0_g96 , temp_output_45_0_g96 );
				float3 temp_cast_0 = (0.5).xxx;
				float3 temp_output_2_0_g96 = ( ( ceil( temp_output_69_0_g93 ) / 1.0 ) - temp_cast_0 );
				float dotResult25_g96 = dot( temp_output_1_0_g96 , temp_output_2_0_g96 );
				float3 temp_output_30_0_g96 = ( WP70_g93 - temp_output_45_0_g96 );
				float dotResult28_g96 = dot( temp_output_1_0_g96 , temp_output_30_0_g96 );
				float temp_output_27_0_g96 = ( ( ( dotResult22_g96 - dotResult25_g96 ) * -1.0 ) / dotResult28_g96 );
				float3 normalizeResult27_g97 = normalize( temp_output_1_0_g96 );
				float3 normalizeResult31_g97 = normalize( float3(0,0.00015,-1) );
				float3 normalizeResult29_g97 = normalize( cross( normalizeResult27_g97 , normalizeResult31_g97 ) );
				float3 temp_output_7_0_g96 = ( normalizeResult29_g97 * float3( 1,1,1 ) );
				float3 temp_output_34_0_g96 = ( temp_output_45_0_g96 + ( temp_output_27_0_g96 * temp_output_30_0_g96 ) );
				float3 temp_output_35_0_g96 = ( temp_output_34_0_g96 - temp_output_2_0_g96 );
				float dotResult11_g96 = dot( temp_output_7_0_g96 , temp_output_35_0_g96 );
				float3 normalizeResult10_g96 = normalize( cross( temp_output_7_0_g96 , normalizeResult27_g97 ) );
				float dotResult12_g96 = dot( normalizeResult10_g96 , temp_output_35_0_g96 );
				float2 appendResult14_g96 = (float2(dotResult11_g96 , dotResult12_g96));
				float2 temp_cast_1 = (0.0).xx;
				float2 temp_cast_2 = (0.0).xx;
				float2 ifLocalVar15_g96 = 0;
				if( temp_output_27_0_g96 <= 0.0 )
				ifLocalVar15_g96 = temp_cast_2;
				else
				ifLocalVar15_g96 = appendResult14_g96;
				float2 texCoord46_g93 = IN.ase_texcoord5.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord43_g93 = IN.ase_texcoord5.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch182_g93 = texCoord43_g93.x;
				#else
				float staticSwitch182_g93 = texCoord43_g93.y;
				#endif
				float clampResult161_g93 = clamp( ( ( tex2D( _MaskMap, (texCoord46_g93*_TilingTransition + 0.0) ).r * _TransitionFactor ) + staticSwitch182_g93 ) , 0.0 , 1.0 );
				float2 texCoord44_g93 = IN.ase_texcoord5.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_39_0_g93 = ( pow( tex2D( _MaskMap, (texCoord44_g93*_Tiling + 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_33_0_g93 = ( ( 1.0 - ( clampResult161_g93 * float3(1,1,1) ) ) + temp_output_39_0_g93 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch123_g93 = ( 1.0 - temp_output_33_0_g93 );
				#else
				float3 staticSwitch123_g93 = temp_output_33_0_g93;
				#endif
				float lerpResult150_g93 = lerp( 0.0 , 3.14 , _TransitionControlManualAnimationMode);
				float mulTime125_g93 = _TimeParameters.x * _Transition;
				float _Time147_g93 = mulTime125_g93;
				float _Period147_g93 = 2.0;
				float localMyCustomExpression147_g93 = MyCustomExpression147_g93( _Time147_g93 , _Period147_g93 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch180_g93 = localMyCustomExpression147_g93;
				#else
				float staticSwitch180_g93 = sin( lerpResult150_g93 );
				#endif
				#ifdef _INVERSEANIMATION2_ON
				float staticSwitch124_g93 = ( 1.0 - staticSwitch180_g93 );
				#else
				float staticSwitch124_g93 = staticSwitch180_g93;
				#endif
				#ifdef _INVERSEANIMATION4_ON
				float staticSwitch181_g93 = ( _Exp * 2.0 );
				#else
				float staticSwitch181_g93 = _Exp;
				#endif
				float3 temp_cast_3 = (( ( pow( staticSwitch124_g93 , staticSwitch181_g93 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult11_g93 = clamp( (( staticSwitch123_g93 - temp_cast_3 )).z , 0.0 , 1.0 );
				float temp_output_14_0_g93 = ( 1.0 - pow( clampResult11_g93 , 2.0 ) );
				float TransitionMask92_g93 = temp_output_14_0_g93;
				float MaskMap42_g93 = temp_output_39_0_g93;
				float lerpResult106_g93 = lerp( 0.0 , _Distortion , TransitionMask92_g93);
				float2 temp_output_107_0_g93 = ( ( ( ifLocalVar15_g96 / ( ( 1.0 - ( TransitionMask92_g93 * float2( 1,1 ) ) ) * _SizeWhenTransition ) ) + 0.5 ) + ( MaskMap42_g93 * lerpResult106_g93 ) );
				float2 temp_cast_4 = (0.5).xx;
				float lerpResult18_g93 = lerp( 1.0 , 0.0 , TransitionMask92_g93);
				float2 temp_output_7_0_g95 = ( ( temp_output_107_0_g93 - temp_cast_4 ) / lerpResult18_g93 );
				float2 temp_cast_5 = (0.5).xx;
				float dotResult2_g95 = dot( temp_output_7_0_g95 , temp_output_7_0_g95 );
				float lerpResult16_g93 = lerp( 1.0 , 0.1 , TransitionMask92_g93);
				float mulTime109_g93 = _TimeParameters.x * 2.0;
				float cos88_g93 = cos( ( mulTime109_g93 + TransitionMask92_g93 ) );
				float sin88_g93 = sin( ( mulTime109_g93 + TransitionMask92_g93 ) );
				float2 rotator88_g93 = mul( temp_output_107_0_g93 - float2( 0.5,0.5 ) , float2x2( cos88_g93 , -sin88_g93 , sin88_g93 , cos88_g93 )) + float2( 0.5,0.5 );
				float clampResult101_g93 = clamp( ( pow( tex2D( _Pattern, rotator88_g93 ).r , 6.0 ) + 0.1 ) , 0.0 , 1.0 );
				float clampResult97_g93 = clamp( ( clampResult101_g93 - TransitionMask92_g93 ) , 0.0 , 1.0 );
				float temp_output_86_0_g93 = ( 1.0 - (( _CustomTexture )?( ( 1.0 - clampResult97_g93 ) ):( pow( saturate( dotResult2_g95 ) , lerpResult16_g93 ) )) );
				float lerpResult91_g93 = lerp( 1.0 , temp_output_39_0_g93 , temp_output_14_0_g93);
				float lerpResult41_g93 = lerp( lerpResult91_g93 , 0.0 , TransitionMask92_g93);
				float temp_output_120_0_g93 = ( temp_output_86_0_g93 * lerpResult41_g93 );
				float FinalAlpha116_g93 = floor( ceil( temp_output_120_0_g93 ) );
				

				float3 Normal = float3(0, 0, 1);
				float Alpha = FinalAlpha116_g93;
				float AlphaClipThreshold = 0.1;
				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = IN.clipPos.z;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				#if defined(_GBUFFER_NORMALS_OCT)
					float2 octNormalWS = PackNormalOctQuadEncode(WorldNormal);
					float2 remappedOctNormalWS = saturate(octNormalWS * 0.5 + 0.5);
					half3 packedNormalWS = PackFloat2To888(remappedOctNormalWS);
					return half4(packedNormalWS, 0.0);
				#else
					#if defined(_NORMALMAP)
						#if _NORMAL_DROPOFF_TS
							float crossSign = (WorldTangent.w > 0.0 ? 1.0 : -1.0) * GetOddNegativeScale();
							float3 bitangent = crossSign * cross(WorldNormal.xyz, WorldTangent.xyz);
							float3 normalWS = TransformTangentToWorld(Normal, half3x3(WorldTangent.xyz, bitangent, WorldNormal.xyz));
						#elif _NORMAL_DROPOFF_OS
							float3 normalWS = TransformObjectToWorldNormal(Normal);
						#elif _NORMAL_DROPOFF_WS
							float3 normalWS = Normal;
						#endif
					#else
						float3 normalWS = WorldNormal;
					#endif
					return half4(NormalizeNormalPerPixel(normalWS), 0.0);
				#endif
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "GBuffer"
			Tags { "LightMode"="UniversalGBuffer" }

			Blend One Zero, One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma instancing_options renderinglayer
			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define ASE_ABSOLUTE_VERTEX_POS 1
			#define _EMISSION
			#define _ALPHATEST_ON 1
			#define ASE_SRP_VERSION 120112


			#pragma shader_feature_local _RECEIVE_SHADOWS_OFF
			#pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
			#pragma shader_feature_local_fragment _ENVIRONMENTREFLECTIONS_OFF

			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
			#pragma multi_compile_fragment _ _SHADOWS_SOFT
			#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
			#pragma multi_compile_fragment _ _LIGHT_LAYERS
			#pragma multi_compile_fragment _ _RENDER_PASS_ENABLED

			#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
			#pragma multi_compile _ SHADOWS_SHADOWMASK
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON
			#pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_GBUFFER

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(UNITY_INSTANCING_ENABLED) && defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL)
				#define ENABLE_TERRAIN_PERPIXEL_NORMAL
			#endif

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#pragma shader_feature_local _INVERSEDIRECTION_ON
			#pragma shader_feature_local _TRANSITIONXVSY_ON
			#pragma shader_feature_local _INVERSEANIMATION2_ON
			#pragma shader_feature_local _MANUALAUTOMATIC_ON
			#pragma shader_feature_local _INVERSEANIMATION4_ON
			#pragma shader_feature_local _INVERSEANIMATION1_ON
			#pragma shader_feature_local _CUSTOMPIVOT_ON
			#pragma shader_feature_local _INVERSEANIMATION3_ON
			#pragma shader_feature_local _COLORMAP_ON
			#pragma shader_feature_local _MAPMATCAP_ON
			#pragma shader_feature_local _USEMAINTEXTURE_ON


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				ASE_SV_POSITION_QUALIFIERS float4 clipPos : SV_POSITION;
				float4 clipPosV : TEXCOORD0;
				float4 lightmapUVOrVertexSH : TEXCOORD1;
				half4 fogFactorAndVertexLight : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				float4 shadowCoord : TEXCOORD6;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON)
				float2 dynamicLightmapUV : TEXCOORD7;
				#endif
				float4 ase_texcoord8 : TEXCOORD8;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _OffsetPivot;
			float4 _MainColor;
			float4 _ColorTransition;
			float3 _NormalizedRotationAxis;
			float3 _CustomPivotVec;
			float _Push;
			float _SharpTransition;
			float _STEP;
			float _Distortion;
			float _SizeWhenTransition;
			float _Subdivision;
			float _CustomTexture;
			float _DETAILES;
			float _EmissiveFctor;
			float _ColorPow;
			float _Metallic;
			float _Desaturation;
			float _Angle;
			float _Exp;
			float _Transition;
			float _TransitionControlManualAnimationMode;
			float _Tiling;
			float _TransitionFactor;
			float _TilingTransition;
			float _MainColorMult;
			float _Smoothness;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			// Property used by ScenePickingPass
			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			// Properties used by SceneSelectionPass
			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _MaskMap;
			sampler2D _MainMap;
			sampler2D _MainColorMap;
			sampler2D _Pattern;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"

			float MyCustomExpression147_g93( float _Time, float _Period )
			{
				// Calculate a sine wave value that oscillates between 0 and 1 over time
				float v = (sin(_Time * 2 * 3.14159 / _Period) + 1) * 0.5;
				return v ;
			}
			
			float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
			{
				original -= center;
				float C = cos( angle );
				float S = sin( angle );
				float t = 1 - C;
				float m00 = t * u.x * u.x + C;
				float m01 = t * u.x * u.y - S * u.z;
				float m02 = t * u.x * u.z + S * u.y;
				float m10 = t * u.x * u.y + S * u.z;
				float m11 = t * u.y * u.y + C;
				float m12 = t * u.y * u.z - S * u.x;
				float m20 = t * u.x * u.z - S * u.y;
				float m21 = t * u.y * u.z + S * u.x;
				float m22 = t * u.z * u.z + C;
				float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
				return mul( finalMatrix, original ) + center;
			}
			
			float2 MyCustomExpression159_g93( float3 normal )
			{
				float2 uv_matcap = normal *0.5 + float2(0.5,0.5); float2(0.5,0.5);
				return uv_matcap;
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 texCoord46_g93 = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord43_g93 = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch182_g93 = texCoord43_g93.x;
				#else
				float staticSwitch182_g93 = texCoord43_g93.y;
				#endif
				float clampResult161_g93 = clamp( ( ( tex2Dlod( _MaskMap, float4( (texCoord46_g93*_TilingTransition + 0.0), 0, 0.0) ).r * _TransitionFactor ) + staticSwitch182_g93 ) , 0.0 , 1.0 );
				float2 texCoord44_g93 = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_39_0_g93 = ( pow( tex2Dlod( _MaskMap, float4( (texCoord44_g93*_Tiling + 0.0), 0, 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_33_0_g93 = ( ( 1.0 - ( clampResult161_g93 * float3(1,1,1) ) ) + temp_output_39_0_g93 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch123_g93 = ( 1.0 - temp_output_33_0_g93 );
				#else
				float3 staticSwitch123_g93 = temp_output_33_0_g93;
				#endif
				float lerpResult150_g93 = lerp( 0.0 , 3.14 , _TransitionControlManualAnimationMode);
				float mulTime125_g93 = _TimeParameters.x * _Transition;
				float _Time147_g93 = mulTime125_g93;
				float _Period147_g93 = 2.0;
				float localMyCustomExpression147_g93 = MyCustomExpression147_g93( _Time147_g93 , _Period147_g93 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch180_g93 = localMyCustomExpression147_g93;
				#else
				float staticSwitch180_g93 = sin( lerpResult150_g93 );
				#endif
				#ifdef _INVERSEANIMATION2_ON
				float staticSwitch124_g93 = ( 1.0 - staticSwitch180_g93 );
				#else
				float staticSwitch124_g93 = staticSwitch180_g93;
				#endif
				#ifdef _INVERSEANIMATION4_ON
				float staticSwitch181_g93 = ( _Exp * 2.0 );
				#else
				float staticSwitch181_g93 = _Exp;
				#endif
				float3 temp_cast_0 = (( ( pow( staticSwitch124_g93 , staticSwitch181_g93 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult11_g93 = clamp( (( staticSwitch123_g93 - temp_cast_0 )).z , 0.0 , 1.0 );
				float temp_output_14_0_g93 = ( 1.0 - pow( clampResult11_g93 , 2.0 ) );
				float TransitionMask92_g93 = temp_output_14_0_g93;
				float lerpResult20_g93 = lerp( 0.0 , ( _Push / 100.0 ) , TransitionMask92_g93);
				#ifdef _INVERSEANIMATION1_ON
				float3 staticSwitch63_g93 = ( _NormalizedRotationAxis * -1.0 );
				#else
				float3 staticSwitch63_g93 = _NormalizedRotationAxis;
				#endif
				float MaskMap42_g93 = temp_output_39_0_g93;
				float4 transform191_g93 = mul(GetWorldToObjectMatrix(),float4( 0,0,0,1 ));
				float3 objToWorld192_g93 = mul( GetObjectToWorldMatrix(), float4( transform191_g93.xyz, 1 ) ).xyz;
				float3 clampResult174_g93 = clamp( _CustomPivotVec , float3( -1.5,-1.5,-1.5 ) , float3( 1.5,1.5,1.5 ) );
				#ifdef _CUSTOMPIVOT_ON
				float3 staticSwitch195_g93 = clampResult174_g93;
				#else
				float3 staticSwitch195_g93 = objToWorld192_g93;
				#endif
				#ifdef _INVERSEANIMATION3_ON
				float4 staticSwitch164_g93 = ( _OffsetPivot * -1.0 );
				#else
				float4 staticSwitch164_g93 = _OffsetPivot;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float3 worldToObj52_g93 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 rotatedValue23_g93 = RotateAroundAxis( ( float4( staticSwitch195_g93 , 0.0 ) + ( staticSwitch164_g93 / 100.0 ) ).xyz, worldToObj52_g93, staticSwitch63_g93, ( ( TransitionMask92_g93 * MaskMap42_g93 ) * _Angle ) );
				float3 FinalDisplacement36_g93 = ( ( v.ase_normal * lerpResult20_g93 ) + rotatedValue23_g93 );
				
				o.ase_texcoord8.xy = v.texcoord.xy;
				o.ase_normal = v.ase_normal;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord8.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = FinalDisplacement36_g93;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float3 positionVS = TransformWorldToView( positionWS );
				float4 positionCS = TransformWorldToHClip( positionWS );

				VertexNormalInputs normalInput = GetVertexNormalInputs( v.ase_normal, v.ase_tangent );

				o.tSpace0 = float4( normalInput.normalWS, positionWS.x);
				o.tSpace1 = float4( normalInput.tangentWS, positionWS.y);
				o.tSpace2 = float4( normalInput.bitangentWS, positionWS.z);

				#if defined(LIGHTMAP_ON)
					OUTPUT_LIGHTMAP_UV(v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy);
				#endif

				#if defined(DYNAMICLIGHTMAP_ON)
					o.dynamicLightmapUV.xy = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif

				#if !defined(LIGHTMAP_ON)
					OUTPUT_SH(normalInput.normalWS.xyz, o.lightmapUVOrVertexSH.xyz);
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					o.lightmapUVOrVertexSH.zw = v.texcoord.xy;
					o.lightmapUVOrVertexSH.xy = v.texcoord.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif

				half3 vertexLight = VertexLighting( positionWS, normalInput.normalWS );

				o.fogFactorAndVertexLight = half4(0, vertexLight);

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = positionCS;
				o.clipPosV = positionCS;
				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_tangent = v.ase_tangent;
				o.texcoord = v.texcoord;
				o.texcoord1 = v.texcoord1;
				o.texcoord2 = v.texcoord2;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				o.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			FragmentOutput frag ( VertexOutput IN
								#ifdef ASE_DEPTH_WRITE_ON
								,out float outputDepth : ASE_SV_DEPTH
								#endif
								 )
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float2 sampleCoords = (IN.lightmapUVOrVertexSH.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
					float3 WorldNormal = TransformObjectToWorldNormal(normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
					float3 WorldTangent = -cross(GetObjectToWorldMatrix()._13_23_33, WorldNormal);
					float3 WorldBiTangent = cross(WorldNormal, -WorldTangent);
				#else
					float3 WorldNormal = normalize( IN.tSpace0.xyz );
					float3 WorldTangent = IN.tSpace1.xyz;
					float3 WorldBiTangent = IN.tSpace2.xyz;
				#endif

				float3 WorldPosition = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 WorldViewDirection = _WorldSpaceCameraPos.xyz  - WorldPosition;
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				float4 ClipPos = IN.clipPosV;
				float4 ScreenPos = ComputeScreenPos( IN.clipPosV );

				float2 NormalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(IN.clipPos);

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					ShadowCoords = IN.shadowCoord;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
				#else
					ShadowCoords = float4(0, 0, 0, 0);
				#endif

				WorldViewDirection = SafeNormalize( WorldViewDirection );

				float2 uv_MainMap171_g93 = IN.ase_texcoord8.xy;
				float4 tex2DNode171_g93 = tex2D( _MainMap, uv_MainMap171_g93 );
				float3 objToViewDir129_g93 = mul( UNITY_MATRIX_IT_MV, float4( IN.ase_normal, 0 ) ).xyz;
				float3 normalizeResult128_g93 = normalize( objToViewDir129_g93 );
				float3 normal159_g93 = normalizeResult128_g93;
				float2 localMyCustomExpression159_g93 = MyCustomExpression159_g93( normal159_g93 );
				float3 desaturateInitialColor142_g93 = tex2D( _MainColorMap, localMyCustomExpression159_g93 ).rgb;
				float desaturateDot142_g93 = dot( desaturateInitialColor142_g93, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar142_g93 = lerp( desaturateInitialColor142_g93, desaturateDot142_g93.xxx, _Desaturation );
				float3 temp_cast_1 = (_ColorPow).xxx;
				#ifdef _MAPMATCAP_ON
				float4 staticSwitch144_g93 = ( float4( pow( desaturateVar142_g93 , temp_cast_1 ) , 0.0 ) * _MainColorMult * _ColorTransition );
				#else
				float4 staticSwitch144_g93 = tex2DNode171_g93;
				#endif
				#ifdef _COLORMAP_ON
				float4 staticSwitch143_g93 = _MainColor;
				#else
				float4 staticSwitch143_g93 = staticSwitch144_g93;
				#endif
				#ifdef _USEMAINTEXTURE_ON
				float4 staticSwitch167_g93 = tex2DNode171_g93;
				#else
				float4 staticSwitch167_g93 = _ColorTransition;
				#endif
				float3 break74_g93 = _WorldSpaceCameraPos;
				float3 appendResult73_g93 = (float3(( break74_g93.x * -1.0 ) , break74_g93.z , break74_g93.y));
				float3 temp_output_75_0_g93 = ( appendResult73_g93 * _Subdivision );
				float3 break67_g93 = WorldPosition;
				float3 appendResult72_g93 = (float3(( break67_g93.x * -1.0 ) , break67_g93.z , break67_g93.y));
				float3 temp_output_71_0_g93 = ( appendResult72_g93 * _Subdivision );
				float3 WP70_g93 = temp_output_71_0_g93;
				float3 temp_output_69_0_g93 = ( WP70_g93 * 1.0 );
				float3 normalizeResult84_g93 = normalize( ( temp_output_75_0_g93 - temp_output_69_0_g93 ) );
				float3 temp_output_1_0_g96 = normalizeResult84_g93;
				float3 temp_output_45_0_g96 = temp_output_75_0_g93;
				float dotResult22_g96 = dot( temp_output_1_0_g96 , temp_output_45_0_g96 );
				float3 temp_cast_3 = (0.5).xxx;
				float3 temp_output_2_0_g96 = ( ( ceil( temp_output_69_0_g93 ) / 1.0 ) - temp_cast_3 );
				float dotResult25_g96 = dot( temp_output_1_0_g96 , temp_output_2_0_g96 );
				float3 temp_output_30_0_g96 = ( WP70_g93 - temp_output_45_0_g96 );
				float dotResult28_g96 = dot( temp_output_1_0_g96 , temp_output_30_0_g96 );
				float temp_output_27_0_g96 = ( ( ( dotResult22_g96 - dotResult25_g96 ) * -1.0 ) / dotResult28_g96 );
				float3 normalizeResult27_g97 = normalize( temp_output_1_0_g96 );
				float3 normalizeResult31_g97 = normalize( float3(0,0.00015,-1) );
				float3 normalizeResult29_g97 = normalize( cross( normalizeResult27_g97 , normalizeResult31_g97 ) );
				float3 temp_output_7_0_g96 = ( normalizeResult29_g97 * float3( 1,1,1 ) );
				float3 temp_output_34_0_g96 = ( temp_output_45_0_g96 + ( temp_output_27_0_g96 * temp_output_30_0_g96 ) );
				float3 temp_output_35_0_g96 = ( temp_output_34_0_g96 - temp_output_2_0_g96 );
				float dotResult11_g96 = dot( temp_output_7_0_g96 , temp_output_35_0_g96 );
				float3 normalizeResult10_g96 = normalize( cross( temp_output_7_0_g96 , normalizeResult27_g97 ) );
				float dotResult12_g96 = dot( normalizeResult10_g96 , temp_output_35_0_g96 );
				float2 appendResult14_g96 = (float2(dotResult11_g96 , dotResult12_g96));
				float2 temp_cast_4 = (0.0).xx;
				float2 temp_cast_5 = (0.0).xx;
				float2 ifLocalVar15_g96 = 0;
				if( temp_output_27_0_g96 <= 0.0 )
				ifLocalVar15_g96 = temp_cast_5;
				else
				ifLocalVar15_g96 = appendResult14_g96;
				float2 texCoord46_g93 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord43_g93 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch182_g93 = texCoord43_g93.x;
				#else
				float staticSwitch182_g93 = texCoord43_g93.y;
				#endif
				float clampResult161_g93 = clamp( ( ( tex2D( _MaskMap, (texCoord46_g93*_TilingTransition + 0.0) ).r * _TransitionFactor ) + staticSwitch182_g93 ) , 0.0 , 1.0 );
				float2 texCoord44_g93 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_39_0_g93 = ( pow( tex2D( _MaskMap, (texCoord44_g93*_Tiling + 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_33_0_g93 = ( ( 1.0 - ( clampResult161_g93 * float3(1,1,1) ) ) + temp_output_39_0_g93 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch123_g93 = ( 1.0 - temp_output_33_0_g93 );
				#else
				float3 staticSwitch123_g93 = temp_output_33_0_g93;
				#endif
				float lerpResult150_g93 = lerp( 0.0 , 3.14 , _TransitionControlManualAnimationMode);
				float mulTime125_g93 = _TimeParameters.x * _Transition;
				float _Time147_g93 = mulTime125_g93;
				float _Period147_g93 = 2.0;
				float localMyCustomExpression147_g93 = MyCustomExpression147_g93( _Time147_g93 , _Period147_g93 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch180_g93 = localMyCustomExpression147_g93;
				#else
				float staticSwitch180_g93 = sin( lerpResult150_g93 );
				#endif
				#ifdef _INVERSEANIMATION2_ON
				float staticSwitch124_g93 = ( 1.0 - staticSwitch180_g93 );
				#else
				float staticSwitch124_g93 = staticSwitch180_g93;
				#endif
				#ifdef _INVERSEANIMATION4_ON
				float staticSwitch181_g93 = ( _Exp * 2.0 );
				#else
				float staticSwitch181_g93 = _Exp;
				#endif
				float3 temp_cast_6 = (( ( pow( staticSwitch124_g93 , staticSwitch181_g93 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult11_g93 = clamp( (( staticSwitch123_g93 - temp_cast_6 )).z , 0.0 , 1.0 );
				float temp_output_14_0_g93 = ( 1.0 - pow( clampResult11_g93 , 2.0 ) );
				float TransitionMask92_g93 = temp_output_14_0_g93;
				float MaskMap42_g93 = temp_output_39_0_g93;
				float lerpResult106_g93 = lerp( 0.0 , _Distortion , TransitionMask92_g93);
				float2 temp_output_107_0_g93 = ( ( ( ifLocalVar15_g96 / ( ( 1.0 - ( TransitionMask92_g93 * float2( 1,1 ) ) ) * _SizeWhenTransition ) ) + 0.5 ) + ( MaskMap42_g93 * lerpResult106_g93 ) );
				float2 temp_cast_7 = (0.5).xx;
				float lerpResult18_g93 = lerp( 1.0 , 0.0 , TransitionMask92_g93);
				float2 temp_output_7_0_g95 = ( ( temp_output_107_0_g93 - temp_cast_7 ) / lerpResult18_g93 );
				float2 temp_cast_8 = (0.5).xx;
				float dotResult2_g95 = dot( temp_output_7_0_g95 , temp_output_7_0_g95 );
				float lerpResult16_g93 = lerp( 1.0 , 0.1 , TransitionMask92_g93);
				float mulTime109_g93 = _TimeParameters.x * 2.0;
				float cos88_g93 = cos( ( mulTime109_g93 + TransitionMask92_g93 ) );
				float sin88_g93 = sin( ( mulTime109_g93 + TransitionMask92_g93 ) );
				float2 rotator88_g93 = mul( temp_output_107_0_g93 - float2( 0.5,0.5 ) , float2x2( cos88_g93 , -sin88_g93 , sin88_g93 , cos88_g93 )) + float2( 0.5,0.5 );
				float clampResult101_g93 = clamp( ( pow( tex2D( _Pattern, rotator88_g93 ).r , 6.0 ) + 0.1 ) , 0.0 , 1.0 );
				float clampResult97_g93 = clamp( ( clampResult101_g93 - TransitionMask92_g93 ) , 0.0 , 1.0 );
				float temp_output_86_0_g93 = ( 1.0 - (( _CustomTexture )?( ( 1.0 - clampResult97_g93 ) ):( pow( saturate( dotResult2_g95 ) , lerpResult16_g93 ) )) );
				float clampResult136_g93 = clamp( ( temp_output_86_0_g93 * _STEP ) , 0.0 , 1.0 );
				float4 temp_output_137_0_g93 = ( ( staticSwitch167_g93 * _EmissiveFctor * 1.0 ) * (( _DETAILES )?( frac( clampResult136_g93 ) ):( 1.0 )) );
				float4 lerpResult139_g93 = lerp( staticSwitch143_g93 , temp_output_137_0_g93 , pow( TransitionMask92_g93 , _SharpTransition ));
				float4 FinalColor157_g93 = lerpResult139_g93;
				
				float4 Emissive212_g93 = ( temp_output_137_0_g93 * TransitionMask92_g93 );
				
				float lerpResult91_g93 = lerp( 1.0 , temp_output_39_0_g93 , temp_output_14_0_g93);
				float lerpResult41_g93 = lerp( lerpResult91_g93 , 0.0 , TransitionMask92_g93);
				float temp_output_120_0_g93 = ( temp_output_86_0_g93 * lerpResult41_g93 );
				float FinalAlpha116_g93 = floor( ceil( temp_output_120_0_g93 ) );
				

				float3 BaseColor = FinalColor157_g93.rgb;
				float3 Normal = float3(0, 0, 1);
				float3 Emission = Emissive212_g93.rgb;
				float3 Specular = 0.5;
				float Metallic = _Metallic;
				float Smoothness = _Smoothness;
				float Occlusion = 1;
				float Alpha = FinalAlpha116_g93;
				float AlphaClipThreshold = 0.1;
				float AlphaClipThresholdShadow = 0.5;
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				float3 Transmission = 1;
				float3 Translucency = 1;

				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = IN.clipPos.z;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				InputData inputData = (InputData)0;
				inputData.positionWS = WorldPosition;
				inputData.positionCS = IN.clipPos;
				inputData.shadowCoord = ShadowCoords;

				#ifdef _NORMALMAP
					#if _NORMAL_DROPOFF_TS
						inputData.normalWS = TransformTangentToWorld(Normal, half3x3( WorldTangent, WorldBiTangent, WorldNormal ));
					#elif _NORMAL_DROPOFF_OS
						inputData.normalWS = TransformObjectToWorldNormal(Normal);
					#elif _NORMAL_DROPOFF_WS
						inputData.normalWS = Normal;
					#endif
				#else
					inputData.normalWS = WorldNormal;
				#endif

				inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
				inputData.viewDirectionWS = SafeNormalize( WorldViewDirection );

				inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float3 SH = SampleSH(inputData.normalWS.xyz);
				#else
					float3 SH = IN.lightmapUVOrVertexSH.xyz;
				#endif

				#ifdef ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#else
					#if defined(DYNAMICLIGHTMAP_ON)
						inputData.bakedGI = SAMPLE_GI( IN.lightmapUVOrVertexSH.xy, IN.dynamicLightmapUV.xy, SH, inputData.normalWS);
					#else
						inputData.bakedGI = SAMPLE_GI( IN.lightmapUVOrVertexSH.xy, SH, inputData.normalWS );
					#endif
				#endif

				inputData.normalizedScreenSpaceUV = NormalizedScreenSpaceUV;
				inputData.shadowMask = SAMPLE_SHADOWMASK(IN.lightmapUVOrVertexSH.xy);

				#if defined(DEBUG_DISPLAY)
					#if defined(DYNAMICLIGHTMAP_ON)
						inputData.dynamicLightmapUV = IN.dynamicLightmapUV.xy;
						#endif
					#if defined(LIGHTMAP_ON)
						inputData.staticLightmapUV = IN.lightmapUVOrVertexSH.xy;
					#else
						inputData.vertexSH = SH;
					#endif
				#endif

				#ifdef _DBUFFER
					ApplyDecal(IN.clipPos,
						BaseColor,
						Specular,
						inputData.normalWS,
						Metallic,
						Occlusion,
						Smoothness);
				#endif

				BRDFData brdfData;
				InitializeBRDFData
				(BaseColor, Metallic, Specular, Smoothness, Alpha, brdfData);

				Light mainLight = GetMainLight(inputData.shadowCoord, inputData.positionWS, inputData.shadowMask);
				half4 color;
				MixRealtimeAndBakedGI(mainLight, inputData.normalWS, inputData.bakedGI, inputData.shadowMask);
				color.rgb = GlobalIllumination(brdfData, inputData.bakedGI, Occlusion, inputData.positionWS, inputData.normalWS, inputData.viewDirectionWS);
				color.a = Alpha;

				#ifdef ASE_FINAL_COLOR_ALPHA_MULTIPLY
					color.rgb *= color.a;
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				return BRDFDataToGbuffer(brdfData, inputData, Smoothness, Emission + color.rgb, Occlusion);
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "SceneSelectionPass"
			Tags { "LightMode"="SceneSelectionPass" }

			Cull Off

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#define ASE_ABSOLUTE_VERTEX_POS 1
			#define _EMISSION
			#define _ALPHATEST_ON 1
			#define ASE_SRP_VERSION 120112


			#pragma vertex vert
			#pragma fragment frag

			#define SCENESELECTIONPASS 1

			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#pragma shader_feature_local _INVERSEDIRECTION_ON
			#pragma shader_feature_local _TRANSITIONXVSY_ON
			#pragma shader_feature_local _INVERSEANIMATION2_ON
			#pragma shader_feature_local _MANUALAUTOMATIC_ON
			#pragma shader_feature_local _INVERSEANIMATION4_ON
			#pragma shader_feature_local _INVERSEANIMATION1_ON
			#pragma shader_feature_local _CUSTOMPIVOT_ON
			#pragma shader_feature_local _INVERSEANIMATION3_ON


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _OffsetPivot;
			float4 _MainColor;
			float4 _ColorTransition;
			float3 _NormalizedRotationAxis;
			float3 _CustomPivotVec;
			float _Push;
			float _SharpTransition;
			float _STEP;
			float _Distortion;
			float _SizeWhenTransition;
			float _Subdivision;
			float _CustomTexture;
			float _DETAILES;
			float _EmissiveFctor;
			float _ColorPow;
			float _Metallic;
			float _Desaturation;
			float _Angle;
			float _Exp;
			float _Transition;
			float _TransitionControlManualAnimationMode;
			float _Tiling;
			float _TransitionFactor;
			float _TilingTransition;
			float _MainColorMult;
			float _Smoothness;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			// Property used by ScenePickingPass
			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			// Properties used by SceneSelectionPass
			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _MaskMap;
			sampler2D _Pattern;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			float MyCustomExpression147_g93( float _Time, float _Period )
			{
				// Calculate a sine wave value that oscillates between 0 and 1 over time
				float v = (sin(_Time * 2 * 3.14159 / _Period) + 1) * 0.5;
				return v ;
			}
			
			float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
			{
				original -= center;
				float C = cos( angle );
				float S = sin( angle );
				float t = 1 - C;
				float m00 = t * u.x * u.x + C;
				float m01 = t * u.x * u.y - S * u.z;
				float m02 = t * u.x * u.z + S * u.y;
				float m10 = t * u.x * u.y + S * u.z;
				float m11 = t * u.y * u.y + C;
				float m12 = t * u.y * u.z - S * u.x;
				float m20 = t * u.x * u.z - S * u.y;
				float m21 = t * u.y * u.z + S * u.x;
				float m22 = t * u.z * u.z + C;
				float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
				return mul( finalMatrix, original ) + center;
			}
			

			struct SurfaceDescription
			{
				float Alpha;
				float AlphaClipThreshold;
			};

			VertexOutput VertexFunction(VertexInput v  )
			{
				VertexOutput o;
				ZERO_INITIALIZE(VertexOutput, o);

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 texCoord46_g93 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord43_g93 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch182_g93 = texCoord43_g93.x;
				#else
				float staticSwitch182_g93 = texCoord43_g93.y;
				#endif
				float clampResult161_g93 = clamp( ( ( tex2Dlod( _MaskMap, float4( (texCoord46_g93*_TilingTransition + 0.0), 0, 0.0) ).r * _TransitionFactor ) + staticSwitch182_g93 ) , 0.0 , 1.0 );
				float2 texCoord44_g93 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_39_0_g93 = ( pow( tex2Dlod( _MaskMap, float4( (texCoord44_g93*_Tiling + 0.0), 0, 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_33_0_g93 = ( ( 1.0 - ( clampResult161_g93 * float3(1,1,1) ) ) + temp_output_39_0_g93 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch123_g93 = ( 1.0 - temp_output_33_0_g93 );
				#else
				float3 staticSwitch123_g93 = temp_output_33_0_g93;
				#endif
				float lerpResult150_g93 = lerp( 0.0 , 3.14 , _TransitionControlManualAnimationMode);
				float mulTime125_g93 = _TimeParameters.x * _Transition;
				float _Time147_g93 = mulTime125_g93;
				float _Period147_g93 = 2.0;
				float localMyCustomExpression147_g93 = MyCustomExpression147_g93( _Time147_g93 , _Period147_g93 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch180_g93 = localMyCustomExpression147_g93;
				#else
				float staticSwitch180_g93 = sin( lerpResult150_g93 );
				#endif
				#ifdef _INVERSEANIMATION2_ON
				float staticSwitch124_g93 = ( 1.0 - staticSwitch180_g93 );
				#else
				float staticSwitch124_g93 = staticSwitch180_g93;
				#endif
				#ifdef _INVERSEANIMATION4_ON
				float staticSwitch181_g93 = ( _Exp * 2.0 );
				#else
				float staticSwitch181_g93 = _Exp;
				#endif
				float3 temp_cast_0 = (( ( pow( staticSwitch124_g93 , staticSwitch181_g93 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult11_g93 = clamp( (( staticSwitch123_g93 - temp_cast_0 )).z , 0.0 , 1.0 );
				float temp_output_14_0_g93 = ( 1.0 - pow( clampResult11_g93 , 2.0 ) );
				float TransitionMask92_g93 = temp_output_14_0_g93;
				float lerpResult20_g93 = lerp( 0.0 , ( _Push / 100.0 ) , TransitionMask92_g93);
				#ifdef _INVERSEANIMATION1_ON
				float3 staticSwitch63_g93 = ( _NormalizedRotationAxis * -1.0 );
				#else
				float3 staticSwitch63_g93 = _NormalizedRotationAxis;
				#endif
				float MaskMap42_g93 = temp_output_39_0_g93;
				float4 transform191_g93 = mul(GetWorldToObjectMatrix(),float4( 0,0,0,1 ));
				float3 objToWorld192_g93 = mul( GetObjectToWorldMatrix(), float4( transform191_g93.xyz, 1 ) ).xyz;
				float3 clampResult174_g93 = clamp( _CustomPivotVec , float3( -1.5,-1.5,-1.5 ) , float3( 1.5,1.5,1.5 ) );
				#ifdef _CUSTOMPIVOT_ON
				float3 staticSwitch195_g93 = clampResult174_g93;
				#else
				float3 staticSwitch195_g93 = objToWorld192_g93;
				#endif
				#ifdef _INVERSEANIMATION3_ON
				float4 staticSwitch164_g93 = ( _OffsetPivot * -1.0 );
				#else
				float4 staticSwitch164_g93 = _OffsetPivot;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float3 worldToObj52_g93 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 rotatedValue23_g93 = RotateAroundAxis( ( float4( staticSwitch195_g93 , 0.0 ) + ( staticSwitch164_g93 / 100.0 ) ).xyz, worldToObj52_g93, staticSwitch63_g93, ( ( TransitionMask92_g93 * MaskMap42_g93 ) * _Angle ) );
				float3 FinalDisplacement36_g93 = ( ( v.ase_normal * lerpResult20_g93 ) + rotatedValue23_g93 );
				
				o.ase_texcoord.xyz = ase_worldPos;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.w = 0;
				o.ase_texcoord1.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = FinalDisplacement36_g93;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );

				o.clipPos = TransformWorldToHClip(positionWS);

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN ) : SV_TARGET
			{
				SurfaceDescription surfaceDescription = (SurfaceDescription)0;

				float3 break74_g93 = _WorldSpaceCameraPos;
				float3 appendResult73_g93 = (float3(( break74_g93.x * -1.0 ) , break74_g93.z , break74_g93.y));
				float3 temp_output_75_0_g93 = ( appendResult73_g93 * _Subdivision );
				float3 ase_worldPos = IN.ase_texcoord.xyz;
				float3 break67_g93 = ase_worldPos;
				float3 appendResult72_g93 = (float3(( break67_g93.x * -1.0 ) , break67_g93.z , break67_g93.y));
				float3 temp_output_71_0_g93 = ( appendResult72_g93 * _Subdivision );
				float3 WP70_g93 = temp_output_71_0_g93;
				float3 temp_output_69_0_g93 = ( WP70_g93 * 1.0 );
				float3 normalizeResult84_g93 = normalize( ( temp_output_75_0_g93 - temp_output_69_0_g93 ) );
				float3 temp_output_1_0_g96 = normalizeResult84_g93;
				float3 temp_output_45_0_g96 = temp_output_75_0_g93;
				float dotResult22_g96 = dot( temp_output_1_0_g96 , temp_output_45_0_g96 );
				float3 temp_cast_0 = (0.5).xxx;
				float3 temp_output_2_0_g96 = ( ( ceil( temp_output_69_0_g93 ) / 1.0 ) - temp_cast_0 );
				float dotResult25_g96 = dot( temp_output_1_0_g96 , temp_output_2_0_g96 );
				float3 temp_output_30_0_g96 = ( WP70_g93 - temp_output_45_0_g96 );
				float dotResult28_g96 = dot( temp_output_1_0_g96 , temp_output_30_0_g96 );
				float temp_output_27_0_g96 = ( ( ( dotResult22_g96 - dotResult25_g96 ) * -1.0 ) / dotResult28_g96 );
				float3 normalizeResult27_g97 = normalize( temp_output_1_0_g96 );
				float3 normalizeResult31_g97 = normalize( float3(0,0.00015,-1) );
				float3 normalizeResult29_g97 = normalize( cross( normalizeResult27_g97 , normalizeResult31_g97 ) );
				float3 temp_output_7_0_g96 = ( normalizeResult29_g97 * float3( 1,1,1 ) );
				float3 temp_output_34_0_g96 = ( temp_output_45_0_g96 + ( temp_output_27_0_g96 * temp_output_30_0_g96 ) );
				float3 temp_output_35_0_g96 = ( temp_output_34_0_g96 - temp_output_2_0_g96 );
				float dotResult11_g96 = dot( temp_output_7_0_g96 , temp_output_35_0_g96 );
				float3 normalizeResult10_g96 = normalize( cross( temp_output_7_0_g96 , normalizeResult27_g97 ) );
				float dotResult12_g96 = dot( normalizeResult10_g96 , temp_output_35_0_g96 );
				float2 appendResult14_g96 = (float2(dotResult11_g96 , dotResult12_g96));
				float2 temp_cast_1 = (0.0).xx;
				float2 temp_cast_2 = (0.0).xx;
				float2 ifLocalVar15_g96 = 0;
				if( temp_output_27_0_g96 <= 0.0 )
				ifLocalVar15_g96 = temp_cast_2;
				else
				ifLocalVar15_g96 = appendResult14_g96;
				float2 texCoord46_g93 = IN.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord43_g93 = IN.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch182_g93 = texCoord43_g93.x;
				#else
				float staticSwitch182_g93 = texCoord43_g93.y;
				#endif
				float clampResult161_g93 = clamp( ( ( tex2D( _MaskMap, (texCoord46_g93*_TilingTransition + 0.0) ).r * _TransitionFactor ) + staticSwitch182_g93 ) , 0.0 , 1.0 );
				float2 texCoord44_g93 = IN.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_39_0_g93 = ( pow( tex2D( _MaskMap, (texCoord44_g93*_Tiling + 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_33_0_g93 = ( ( 1.0 - ( clampResult161_g93 * float3(1,1,1) ) ) + temp_output_39_0_g93 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch123_g93 = ( 1.0 - temp_output_33_0_g93 );
				#else
				float3 staticSwitch123_g93 = temp_output_33_0_g93;
				#endif
				float lerpResult150_g93 = lerp( 0.0 , 3.14 , _TransitionControlManualAnimationMode);
				float mulTime125_g93 = _TimeParameters.x * _Transition;
				float _Time147_g93 = mulTime125_g93;
				float _Period147_g93 = 2.0;
				float localMyCustomExpression147_g93 = MyCustomExpression147_g93( _Time147_g93 , _Period147_g93 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch180_g93 = localMyCustomExpression147_g93;
				#else
				float staticSwitch180_g93 = sin( lerpResult150_g93 );
				#endif
				#ifdef _INVERSEANIMATION2_ON
				float staticSwitch124_g93 = ( 1.0 - staticSwitch180_g93 );
				#else
				float staticSwitch124_g93 = staticSwitch180_g93;
				#endif
				#ifdef _INVERSEANIMATION4_ON
				float staticSwitch181_g93 = ( _Exp * 2.0 );
				#else
				float staticSwitch181_g93 = _Exp;
				#endif
				float3 temp_cast_3 = (( ( pow( staticSwitch124_g93 , staticSwitch181_g93 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult11_g93 = clamp( (( staticSwitch123_g93 - temp_cast_3 )).z , 0.0 , 1.0 );
				float temp_output_14_0_g93 = ( 1.0 - pow( clampResult11_g93 , 2.0 ) );
				float TransitionMask92_g93 = temp_output_14_0_g93;
				float MaskMap42_g93 = temp_output_39_0_g93;
				float lerpResult106_g93 = lerp( 0.0 , _Distortion , TransitionMask92_g93);
				float2 temp_output_107_0_g93 = ( ( ( ifLocalVar15_g96 / ( ( 1.0 - ( TransitionMask92_g93 * float2( 1,1 ) ) ) * _SizeWhenTransition ) ) + 0.5 ) + ( MaskMap42_g93 * lerpResult106_g93 ) );
				float2 temp_cast_4 = (0.5).xx;
				float lerpResult18_g93 = lerp( 1.0 , 0.0 , TransitionMask92_g93);
				float2 temp_output_7_0_g95 = ( ( temp_output_107_0_g93 - temp_cast_4 ) / lerpResult18_g93 );
				float2 temp_cast_5 = (0.5).xx;
				float dotResult2_g95 = dot( temp_output_7_0_g95 , temp_output_7_0_g95 );
				float lerpResult16_g93 = lerp( 1.0 , 0.1 , TransitionMask92_g93);
				float mulTime109_g93 = _TimeParameters.x * 2.0;
				float cos88_g93 = cos( ( mulTime109_g93 + TransitionMask92_g93 ) );
				float sin88_g93 = sin( ( mulTime109_g93 + TransitionMask92_g93 ) );
				float2 rotator88_g93 = mul( temp_output_107_0_g93 - float2( 0.5,0.5 ) , float2x2( cos88_g93 , -sin88_g93 , sin88_g93 , cos88_g93 )) + float2( 0.5,0.5 );
				float clampResult101_g93 = clamp( ( pow( tex2D( _Pattern, rotator88_g93 ).r , 6.0 ) + 0.1 ) , 0.0 , 1.0 );
				float clampResult97_g93 = clamp( ( clampResult101_g93 - TransitionMask92_g93 ) , 0.0 , 1.0 );
				float temp_output_86_0_g93 = ( 1.0 - (( _CustomTexture )?( ( 1.0 - clampResult97_g93 ) ):( pow( saturate( dotResult2_g95 ) , lerpResult16_g93 ) )) );
				float lerpResult91_g93 = lerp( 1.0 , temp_output_39_0_g93 , temp_output_14_0_g93);
				float lerpResult41_g93 = lerp( lerpResult91_g93 , 0.0 , TransitionMask92_g93);
				float temp_output_120_0_g93 = ( temp_output_86_0_g93 * lerpResult41_g93 );
				float FinalAlpha116_g93 = floor( ceil( temp_output_120_0_g93 ) );
				

				surfaceDescription.Alpha = FinalAlpha116_g93;
				surfaceDescription.AlphaClipThreshold = 0.1;

				#if _ALPHATEST_ON
					float alphaClipThreshold = 0.01f;
					#if ALPHA_CLIP_THRESHOLD
						alphaClipThreshold = surfaceDescription.AlphaClipThreshold;
					#endif
					clip(surfaceDescription.Alpha - alphaClipThreshold);
				#endif

				half4 outColor = 0;

				#ifdef SCENESELECTIONPASS
					outColor = half4(_ObjectId, _PassValue, 1.0, 1.0);
				#elif defined(SCENEPICKINGPASS)
					outColor = _SelectionID;
				#endif

				return outColor;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "ScenePickingPass"
			Tags { "LightMode"="Picking" }

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#define ASE_ABSOLUTE_VERTEX_POS 1
			#define _EMISSION
			#define _ALPHATEST_ON 1
			#define ASE_SRP_VERSION 120112


			#pragma vertex vert
			#pragma fragment frag

		    #define SCENEPICKINGPASS 1

			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#pragma shader_feature_local _INVERSEDIRECTION_ON
			#pragma shader_feature_local _TRANSITIONXVSY_ON
			#pragma shader_feature_local _INVERSEANIMATION2_ON
			#pragma shader_feature_local _MANUALAUTOMATIC_ON
			#pragma shader_feature_local _INVERSEANIMATION4_ON
			#pragma shader_feature_local _INVERSEANIMATION1_ON
			#pragma shader_feature_local _CUSTOMPIVOT_ON
			#pragma shader_feature_local _INVERSEANIMATION3_ON


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _OffsetPivot;
			float4 _MainColor;
			float4 _ColorTransition;
			float3 _NormalizedRotationAxis;
			float3 _CustomPivotVec;
			float _Push;
			float _SharpTransition;
			float _STEP;
			float _Distortion;
			float _SizeWhenTransition;
			float _Subdivision;
			float _CustomTexture;
			float _DETAILES;
			float _EmissiveFctor;
			float _ColorPow;
			float _Metallic;
			float _Desaturation;
			float _Angle;
			float _Exp;
			float _Transition;
			float _TransitionControlManualAnimationMode;
			float _Tiling;
			float _TransitionFactor;
			float _TilingTransition;
			float _MainColorMult;
			float _Smoothness;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			// Property used by ScenePickingPass
			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			// Properties used by SceneSelectionPass
			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _MaskMap;
			sampler2D _Pattern;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			float MyCustomExpression147_g93( float _Time, float _Period )
			{
				// Calculate a sine wave value that oscillates between 0 and 1 over time
				float v = (sin(_Time * 2 * 3.14159 / _Period) + 1) * 0.5;
				return v ;
			}
			
			float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
			{
				original -= center;
				float C = cos( angle );
				float S = sin( angle );
				float t = 1 - C;
				float m00 = t * u.x * u.x + C;
				float m01 = t * u.x * u.y - S * u.z;
				float m02 = t * u.x * u.z + S * u.y;
				float m10 = t * u.x * u.y + S * u.z;
				float m11 = t * u.y * u.y + C;
				float m12 = t * u.y * u.z - S * u.x;
				float m20 = t * u.x * u.z - S * u.y;
				float m21 = t * u.y * u.z + S * u.x;
				float m22 = t * u.z * u.z + C;
				float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
				return mul( finalMatrix, original ) + center;
			}
			

			struct SurfaceDescription
			{
				float Alpha;
				float AlphaClipThreshold;
			};

			VertexOutput VertexFunction(VertexInput v  )
			{
				VertexOutput o;
				ZERO_INITIALIZE(VertexOutput, o);

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 texCoord46_g93 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord43_g93 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch182_g93 = texCoord43_g93.x;
				#else
				float staticSwitch182_g93 = texCoord43_g93.y;
				#endif
				float clampResult161_g93 = clamp( ( ( tex2Dlod( _MaskMap, float4( (texCoord46_g93*_TilingTransition + 0.0), 0, 0.0) ).r * _TransitionFactor ) + staticSwitch182_g93 ) , 0.0 , 1.0 );
				float2 texCoord44_g93 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_39_0_g93 = ( pow( tex2Dlod( _MaskMap, float4( (texCoord44_g93*_Tiling + 0.0), 0, 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_33_0_g93 = ( ( 1.0 - ( clampResult161_g93 * float3(1,1,1) ) ) + temp_output_39_0_g93 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch123_g93 = ( 1.0 - temp_output_33_0_g93 );
				#else
				float3 staticSwitch123_g93 = temp_output_33_0_g93;
				#endif
				float lerpResult150_g93 = lerp( 0.0 , 3.14 , _TransitionControlManualAnimationMode);
				float mulTime125_g93 = _TimeParameters.x * _Transition;
				float _Time147_g93 = mulTime125_g93;
				float _Period147_g93 = 2.0;
				float localMyCustomExpression147_g93 = MyCustomExpression147_g93( _Time147_g93 , _Period147_g93 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch180_g93 = localMyCustomExpression147_g93;
				#else
				float staticSwitch180_g93 = sin( lerpResult150_g93 );
				#endif
				#ifdef _INVERSEANIMATION2_ON
				float staticSwitch124_g93 = ( 1.0 - staticSwitch180_g93 );
				#else
				float staticSwitch124_g93 = staticSwitch180_g93;
				#endif
				#ifdef _INVERSEANIMATION4_ON
				float staticSwitch181_g93 = ( _Exp * 2.0 );
				#else
				float staticSwitch181_g93 = _Exp;
				#endif
				float3 temp_cast_0 = (( ( pow( staticSwitch124_g93 , staticSwitch181_g93 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult11_g93 = clamp( (( staticSwitch123_g93 - temp_cast_0 )).z , 0.0 , 1.0 );
				float temp_output_14_0_g93 = ( 1.0 - pow( clampResult11_g93 , 2.0 ) );
				float TransitionMask92_g93 = temp_output_14_0_g93;
				float lerpResult20_g93 = lerp( 0.0 , ( _Push / 100.0 ) , TransitionMask92_g93);
				#ifdef _INVERSEANIMATION1_ON
				float3 staticSwitch63_g93 = ( _NormalizedRotationAxis * -1.0 );
				#else
				float3 staticSwitch63_g93 = _NormalizedRotationAxis;
				#endif
				float MaskMap42_g93 = temp_output_39_0_g93;
				float4 transform191_g93 = mul(GetWorldToObjectMatrix(),float4( 0,0,0,1 ));
				float3 objToWorld192_g93 = mul( GetObjectToWorldMatrix(), float4( transform191_g93.xyz, 1 ) ).xyz;
				float3 clampResult174_g93 = clamp( _CustomPivotVec , float3( -1.5,-1.5,-1.5 ) , float3( 1.5,1.5,1.5 ) );
				#ifdef _CUSTOMPIVOT_ON
				float3 staticSwitch195_g93 = clampResult174_g93;
				#else
				float3 staticSwitch195_g93 = objToWorld192_g93;
				#endif
				#ifdef _INVERSEANIMATION3_ON
				float4 staticSwitch164_g93 = ( _OffsetPivot * -1.0 );
				#else
				float4 staticSwitch164_g93 = _OffsetPivot;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float3 worldToObj52_g93 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 rotatedValue23_g93 = RotateAroundAxis( ( float4( staticSwitch195_g93 , 0.0 ) + ( staticSwitch164_g93 / 100.0 ) ).xyz, worldToObj52_g93, staticSwitch63_g93, ( ( TransitionMask92_g93 * MaskMap42_g93 ) * _Angle ) );
				float3 FinalDisplacement36_g93 = ( ( v.ase_normal * lerpResult20_g93 ) + rotatedValue23_g93 );
				
				o.ase_texcoord.xyz = ase_worldPos;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.w = 0;
				o.ase_texcoord1.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = FinalDisplacement36_g93;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				o.clipPos = TransformWorldToHClip(positionWS);

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN ) : SV_TARGET
			{
				SurfaceDescription surfaceDescription = (SurfaceDescription)0;

				float3 break74_g93 = _WorldSpaceCameraPos;
				float3 appendResult73_g93 = (float3(( break74_g93.x * -1.0 ) , break74_g93.z , break74_g93.y));
				float3 temp_output_75_0_g93 = ( appendResult73_g93 * _Subdivision );
				float3 ase_worldPos = IN.ase_texcoord.xyz;
				float3 break67_g93 = ase_worldPos;
				float3 appendResult72_g93 = (float3(( break67_g93.x * -1.0 ) , break67_g93.z , break67_g93.y));
				float3 temp_output_71_0_g93 = ( appendResult72_g93 * _Subdivision );
				float3 WP70_g93 = temp_output_71_0_g93;
				float3 temp_output_69_0_g93 = ( WP70_g93 * 1.0 );
				float3 normalizeResult84_g93 = normalize( ( temp_output_75_0_g93 - temp_output_69_0_g93 ) );
				float3 temp_output_1_0_g96 = normalizeResult84_g93;
				float3 temp_output_45_0_g96 = temp_output_75_0_g93;
				float dotResult22_g96 = dot( temp_output_1_0_g96 , temp_output_45_0_g96 );
				float3 temp_cast_0 = (0.5).xxx;
				float3 temp_output_2_0_g96 = ( ( ceil( temp_output_69_0_g93 ) / 1.0 ) - temp_cast_0 );
				float dotResult25_g96 = dot( temp_output_1_0_g96 , temp_output_2_0_g96 );
				float3 temp_output_30_0_g96 = ( WP70_g93 - temp_output_45_0_g96 );
				float dotResult28_g96 = dot( temp_output_1_0_g96 , temp_output_30_0_g96 );
				float temp_output_27_0_g96 = ( ( ( dotResult22_g96 - dotResult25_g96 ) * -1.0 ) / dotResult28_g96 );
				float3 normalizeResult27_g97 = normalize( temp_output_1_0_g96 );
				float3 normalizeResult31_g97 = normalize( float3(0,0.00015,-1) );
				float3 normalizeResult29_g97 = normalize( cross( normalizeResult27_g97 , normalizeResult31_g97 ) );
				float3 temp_output_7_0_g96 = ( normalizeResult29_g97 * float3( 1,1,1 ) );
				float3 temp_output_34_0_g96 = ( temp_output_45_0_g96 + ( temp_output_27_0_g96 * temp_output_30_0_g96 ) );
				float3 temp_output_35_0_g96 = ( temp_output_34_0_g96 - temp_output_2_0_g96 );
				float dotResult11_g96 = dot( temp_output_7_0_g96 , temp_output_35_0_g96 );
				float3 normalizeResult10_g96 = normalize( cross( temp_output_7_0_g96 , normalizeResult27_g97 ) );
				float dotResult12_g96 = dot( normalizeResult10_g96 , temp_output_35_0_g96 );
				float2 appendResult14_g96 = (float2(dotResult11_g96 , dotResult12_g96));
				float2 temp_cast_1 = (0.0).xx;
				float2 temp_cast_2 = (0.0).xx;
				float2 ifLocalVar15_g96 = 0;
				if( temp_output_27_0_g96 <= 0.0 )
				ifLocalVar15_g96 = temp_cast_2;
				else
				ifLocalVar15_g96 = appendResult14_g96;
				float2 texCoord46_g93 = IN.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord43_g93 = IN.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch182_g93 = texCoord43_g93.x;
				#else
				float staticSwitch182_g93 = texCoord43_g93.y;
				#endif
				float clampResult161_g93 = clamp( ( ( tex2D( _MaskMap, (texCoord46_g93*_TilingTransition + 0.0) ).r * _TransitionFactor ) + staticSwitch182_g93 ) , 0.0 , 1.0 );
				float2 texCoord44_g93 = IN.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_39_0_g93 = ( pow( tex2D( _MaskMap, (texCoord44_g93*_Tiling + 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_33_0_g93 = ( ( 1.0 - ( clampResult161_g93 * float3(1,1,1) ) ) + temp_output_39_0_g93 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch123_g93 = ( 1.0 - temp_output_33_0_g93 );
				#else
				float3 staticSwitch123_g93 = temp_output_33_0_g93;
				#endif
				float lerpResult150_g93 = lerp( 0.0 , 3.14 , _TransitionControlManualAnimationMode);
				float mulTime125_g93 = _TimeParameters.x * _Transition;
				float _Time147_g93 = mulTime125_g93;
				float _Period147_g93 = 2.0;
				float localMyCustomExpression147_g93 = MyCustomExpression147_g93( _Time147_g93 , _Period147_g93 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch180_g93 = localMyCustomExpression147_g93;
				#else
				float staticSwitch180_g93 = sin( lerpResult150_g93 );
				#endif
				#ifdef _INVERSEANIMATION2_ON
				float staticSwitch124_g93 = ( 1.0 - staticSwitch180_g93 );
				#else
				float staticSwitch124_g93 = staticSwitch180_g93;
				#endif
				#ifdef _INVERSEANIMATION4_ON
				float staticSwitch181_g93 = ( _Exp * 2.0 );
				#else
				float staticSwitch181_g93 = _Exp;
				#endif
				float3 temp_cast_3 = (( ( pow( staticSwitch124_g93 , staticSwitch181_g93 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult11_g93 = clamp( (( staticSwitch123_g93 - temp_cast_3 )).z , 0.0 , 1.0 );
				float temp_output_14_0_g93 = ( 1.0 - pow( clampResult11_g93 , 2.0 ) );
				float TransitionMask92_g93 = temp_output_14_0_g93;
				float MaskMap42_g93 = temp_output_39_0_g93;
				float lerpResult106_g93 = lerp( 0.0 , _Distortion , TransitionMask92_g93);
				float2 temp_output_107_0_g93 = ( ( ( ifLocalVar15_g96 / ( ( 1.0 - ( TransitionMask92_g93 * float2( 1,1 ) ) ) * _SizeWhenTransition ) ) + 0.5 ) + ( MaskMap42_g93 * lerpResult106_g93 ) );
				float2 temp_cast_4 = (0.5).xx;
				float lerpResult18_g93 = lerp( 1.0 , 0.0 , TransitionMask92_g93);
				float2 temp_output_7_0_g95 = ( ( temp_output_107_0_g93 - temp_cast_4 ) / lerpResult18_g93 );
				float2 temp_cast_5 = (0.5).xx;
				float dotResult2_g95 = dot( temp_output_7_0_g95 , temp_output_7_0_g95 );
				float lerpResult16_g93 = lerp( 1.0 , 0.1 , TransitionMask92_g93);
				float mulTime109_g93 = _TimeParameters.x * 2.0;
				float cos88_g93 = cos( ( mulTime109_g93 + TransitionMask92_g93 ) );
				float sin88_g93 = sin( ( mulTime109_g93 + TransitionMask92_g93 ) );
				float2 rotator88_g93 = mul( temp_output_107_0_g93 - float2( 0.5,0.5 ) , float2x2( cos88_g93 , -sin88_g93 , sin88_g93 , cos88_g93 )) + float2( 0.5,0.5 );
				float clampResult101_g93 = clamp( ( pow( tex2D( _Pattern, rotator88_g93 ).r , 6.0 ) + 0.1 ) , 0.0 , 1.0 );
				float clampResult97_g93 = clamp( ( clampResult101_g93 - TransitionMask92_g93 ) , 0.0 , 1.0 );
				float temp_output_86_0_g93 = ( 1.0 - (( _CustomTexture )?( ( 1.0 - clampResult97_g93 ) ):( pow( saturate( dotResult2_g95 ) , lerpResult16_g93 ) )) );
				float lerpResult91_g93 = lerp( 1.0 , temp_output_39_0_g93 , temp_output_14_0_g93);
				float lerpResult41_g93 = lerp( lerpResult91_g93 , 0.0 , TransitionMask92_g93);
				float temp_output_120_0_g93 = ( temp_output_86_0_g93 * lerpResult41_g93 );
				float FinalAlpha116_g93 = floor( ceil( temp_output_120_0_g93 ) );
				

				surfaceDescription.Alpha = FinalAlpha116_g93;
				surfaceDescription.AlphaClipThreshold = 0.1;

				#if _ALPHATEST_ON
					float alphaClipThreshold = 0.01f;
					#if ALPHA_CLIP_THRESHOLD
						alphaClipThreshold = surfaceDescription.AlphaClipThreshold;
					#endif
						clip(surfaceDescription.Alpha - alphaClipThreshold);
				#endif

				half4 outColor = 0;

				#ifdef SCENESELECTIONPASS
					outColor = half4(_ObjectId, _PassValue, 1.0, 1.0);
				#elif defined(SCENEPICKINGPASS)
					outColor = _SelectionID;
				#endif

				return outColor;
			}

			ENDHLSL
		}
		
	}
	
	
	FallBack "Hidden/Shader Graph/FallbackError"
	
	Fallback "Hidden/InternalErrorShader"
}
/*ASEBEGIN
Version=19108
Node;AmplifyShaderEditor.CommentaryNode;351;7049.35,809.4265;Inherit;False;605.0422;559.5523;Outputs;0;;0.3057392,0.9245283,0.09303422,1;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;608;7352.587,859.4264;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;0;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;609;7352.587,859.4264;Float;False;True;-1;2;;0;12;UltimateDissolveFX_Shader_With_Function;94348b07e5e8bab40bd6c8a1e3df54cd;True;Forward;0;1;Forward;20;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;True;1;1;False;;0;False;;1;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalForward;False;False;0;Hidden/InternalErrorShader;0;0;Standard;41;Workflow;1;0;Surface;0;0;  Refraction Model;0;0;  Blend;0;0;Two Sided;1;0;Fragment Normal Space,InvertActionOnDeselection;0;0;Forward Only;0;0;Transmission;0;0;  Transmission Shadow;0.5,False,;0;Translucency;0;0;  Translucency Strength;1,False,;0;  Normal Distortion;0.5,False,;0;  Scattering;2,False,;0;  Direct;0.9,False,;0;  Ambient;0.1,False,;0;  Shadow;0.5,False,;0;Cast Shadows;1;0;  Use Shadow Threshold;0;0;Receive Shadows;1;0;GPU Instancing;1;0;LOD CrossFade;1;0;Built-in Fog;1;0;_FinalColorxAlpha;0;0;Meta Pass;1;0;Override Baked GI;0;0;Extra Pre Pass;0;0;DOTS Instancing;0;0;Tessellation;0;0;  Phong;0;0;  Strength;0.5,False,;0;  Type;0;0;  Tess;16,False,;0;  Min;10,False,;0;  Max;25,False,;0;  Edge Length;16,False,;0;  Max Displacement;25,False,;0;Write Depth;0;0;  Early Z;0;0;Vertex Position,InvertActionOnDeselection;0;638162030333448931;Debug Display;0;0;Clear Coat;0;0;0;10;False;True;True;True;True;True;True;True;True;True;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;610;7352.587,859.4264;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=ShadowCaster;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;611;7352.587,859.4264;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;False;False;True;1;LightMode=DepthOnly;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;612;7352.587,859.4264;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;613;7352.587,859.4264;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Universal2D;0;5;Universal2D;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;True;1;1;False;;0;False;;1;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=Universal2D;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;614;7352.587,859.4264;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthNormals;0;6;DepthNormals;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=DepthNormals;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;615;7352.587,859.4264;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;GBuffer;0;7;GBuffer;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;True;1;1;False;;0;False;;1;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalGBuffer;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;618;7352.587,939.4264;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;SceneSelectionPass;0;8;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;619;7352.587,939.4264;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ScenePickingPass;0;9;ScenePickingPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Picking;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.RangedFloatNode;600;6458.19,953.5081;Inherit;False;Property;_Smoothness;Smoothness;2;0;Create;False;0;0;0;False;0;False;0.2;0.462;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;599;6745.19,924.5081;Inherit;False;Property;_Metallic;Metallic;1;0;Create;True;0;0;0;False;0;False;0.2;0.063;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;588;6898.846,1018.649;Inherit;False;Constant;_Cutoff;Cutoff;3;0;Create;True;0;0;0;False;0;False;0.1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;629;6225.078,683.5581;Inherit;False;Property;_TransitionControlManualAnimationMode;TransitionControl (Manual Animation Mode);0;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;631;7125.078,552.5581;Inherit;False;Constant;_Vector0;Vector 0;4;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;632;6669.078,685.5581;Inherit;False;MF_UltimateDissolveFX;3;;93;ad15fac1a5a41204f9427c4d4ce0c1fb;0;1;208;FLOAT;0;False;4;COLOR;0;COLOR;202;FLOAT;203;FLOAT3;204
WireConnection;609;0;632;0
WireConnection;609;2;632;202
WireConnection;609;3;599;0
WireConnection;609;4;600;0
WireConnection;609;6;632;203
WireConnection;609;7;588;0
WireConnection;609;8;632;204
WireConnection;632;208;629;0
ASEEND*/
//CHKSM=959FF289B1AEFDD98DD1060415935F0AE6F966ED