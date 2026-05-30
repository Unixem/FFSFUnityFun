// Made with Amplify Shader Editor v1.9.1.7
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "UltimateDissolveFX_Shader"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[Toggle]_CustomTexture("Custom Pattern Shape", Float) = 0
		_SizeWhenTransition("SizeWhenTransition", Range( 0 , 3)) = 1
		[Toggle(_INVERSEDIRECTION_ON)] _InverseDirection("InverseDirection", Float) = 0
		[NoScaleOffset]_MainColorMap("MainColorMap", 2D) = "white" {}
		_Transition("AnimationSpeed", Range( 0 , 1)) = 0.88
		[Toggle(_INVERSEANIMATION_ON)] _InverseAnimation("InverseAnimation", Float) = 0
		_Exp("Transition Falloff", Range( 0 , 2)) = 1
		_Tiling("Tiling", Range( 0 , 4)) = 0.5
		_MainColorMult("MainColorMult", Range( 0 , 24)) = 1
		_Push("Vertices Push Mult", Float) = 0
		_OffsetPivot("Pivot Offset (Obj Pivot Offset)", Vector) = (10,0,0,1)
		_Angle("Rotation Angle", Float) = 8
		_Subdivision("Subdivision", Float) = 400
		[HDR]_ColorTransition("ColorTransition", Color) = (1,1,1,0)
		_SharpTransition("Transition Softness", Range( 0.05 , 2)) = 0.2
		_STEP("(Outlines) Steps", Range( 0 , 10)) = 0.3
		[Toggle]_DETAILES("Outlines (If Possible)", Float) = 0
		_Pattern("Pattern", 2D) = "white" {}
		_Distortion("Pattern Distortion", Range( 0 , 20)) = 1
		_TilingTransition("TilingTransition", Range( 0 , 10)) = 1
		_TransitionFactor("Transition Strength ", Range( -1 , 1)) = 0.2
		_NormalizedRotationAxis("Rotation Axis", Vector) = (0.05,0.2,1.1,0)
		_ManualTransition("Manual Transition", Range( 0 , 1)) = 0.5
		[Toggle(_MANUALAUTOMATIC_ON)] _ManualAutomatic("Manual / Automatic", Float) = 1
		_EmissiveFctor("Emissive Mult", Float) = 10
		[Toggle(_COLORMAP_ON)] _ColorMap("Color / Map", Float) = 1
		_ColorPow("Color Pow", Range( 0.25 , 5)) = 1
		[Toggle(_MAPMATCAP_ON)] _MapMatCap("Map / MatCap", Float) = 1
		[NoScaleOffset]_MainMap("MainMap", 2D) = "white" {}
		_MainColor("MainColor", Color) = (0.1415094,0.1415094,0.1415094,0)
		_Desaturation("Desaturation", Range( 0 , 1)) = 0
		_MaskMap("MaskMap", 2D) = "white" {}
		_Metallic("Metallic", Range( 0 , 2)) = 0.91
		_NormalMap("Normal Map", 2D) = "white" {}
		_Smoothness("Smoothness", Range( 0 , 2)) = 0.4
		[Toggle(_USENORMALMAP_ON)] _UseNormalMap("UseNormalMap", Float) = 0
		[Toggle(_TRANSITIONXVSY_ON)] _TransitionXvsY("Transition Axis : X vs Y", Float) = 0
		[Toggle(_CUSTOMPIVOT_ON)] _CustomPivot("New Custom Pivot Position", Float) = 0
		_CustomPivotVec("CustomPivotVec", Vector) = (0,0,0,0)
		[ASEEnd][Toggle(_USEMAINTEXTURE_ON)] _UseMainTexture("UseMainTexture", Float) = 0
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
			#define _ALPHATEST_ON 1
			#define ASE_SRP_VERSION 140008


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
			#pragma multi_compile _ _FORWARD_PLUS

			#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
			#pragma multi_compile _ SHADOWS_SHADOWMASK
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#pragma multi_compile_fragment _ _WRITE_RENDERING_LAYERS

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
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"

			#if defined(UNITY_INSTANCING_ENABLED) && defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL)
				#define ENABLE_TERRAIN_PERPIXEL_NORMAL
			#endif

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#pragma shader_feature_local _INVERSEDIRECTION_ON
			#pragma shader_feature_local _TRANSITIONXVSY_ON
			#pragma shader_feature_local _INVERSEANIMATION_ON
			#pragma shader_feature_local _MANUALAUTOMATIC_ON
			#pragma shader_feature_local _CUSTOMPIVOT_ON
			#pragma shader_feature_local _USENORMALMAP_ON
			#pragma shader_feature_local _COLORMAP_ON
			#pragma shader_feature_local _MAPMATCAP_ON
			#pragma shader_feature_local _USEMAINTEXTURE_ON


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
				float4 clipPos : SV_POSITION;
				float4 lightmapUVOrVertexSH : TEXCOORD0;
				half4 fogFactorAndVertexLight : TEXCOORD1;
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					float4 shadowCoord : TEXCOORD2;
				#endif
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
					float4 screenPos : TEXCOORD6;
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
			float4 _NormalMap_ST;
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
			float _ManualTransition;
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
			sampler2D _NormalMap;
			sampler2D _MainMap;
			sampler2D _MainColorMap;
			sampler2D _Pattern;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			float MyCustomExpression535( float _Time, float _Period )
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
			
			float2 MyCustomExpression519( float3 normal )
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

				float2 texCoord439 = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord30 = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch603 = texCoord30.x;
				#else
				float staticSwitch603 = texCoord30.y;
				#endif
				float clampResult438 = clamp( ( ( tex2Dlod( _MaskMap, float4( (texCoord439*_TilingTransition + 0.0), 0, 0.0) ).r * _TransitionFactor ) + staticSwitch603 ) , 0.0 , 1.0 );
				float2 texCoord39 = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_46_0 = ( pow( tex2Dlod( _MaskMap, float4( (texCoord39*_Tiling + 0.0), 0, 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_32_0 = ( ( 1.0 - ( clampResult438 * float3(1,1,1) ) ) + temp_output_46_0 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch469 = ( 1.0 - temp_output_32_0 );
				#else
				float3 staticSwitch469 = temp_output_32_0;
				#endif
				float mulTime382 = _TimeParameters.x * _Transition;
				float _Time535 = mulTime382;
				float _Period535 = 2.0;
				float localMyCustomExpression535 = MyCustomExpression535( _Time535 , _Period535 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch516 = localMyCustomExpression535;
				#else
				float staticSwitch516 = _ManualTransition;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch449 = ( 1.0 - staticSwitch516 );
				#else
				float staticSwitch449 = staticSwitch516;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch450 = ( _Exp * 2.0 );
				#else
				float staticSwitch450 = _Exp;
				#endif
				float3 temp_cast_0 = (( ( pow( staticSwitch449 , staticSwitch450 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult34 = clamp( (( staticSwitch469 - temp_cast_0 )).z , 0.0 , 1.0 );
				float temp_output_37_0 = ( 1.0 - pow( clampResult34 , 2.0 ) );
				float TransitionMask486 = temp_output_37_0;
				float lerpResult275 = lerp( 0.0 , ( _Push / 100.0 ) , TransitionMask486);
				#ifdef _INVERSEANIMATION_ON
				float3 staticSwitch455 = ( _NormalizedRotationAxis * -1.0 );
				#else
				float3 staticSwitch455 = _NormalizedRotationAxis;
				#endif
				float MaskMap426 = temp_output_46_0;
				float4 transform261 = mul(GetWorldToObjectMatrix(),float4( 0,0,0,1 ));
				float3 objToWorld290 = mul( GetObjectToWorldMatrix(), float4( transform261.xyz, 1 ) ).xyz;
				float3 clampResult617 = clamp( _CustomPivotVec , float3( -1.5,-1.5,-1.5 ) , float3( 1.5,1.5,1.5 ) );
				#ifdef _CUSTOMPIVOT_ON
				float3 staticSwitch604 = clampResult617;
				#else
				float3 staticSwitch604 = objToWorld290;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float4 staticSwitch452 = ( _OffsetPivot * -1.0 );
				#else
				float4 staticSwitch452 = _OffsetPivot;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float3 worldToObj289 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 rotatedValue258 = RotateAroundAxis( ( float4( staticSwitch604 , 0.0 ) + ( staticSwitch452 / 100.0 ) ).xyz, worldToObj289, staticSwitch455, ( ( TransitionMask486 * MaskMap426 ) * _Angle ) );
				float3 FinalDisplacement347 = ( ( v.ase_normal * lerpResult275 ) + rotatedValue258 );
				
				float2 uv_NormalMap = v.texcoord.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
				#ifdef _USENORMALMAP_ON
				float4 staticSwitch601 = tex2Dlod( _NormalMap, float4( uv_NormalMap, 0, 0.0) );
				#else
				float4 staticSwitch601 = float4( v.ase_normal , 0.0 );
				#endif
				
				o.ase_texcoord8.xy = v.texcoord.xy;
				o.ase_normal = v.ase_normal;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord8.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = FinalDisplacement347;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.ase_normal = staticSwitch601.rgb;

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

				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
					o.screenPos = ComputeScreenPos(positionCS);
				#endif

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

			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE)
				#define ASE_SV_DEPTH SV_DepthLessEqual
			#else
				#define ASE_SV_DEPTH SV_Depth
			#endif

			half4 frag ( VertexOutput IN
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						#ifdef _WRITE_RENDERING_LAYERS
						, out float4 outRenderingLayers : SV_Target1
						#endif
						 ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				#ifdef LOD_FADE_CROSSFADE
					LODFadeCrossFade( IN.clipPos );
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

				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
					float4 ScreenPos = IN.screenPos;
				#endif

				float2 NormalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(IN.clipPos);

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					ShadowCoords = IN.shadowCoord;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
				#endif

				WorldViewDirection = SafeNormalize( WorldViewDirection );

				float2 uv_MainMap548 = IN.ase_texcoord8.xy;
				float4 tex2DNode548 = tex2D( _MainMap, uv_MainMap548 );
				float3 objToViewDir521 = mul( UNITY_MATRIX_IT_MV, float4( IN.ase_normal, 0 ) ).xyz;
				float3 normalizeResult520 = normalize( objToViewDir521 );
				float3 normal519 = normalizeResult520;
				float2 localMyCustomExpression519 = MyCustomExpression519( normal519 );
				float3 desaturateInitialColor527 = tex2D( _MainColorMap, localMyCustomExpression519 ).rgb;
				float desaturateDot527 = dot( desaturateInitialColor527, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar527 = lerp( desaturateInitialColor527, desaturateDot527.xxx, _Desaturation );
				float3 temp_cast_1 = (_ColorPow).xxx;
				#ifdef _MAPMATCAP_ON
				float4 staticSwitch547 = ( float4( pow( desaturateVar527 , temp_cast_1 ) , 0.0 ) * _MainColorMult * _ColorTransition );
				#else
				float4 staticSwitch547 = tex2DNode548;
				#endif
				#ifdef _COLORMAP_ON
				float4 staticSwitch546 = _MainColor;
				#else
				float4 staticSwitch546 = staticSwitch547;
				#endif
				#ifdef _USEMAINTEXTURE_ON
				float4 staticSwitch616 = tex2DNode548;
				#else
				float4 staticSwitch616 = _ColorTransition;
				#endif
				float3 break181 = _WorldSpaceCameraPos;
				float3 appendResult179 = (float3(( break181.x * -1.0 ) , break181.z , break181.y));
				float3 temp_output_182_0 = ( appendResult179 * _Subdivision );
				float3 break176 = WorldPosition;
				float3 appendResult177 = (float3(( break176.x * -1.0 ) , break176.z , break176.y));
				float3 temp_output_174_0 = ( appendResult177 * _Subdivision );
				float3 WP265 = temp_output_174_0;
				float3 temp_output_2_0 = ( WP265 * 1.0 );
				float3 normalizeResult11 = normalize( ( temp_output_182_0 - temp_output_2_0 ) );
				float3 temp_output_1_0_g81 = normalizeResult11;
				float3 temp_output_45_0_g81 = temp_output_182_0;
				float dotResult22_g81 = dot( temp_output_1_0_g81 , temp_output_45_0_g81 );
				float3 temp_cast_3 = (0.5).xxx;
				float3 temp_output_2_0_g81 = ( ( ceil( temp_output_2_0 ) / 1.0 ) - temp_cast_3 );
				float dotResult25_g81 = dot( temp_output_1_0_g81 , temp_output_2_0_g81 );
				float3 temp_output_30_0_g81 = ( WP265 - temp_output_45_0_g81 );
				float dotResult28_g81 = dot( temp_output_1_0_g81 , temp_output_30_0_g81 );
				float temp_output_27_0_g81 = ( ( ( dotResult22_g81 - dotResult25_g81 ) * -1.0 ) / dotResult28_g81 );
				float3 normalizeResult27_g82 = normalize( temp_output_1_0_g81 );
				float3 normalizeResult31_g82 = normalize( float3(0,0.00015,-1) );
				float3 normalizeResult29_g82 = normalize( cross( normalizeResult27_g82 , normalizeResult31_g82 ) );
				float3 temp_output_7_0_g81 = ( normalizeResult29_g82 * float3( 1,1,1 ) );
				float3 temp_output_34_0_g81 = ( temp_output_45_0_g81 + ( temp_output_27_0_g81 * temp_output_30_0_g81 ) );
				float3 temp_output_35_0_g81 = ( temp_output_34_0_g81 - temp_output_2_0_g81 );
				float dotResult11_g81 = dot( temp_output_7_0_g81 , temp_output_35_0_g81 );
				float3 normalizeResult10_g81 = normalize( cross( temp_output_7_0_g81 , normalizeResult27_g82 ) );
				float dotResult12_g81 = dot( normalizeResult10_g81 , temp_output_35_0_g81 );
				float2 appendResult14_g81 = (float2(dotResult11_g81 , dotResult12_g81));
				float2 temp_cast_4 = (0.0).xx;
				float2 temp_cast_5 = (0.0).xx;
				float2 ifLocalVar15_g81 = 0;
				if( temp_output_27_0_g81 <= 0.0 )
				ifLocalVar15_g81 = temp_cast_5;
				else
				ifLocalVar15_g81 = appendResult14_g81;
				float2 texCoord439 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord30 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch603 = texCoord30.x;
				#else
				float staticSwitch603 = texCoord30.y;
				#endif
				float clampResult438 = clamp( ( ( tex2D( _MaskMap, (texCoord439*_TilingTransition + 0.0) ).r * _TransitionFactor ) + staticSwitch603 ) , 0.0 , 1.0 );
				float2 texCoord39 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_46_0 = ( pow( tex2D( _MaskMap, (texCoord39*_Tiling + 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_32_0 = ( ( 1.0 - ( clampResult438 * float3(1,1,1) ) ) + temp_output_46_0 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch469 = ( 1.0 - temp_output_32_0 );
				#else
				float3 staticSwitch469 = temp_output_32_0;
				#endif
				float mulTime382 = _TimeParameters.x * _Transition;
				float _Time535 = mulTime382;
				float _Period535 = 2.0;
				float localMyCustomExpression535 = MyCustomExpression535( _Time535 , _Period535 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch516 = localMyCustomExpression535;
				#else
				float staticSwitch516 = _ManualTransition;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch449 = ( 1.0 - staticSwitch516 );
				#else
				float staticSwitch449 = staticSwitch516;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch450 = ( _Exp * 2.0 );
				#else
				float staticSwitch450 = _Exp;
				#endif
				float3 temp_cast_6 = (( ( pow( staticSwitch449 , staticSwitch450 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult34 = clamp( (( staticSwitch469 - temp_cast_6 )).z , 0.0 , 1.0 );
				float temp_output_37_0 = ( 1.0 - pow( clampResult34 , 2.0 ) );
				float TransitionMask486 = temp_output_37_0;
				float MaskMap426 = temp_output_46_0;
				float lerpResult425 = lerp( 0.0 , _Distortion , TransitionMask486);
				float2 temp_output_419_0 = ( ( ( ifLocalVar15_g81 / ( ( 1.0 - ( TransitionMask486 * float2( 1,1 ) ) ) * _SizeWhenTransition ) ) + 0.5 ) + ( MaskMap426 * lerpResult425 ) );
				float2 temp_cast_7 = (0.5).xx;
				float lerpResult13 = lerp( 1.0 , 0.0 , TransitionMask486);
				float2 temp_output_7_0_g80 = ( ( temp_output_419_0 - temp_cast_7 ) / lerpResult13 );
				float2 temp_cast_8 = (0.5).xx;
				float dotResult2_g80 = dot( temp_output_7_0_g80 , temp_output_7_0_g80 );
				float lerpResult14 = lerp( 1.0 , 0.1 , TransitionMask486);
				float mulTime482 = _TimeParameters.x * 2.0;
				float cos481 = cos( ( mulTime482 + TransitionMask486 ) );
				float sin481 = sin( ( mulTime482 + TransitionMask486 ) );
				float2 rotator481 = mul( temp_output_419_0 - float2( 0.5,0.5 ) , float2x2( cos481 , -sin481 , sin481 , cos481 )) + float2( 0.5,0.5 );
				float clampResult485 = clamp( ( pow( tex2D( _Pattern, rotator481 ).r , 6.0 ) + 0.1 ) , 0.0 , 1.0 );
				float clampResult480 = clamp( ( clampResult485 - TransitionMask486 ) , 0.0 , 1.0 );
				float temp_output_252_0 = ( 1.0 - (( _CustomTexture )?( ( 1.0 - clampResult480 ) ):( pow( saturate( dotResult2_g80 ) , lerpResult14 ) )) );
				float clampResult395 = clamp( ( temp_output_252_0 * _STEP ) , 0.0 , 1.0 );
				float4 lerpResult310 = lerp( staticSwitch546 , ( ( staticSwitch616 * _EmissiveFctor ) * (( _DETAILES )?( frac( clampResult395 ) ):( 1.0 )) ) , pow( TransitionMask486 , _SharpTransition ));
				float4 FinalColor345 = lerpResult310;
				
				float lerpResult431 = lerp( 1.0 , temp_output_46_0 , temp_output_37_0);
				float lerpResult242 = lerp( lerpResult431 , 0.0 , TransitionMask486);
				float temp_output_241_0 = ( temp_output_252_0 * lerpResult242 );
				float FinalAlpha346 = floor( ceil( temp_output_241_0 ) );
				

				float3 BaseColor = FinalColor345.rgb;
				float3 Normal = float3(0, 0, 1);
				float3 Emission = 0;
				float3 Specular = 0.5;
				float Metallic = _Metallic;
				float Smoothness = _Smoothness;
				float Occlusion = 1;
				float Alpha = FinalAlpha346;
				float AlphaClipThreshold = 0.1;
				float AlphaClipThresholdShadow = 0.5;
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				float3 Transmission = 1;
				float3 Translucency = 1;

				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = 0;
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

					#define SUM_LIGHT_TRANSMISSION(Light)\
						float3 atten = Light.color * Light.distanceAttenuation;\
						atten = lerp( atten, atten * Light.shadowAttenuation, shadow );\
						half3 transmission = max( 0, -dot( inputData.normalWS, Light.direction ) ) * atten * Transmission;\
						color.rgb += BaseColor * transmission;

					SUM_LIGHT_TRANSMISSION( GetMainLight( inputData.shadowCoord ) );

					#if defined(_ADDITIONAL_LIGHTS)
						uint meshRenderingLayers = GetMeshRenderingLayer();
						uint pixelLightCount = GetAdditionalLightsCount();
						#if USE_FORWARD_PLUS
							for (uint lightIndex = 0; lightIndex < min(URP_FP_DIRECTIONAL_LIGHTS_COUNT, MAX_VISIBLE_LIGHTS); lightIndex++)
							{
								FORWARD_PLUS_SUBTRACTIVE_LIGHT_CHECK

								Light light = GetAdditionalLight(lightIndex, inputData.positionWS);
								#ifdef _LIGHT_LAYERS
								if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
								#endif
								{
									SUM_LIGHT_TRANSMISSION( light );
								}
							}
						#endif
						LIGHT_LOOP_BEGIN( pixelLightCount )
							Light light = GetAdditionalLight(lightIndex, inputData.positionWS);
							#ifdef _LIGHT_LAYERS
							if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
							#endif
							{
								SUM_LIGHT_TRANSMISSION( light );
							}
						LIGHT_LOOP_END
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

					#define SUM_LIGHT_TRANSLUCENCY(Light)\
						float3 atten = Light.color * Light.distanceAttenuation;\
						atten = lerp( atten, atten * Light.shadowAttenuation, shadow );\
						half3 lightDir = Light.direction + inputData.normalWS * normal;\
						half VdotL = pow( saturate( dot( inputData.viewDirectionWS, -lightDir ) ), scattering );\
						half3 translucency = atten * ( VdotL * direct + inputData.bakedGI * ambient ) * Translucency;\
						color.rgb += BaseColor * translucency * strength;

					SUM_LIGHT_TRANSLUCENCY( GetMainLight( inputData.shadowCoord ) );

					#if defined(_ADDITIONAL_LIGHTS)
						uint meshRenderingLayers = GetMeshRenderingLayer();
						uint pixelLightCount = GetAdditionalLightsCount();
						#if USE_FORWARD_PLUS
							for (uint lightIndex = 0; lightIndex < min(URP_FP_DIRECTIONAL_LIGHTS_COUNT, MAX_VISIBLE_LIGHTS); lightIndex++)
							{
								FORWARD_PLUS_SUBTRACTIVE_LIGHT_CHECK

								Light light = GetAdditionalLight(lightIndex, inputData.positionWS);
								#ifdef _LIGHT_LAYERS
								if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
								#endif
								{
									SUM_LIGHT_TRANSLUCENCY( light );
								}
							}
						#endif
						LIGHT_LOOP_BEGIN( pixelLightCount )
							Light light = GetAdditionalLight(lightIndex, inputData.positionWS);
							#ifdef _LIGHT_LAYERS
							if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
							#endif
							{
								SUM_LIGHT_TRANSLUCENCY( light );
							}
						LIGHT_LOOP_END
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

				#ifdef _WRITE_RENDERING_LAYERS
					uint renderingLayers = GetMeshRenderingLayer();
					outRenderingLayers = float4( EncodeMeshRenderingLayer( renderingLayers ), 0, 0, 0 );
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
			#define _ALPHATEST_ON 1
			#define ASE_SRP_VERSION 140008


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
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#pragma shader_feature_local _INVERSEDIRECTION_ON
			#pragma shader_feature_local _TRANSITIONXVSY_ON
			#pragma shader_feature_local _INVERSEANIMATION_ON
			#pragma shader_feature_local _MANUALAUTOMATIC_ON
			#pragma shader_feature_local _CUSTOMPIVOT_ON
			#pragma shader_feature_local _USENORMALMAP_ON


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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _OffsetPivot;
			float4 _NormalMap_ST;
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
			float _ManualTransition;
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
			sampler2D _NormalMap;
			sampler2D _Pattern;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			float MyCustomExpression535( float _Time, float _Period )
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

				float2 texCoord439 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord30 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch603 = texCoord30.x;
				#else
				float staticSwitch603 = texCoord30.y;
				#endif
				float clampResult438 = clamp( ( ( tex2Dlod( _MaskMap, float4( (texCoord439*_TilingTransition + 0.0), 0, 0.0) ).r * _TransitionFactor ) + staticSwitch603 ) , 0.0 , 1.0 );
				float2 texCoord39 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_46_0 = ( pow( tex2Dlod( _MaskMap, float4( (texCoord39*_Tiling + 0.0), 0, 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_32_0 = ( ( 1.0 - ( clampResult438 * float3(1,1,1) ) ) + temp_output_46_0 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch469 = ( 1.0 - temp_output_32_0 );
				#else
				float3 staticSwitch469 = temp_output_32_0;
				#endif
				float mulTime382 = _TimeParameters.x * _Transition;
				float _Time535 = mulTime382;
				float _Period535 = 2.0;
				float localMyCustomExpression535 = MyCustomExpression535( _Time535 , _Period535 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch516 = localMyCustomExpression535;
				#else
				float staticSwitch516 = _ManualTransition;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch449 = ( 1.0 - staticSwitch516 );
				#else
				float staticSwitch449 = staticSwitch516;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch450 = ( _Exp * 2.0 );
				#else
				float staticSwitch450 = _Exp;
				#endif
				float3 temp_cast_0 = (( ( pow( staticSwitch449 , staticSwitch450 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult34 = clamp( (( staticSwitch469 - temp_cast_0 )).z , 0.0 , 1.0 );
				float temp_output_37_0 = ( 1.0 - pow( clampResult34 , 2.0 ) );
				float TransitionMask486 = temp_output_37_0;
				float lerpResult275 = lerp( 0.0 , ( _Push / 100.0 ) , TransitionMask486);
				#ifdef _INVERSEANIMATION_ON
				float3 staticSwitch455 = ( _NormalizedRotationAxis * -1.0 );
				#else
				float3 staticSwitch455 = _NormalizedRotationAxis;
				#endif
				float MaskMap426 = temp_output_46_0;
				float4 transform261 = mul(GetWorldToObjectMatrix(),float4( 0,0,0,1 ));
				float3 objToWorld290 = mul( GetObjectToWorldMatrix(), float4( transform261.xyz, 1 ) ).xyz;
				float3 clampResult617 = clamp( _CustomPivotVec , float3( -1.5,-1.5,-1.5 ) , float3( 1.5,1.5,1.5 ) );
				#ifdef _CUSTOMPIVOT_ON
				float3 staticSwitch604 = clampResult617;
				#else
				float3 staticSwitch604 = objToWorld290;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float4 staticSwitch452 = ( _OffsetPivot * -1.0 );
				#else
				float4 staticSwitch452 = _OffsetPivot;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float3 worldToObj289 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 rotatedValue258 = RotateAroundAxis( ( float4( staticSwitch604 , 0.0 ) + ( staticSwitch452 / 100.0 ) ).xyz, worldToObj289, staticSwitch455, ( ( TransitionMask486 * MaskMap426 ) * _Angle ) );
				float3 FinalDisplacement347 = ( ( v.ase_normal * lerpResult275 ) + rotatedValue258 );
				
				float2 uv_NormalMap = v.ase_texcoord.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
				#ifdef _USENORMALMAP_ON
				float4 staticSwitch601 = tex2Dlod( _NormalMap, float4( uv_NormalMap, 0, 0.0) );
				#else
				float4 staticSwitch601 = float4( v.ase_normal , 0.0 );
				#endif
				
				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = FinalDisplacement347;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = staticSwitch601.rgb;

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

			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE)
				#define ASE_SV_DEPTH SV_DepthLessEqual
			#else
				#define ASE_SV_DEPTH SV_Depth
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

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float3 break181 = _WorldSpaceCameraPos;
				float3 appendResult179 = (float3(( break181.x * -1.0 ) , break181.z , break181.y));
				float3 temp_output_182_0 = ( appendResult179 * _Subdivision );
				float3 break176 = WorldPosition;
				float3 appendResult177 = (float3(( break176.x * -1.0 ) , break176.z , break176.y));
				float3 temp_output_174_0 = ( appendResult177 * _Subdivision );
				float3 WP265 = temp_output_174_0;
				float3 temp_output_2_0 = ( WP265 * 1.0 );
				float3 normalizeResult11 = normalize( ( temp_output_182_0 - temp_output_2_0 ) );
				float3 temp_output_1_0_g81 = normalizeResult11;
				float3 temp_output_45_0_g81 = temp_output_182_0;
				float dotResult22_g81 = dot( temp_output_1_0_g81 , temp_output_45_0_g81 );
				float3 temp_cast_0 = (0.5).xxx;
				float3 temp_output_2_0_g81 = ( ( ceil( temp_output_2_0 ) / 1.0 ) - temp_cast_0 );
				float dotResult25_g81 = dot( temp_output_1_0_g81 , temp_output_2_0_g81 );
				float3 temp_output_30_0_g81 = ( WP265 - temp_output_45_0_g81 );
				float dotResult28_g81 = dot( temp_output_1_0_g81 , temp_output_30_0_g81 );
				float temp_output_27_0_g81 = ( ( ( dotResult22_g81 - dotResult25_g81 ) * -1.0 ) / dotResult28_g81 );
				float3 normalizeResult27_g82 = normalize( temp_output_1_0_g81 );
				float3 normalizeResult31_g82 = normalize( float3(0,0.00015,-1) );
				float3 normalizeResult29_g82 = normalize( cross( normalizeResult27_g82 , normalizeResult31_g82 ) );
				float3 temp_output_7_0_g81 = ( normalizeResult29_g82 * float3( 1,1,1 ) );
				float3 temp_output_34_0_g81 = ( temp_output_45_0_g81 + ( temp_output_27_0_g81 * temp_output_30_0_g81 ) );
				float3 temp_output_35_0_g81 = ( temp_output_34_0_g81 - temp_output_2_0_g81 );
				float dotResult11_g81 = dot( temp_output_7_0_g81 , temp_output_35_0_g81 );
				float3 normalizeResult10_g81 = normalize( cross( temp_output_7_0_g81 , normalizeResult27_g82 ) );
				float dotResult12_g81 = dot( normalizeResult10_g81 , temp_output_35_0_g81 );
				float2 appendResult14_g81 = (float2(dotResult11_g81 , dotResult12_g81));
				float2 temp_cast_1 = (0.0).xx;
				float2 temp_cast_2 = (0.0).xx;
				float2 ifLocalVar15_g81 = 0;
				if( temp_output_27_0_g81 <= 0.0 )
				ifLocalVar15_g81 = temp_cast_2;
				else
				ifLocalVar15_g81 = appendResult14_g81;
				float2 texCoord439 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord30 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch603 = texCoord30.x;
				#else
				float staticSwitch603 = texCoord30.y;
				#endif
				float clampResult438 = clamp( ( ( tex2D( _MaskMap, (texCoord439*_TilingTransition + 0.0) ).r * _TransitionFactor ) + staticSwitch603 ) , 0.0 , 1.0 );
				float2 texCoord39 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_46_0 = ( pow( tex2D( _MaskMap, (texCoord39*_Tiling + 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_32_0 = ( ( 1.0 - ( clampResult438 * float3(1,1,1) ) ) + temp_output_46_0 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch469 = ( 1.0 - temp_output_32_0 );
				#else
				float3 staticSwitch469 = temp_output_32_0;
				#endif
				float mulTime382 = _TimeParameters.x * _Transition;
				float _Time535 = mulTime382;
				float _Period535 = 2.0;
				float localMyCustomExpression535 = MyCustomExpression535( _Time535 , _Period535 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch516 = localMyCustomExpression535;
				#else
				float staticSwitch516 = _ManualTransition;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch449 = ( 1.0 - staticSwitch516 );
				#else
				float staticSwitch449 = staticSwitch516;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch450 = ( _Exp * 2.0 );
				#else
				float staticSwitch450 = _Exp;
				#endif
				float3 temp_cast_3 = (( ( pow( staticSwitch449 , staticSwitch450 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult34 = clamp( (( staticSwitch469 - temp_cast_3 )).z , 0.0 , 1.0 );
				float temp_output_37_0 = ( 1.0 - pow( clampResult34 , 2.0 ) );
				float TransitionMask486 = temp_output_37_0;
				float MaskMap426 = temp_output_46_0;
				float lerpResult425 = lerp( 0.0 , _Distortion , TransitionMask486);
				float2 temp_output_419_0 = ( ( ( ifLocalVar15_g81 / ( ( 1.0 - ( TransitionMask486 * float2( 1,1 ) ) ) * _SizeWhenTransition ) ) + 0.5 ) + ( MaskMap426 * lerpResult425 ) );
				float2 temp_cast_4 = (0.5).xx;
				float lerpResult13 = lerp( 1.0 , 0.0 , TransitionMask486);
				float2 temp_output_7_0_g80 = ( ( temp_output_419_0 - temp_cast_4 ) / lerpResult13 );
				float2 temp_cast_5 = (0.5).xx;
				float dotResult2_g80 = dot( temp_output_7_0_g80 , temp_output_7_0_g80 );
				float lerpResult14 = lerp( 1.0 , 0.1 , TransitionMask486);
				float mulTime482 = _TimeParameters.x * 2.0;
				float cos481 = cos( ( mulTime482 + TransitionMask486 ) );
				float sin481 = sin( ( mulTime482 + TransitionMask486 ) );
				float2 rotator481 = mul( temp_output_419_0 - float2( 0.5,0.5 ) , float2x2( cos481 , -sin481 , sin481 , cos481 )) + float2( 0.5,0.5 );
				float clampResult485 = clamp( ( pow( tex2D( _Pattern, rotator481 ).r , 6.0 ) + 0.1 ) , 0.0 , 1.0 );
				float clampResult480 = clamp( ( clampResult485 - TransitionMask486 ) , 0.0 , 1.0 );
				float temp_output_252_0 = ( 1.0 - (( _CustomTexture )?( ( 1.0 - clampResult480 ) ):( pow( saturate( dotResult2_g80 ) , lerpResult14 ) )) );
				float lerpResult431 = lerp( 1.0 , temp_output_46_0 , temp_output_37_0);
				float lerpResult242 = lerp( lerpResult431 , 0.0 , TransitionMask486);
				float temp_output_241_0 = ( temp_output_252_0 * lerpResult242 );
				float FinalAlpha346 = floor( ceil( temp_output_241_0 ) );
				

				float Alpha = FinalAlpha346;
				float AlphaClipThreshold = 0.1;
				float AlphaClipThresholdShadow = 0.5;

				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = 0;
				#endif

				#ifdef _ALPHATEST_ON
					#ifdef _ALPHATEST_SHADOW_ON
						clip(Alpha - AlphaClipThresholdShadow);
					#else
						clip(Alpha - AlphaClipThreshold);
					#endif
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODFadeCrossFade( IN.clipPos );
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
			#define _ALPHATEST_ON 1
			#define ASE_SRP_VERSION 140008


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
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
			
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#pragma shader_feature_local _INVERSEDIRECTION_ON
			#pragma shader_feature_local _TRANSITIONXVSY_ON
			#pragma shader_feature_local _INVERSEANIMATION_ON
			#pragma shader_feature_local _MANUALAUTOMATIC_ON
			#pragma shader_feature_local _CUSTOMPIVOT_ON
			#pragma shader_feature_local _USENORMALMAP_ON


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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _OffsetPivot;
			float4 _NormalMap_ST;
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
			float _ManualTransition;
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
			sampler2D _NormalMap;
			sampler2D _Pattern;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			float MyCustomExpression535( float _Time, float _Period )
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

				float2 texCoord439 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord30 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch603 = texCoord30.x;
				#else
				float staticSwitch603 = texCoord30.y;
				#endif
				float clampResult438 = clamp( ( ( tex2Dlod( _MaskMap, float4( (texCoord439*_TilingTransition + 0.0), 0, 0.0) ).r * _TransitionFactor ) + staticSwitch603 ) , 0.0 , 1.0 );
				float2 texCoord39 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_46_0 = ( pow( tex2Dlod( _MaskMap, float4( (texCoord39*_Tiling + 0.0), 0, 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_32_0 = ( ( 1.0 - ( clampResult438 * float3(1,1,1) ) ) + temp_output_46_0 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch469 = ( 1.0 - temp_output_32_0 );
				#else
				float3 staticSwitch469 = temp_output_32_0;
				#endif
				float mulTime382 = _TimeParameters.x * _Transition;
				float _Time535 = mulTime382;
				float _Period535 = 2.0;
				float localMyCustomExpression535 = MyCustomExpression535( _Time535 , _Period535 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch516 = localMyCustomExpression535;
				#else
				float staticSwitch516 = _ManualTransition;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch449 = ( 1.0 - staticSwitch516 );
				#else
				float staticSwitch449 = staticSwitch516;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch450 = ( _Exp * 2.0 );
				#else
				float staticSwitch450 = _Exp;
				#endif
				float3 temp_cast_0 = (( ( pow( staticSwitch449 , staticSwitch450 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult34 = clamp( (( staticSwitch469 - temp_cast_0 )).z , 0.0 , 1.0 );
				float temp_output_37_0 = ( 1.0 - pow( clampResult34 , 2.0 ) );
				float TransitionMask486 = temp_output_37_0;
				float lerpResult275 = lerp( 0.0 , ( _Push / 100.0 ) , TransitionMask486);
				#ifdef _INVERSEANIMATION_ON
				float3 staticSwitch455 = ( _NormalizedRotationAxis * -1.0 );
				#else
				float3 staticSwitch455 = _NormalizedRotationAxis;
				#endif
				float MaskMap426 = temp_output_46_0;
				float4 transform261 = mul(GetWorldToObjectMatrix(),float4( 0,0,0,1 ));
				float3 objToWorld290 = mul( GetObjectToWorldMatrix(), float4( transform261.xyz, 1 ) ).xyz;
				float3 clampResult617 = clamp( _CustomPivotVec , float3( -1.5,-1.5,-1.5 ) , float3( 1.5,1.5,1.5 ) );
				#ifdef _CUSTOMPIVOT_ON
				float3 staticSwitch604 = clampResult617;
				#else
				float3 staticSwitch604 = objToWorld290;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float4 staticSwitch452 = ( _OffsetPivot * -1.0 );
				#else
				float4 staticSwitch452 = _OffsetPivot;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float3 worldToObj289 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 rotatedValue258 = RotateAroundAxis( ( float4( staticSwitch604 , 0.0 ) + ( staticSwitch452 / 100.0 ) ).xyz, worldToObj289, staticSwitch455, ( ( TransitionMask486 * MaskMap426 ) * _Angle ) );
				float3 FinalDisplacement347 = ( ( v.ase_normal * lerpResult275 ) + rotatedValue258 );
				
				float2 uv_NormalMap = v.ase_texcoord.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
				#ifdef _USENORMALMAP_ON
				float4 staticSwitch601 = tex2Dlod( _NormalMap, float4( uv_NormalMap, 0, 0.0) );
				#else
				float4 staticSwitch601 = float4( v.ase_normal , 0.0 );
				#endif
				
				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = FinalDisplacement347;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = staticSwitch601.rgb;
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

			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE)
				#define ASE_SV_DEPTH SV_DepthLessEqual
			#else
				#define ASE_SV_DEPTH SV_Depth
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

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float3 break181 = _WorldSpaceCameraPos;
				float3 appendResult179 = (float3(( break181.x * -1.0 ) , break181.z , break181.y));
				float3 temp_output_182_0 = ( appendResult179 * _Subdivision );
				float3 break176 = WorldPosition;
				float3 appendResult177 = (float3(( break176.x * -1.0 ) , break176.z , break176.y));
				float3 temp_output_174_0 = ( appendResult177 * _Subdivision );
				float3 WP265 = temp_output_174_0;
				float3 temp_output_2_0 = ( WP265 * 1.0 );
				float3 normalizeResult11 = normalize( ( temp_output_182_0 - temp_output_2_0 ) );
				float3 temp_output_1_0_g81 = normalizeResult11;
				float3 temp_output_45_0_g81 = temp_output_182_0;
				float dotResult22_g81 = dot( temp_output_1_0_g81 , temp_output_45_0_g81 );
				float3 temp_cast_0 = (0.5).xxx;
				float3 temp_output_2_0_g81 = ( ( ceil( temp_output_2_0 ) / 1.0 ) - temp_cast_0 );
				float dotResult25_g81 = dot( temp_output_1_0_g81 , temp_output_2_0_g81 );
				float3 temp_output_30_0_g81 = ( WP265 - temp_output_45_0_g81 );
				float dotResult28_g81 = dot( temp_output_1_0_g81 , temp_output_30_0_g81 );
				float temp_output_27_0_g81 = ( ( ( dotResult22_g81 - dotResult25_g81 ) * -1.0 ) / dotResult28_g81 );
				float3 normalizeResult27_g82 = normalize( temp_output_1_0_g81 );
				float3 normalizeResult31_g82 = normalize( float3(0,0.00015,-1) );
				float3 normalizeResult29_g82 = normalize( cross( normalizeResult27_g82 , normalizeResult31_g82 ) );
				float3 temp_output_7_0_g81 = ( normalizeResult29_g82 * float3( 1,1,1 ) );
				float3 temp_output_34_0_g81 = ( temp_output_45_0_g81 + ( temp_output_27_0_g81 * temp_output_30_0_g81 ) );
				float3 temp_output_35_0_g81 = ( temp_output_34_0_g81 - temp_output_2_0_g81 );
				float dotResult11_g81 = dot( temp_output_7_0_g81 , temp_output_35_0_g81 );
				float3 normalizeResult10_g81 = normalize( cross( temp_output_7_0_g81 , normalizeResult27_g82 ) );
				float dotResult12_g81 = dot( normalizeResult10_g81 , temp_output_35_0_g81 );
				float2 appendResult14_g81 = (float2(dotResult11_g81 , dotResult12_g81));
				float2 temp_cast_1 = (0.0).xx;
				float2 temp_cast_2 = (0.0).xx;
				float2 ifLocalVar15_g81 = 0;
				if( temp_output_27_0_g81 <= 0.0 )
				ifLocalVar15_g81 = temp_cast_2;
				else
				ifLocalVar15_g81 = appendResult14_g81;
				float2 texCoord439 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord30 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch603 = texCoord30.x;
				#else
				float staticSwitch603 = texCoord30.y;
				#endif
				float clampResult438 = clamp( ( ( tex2D( _MaskMap, (texCoord439*_TilingTransition + 0.0) ).r * _TransitionFactor ) + staticSwitch603 ) , 0.0 , 1.0 );
				float2 texCoord39 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_46_0 = ( pow( tex2D( _MaskMap, (texCoord39*_Tiling + 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_32_0 = ( ( 1.0 - ( clampResult438 * float3(1,1,1) ) ) + temp_output_46_0 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch469 = ( 1.0 - temp_output_32_0 );
				#else
				float3 staticSwitch469 = temp_output_32_0;
				#endif
				float mulTime382 = _TimeParameters.x * _Transition;
				float _Time535 = mulTime382;
				float _Period535 = 2.0;
				float localMyCustomExpression535 = MyCustomExpression535( _Time535 , _Period535 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch516 = localMyCustomExpression535;
				#else
				float staticSwitch516 = _ManualTransition;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch449 = ( 1.0 - staticSwitch516 );
				#else
				float staticSwitch449 = staticSwitch516;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch450 = ( _Exp * 2.0 );
				#else
				float staticSwitch450 = _Exp;
				#endif
				float3 temp_cast_3 = (( ( pow( staticSwitch449 , staticSwitch450 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult34 = clamp( (( staticSwitch469 - temp_cast_3 )).z , 0.0 , 1.0 );
				float temp_output_37_0 = ( 1.0 - pow( clampResult34 , 2.0 ) );
				float TransitionMask486 = temp_output_37_0;
				float MaskMap426 = temp_output_46_0;
				float lerpResult425 = lerp( 0.0 , _Distortion , TransitionMask486);
				float2 temp_output_419_0 = ( ( ( ifLocalVar15_g81 / ( ( 1.0 - ( TransitionMask486 * float2( 1,1 ) ) ) * _SizeWhenTransition ) ) + 0.5 ) + ( MaskMap426 * lerpResult425 ) );
				float2 temp_cast_4 = (0.5).xx;
				float lerpResult13 = lerp( 1.0 , 0.0 , TransitionMask486);
				float2 temp_output_7_0_g80 = ( ( temp_output_419_0 - temp_cast_4 ) / lerpResult13 );
				float2 temp_cast_5 = (0.5).xx;
				float dotResult2_g80 = dot( temp_output_7_0_g80 , temp_output_7_0_g80 );
				float lerpResult14 = lerp( 1.0 , 0.1 , TransitionMask486);
				float mulTime482 = _TimeParameters.x * 2.0;
				float cos481 = cos( ( mulTime482 + TransitionMask486 ) );
				float sin481 = sin( ( mulTime482 + TransitionMask486 ) );
				float2 rotator481 = mul( temp_output_419_0 - float2( 0.5,0.5 ) , float2x2( cos481 , -sin481 , sin481 , cos481 )) + float2( 0.5,0.5 );
				float clampResult485 = clamp( ( pow( tex2D( _Pattern, rotator481 ).r , 6.0 ) + 0.1 ) , 0.0 , 1.0 );
				float clampResult480 = clamp( ( clampResult485 - TransitionMask486 ) , 0.0 , 1.0 );
				float temp_output_252_0 = ( 1.0 - (( _CustomTexture )?( ( 1.0 - clampResult480 ) ):( pow( saturate( dotResult2_g80 ) , lerpResult14 ) )) );
				float lerpResult431 = lerp( 1.0 , temp_output_46_0 , temp_output_37_0);
				float lerpResult242 = lerp( lerpResult431 , 0.0 , TransitionMask486);
				float temp_output_241_0 = ( temp_output_252_0 * lerpResult242 );
				float FinalAlpha346 = floor( ceil( temp_output_241_0 ) );
				

				float Alpha = FinalAlpha346;
				float AlphaClipThreshold = 0.1;
				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = 0;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODFadeCrossFade( IN.clipPos );
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
			#define _ALPHATEST_ON 1
			#define ASE_SRP_VERSION 140008


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
			#pragma shader_feature_local _INVERSEANIMATION_ON
			#pragma shader_feature_local _MANUALAUTOMATIC_ON
			#pragma shader_feature_local _CUSTOMPIVOT_ON
			#pragma shader_feature_local _USENORMALMAP_ON
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
			float4 _NormalMap_ST;
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
			float _ManualTransition;
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
			sampler2D _NormalMap;
			sampler2D _MainMap;
			sampler2D _MainColorMap;
			sampler2D _Pattern;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			float MyCustomExpression535( float _Time, float _Period )
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
			
			float2 MyCustomExpression519( float3 normal )
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

				float2 texCoord439 = v.texcoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord30 = v.texcoord0.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch603 = texCoord30.x;
				#else
				float staticSwitch603 = texCoord30.y;
				#endif
				float clampResult438 = clamp( ( ( tex2Dlod( _MaskMap, float4( (texCoord439*_TilingTransition + 0.0), 0, 0.0) ).r * _TransitionFactor ) + staticSwitch603 ) , 0.0 , 1.0 );
				float2 texCoord39 = v.texcoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_46_0 = ( pow( tex2Dlod( _MaskMap, float4( (texCoord39*_Tiling + 0.0), 0, 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_32_0 = ( ( 1.0 - ( clampResult438 * float3(1,1,1) ) ) + temp_output_46_0 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch469 = ( 1.0 - temp_output_32_0 );
				#else
				float3 staticSwitch469 = temp_output_32_0;
				#endif
				float mulTime382 = _TimeParameters.x * _Transition;
				float _Time535 = mulTime382;
				float _Period535 = 2.0;
				float localMyCustomExpression535 = MyCustomExpression535( _Time535 , _Period535 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch516 = localMyCustomExpression535;
				#else
				float staticSwitch516 = _ManualTransition;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch449 = ( 1.0 - staticSwitch516 );
				#else
				float staticSwitch449 = staticSwitch516;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch450 = ( _Exp * 2.0 );
				#else
				float staticSwitch450 = _Exp;
				#endif
				float3 temp_cast_0 = (( ( pow( staticSwitch449 , staticSwitch450 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult34 = clamp( (( staticSwitch469 - temp_cast_0 )).z , 0.0 , 1.0 );
				float temp_output_37_0 = ( 1.0 - pow( clampResult34 , 2.0 ) );
				float TransitionMask486 = temp_output_37_0;
				float lerpResult275 = lerp( 0.0 , ( _Push / 100.0 ) , TransitionMask486);
				#ifdef _INVERSEANIMATION_ON
				float3 staticSwitch455 = ( _NormalizedRotationAxis * -1.0 );
				#else
				float3 staticSwitch455 = _NormalizedRotationAxis;
				#endif
				float MaskMap426 = temp_output_46_0;
				float4 transform261 = mul(GetWorldToObjectMatrix(),float4( 0,0,0,1 ));
				float3 objToWorld290 = mul( GetObjectToWorldMatrix(), float4( transform261.xyz, 1 ) ).xyz;
				float3 clampResult617 = clamp( _CustomPivotVec , float3( -1.5,-1.5,-1.5 ) , float3( 1.5,1.5,1.5 ) );
				#ifdef _CUSTOMPIVOT_ON
				float3 staticSwitch604 = clampResult617;
				#else
				float3 staticSwitch604 = objToWorld290;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float4 staticSwitch452 = ( _OffsetPivot * -1.0 );
				#else
				float4 staticSwitch452 = _OffsetPivot;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float3 worldToObj289 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 rotatedValue258 = RotateAroundAxis( ( float4( staticSwitch604 , 0.0 ) + ( staticSwitch452 / 100.0 ) ).xyz, worldToObj289, staticSwitch455, ( ( TransitionMask486 * MaskMap426 ) * _Angle ) );
				float3 FinalDisplacement347 = ( ( v.ase_normal * lerpResult275 ) + rotatedValue258 );
				
				float2 uv_NormalMap = v.texcoord0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
				#ifdef _USENORMALMAP_ON
				float4 staticSwitch601 = tex2Dlod( _NormalMap, float4( uv_NormalMap, 0, 0.0) );
				#else
				float4 staticSwitch601 = float4( v.ase_normal , 0.0 );
				#endif
				
				o.ase_texcoord4.xy = v.texcoord0.xy;
				o.ase_normal = v.ase_normal;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord4.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = FinalDisplacement347;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = staticSwitch601.rgb;

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

				float2 uv_MainMap548 = IN.ase_texcoord4.xy;
				float4 tex2DNode548 = tex2D( _MainMap, uv_MainMap548 );
				float3 objToViewDir521 = mul( UNITY_MATRIX_IT_MV, float4( IN.ase_normal, 0 ) ).xyz;
				float3 normalizeResult520 = normalize( objToViewDir521 );
				float3 normal519 = normalizeResult520;
				float2 localMyCustomExpression519 = MyCustomExpression519( normal519 );
				float3 desaturateInitialColor527 = tex2D( _MainColorMap, localMyCustomExpression519 ).rgb;
				float desaturateDot527 = dot( desaturateInitialColor527, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar527 = lerp( desaturateInitialColor527, desaturateDot527.xxx, _Desaturation );
				float3 temp_cast_1 = (_ColorPow).xxx;
				#ifdef _MAPMATCAP_ON
				float4 staticSwitch547 = ( float4( pow( desaturateVar527 , temp_cast_1 ) , 0.0 ) * _MainColorMult * _ColorTransition );
				#else
				float4 staticSwitch547 = tex2DNode548;
				#endif
				#ifdef _COLORMAP_ON
				float4 staticSwitch546 = _MainColor;
				#else
				float4 staticSwitch546 = staticSwitch547;
				#endif
				#ifdef _USEMAINTEXTURE_ON
				float4 staticSwitch616 = tex2DNode548;
				#else
				float4 staticSwitch616 = _ColorTransition;
				#endif
				float3 break181 = _WorldSpaceCameraPos;
				float3 appendResult179 = (float3(( break181.x * -1.0 ) , break181.z , break181.y));
				float3 temp_output_182_0 = ( appendResult179 * _Subdivision );
				float3 break176 = WorldPosition;
				float3 appendResult177 = (float3(( break176.x * -1.0 ) , break176.z , break176.y));
				float3 temp_output_174_0 = ( appendResult177 * _Subdivision );
				float3 WP265 = temp_output_174_0;
				float3 temp_output_2_0 = ( WP265 * 1.0 );
				float3 normalizeResult11 = normalize( ( temp_output_182_0 - temp_output_2_0 ) );
				float3 temp_output_1_0_g81 = normalizeResult11;
				float3 temp_output_45_0_g81 = temp_output_182_0;
				float dotResult22_g81 = dot( temp_output_1_0_g81 , temp_output_45_0_g81 );
				float3 temp_cast_3 = (0.5).xxx;
				float3 temp_output_2_0_g81 = ( ( ceil( temp_output_2_0 ) / 1.0 ) - temp_cast_3 );
				float dotResult25_g81 = dot( temp_output_1_0_g81 , temp_output_2_0_g81 );
				float3 temp_output_30_0_g81 = ( WP265 - temp_output_45_0_g81 );
				float dotResult28_g81 = dot( temp_output_1_0_g81 , temp_output_30_0_g81 );
				float temp_output_27_0_g81 = ( ( ( dotResult22_g81 - dotResult25_g81 ) * -1.0 ) / dotResult28_g81 );
				float3 normalizeResult27_g82 = normalize( temp_output_1_0_g81 );
				float3 normalizeResult31_g82 = normalize( float3(0,0.00015,-1) );
				float3 normalizeResult29_g82 = normalize( cross( normalizeResult27_g82 , normalizeResult31_g82 ) );
				float3 temp_output_7_0_g81 = ( normalizeResult29_g82 * float3( 1,1,1 ) );
				float3 temp_output_34_0_g81 = ( temp_output_45_0_g81 + ( temp_output_27_0_g81 * temp_output_30_0_g81 ) );
				float3 temp_output_35_0_g81 = ( temp_output_34_0_g81 - temp_output_2_0_g81 );
				float dotResult11_g81 = dot( temp_output_7_0_g81 , temp_output_35_0_g81 );
				float3 normalizeResult10_g81 = normalize( cross( temp_output_7_0_g81 , normalizeResult27_g82 ) );
				float dotResult12_g81 = dot( normalizeResult10_g81 , temp_output_35_0_g81 );
				float2 appendResult14_g81 = (float2(dotResult11_g81 , dotResult12_g81));
				float2 temp_cast_4 = (0.0).xx;
				float2 temp_cast_5 = (0.0).xx;
				float2 ifLocalVar15_g81 = 0;
				if( temp_output_27_0_g81 <= 0.0 )
				ifLocalVar15_g81 = temp_cast_5;
				else
				ifLocalVar15_g81 = appendResult14_g81;
				float2 texCoord439 = IN.ase_texcoord4.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord30 = IN.ase_texcoord4.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch603 = texCoord30.x;
				#else
				float staticSwitch603 = texCoord30.y;
				#endif
				float clampResult438 = clamp( ( ( tex2D( _MaskMap, (texCoord439*_TilingTransition + 0.0) ).r * _TransitionFactor ) + staticSwitch603 ) , 0.0 , 1.0 );
				float2 texCoord39 = IN.ase_texcoord4.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_46_0 = ( pow( tex2D( _MaskMap, (texCoord39*_Tiling + 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_32_0 = ( ( 1.0 - ( clampResult438 * float3(1,1,1) ) ) + temp_output_46_0 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch469 = ( 1.0 - temp_output_32_0 );
				#else
				float3 staticSwitch469 = temp_output_32_0;
				#endif
				float mulTime382 = _TimeParameters.x * _Transition;
				float _Time535 = mulTime382;
				float _Period535 = 2.0;
				float localMyCustomExpression535 = MyCustomExpression535( _Time535 , _Period535 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch516 = localMyCustomExpression535;
				#else
				float staticSwitch516 = _ManualTransition;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch449 = ( 1.0 - staticSwitch516 );
				#else
				float staticSwitch449 = staticSwitch516;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch450 = ( _Exp * 2.0 );
				#else
				float staticSwitch450 = _Exp;
				#endif
				float3 temp_cast_6 = (( ( pow( staticSwitch449 , staticSwitch450 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult34 = clamp( (( staticSwitch469 - temp_cast_6 )).z , 0.0 , 1.0 );
				float temp_output_37_0 = ( 1.0 - pow( clampResult34 , 2.0 ) );
				float TransitionMask486 = temp_output_37_0;
				float MaskMap426 = temp_output_46_0;
				float lerpResult425 = lerp( 0.0 , _Distortion , TransitionMask486);
				float2 temp_output_419_0 = ( ( ( ifLocalVar15_g81 / ( ( 1.0 - ( TransitionMask486 * float2( 1,1 ) ) ) * _SizeWhenTransition ) ) + 0.5 ) + ( MaskMap426 * lerpResult425 ) );
				float2 temp_cast_7 = (0.5).xx;
				float lerpResult13 = lerp( 1.0 , 0.0 , TransitionMask486);
				float2 temp_output_7_0_g80 = ( ( temp_output_419_0 - temp_cast_7 ) / lerpResult13 );
				float2 temp_cast_8 = (0.5).xx;
				float dotResult2_g80 = dot( temp_output_7_0_g80 , temp_output_7_0_g80 );
				float lerpResult14 = lerp( 1.0 , 0.1 , TransitionMask486);
				float mulTime482 = _TimeParameters.x * 2.0;
				float cos481 = cos( ( mulTime482 + TransitionMask486 ) );
				float sin481 = sin( ( mulTime482 + TransitionMask486 ) );
				float2 rotator481 = mul( temp_output_419_0 - float2( 0.5,0.5 ) , float2x2( cos481 , -sin481 , sin481 , cos481 )) + float2( 0.5,0.5 );
				float clampResult485 = clamp( ( pow( tex2D( _Pattern, rotator481 ).r , 6.0 ) + 0.1 ) , 0.0 , 1.0 );
				float clampResult480 = clamp( ( clampResult485 - TransitionMask486 ) , 0.0 , 1.0 );
				float temp_output_252_0 = ( 1.0 - (( _CustomTexture )?( ( 1.0 - clampResult480 ) ):( pow( saturate( dotResult2_g80 ) , lerpResult14 ) )) );
				float clampResult395 = clamp( ( temp_output_252_0 * _STEP ) , 0.0 , 1.0 );
				float4 lerpResult310 = lerp( staticSwitch546 , ( ( staticSwitch616 * _EmissiveFctor ) * (( _DETAILES )?( frac( clampResult395 ) ):( 1.0 )) ) , pow( TransitionMask486 , _SharpTransition ));
				float4 FinalColor345 = lerpResult310;
				
				float lerpResult431 = lerp( 1.0 , temp_output_46_0 , temp_output_37_0);
				float lerpResult242 = lerp( lerpResult431 , 0.0 , TransitionMask486);
				float temp_output_241_0 = ( temp_output_252_0 * lerpResult242 );
				float FinalAlpha346 = floor( ceil( temp_output_241_0 ) );
				

				float3 BaseColor = FinalColor345.rgb;
				float3 Emission = 0;
				float Alpha = FinalAlpha346;
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
			#define _ALPHATEST_ON 1
			#define ASE_SRP_VERSION 140008


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
			#pragma shader_feature_local _INVERSEANIMATION_ON
			#pragma shader_feature_local _MANUALAUTOMATIC_ON
			#pragma shader_feature_local _CUSTOMPIVOT_ON
			#pragma shader_feature_local _USENORMALMAP_ON
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
			float4 _NormalMap_ST;
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
			float _ManualTransition;
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
			sampler2D _NormalMap;
			sampler2D _MainMap;
			sampler2D _MainColorMap;
			sampler2D _Pattern;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			float MyCustomExpression535( float _Time, float _Period )
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
			
			float2 MyCustomExpression519( float3 normal )
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

				float2 texCoord439 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord30 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch603 = texCoord30.x;
				#else
				float staticSwitch603 = texCoord30.y;
				#endif
				float clampResult438 = clamp( ( ( tex2Dlod( _MaskMap, float4( (texCoord439*_TilingTransition + 0.0), 0, 0.0) ).r * _TransitionFactor ) + staticSwitch603 ) , 0.0 , 1.0 );
				float2 texCoord39 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_46_0 = ( pow( tex2Dlod( _MaskMap, float4( (texCoord39*_Tiling + 0.0), 0, 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_32_0 = ( ( 1.0 - ( clampResult438 * float3(1,1,1) ) ) + temp_output_46_0 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch469 = ( 1.0 - temp_output_32_0 );
				#else
				float3 staticSwitch469 = temp_output_32_0;
				#endif
				float mulTime382 = _TimeParameters.x * _Transition;
				float _Time535 = mulTime382;
				float _Period535 = 2.0;
				float localMyCustomExpression535 = MyCustomExpression535( _Time535 , _Period535 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch516 = localMyCustomExpression535;
				#else
				float staticSwitch516 = _ManualTransition;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch449 = ( 1.0 - staticSwitch516 );
				#else
				float staticSwitch449 = staticSwitch516;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch450 = ( _Exp * 2.0 );
				#else
				float staticSwitch450 = _Exp;
				#endif
				float3 temp_cast_0 = (( ( pow( staticSwitch449 , staticSwitch450 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult34 = clamp( (( staticSwitch469 - temp_cast_0 )).z , 0.0 , 1.0 );
				float temp_output_37_0 = ( 1.0 - pow( clampResult34 , 2.0 ) );
				float TransitionMask486 = temp_output_37_0;
				float lerpResult275 = lerp( 0.0 , ( _Push / 100.0 ) , TransitionMask486);
				#ifdef _INVERSEANIMATION_ON
				float3 staticSwitch455 = ( _NormalizedRotationAxis * -1.0 );
				#else
				float3 staticSwitch455 = _NormalizedRotationAxis;
				#endif
				float MaskMap426 = temp_output_46_0;
				float4 transform261 = mul(GetWorldToObjectMatrix(),float4( 0,0,0,1 ));
				float3 objToWorld290 = mul( GetObjectToWorldMatrix(), float4( transform261.xyz, 1 ) ).xyz;
				float3 clampResult617 = clamp( _CustomPivotVec , float3( -1.5,-1.5,-1.5 ) , float3( 1.5,1.5,1.5 ) );
				#ifdef _CUSTOMPIVOT_ON
				float3 staticSwitch604 = clampResult617;
				#else
				float3 staticSwitch604 = objToWorld290;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float4 staticSwitch452 = ( _OffsetPivot * -1.0 );
				#else
				float4 staticSwitch452 = _OffsetPivot;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float3 worldToObj289 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 rotatedValue258 = RotateAroundAxis( ( float4( staticSwitch604 , 0.0 ) + ( staticSwitch452 / 100.0 ) ).xyz, worldToObj289, staticSwitch455, ( ( TransitionMask486 * MaskMap426 ) * _Angle ) );
				float3 FinalDisplacement347 = ( ( v.ase_normal * lerpResult275 ) + rotatedValue258 );
				
				float2 uv_NormalMap = v.ase_texcoord.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
				#ifdef _USENORMALMAP_ON
				float4 staticSwitch601 = tex2Dlod( _NormalMap, float4( uv_NormalMap, 0, 0.0) );
				#else
				float4 staticSwitch601 = float4( v.ase_normal , 0.0 );
				#endif
				
				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				o.ase_normal = v.ase_normal;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = FinalDisplacement347;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = staticSwitch601.rgb;

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

				float2 uv_MainMap548 = IN.ase_texcoord2.xy;
				float4 tex2DNode548 = tex2D( _MainMap, uv_MainMap548 );
				float3 objToViewDir521 = mul( UNITY_MATRIX_IT_MV, float4( IN.ase_normal, 0 ) ).xyz;
				float3 normalizeResult520 = normalize( objToViewDir521 );
				float3 normal519 = normalizeResult520;
				float2 localMyCustomExpression519 = MyCustomExpression519( normal519 );
				float3 desaturateInitialColor527 = tex2D( _MainColorMap, localMyCustomExpression519 ).rgb;
				float desaturateDot527 = dot( desaturateInitialColor527, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar527 = lerp( desaturateInitialColor527, desaturateDot527.xxx, _Desaturation );
				float3 temp_cast_1 = (_ColorPow).xxx;
				#ifdef _MAPMATCAP_ON
				float4 staticSwitch547 = ( float4( pow( desaturateVar527 , temp_cast_1 ) , 0.0 ) * _MainColorMult * _ColorTransition );
				#else
				float4 staticSwitch547 = tex2DNode548;
				#endif
				#ifdef _COLORMAP_ON
				float4 staticSwitch546 = _MainColor;
				#else
				float4 staticSwitch546 = staticSwitch547;
				#endif
				#ifdef _USEMAINTEXTURE_ON
				float4 staticSwitch616 = tex2DNode548;
				#else
				float4 staticSwitch616 = _ColorTransition;
				#endif
				float3 break181 = _WorldSpaceCameraPos;
				float3 appendResult179 = (float3(( break181.x * -1.0 ) , break181.z , break181.y));
				float3 temp_output_182_0 = ( appendResult179 * _Subdivision );
				float3 break176 = WorldPosition;
				float3 appendResult177 = (float3(( break176.x * -1.0 ) , break176.z , break176.y));
				float3 temp_output_174_0 = ( appendResult177 * _Subdivision );
				float3 WP265 = temp_output_174_0;
				float3 temp_output_2_0 = ( WP265 * 1.0 );
				float3 normalizeResult11 = normalize( ( temp_output_182_0 - temp_output_2_0 ) );
				float3 temp_output_1_0_g81 = normalizeResult11;
				float3 temp_output_45_0_g81 = temp_output_182_0;
				float dotResult22_g81 = dot( temp_output_1_0_g81 , temp_output_45_0_g81 );
				float3 temp_cast_3 = (0.5).xxx;
				float3 temp_output_2_0_g81 = ( ( ceil( temp_output_2_0 ) / 1.0 ) - temp_cast_3 );
				float dotResult25_g81 = dot( temp_output_1_0_g81 , temp_output_2_0_g81 );
				float3 temp_output_30_0_g81 = ( WP265 - temp_output_45_0_g81 );
				float dotResult28_g81 = dot( temp_output_1_0_g81 , temp_output_30_0_g81 );
				float temp_output_27_0_g81 = ( ( ( dotResult22_g81 - dotResult25_g81 ) * -1.0 ) / dotResult28_g81 );
				float3 normalizeResult27_g82 = normalize( temp_output_1_0_g81 );
				float3 normalizeResult31_g82 = normalize( float3(0,0.00015,-1) );
				float3 normalizeResult29_g82 = normalize( cross( normalizeResult27_g82 , normalizeResult31_g82 ) );
				float3 temp_output_7_0_g81 = ( normalizeResult29_g82 * float3( 1,1,1 ) );
				float3 temp_output_34_0_g81 = ( temp_output_45_0_g81 + ( temp_output_27_0_g81 * temp_output_30_0_g81 ) );
				float3 temp_output_35_0_g81 = ( temp_output_34_0_g81 - temp_output_2_0_g81 );
				float dotResult11_g81 = dot( temp_output_7_0_g81 , temp_output_35_0_g81 );
				float3 normalizeResult10_g81 = normalize( cross( temp_output_7_0_g81 , normalizeResult27_g82 ) );
				float dotResult12_g81 = dot( normalizeResult10_g81 , temp_output_35_0_g81 );
				float2 appendResult14_g81 = (float2(dotResult11_g81 , dotResult12_g81));
				float2 temp_cast_4 = (0.0).xx;
				float2 temp_cast_5 = (0.0).xx;
				float2 ifLocalVar15_g81 = 0;
				if( temp_output_27_0_g81 <= 0.0 )
				ifLocalVar15_g81 = temp_cast_5;
				else
				ifLocalVar15_g81 = appendResult14_g81;
				float2 texCoord439 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord30 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch603 = texCoord30.x;
				#else
				float staticSwitch603 = texCoord30.y;
				#endif
				float clampResult438 = clamp( ( ( tex2D( _MaskMap, (texCoord439*_TilingTransition + 0.0) ).r * _TransitionFactor ) + staticSwitch603 ) , 0.0 , 1.0 );
				float2 texCoord39 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_46_0 = ( pow( tex2D( _MaskMap, (texCoord39*_Tiling + 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_32_0 = ( ( 1.0 - ( clampResult438 * float3(1,1,1) ) ) + temp_output_46_0 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch469 = ( 1.0 - temp_output_32_0 );
				#else
				float3 staticSwitch469 = temp_output_32_0;
				#endif
				float mulTime382 = _TimeParameters.x * _Transition;
				float _Time535 = mulTime382;
				float _Period535 = 2.0;
				float localMyCustomExpression535 = MyCustomExpression535( _Time535 , _Period535 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch516 = localMyCustomExpression535;
				#else
				float staticSwitch516 = _ManualTransition;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch449 = ( 1.0 - staticSwitch516 );
				#else
				float staticSwitch449 = staticSwitch516;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch450 = ( _Exp * 2.0 );
				#else
				float staticSwitch450 = _Exp;
				#endif
				float3 temp_cast_6 = (( ( pow( staticSwitch449 , staticSwitch450 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult34 = clamp( (( staticSwitch469 - temp_cast_6 )).z , 0.0 , 1.0 );
				float temp_output_37_0 = ( 1.0 - pow( clampResult34 , 2.0 ) );
				float TransitionMask486 = temp_output_37_0;
				float MaskMap426 = temp_output_46_0;
				float lerpResult425 = lerp( 0.0 , _Distortion , TransitionMask486);
				float2 temp_output_419_0 = ( ( ( ifLocalVar15_g81 / ( ( 1.0 - ( TransitionMask486 * float2( 1,1 ) ) ) * _SizeWhenTransition ) ) + 0.5 ) + ( MaskMap426 * lerpResult425 ) );
				float2 temp_cast_7 = (0.5).xx;
				float lerpResult13 = lerp( 1.0 , 0.0 , TransitionMask486);
				float2 temp_output_7_0_g80 = ( ( temp_output_419_0 - temp_cast_7 ) / lerpResult13 );
				float2 temp_cast_8 = (0.5).xx;
				float dotResult2_g80 = dot( temp_output_7_0_g80 , temp_output_7_0_g80 );
				float lerpResult14 = lerp( 1.0 , 0.1 , TransitionMask486);
				float mulTime482 = _TimeParameters.x * 2.0;
				float cos481 = cos( ( mulTime482 + TransitionMask486 ) );
				float sin481 = sin( ( mulTime482 + TransitionMask486 ) );
				float2 rotator481 = mul( temp_output_419_0 - float2( 0.5,0.5 ) , float2x2( cos481 , -sin481 , sin481 , cos481 )) + float2( 0.5,0.5 );
				float clampResult485 = clamp( ( pow( tex2D( _Pattern, rotator481 ).r , 6.0 ) + 0.1 ) , 0.0 , 1.0 );
				float clampResult480 = clamp( ( clampResult485 - TransitionMask486 ) , 0.0 , 1.0 );
				float temp_output_252_0 = ( 1.0 - (( _CustomTexture )?( ( 1.0 - clampResult480 ) ):( pow( saturate( dotResult2_g80 ) , lerpResult14 ) )) );
				float clampResult395 = clamp( ( temp_output_252_0 * _STEP ) , 0.0 , 1.0 );
				float4 lerpResult310 = lerp( staticSwitch546 , ( ( staticSwitch616 * _EmissiveFctor ) * (( _DETAILES )?( frac( clampResult395 ) ):( 1.0 )) ) , pow( TransitionMask486 , _SharpTransition ));
				float4 FinalColor345 = lerpResult310;
				
				float lerpResult431 = lerp( 1.0 , temp_output_46_0 , temp_output_37_0);
				float lerpResult242 = lerp( lerpResult431 , 0.0 , TransitionMask486);
				float temp_output_241_0 = ( temp_output_252_0 * lerpResult242 );
				float FinalAlpha346 = floor( ceil( temp_output_241_0 ) );
				

				float3 BaseColor = FinalColor345.rgb;
				float Alpha = FinalAlpha346;
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
			#define _ALPHATEST_ON 1
			#define ASE_SRP_VERSION 140008


			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile_fragment _ _WRITE_RENDERING_LAYERS

			#define SHADERPASS SHADERPASS_DEPTHNORMALSONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#pragma shader_feature_local _INVERSEDIRECTION_ON
			#pragma shader_feature_local _TRANSITIONXVSY_ON
			#pragma shader_feature_local _INVERSEANIMATION_ON
			#pragma shader_feature_local _MANUALAUTOMATIC_ON
			#pragma shader_feature_local _CUSTOMPIVOT_ON
			#pragma shader_feature_local _USENORMALMAP_ON


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
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord : TEXCOORD1;
				#endif
				float3 worldNormal : TEXCOORD2;
				float4 worldTangent : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _OffsetPivot;
			float4 _NormalMap_ST;
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
			float _ManualTransition;
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
			sampler2D _NormalMap;
			sampler2D _Pattern;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			float MyCustomExpression535( float _Time, float _Period )
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

				float2 texCoord439 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord30 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch603 = texCoord30.x;
				#else
				float staticSwitch603 = texCoord30.y;
				#endif
				float clampResult438 = clamp( ( ( tex2Dlod( _MaskMap, float4( (texCoord439*_TilingTransition + 0.0), 0, 0.0) ).r * _TransitionFactor ) + staticSwitch603 ) , 0.0 , 1.0 );
				float2 texCoord39 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_46_0 = ( pow( tex2Dlod( _MaskMap, float4( (texCoord39*_Tiling + 0.0), 0, 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_32_0 = ( ( 1.0 - ( clampResult438 * float3(1,1,1) ) ) + temp_output_46_0 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch469 = ( 1.0 - temp_output_32_0 );
				#else
				float3 staticSwitch469 = temp_output_32_0;
				#endif
				float mulTime382 = _TimeParameters.x * _Transition;
				float _Time535 = mulTime382;
				float _Period535 = 2.0;
				float localMyCustomExpression535 = MyCustomExpression535( _Time535 , _Period535 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch516 = localMyCustomExpression535;
				#else
				float staticSwitch516 = _ManualTransition;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch449 = ( 1.0 - staticSwitch516 );
				#else
				float staticSwitch449 = staticSwitch516;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch450 = ( _Exp * 2.0 );
				#else
				float staticSwitch450 = _Exp;
				#endif
				float3 temp_cast_0 = (( ( pow( staticSwitch449 , staticSwitch450 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult34 = clamp( (( staticSwitch469 - temp_cast_0 )).z , 0.0 , 1.0 );
				float temp_output_37_0 = ( 1.0 - pow( clampResult34 , 2.0 ) );
				float TransitionMask486 = temp_output_37_0;
				float lerpResult275 = lerp( 0.0 , ( _Push / 100.0 ) , TransitionMask486);
				#ifdef _INVERSEANIMATION_ON
				float3 staticSwitch455 = ( _NormalizedRotationAxis * -1.0 );
				#else
				float3 staticSwitch455 = _NormalizedRotationAxis;
				#endif
				float MaskMap426 = temp_output_46_0;
				float4 transform261 = mul(GetWorldToObjectMatrix(),float4( 0,0,0,1 ));
				float3 objToWorld290 = mul( GetObjectToWorldMatrix(), float4( transform261.xyz, 1 ) ).xyz;
				float3 clampResult617 = clamp( _CustomPivotVec , float3( -1.5,-1.5,-1.5 ) , float3( 1.5,1.5,1.5 ) );
				#ifdef _CUSTOMPIVOT_ON
				float3 staticSwitch604 = clampResult617;
				#else
				float3 staticSwitch604 = objToWorld290;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float4 staticSwitch452 = ( _OffsetPivot * -1.0 );
				#else
				float4 staticSwitch452 = _OffsetPivot;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float3 worldToObj289 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 rotatedValue258 = RotateAroundAxis( ( float4( staticSwitch604 , 0.0 ) + ( staticSwitch452 / 100.0 ) ).xyz, worldToObj289, staticSwitch455, ( ( TransitionMask486 * MaskMap426 ) * _Angle ) );
				float3 FinalDisplacement347 = ( ( v.ase_normal * lerpResult275 ) + rotatedValue258 );
				
				float2 uv_NormalMap = v.ase_texcoord.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
				#ifdef _USENORMALMAP_ON
				float4 staticSwitch601 = tex2Dlod( _NormalMap, float4( uv_NormalMap, 0, 0.0) );
				#else
				float4 staticSwitch601 = float4( v.ase_normal , 0.0 );
				#endif
				
				o.ase_texcoord4.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord4.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = FinalDisplacement347;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = staticSwitch601.rgb;
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

			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE)
				#define ASE_SV_DEPTH SV_DepthLessEqual
			#else
				#define ASE_SV_DEPTH SV_Depth
			#endif

			void frag(	VertexOutput IN
						, out half4 outNormalWS : SV_Target0
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						#ifdef _WRITE_RENDERING_LAYERS
						, out float4 outRenderingLayers : SV_Target1
						#endif
						 )
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 WorldPosition = IN.worldPos;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );
				float3 WorldNormal = IN.worldNormal;
				float4 WorldTangent = IN.worldTangent;

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float3 break181 = _WorldSpaceCameraPos;
				float3 appendResult179 = (float3(( break181.x * -1.0 ) , break181.z , break181.y));
				float3 temp_output_182_0 = ( appendResult179 * _Subdivision );
				float3 break176 = WorldPosition;
				float3 appendResult177 = (float3(( break176.x * -1.0 ) , break176.z , break176.y));
				float3 temp_output_174_0 = ( appendResult177 * _Subdivision );
				float3 WP265 = temp_output_174_0;
				float3 temp_output_2_0 = ( WP265 * 1.0 );
				float3 normalizeResult11 = normalize( ( temp_output_182_0 - temp_output_2_0 ) );
				float3 temp_output_1_0_g81 = normalizeResult11;
				float3 temp_output_45_0_g81 = temp_output_182_0;
				float dotResult22_g81 = dot( temp_output_1_0_g81 , temp_output_45_0_g81 );
				float3 temp_cast_0 = (0.5).xxx;
				float3 temp_output_2_0_g81 = ( ( ceil( temp_output_2_0 ) / 1.0 ) - temp_cast_0 );
				float dotResult25_g81 = dot( temp_output_1_0_g81 , temp_output_2_0_g81 );
				float3 temp_output_30_0_g81 = ( WP265 - temp_output_45_0_g81 );
				float dotResult28_g81 = dot( temp_output_1_0_g81 , temp_output_30_0_g81 );
				float temp_output_27_0_g81 = ( ( ( dotResult22_g81 - dotResult25_g81 ) * -1.0 ) / dotResult28_g81 );
				float3 normalizeResult27_g82 = normalize( temp_output_1_0_g81 );
				float3 normalizeResult31_g82 = normalize( float3(0,0.00015,-1) );
				float3 normalizeResult29_g82 = normalize( cross( normalizeResult27_g82 , normalizeResult31_g82 ) );
				float3 temp_output_7_0_g81 = ( normalizeResult29_g82 * float3( 1,1,1 ) );
				float3 temp_output_34_0_g81 = ( temp_output_45_0_g81 + ( temp_output_27_0_g81 * temp_output_30_0_g81 ) );
				float3 temp_output_35_0_g81 = ( temp_output_34_0_g81 - temp_output_2_0_g81 );
				float dotResult11_g81 = dot( temp_output_7_0_g81 , temp_output_35_0_g81 );
				float3 normalizeResult10_g81 = normalize( cross( temp_output_7_0_g81 , normalizeResult27_g82 ) );
				float dotResult12_g81 = dot( normalizeResult10_g81 , temp_output_35_0_g81 );
				float2 appendResult14_g81 = (float2(dotResult11_g81 , dotResult12_g81));
				float2 temp_cast_1 = (0.0).xx;
				float2 temp_cast_2 = (0.0).xx;
				float2 ifLocalVar15_g81 = 0;
				if( temp_output_27_0_g81 <= 0.0 )
				ifLocalVar15_g81 = temp_cast_2;
				else
				ifLocalVar15_g81 = appendResult14_g81;
				float2 texCoord439 = IN.ase_texcoord4.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord30 = IN.ase_texcoord4.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch603 = texCoord30.x;
				#else
				float staticSwitch603 = texCoord30.y;
				#endif
				float clampResult438 = clamp( ( ( tex2D( _MaskMap, (texCoord439*_TilingTransition + 0.0) ).r * _TransitionFactor ) + staticSwitch603 ) , 0.0 , 1.0 );
				float2 texCoord39 = IN.ase_texcoord4.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_46_0 = ( pow( tex2D( _MaskMap, (texCoord39*_Tiling + 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_32_0 = ( ( 1.0 - ( clampResult438 * float3(1,1,1) ) ) + temp_output_46_0 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch469 = ( 1.0 - temp_output_32_0 );
				#else
				float3 staticSwitch469 = temp_output_32_0;
				#endif
				float mulTime382 = _TimeParameters.x * _Transition;
				float _Time535 = mulTime382;
				float _Period535 = 2.0;
				float localMyCustomExpression535 = MyCustomExpression535( _Time535 , _Period535 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch516 = localMyCustomExpression535;
				#else
				float staticSwitch516 = _ManualTransition;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch449 = ( 1.0 - staticSwitch516 );
				#else
				float staticSwitch449 = staticSwitch516;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch450 = ( _Exp * 2.0 );
				#else
				float staticSwitch450 = _Exp;
				#endif
				float3 temp_cast_3 = (( ( pow( staticSwitch449 , staticSwitch450 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult34 = clamp( (( staticSwitch469 - temp_cast_3 )).z , 0.0 , 1.0 );
				float temp_output_37_0 = ( 1.0 - pow( clampResult34 , 2.0 ) );
				float TransitionMask486 = temp_output_37_0;
				float MaskMap426 = temp_output_46_0;
				float lerpResult425 = lerp( 0.0 , _Distortion , TransitionMask486);
				float2 temp_output_419_0 = ( ( ( ifLocalVar15_g81 / ( ( 1.0 - ( TransitionMask486 * float2( 1,1 ) ) ) * _SizeWhenTransition ) ) + 0.5 ) + ( MaskMap426 * lerpResult425 ) );
				float2 temp_cast_4 = (0.5).xx;
				float lerpResult13 = lerp( 1.0 , 0.0 , TransitionMask486);
				float2 temp_output_7_0_g80 = ( ( temp_output_419_0 - temp_cast_4 ) / lerpResult13 );
				float2 temp_cast_5 = (0.5).xx;
				float dotResult2_g80 = dot( temp_output_7_0_g80 , temp_output_7_0_g80 );
				float lerpResult14 = lerp( 1.0 , 0.1 , TransitionMask486);
				float mulTime482 = _TimeParameters.x * 2.0;
				float cos481 = cos( ( mulTime482 + TransitionMask486 ) );
				float sin481 = sin( ( mulTime482 + TransitionMask486 ) );
				float2 rotator481 = mul( temp_output_419_0 - float2( 0.5,0.5 ) , float2x2( cos481 , -sin481 , sin481 , cos481 )) + float2( 0.5,0.5 );
				float clampResult485 = clamp( ( pow( tex2D( _Pattern, rotator481 ).r , 6.0 ) + 0.1 ) , 0.0 , 1.0 );
				float clampResult480 = clamp( ( clampResult485 - TransitionMask486 ) , 0.0 , 1.0 );
				float temp_output_252_0 = ( 1.0 - (( _CustomTexture )?( ( 1.0 - clampResult480 ) ):( pow( saturate( dotResult2_g80 ) , lerpResult14 ) )) );
				float lerpResult431 = lerp( 1.0 , temp_output_46_0 , temp_output_37_0);
				float lerpResult242 = lerp( lerpResult431 , 0.0 , TransitionMask486);
				float temp_output_241_0 = ( temp_output_252_0 * lerpResult242 );
				float FinalAlpha346 = floor( ceil( temp_output_241_0 ) );
				

				float3 Normal = float3(0, 0, 1);
				float Alpha = FinalAlpha346;
				float AlphaClipThreshold = 0.1;
				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = 0;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODFadeCrossFade( IN.clipPos );
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				#if defined(_GBUFFER_NORMALS_OCT)
					float2 octNormalWS = PackNormalOctQuadEncode(WorldNormal);
					float2 remappedOctNormalWS = saturate(octNormalWS * 0.5 + 0.5);
					half3 packedNormalWS = PackFloat2To888(remappedOctNormalWS);
					outNormalWS = half4(packedNormalWS, 0.0);
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
					outNormalWS = half4(NormalizeNormalPerPixel(normalWS), 0.0);
				#endif

				#ifdef _WRITE_RENDERING_LAYERS
					uint renderingLayers = GetMeshRenderingLayer();
					outRenderingLayers = float4( EncodeMeshRenderingLayer( renderingLayers ), 0, 0, 0 );
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
			#define _ALPHATEST_ON 1
			#define ASE_SRP_VERSION 140008


			#pragma shader_feature_local _RECEIVE_SHADOWS_OFF
			#pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
			#pragma shader_feature_local_fragment _ENVIRONMENTREFLECTIONS_OFF

			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
			#pragma multi_compile_fragment _ _SHADOWS_SOFT
			#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
			#pragma multi_compile_fragment _ _RENDER_PASS_ENABLED

			#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
			#pragma multi_compile _ SHADOWS_SHADOWMASK
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON
			#pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
			#pragma multi_compile_fragment _ _WRITE_RENDERING_LAYERS

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
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
			
			#if defined(UNITY_INSTANCING_ENABLED) && defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL)
				#define ENABLE_TERRAIN_PERPIXEL_NORMAL
			#endif

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#pragma shader_feature_local _INVERSEDIRECTION_ON
			#pragma shader_feature_local _TRANSITIONXVSY_ON
			#pragma shader_feature_local _INVERSEANIMATION_ON
			#pragma shader_feature_local _MANUALAUTOMATIC_ON
			#pragma shader_feature_local _CUSTOMPIVOT_ON
			#pragma shader_feature_local _USENORMALMAP_ON
			#pragma shader_feature_local _COLORMAP_ON
			#pragma shader_feature_local _MAPMATCAP_ON
			#pragma shader_feature_local _USEMAINTEXTURE_ON


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
				float4 clipPos : SV_POSITION;
				float4 lightmapUVOrVertexSH : TEXCOORD0;
				half4 fogFactorAndVertexLight : TEXCOORD1;
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				float4 shadowCoord : TEXCOORD2;
				#endif
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				float4 screenPos : TEXCOORD6;
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
			float4 _NormalMap_ST;
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
			float _ManualTransition;
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
			sampler2D _NormalMap;
			sampler2D _MainMap;
			sampler2D _MainColorMap;
			sampler2D _Pattern;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"

			float MyCustomExpression535( float _Time, float _Period )
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
			
			float2 MyCustomExpression519( float3 normal )
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

				float2 texCoord439 = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord30 = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch603 = texCoord30.x;
				#else
				float staticSwitch603 = texCoord30.y;
				#endif
				float clampResult438 = clamp( ( ( tex2Dlod( _MaskMap, float4( (texCoord439*_TilingTransition + 0.0), 0, 0.0) ).r * _TransitionFactor ) + staticSwitch603 ) , 0.0 , 1.0 );
				float2 texCoord39 = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_46_0 = ( pow( tex2Dlod( _MaskMap, float4( (texCoord39*_Tiling + 0.0), 0, 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_32_0 = ( ( 1.0 - ( clampResult438 * float3(1,1,1) ) ) + temp_output_46_0 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch469 = ( 1.0 - temp_output_32_0 );
				#else
				float3 staticSwitch469 = temp_output_32_0;
				#endif
				float mulTime382 = _TimeParameters.x * _Transition;
				float _Time535 = mulTime382;
				float _Period535 = 2.0;
				float localMyCustomExpression535 = MyCustomExpression535( _Time535 , _Period535 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch516 = localMyCustomExpression535;
				#else
				float staticSwitch516 = _ManualTransition;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch449 = ( 1.0 - staticSwitch516 );
				#else
				float staticSwitch449 = staticSwitch516;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch450 = ( _Exp * 2.0 );
				#else
				float staticSwitch450 = _Exp;
				#endif
				float3 temp_cast_0 = (( ( pow( staticSwitch449 , staticSwitch450 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult34 = clamp( (( staticSwitch469 - temp_cast_0 )).z , 0.0 , 1.0 );
				float temp_output_37_0 = ( 1.0 - pow( clampResult34 , 2.0 ) );
				float TransitionMask486 = temp_output_37_0;
				float lerpResult275 = lerp( 0.0 , ( _Push / 100.0 ) , TransitionMask486);
				#ifdef _INVERSEANIMATION_ON
				float3 staticSwitch455 = ( _NormalizedRotationAxis * -1.0 );
				#else
				float3 staticSwitch455 = _NormalizedRotationAxis;
				#endif
				float MaskMap426 = temp_output_46_0;
				float4 transform261 = mul(GetWorldToObjectMatrix(),float4( 0,0,0,1 ));
				float3 objToWorld290 = mul( GetObjectToWorldMatrix(), float4( transform261.xyz, 1 ) ).xyz;
				float3 clampResult617 = clamp( _CustomPivotVec , float3( -1.5,-1.5,-1.5 ) , float3( 1.5,1.5,1.5 ) );
				#ifdef _CUSTOMPIVOT_ON
				float3 staticSwitch604 = clampResult617;
				#else
				float3 staticSwitch604 = objToWorld290;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float4 staticSwitch452 = ( _OffsetPivot * -1.0 );
				#else
				float4 staticSwitch452 = _OffsetPivot;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float3 worldToObj289 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 rotatedValue258 = RotateAroundAxis( ( float4( staticSwitch604 , 0.0 ) + ( staticSwitch452 / 100.0 ) ).xyz, worldToObj289, staticSwitch455, ( ( TransitionMask486 * MaskMap426 ) * _Angle ) );
				float3 FinalDisplacement347 = ( ( v.ase_normal * lerpResult275 ) + rotatedValue258 );
				
				float2 uv_NormalMap = v.texcoord.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
				#ifdef _USENORMALMAP_ON
				float4 staticSwitch601 = tex2Dlod( _NormalMap, float4( uv_NormalMap, 0, 0.0) );
				#else
				float4 staticSwitch601 = float4( v.ase_normal , 0.0 );
				#endif
				
				o.ase_texcoord8.xy = v.texcoord.xy;
				o.ase_normal = v.ase_normal;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord8.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = FinalDisplacement347;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = staticSwitch601.rgb;

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

				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
					o.screenPos = ComputeScreenPos(positionCS);
				#endif

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

			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE)
				#define ASE_SV_DEPTH SV_DepthLessEqual
			#else
				#define ASE_SV_DEPTH SV_Depth
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
					LODFadeCrossFade( IN.clipPos );
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

				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
					float4 ScreenPos = IN.screenPos;
				#endif

				float2 NormalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(IN.clipPos);

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					ShadowCoords = IN.shadowCoord;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
				#else
					ShadowCoords = float4(0, 0, 0, 0);
				#endif

				WorldViewDirection = SafeNormalize( WorldViewDirection );

				float2 uv_MainMap548 = IN.ase_texcoord8.xy;
				float4 tex2DNode548 = tex2D( _MainMap, uv_MainMap548 );
				float3 objToViewDir521 = mul( UNITY_MATRIX_IT_MV, float4( IN.ase_normal, 0 ) ).xyz;
				float3 normalizeResult520 = normalize( objToViewDir521 );
				float3 normal519 = normalizeResult520;
				float2 localMyCustomExpression519 = MyCustomExpression519( normal519 );
				float3 desaturateInitialColor527 = tex2D( _MainColorMap, localMyCustomExpression519 ).rgb;
				float desaturateDot527 = dot( desaturateInitialColor527, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar527 = lerp( desaturateInitialColor527, desaturateDot527.xxx, _Desaturation );
				float3 temp_cast_1 = (_ColorPow).xxx;
				#ifdef _MAPMATCAP_ON
				float4 staticSwitch547 = ( float4( pow( desaturateVar527 , temp_cast_1 ) , 0.0 ) * _MainColorMult * _ColorTransition );
				#else
				float4 staticSwitch547 = tex2DNode548;
				#endif
				#ifdef _COLORMAP_ON
				float4 staticSwitch546 = _MainColor;
				#else
				float4 staticSwitch546 = staticSwitch547;
				#endif
				#ifdef _USEMAINTEXTURE_ON
				float4 staticSwitch616 = tex2DNode548;
				#else
				float4 staticSwitch616 = _ColorTransition;
				#endif
				float3 break181 = _WorldSpaceCameraPos;
				float3 appendResult179 = (float3(( break181.x * -1.0 ) , break181.z , break181.y));
				float3 temp_output_182_0 = ( appendResult179 * _Subdivision );
				float3 break176 = WorldPosition;
				float3 appendResult177 = (float3(( break176.x * -1.0 ) , break176.z , break176.y));
				float3 temp_output_174_0 = ( appendResult177 * _Subdivision );
				float3 WP265 = temp_output_174_0;
				float3 temp_output_2_0 = ( WP265 * 1.0 );
				float3 normalizeResult11 = normalize( ( temp_output_182_0 - temp_output_2_0 ) );
				float3 temp_output_1_0_g81 = normalizeResult11;
				float3 temp_output_45_0_g81 = temp_output_182_0;
				float dotResult22_g81 = dot( temp_output_1_0_g81 , temp_output_45_0_g81 );
				float3 temp_cast_3 = (0.5).xxx;
				float3 temp_output_2_0_g81 = ( ( ceil( temp_output_2_0 ) / 1.0 ) - temp_cast_3 );
				float dotResult25_g81 = dot( temp_output_1_0_g81 , temp_output_2_0_g81 );
				float3 temp_output_30_0_g81 = ( WP265 - temp_output_45_0_g81 );
				float dotResult28_g81 = dot( temp_output_1_0_g81 , temp_output_30_0_g81 );
				float temp_output_27_0_g81 = ( ( ( dotResult22_g81 - dotResult25_g81 ) * -1.0 ) / dotResult28_g81 );
				float3 normalizeResult27_g82 = normalize( temp_output_1_0_g81 );
				float3 normalizeResult31_g82 = normalize( float3(0,0.00015,-1) );
				float3 normalizeResult29_g82 = normalize( cross( normalizeResult27_g82 , normalizeResult31_g82 ) );
				float3 temp_output_7_0_g81 = ( normalizeResult29_g82 * float3( 1,1,1 ) );
				float3 temp_output_34_0_g81 = ( temp_output_45_0_g81 + ( temp_output_27_0_g81 * temp_output_30_0_g81 ) );
				float3 temp_output_35_0_g81 = ( temp_output_34_0_g81 - temp_output_2_0_g81 );
				float dotResult11_g81 = dot( temp_output_7_0_g81 , temp_output_35_0_g81 );
				float3 normalizeResult10_g81 = normalize( cross( temp_output_7_0_g81 , normalizeResult27_g82 ) );
				float dotResult12_g81 = dot( normalizeResult10_g81 , temp_output_35_0_g81 );
				float2 appendResult14_g81 = (float2(dotResult11_g81 , dotResult12_g81));
				float2 temp_cast_4 = (0.0).xx;
				float2 temp_cast_5 = (0.0).xx;
				float2 ifLocalVar15_g81 = 0;
				if( temp_output_27_0_g81 <= 0.0 )
				ifLocalVar15_g81 = temp_cast_5;
				else
				ifLocalVar15_g81 = appendResult14_g81;
				float2 texCoord439 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord30 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch603 = texCoord30.x;
				#else
				float staticSwitch603 = texCoord30.y;
				#endif
				float clampResult438 = clamp( ( ( tex2D( _MaskMap, (texCoord439*_TilingTransition + 0.0) ).r * _TransitionFactor ) + staticSwitch603 ) , 0.0 , 1.0 );
				float2 texCoord39 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_46_0 = ( pow( tex2D( _MaskMap, (texCoord39*_Tiling + 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_32_0 = ( ( 1.0 - ( clampResult438 * float3(1,1,1) ) ) + temp_output_46_0 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch469 = ( 1.0 - temp_output_32_0 );
				#else
				float3 staticSwitch469 = temp_output_32_0;
				#endif
				float mulTime382 = _TimeParameters.x * _Transition;
				float _Time535 = mulTime382;
				float _Period535 = 2.0;
				float localMyCustomExpression535 = MyCustomExpression535( _Time535 , _Period535 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch516 = localMyCustomExpression535;
				#else
				float staticSwitch516 = _ManualTransition;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch449 = ( 1.0 - staticSwitch516 );
				#else
				float staticSwitch449 = staticSwitch516;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch450 = ( _Exp * 2.0 );
				#else
				float staticSwitch450 = _Exp;
				#endif
				float3 temp_cast_6 = (( ( pow( staticSwitch449 , staticSwitch450 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult34 = clamp( (( staticSwitch469 - temp_cast_6 )).z , 0.0 , 1.0 );
				float temp_output_37_0 = ( 1.0 - pow( clampResult34 , 2.0 ) );
				float TransitionMask486 = temp_output_37_0;
				float MaskMap426 = temp_output_46_0;
				float lerpResult425 = lerp( 0.0 , _Distortion , TransitionMask486);
				float2 temp_output_419_0 = ( ( ( ifLocalVar15_g81 / ( ( 1.0 - ( TransitionMask486 * float2( 1,1 ) ) ) * _SizeWhenTransition ) ) + 0.5 ) + ( MaskMap426 * lerpResult425 ) );
				float2 temp_cast_7 = (0.5).xx;
				float lerpResult13 = lerp( 1.0 , 0.0 , TransitionMask486);
				float2 temp_output_7_0_g80 = ( ( temp_output_419_0 - temp_cast_7 ) / lerpResult13 );
				float2 temp_cast_8 = (0.5).xx;
				float dotResult2_g80 = dot( temp_output_7_0_g80 , temp_output_7_0_g80 );
				float lerpResult14 = lerp( 1.0 , 0.1 , TransitionMask486);
				float mulTime482 = _TimeParameters.x * 2.0;
				float cos481 = cos( ( mulTime482 + TransitionMask486 ) );
				float sin481 = sin( ( mulTime482 + TransitionMask486 ) );
				float2 rotator481 = mul( temp_output_419_0 - float2( 0.5,0.5 ) , float2x2( cos481 , -sin481 , sin481 , cos481 )) + float2( 0.5,0.5 );
				float clampResult485 = clamp( ( pow( tex2D( _Pattern, rotator481 ).r , 6.0 ) + 0.1 ) , 0.0 , 1.0 );
				float clampResult480 = clamp( ( clampResult485 - TransitionMask486 ) , 0.0 , 1.0 );
				float temp_output_252_0 = ( 1.0 - (( _CustomTexture )?( ( 1.0 - clampResult480 ) ):( pow( saturate( dotResult2_g80 ) , lerpResult14 ) )) );
				float clampResult395 = clamp( ( temp_output_252_0 * _STEP ) , 0.0 , 1.0 );
				float4 lerpResult310 = lerp( staticSwitch546 , ( ( staticSwitch616 * _EmissiveFctor ) * (( _DETAILES )?( frac( clampResult395 ) ):( 1.0 )) ) , pow( TransitionMask486 , _SharpTransition ));
				float4 FinalColor345 = lerpResult310;
				
				float lerpResult431 = lerp( 1.0 , temp_output_46_0 , temp_output_37_0);
				float lerpResult242 = lerp( lerpResult431 , 0.0 , TransitionMask486);
				float temp_output_241_0 = ( temp_output_252_0 * lerpResult242 );
				float FinalAlpha346 = floor( ceil( temp_output_241_0 ) );
				

				float3 BaseColor = FinalColor345.rgb;
				float3 Normal = float3(0, 0, 1);
				float3 Emission = 0;
				float3 Specular = 0.5;
				float Metallic = _Metallic;
				float Smoothness = _Smoothness;
				float Occlusion = 1;
				float Alpha = FinalAlpha346;
				float AlphaClipThreshold = 0.1;
				float AlphaClipThresholdShadow = 0.5;
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				float3 Transmission = 1;
				float3 Translucency = 1;

				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = 0;
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
			#define _ALPHATEST_ON 1
			#define ASE_SRP_VERSION 140008


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
			#pragma shader_feature_local _INVERSEANIMATION_ON
			#pragma shader_feature_local _MANUALAUTOMATIC_ON
			#pragma shader_feature_local _CUSTOMPIVOT_ON
			#pragma shader_feature_local _USENORMALMAP_ON


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
			float4 _NormalMap_ST;
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
			float _ManualTransition;
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
			sampler2D _NormalMap;
			sampler2D _Pattern;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			float MyCustomExpression535( float _Time, float _Period )
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

				float2 texCoord439 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord30 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch603 = texCoord30.x;
				#else
				float staticSwitch603 = texCoord30.y;
				#endif
				float clampResult438 = clamp( ( ( tex2Dlod( _MaskMap, float4( (texCoord439*_TilingTransition + 0.0), 0, 0.0) ).r * _TransitionFactor ) + staticSwitch603 ) , 0.0 , 1.0 );
				float2 texCoord39 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_46_0 = ( pow( tex2Dlod( _MaskMap, float4( (texCoord39*_Tiling + 0.0), 0, 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_32_0 = ( ( 1.0 - ( clampResult438 * float3(1,1,1) ) ) + temp_output_46_0 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch469 = ( 1.0 - temp_output_32_0 );
				#else
				float3 staticSwitch469 = temp_output_32_0;
				#endif
				float mulTime382 = _TimeParameters.x * _Transition;
				float _Time535 = mulTime382;
				float _Period535 = 2.0;
				float localMyCustomExpression535 = MyCustomExpression535( _Time535 , _Period535 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch516 = localMyCustomExpression535;
				#else
				float staticSwitch516 = _ManualTransition;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch449 = ( 1.0 - staticSwitch516 );
				#else
				float staticSwitch449 = staticSwitch516;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch450 = ( _Exp * 2.0 );
				#else
				float staticSwitch450 = _Exp;
				#endif
				float3 temp_cast_0 = (( ( pow( staticSwitch449 , staticSwitch450 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult34 = clamp( (( staticSwitch469 - temp_cast_0 )).z , 0.0 , 1.0 );
				float temp_output_37_0 = ( 1.0 - pow( clampResult34 , 2.0 ) );
				float TransitionMask486 = temp_output_37_0;
				float lerpResult275 = lerp( 0.0 , ( _Push / 100.0 ) , TransitionMask486);
				#ifdef _INVERSEANIMATION_ON
				float3 staticSwitch455 = ( _NormalizedRotationAxis * -1.0 );
				#else
				float3 staticSwitch455 = _NormalizedRotationAxis;
				#endif
				float MaskMap426 = temp_output_46_0;
				float4 transform261 = mul(GetWorldToObjectMatrix(),float4( 0,0,0,1 ));
				float3 objToWorld290 = mul( GetObjectToWorldMatrix(), float4( transform261.xyz, 1 ) ).xyz;
				float3 clampResult617 = clamp( _CustomPivotVec , float3( -1.5,-1.5,-1.5 ) , float3( 1.5,1.5,1.5 ) );
				#ifdef _CUSTOMPIVOT_ON
				float3 staticSwitch604 = clampResult617;
				#else
				float3 staticSwitch604 = objToWorld290;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float4 staticSwitch452 = ( _OffsetPivot * -1.0 );
				#else
				float4 staticSwitch452 = _OffsetPivot;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float3 worldToObj289 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 rotatedValue258 = RotateAroundAxis( ( float4( staticSwitch604 , 0.0 ) + ( staticSwitch452 / 100.0 ) ).xyz, worldToObj289, staticSwitch455, ( ( TransitionMask486 * MaskMap426 ) * _Angle ) );
				float3 FinalDisplacement347 = ( ( v.ase_normal * lerpResult275 ) + rotatedValue258 );
				
				float2 uv_NormalMap = v.ase_texcoord.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
				#ifdef _USENORMALMAP_ON
				float4 staticSwitch601 = tex2Dlod( _NormalMap, float4( uv_NormalMap, 0, 0.0) );
				#else
				float4 staticSwitch601 = float4( v.ase_normal , 0.0 );
				#endif
				
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

				float3 vertexValue = FinalDisplacement347;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = staticSwitch601.rgb;

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

				float3 break181 = _WorldSpaceCameraPos;
				float3 appendResult179 = (float3(( break181.x * -1.0 ) , break181.z , break181.y));
				float3 temp_output_182_0 = ( appendResult179 * _Subdivision );
				float3 ase_worldPos = IN.ase_texcoord.xyz;
				float3 break176 = ase_worldPos;
				float3 appendResult177 = (float3(( break176.x * -1.0 ) , break176.z , break176.y));
				float3 temp_output_174_0 = ( appendResult177 * _Subdivision );
				float3 WP265 = temp_output_174_0;
				float3 temp_output_2_0 = ( WP265 * 1.0 );
				float3 normalizeResult11 = normalize( ( temp_output_182_0 - temp_output_2_0 ) );
				float3 temp_output_1_0_g81 = normalizeResult11;
				float3 temp_output_45_0_g81 = temp_output_182_0;
				float dotResult22_g81 = dot( temp_output_1_0_g81 , temp_output_45_0_g81 );
				float3 temp_cast_0 = (0.5).xxx;
				float3 temp_output_2_0_g81 = ( ( ceil( temp_output_2_0 ) / 1.0 ) - temp_cast_0 );
				float dotResult25_g81 = dot( temp_output_1_0_g81 , temp_output_2_0_g81 );
				float3 temp_output_30_0_g81 = ( WP265 - temp_output_45_0_g81 );
				float dotResult28_g81 = dot( temp_output_1_0_g81 , temp_output_30_0_g81 );
				float temp_output_27_0_g81 = ( ( ( dotResult22_g81 - dotResult25_g81 ) * -1.0 ) / dotResult28_g81 );
				float3 normalizeResult27_g82 = normalize( temp_output_1_0_g81 );
				float3 normalizeResult31_g82 = normalize( float3(0,0.00015,-1) );
				float3 normalizeResult29_g82 = normalize( cross( normalizeResult27_g82 , normalizeResult31_g82 ) );
				float3 temp_output_7_0_g81 = ( normalizeResult29_g82 * float3( 1,1,1 ) );
				float3 temp_output_34_0_g81 = ( temp_output_45_0_g81 + ( temp_output_27_0_g81 * temp_output_30_0_g81 ) );
				float3 temp_output_35_0_g81 = ( temp_output_34_0_g81 - temp_output_2_0_g81 );
				float dotResult11_g81 = dot( temp_output_7_0_g81 , temp_output_35_0_g81 );
				float3 normalizeResult10_g81 = normalize( cross( temp_output_7_0_g81 , normalizeResult27_g82 ) );
				float dotResult12_g81 = dot( normalizeResult10_g81 , temp_output_35_0_g81 );
				float2 appendResult14_g81 = (float2(dotResult11_g81 , dotResult12_g81));
				float2 temp_cast_1 = (0.0).xx;
				float2 temp_cast_2 = (0.0).xx;
				float2 ifLocalVar15_g81 = 0;
				if( temp_output_27_0_g81 <= 0.0 )
				ifLocalVar15_g81 = temp_cast_2;
				else
				ifLocalVar15_g81 = appendResult14_g81;
				float2 texCoord439 = IN.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord30 = IN.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch603 = texCoord30.x;
				#else
				float staticSwitch603 = texCoord30.y;
				#endif
				float clampResult438 = clamp( ( ( tex2D( _MaskMap, (texCoord439*_TilingTransition + 0.0) ).r * _TransitionFactor ) + staticSwitch603 ) , 0.0 , 1.0 );
				float2 texCoord39 = IN.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_46_0 = ( pow( tex2D( _MaskMap, (texCoord39*_Tiling + 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_32_0 = ( ( 1.0 - ( clampResult438 * float3(1,1,1) ) ) + temp_output_46_0 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch469 = ( 1.0 - temp_output_32_0 );
				#else
				float3 staticSwitch469 = temp_output_32_0;
				#endif
				float mulTime382 = _TimeParameters.x * _Transition;
				float _Time535 = mulTime382;
				float _Period535 = 2.0;
				float localMyCustomExpression535 = MyCustomExpression535( _Time535 , _Period535 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch516 = localMyCustomExpression535;
				#else
				float staticSwitch516 = _ManualTransition;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch449 = ( 1.0 - staticSwitch516 );
				#else
				float staticSwitch449 = staticSwitch516;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch450 = ( _Exp * 2.0 );
				#else
				float staticSwitch450 = _Exp;
				#endif
				float3 temp_cast_3 = (( ( pow( staticSwitch449 , staticSwitch450 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult34 = clamp( (( staticSwitch469 - temp_cast_3 )).z , 0.0 , 1.0 );
				float temp_output_37_0 = ( 1.0 - pow( clampResult34 , 2.0 ) );
				float TransitionMask486 = temp_output_37_0;
				float MaskMap426 = temp_output_46_0;
				float lerpResult425 = lerp( 0.0 , _Distortion , TransitionMask486);
				float2 temp_output_419_0 = ( ( ( ifLocalVar15_g81 / ( ( 1.0 - ( TransitionMask486 * float2( 1,1 ) ) ) * _SizeWhenTransition ) ) + 0.5 ) + ( MaskMap426 * lerpResult425 ) );
				float2 temp_cast_4 = (0.5).xx;
				float lerpResult13 = lerp( 1.0 , 0.0 , TransitionMask486);
				float2 temp_output_7_0_g80 = ( ( temp_output_419_0 - temp_cast_4 ) / lerpResult13 );
				float2 temp_cast_5 = (0.5).xx;
				float dotResult2_g80 = dot( temp_output_7_0_g80 , temp_output_7_0_g80 );
				float lerpResult14 = lerp( 1.0 , 0.1 , TransitionMask486);
				float mulTime482 = _TimeParameters.x * 2.0;
				float cos481 = cos( ( mulTime482 + TransitionMask486 ) );
				float sin481 = sin( ( mulTime482 + TransitionMask486 ) );
				float2 rotator481 = mul( temp_output_419_0 - float2( 0.5,0.5 ) , float2x2( cos481 , -sin481 , sin481 , cos481 )) + float2( 0.5,0.5 );
				float clampResult485 = clamp( ( pow( tex2D( _Pattern, rotator481 ).r , 6.0 ) + 0.1 ) , 0.0 , 1.0 );
				float clampResult480 = clamp( ( clampResult485 - TransitionMask486 ) , 0.0 , 1.0 );
				float temp_output_252_0 = ( 1.0 - (( _CustomTexture )?( ( 1.0 - clampResult480 ) ):( pow( saturate( dotResult2_g80 ) , lerpResult14 ) )) );
				float lerpResult431 = lerp( 1.0 , temp_output_46_0 , temp_output_37_0);
				float lerpResult242 = lerp( lerpResult431 , 0.0 , TransitionMask486);
				float temp_output_241_0 = ( temp_output_252_0 * lerpResult242 );
				float FinalAlpha346 = floor( ceil( temp_output_241_0 ) );
				

				surfaceDescription.Alpha = FinalAlpha346;
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
			#define _ALPHATEST_ON 1
			#define ASE_SRP_VERSION 140008


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
			#pragma shader_feature_local _INVERSEANIMATION_ON
			#pragma shader_feature_local _MANUALAUTOMATIC_ON
			#pragma shader_feature_local _CUSTOMPIVOT_ON
			#pragma shader_feature_local _USENORMALMAP_ON


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
			float4 _NormalMap_ST;
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
			float _ManualTransition;
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
			sampler2D _NormalMap;
			sampler2D _Pattern;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			float MyCustomExpression535( float _Time, float _Period )
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

				float2 texCoord439 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord30 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch603 = texCoord30.x;
				#else
				float staticSwitch603 = texCoord30.y;
				#endif
				float clampResult438 = clamp( ( ( tex2Dlod( _MaskMap, float4( (texCoord439*_TilingTransition + 0.0), 0, 0.0) ).r * _TransitionFactor ) + staticSwitch603 ) , 0.0 , 1.0 );
				float2 texCoord39 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_46_0 = ( pow( tex2Dlod( _MaskMap, float4( (texCoord39*_Tiling + 0.0), 0, 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_32_0 = ( ( 1.0 - ( clampResult438 * float3(1,1,1) ) ) + temp_output_46_0 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch469 = ( 1.0 - temp_output_32_0 );
				#else
				float3 staticSwitch469 = temp_output_32_0;
				#endif
				float mulTime382 = _TimeParameters.x * _Transition;
				float _Time535 = mulTime382;
				float _Period535 = 2.0;
				float localMyCustomExpression535 = MyCustomExpression535( _Time535 , _Period535 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch516 = localMyCustomExpression535;
				#else
				float staticSwitch516 = _ManualTransition;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch449 = ( 1.0 - staticSwitch516 );
				#else
				float staticSwitch449 = staticSwitch516;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch450 = ( _Exp * 2.0 );
				#else
				float staticSwitch450 = _Exp;
				#endif
				float3 temp_cast_0 = (( ( pow( staticSwitch449 , staticSwitch450 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult34 = clamp( (( staticSwitch469 - temp_cast_0 )).z , 0.0 , 1.0 );
				float temp_output_37_0 = ( 1.0 - pow( clampResult34 , 2.0 ) );
				float TransitionMask486 = temp_output_37_0;
				float lerpResult275 = lerp( 0.0 , ( _Push / 100.0 ) , TransitionMask486);
				#ifdef _INVERSEANIMATION_ON
				float3 staticSwitch455 = ( _NormalizedRotationAxis * -1.0 );
				#else
				float3 staticSwitch455 = _NormalizedRotationAxis;
				#endif
				float MaskMap426 = temp_output_46_0;
				float4 transform261 = mul(GetWorldToObjectMatrix(),float4( 0,0,0,1 ));
				float3 objToWorld290 = mul( GetObjectToWorldMatrix(), float4( transform261.xyz, 1 ) ).xyz;
				float3 clampResult617 = clamp( _CustomPivotVec , float3( -1.5,-1.5,-1.5 ) , float3( 1.5,1.5,1.5 ) );
				#ifdef _CUSTOMPIVOT_ON
				float3 staticSwitch604 = clampResult617;
				#else
				float3 staticSwitch604 = objToWorld290;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float4 staticSwitch452 = ( _OffsetPivot * -1.0 );
				#else
				float4 staticSwitch452 = _OffsetPivot;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float3 worldToObj289 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 rotatedValue258 = RotateAroundAxis( ( float4( staticSwitch604 , 0.0 ) + ( staticSwitch452 / 100.0 ) ).xyz, worldToObj289, staticSwitch455, ( ( TransitionMask486 * MaskMap426 ) * _Angle ) );
				float3 FinalDisplacement347 = ( ( v.ase_normal * lerpResult275 ) + rotatedValue258 );
				
				float2 uv_NormalMap = v.ase_texcoord.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
				#ifdef _USENORMALMAP_ON
				float4 staticSwitch601 = tex2Dlod( _NormalMap, float4( uv_NormalMap, 0, 0.0) );
				#else
				float4 staticSwitch601 = float4( v.ase_normal , 0.0 );
				#endif
				
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

				float3 vertexValue = FinalDisplacement347;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = staticSwitch601.rgb;

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

				float3 break181 = _WorldSpaceCameraPos;
				float3 appendResult179 = (float3(( break181.x * -1.0 ) , break181.z , break181.y));
				float3 temp_output_182_0 = ( appendResult179 * _Subdivision );
				float3 ase_worldPos = IN.ase_texcoord.xyz;
				float3 break176 = ase_worldPos;
				float3 appendResult177 = (float3(( break176.x * -1.0 ) , break176.z , break176.y));
				float3 temp_output_174_0 = ( appendResult177 * _Subdivision );
				float3 WP265 = temp_output_174_0;
				float3 temp_output_2_0 = ( WP265 * 1.0 );
				float3 normalizeResult11 = normalize( ( temp_output_182_0 - temp_output_2_0 ) );
				float3 temp_output_1_0_g81 = normalizeResult11;
				float3 temp_output_45_0_g81 = temp_output_182_0;
				float dotResult22_g81 = dot( temp_output_1_0_g81 , temp_output_45_0_g81 );
				float3 temp_cast_0 = (0.5).xxx;
				float3 temp_output_2_0_g81 = ( ( ceil( temp_output_2_0 ) / 1.0 ) - temp_cast_0 );
				float dotResult25_g81 = dot( temp_output_1_0_g81 , temp_output_2_0_g81 );
				float3 temp_output_30_0_g81 = ( WP265 - temp_output_45_0_g81 );
				float dotResult28_g81 = dot( temp_output_1_0_g81 , temp_output_30_0_g81 );
				float temp_output_27_0_g81 = ( ( ( dotResult22_g81 - dotResult25_g81 ) * -1.0 ) / dotResult28_g81 );
				float3 normalizeResult27_g82 = normalize( temp_output_1_0_g81 );
				float3 normalizeResult31_g82 = normalize( float3(0,0.00015,-1) );
				float3 normalizeResult29_g82 = normalize( cross( normalizeResult27_g82 , normalizeResult31_g82 ) );
				float3 temp_output_7_0_g81 = ( normalizeResult29_g82 * float3( 1,1,1 ) );
				float3 temp_output_34_0_g81 = ( temp_output_45_0_g81 + ( temp_output_27_0_g81 * temp_output_30_0_g81 ) );
				float3 temp_output_35_0_g81 = ( temp_output_34_0_g81 - temp_output_2_0_g81 );
				float dotResult11_g81 = dot( temp_output_7_0_g81 , temp_output_35_0_g81 );
				float3 normalizeResult10_g81 = normalize( cross( temp_output_7_0_g81 , normalizeResult27_g82 ) );
				float dotResult12_g81 = dot( normalizeResult10_g81 , temp_output_35_0_g81 );
				float2 appendResult14_g81 = (float2(dotResult11_g81 , dotResult12_g81));
				float2 temp_cast_1 = (0.0).xx;
				float2 temp_cast_2 = (0.0).xx;
				float2 ifLocalVar15_g81 = 0;
				if( temp_output_27_0_g81 <= 0.0 )
				ifLocalVar15_g81 = temp_cast_2;
				else
				ifLocalVar15_g81 = appendResult14_g81;
				float2 texCoord439 = IN.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 texCoord30 = IN.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				#ifdef _TRANSITIONXVSY_ON
				float staticSwitch603 = texCoord30.x;
				#else
				float staticSwitch603 = texCoord30.y;
				#endif
				float clampResult438 = clamp( ( ( tex2D( _MaskMap, (texCoord439*_TilingTransition + 0.0) ).r * _TransitionFactor ) + staticSwitch603 ) , 0.0 , 1.0 );
				float2 texCoord39 = IN.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_46_0 = ( pow( tex2D( _MaskMap, (texCoord39*_Tiling + 0.0) ).r , 2.0 ) * 0.25 );
				float3 temp_output_32_0 = ( ( 1.0 - ( clampResult438 * float3(1,1,1) ) ) + temp_output_46_0 );
				#ifdef _INVERSEDIRECTION_ON
				float3 staticSwitch469 = ( 1.0 - temp_output_32_0 );
				#else
				float3 staticSwitch469 = temp_output_32_0;
				#endif
				float mulTime382 = _TimeParameters.x * _Transition;
				float _Time535 = mulTime382;
				float _Period535 = 2.0;
				float localMyCustomExpression535 = MyCustomExpression535( _Time535 , _Period535 );
				#ifdef _MANUALAUTOMATIC_ON
				float staticSwitch516 = localMyCustomExpression535;
				#else
				float staticSwitch516 = _ManualTransition;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch449 = ( 1.0 - staticSwitch516 );
				#else
				float staticSwitch449 = staticSwitch516;
				#endif
				#ifdef _INVERSEANIMATION_ON
				float staticSwitch450 = ( _Exp * 2.0 );
				#else
				float staticSwitch450 = _Exp;
				#endif
				float3 temp_cast_3 = (( ( pow( staticSwitch449 , staticSwitch450 ) - 0.5 ) * 2.0 )).xxx;
				float clampResult34 = clamp( (( staticSwitch469 - temp_cast_3 )).z , 0.0 , 1.0 );
				float temp_output_37_0 = ( 1.0 - pow( clampResult34 , 2.0 ) );
				float TransitionMask486 = temp_output_37_0;
				float MaskMap426 = temp_output_46_0;
				float lerpResult425 = lerp( 0.0 , _Distortion , TransitionMask486);
				float2 temp_output_419_0 = ( ( ( ifLocalVar15_g81 / ( ( 1.0 - ( TransitionMask486 * float2( 1,1 ) ) ) * _SizeWhenTransition ) ) + 0.5 ) + ( MaskMap426 * lerpResult425 ) );
				float2 temp_cast_4 = (0.5).xx;
				float lerpResult13 = lerp( 1.0 , 0.0 , TransitionMask486);
				float2 temp_output_7_0_g80 = ( ( temp_output_419_0 - temp_cast_4 ) / lerpResult13 );
				float2 temp_cast_5 = (0.5).xx;
				float dotResult2_g80 = dot( temp_output_7_0_g80 , temp_output_7_0_g80 );
				float lerpResult14 = lerp( 1.0 , 0.1 , TransitionMask486);
				float mulTime482 = _TimeParameters.x * 2.0;
				float cos481 = cos( ( mulTime482 + TransitionMask486 ) );
				float sin481 = sin( ( mulTime482 + TransitionMask486 ) );
				float2 rotator481 = mul( temp_output_419_0 - float2( 0.5,0.5 ) , float2x2( cos481 , -sin481 , sin481 , cos481 )) + float2( 0.5,0.5 );
				float clampResult485 = clamp( ( pow( tex2D( _Pattern, rotator481 ).r , 6.0 ) + 0.1 ) , 0.0 , 1.0 );
				float clampResult480 = clamp( ( clampResult485 - TransitionMask486 ) , 0.0 , 1.0 );
				float temp_output_252_0 = ( 1.0 - (( _CustomTexture )?( ( 1.0 - clampResult480 ) ):( pow( saturate( dotResult2_g80 ) , lerpResult14 ) )) );
				float lerpResult431 = lerp( 1.0 , temp_output_46_0 , temp_output_37_0);
				float lerpResult242 = lerp( lerpResult431 , 0.0 , TransitionMask486);
				float temp_output_241_0 = ( temp_output_252_0 * lerpResult242 );
				float FinalAlpha346 = floor( ceil( temp_output_241_0 ) );
				

				surfaceDescription.Alpha = FinalAlpha346;
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
	
	CustomEditor "UltimateDissolveFX_GUI"
	FallBack "Hidden/Shader Graph/FallbackError"
	
	Fallback "Hidden/InternalErrorShader"
}
/*ASEBEGIN
Version=19107
Node;AmplifyShaderEditor.CommentaryNode;353;3627.18,798.48;Inherit;False;1849.36;960.031;Colors;16;492;313;312;345;310;433;432;397;446;447;307;387;395;384;394;616;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;351;7049.35,809.4265;Inherit;False;605.0422;559.5523;Outputs;3;350;349;348;;0.3057392,0.9245283,0.09303422,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;280;520.7256,273.0792;Inherit;False;1114;667;Displacement;8;274;275;276;277;279;293;294;445;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;273;5.079835,1399.193;Inherit;False;1581.321;1088.194;Comment;17;255;256;257;258;282;264;261;286;290;289;291;292;444;458;459;460;604;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;254;-4869.333,388.0443;Inherit;False;3567.948;870.5713;Mask;32;450;469;19;21;470;449;451;382;383;448;20;304;305;30;32;297;295;296;37;35;36;34;33;29;28;27;515;516;535;539;554;553;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;253;-2623.023,1429.618;Inherit;False;1414.361;665.7555;Comment;8;39;44;45;46;47;240;41;43;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;518;2179.756,-223.2137;Inherit;False;828.1869;614.2216;MatcapUv;4;522;521;520;519;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;27;-3219.362,911.1561;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-2907.156,912.1732;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;29;-2369.188,889.7998;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;33;-2163.762,882.6815;Inherit;False;False;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;34;-1888.167,892.851;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1887.15,1118.614;Inherit;False;Constant;_Float3;Float 3;5;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;35;-1678.674,896.9186;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;37;-1481.385,899.9694;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;277;1132.726,412.0792;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;14;-717.6176,-212.299;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1143.308,-192.2838;Inherit;False;Constant;_SEnd;SEnd;1;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;13;-717.5836,-499.0809;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;256;498.9415,1520.548;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;275;776.7256,791.0792;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;276;793.1119,410.3069;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;255;172.0425,1519.967;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotateAboutAxisNode;258;1254.14,1499.714;Inherit;False;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;293;752.1472,594.3851;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;291;587.3193,2228.126;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;294;578.1472,713.3851;Inherit;False;Constant;_Float7;Float 7;8;0;Create;True;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1132.75,-278.4413;Inherit;False;Constant;_SStart;SStart;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1122.636,-473.3851;Inherit;False;Constant;_REnd;REnd;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1113.721,-555.9961;Inherit;False;Constant;_RStart;RStart;1;0;Create;True;0;0;0;False;0;False;1;144;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;296;-3022.79,597.5288;Inherit;False;Constant;_Vector2;Vector 2;8;0;Create;True;0;0;0;False;0;False;1,1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;295;-2770.79,517.5289;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;297;-2614.456,518.5273;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-2453.798,516.7134;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-1762.677,1635.618;Inherit;False;Constant;_Float4;Float 4;7;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-1551.421,1697.671;Inherit;False;Constant;_Float5;Float 5;7;0;Create;True;0;0;0;False;0;False;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;347;1776.566,407.8797;Inherit;False;FinalDisplacement;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;369;-730.1992,-613.7822;Inherit;False;Constant;_Float12;Float 12;12;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;44;-1594.843,1565.128;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-1371.996,1560.752;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;298;-23.35594,-296.6336;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;242;56.48321,-337.7164;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;426;-1037.795,1554.852;Inherit;False;MaskMap;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;30;-3073.587,428.4596;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-2573.023,1573.178;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;240;-2282.734,1571.694;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;439;-4012.514,-10.48889;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;440;-3722.225,-11.9729;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;437;-3056.993,-4.461912;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;444;988.0624,2193.4;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;286;1009.484,1958.608;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;289;1193.945,1955.113;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;279;1421.726,412.0792;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;445;1379.707,552.0443;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.AbsOpNode;305;-3665.398,455.5951;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;304;-3834.398,435.5951;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;453;284.6338,2585.535;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;459;344.3795,1841.69;Inherit;False;Constant;_Float10;Float 9;25;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;460;478.3795,1765.69;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;458;606.3795,1692.69;Inherit;False;Property;_InverseAnimation;InverseAnimation;0;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;457;667.7231,1334.204;Inherit;False;Constant;_Float9;Float 9;25;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;456;801.7231,1258.204;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;455;866.7231,1030.204;Inherit;False;Property;_InverseAnimation;InverseAnimation;0;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;470;-2276.281,545.9377;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1;-5114.27,-638.3536;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;178;-4692.597,-260.1885;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;176;-4903.596,-397.1885;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleSubtractOpNode;10;-3157.273,-1161.754;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-3715.662,-642.3205;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;265;-4208.872,-647.0384;Inherit;False;WP;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;174;-4447.598,-648.1887;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;177;-4517.598,-396.1885;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;179;-4382.496,-1195.405;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;181;-4770.494,-1196.405;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;182;-4179.531,-1171.205;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;9;-5150.988,-1214.389;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleDivideOpNode;5;-3220.611,-693.4303;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CeilOpNode;4;-3450.685,-692.7392;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-3129.593,-569.0746;Inherit;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;180;-4559.495,-1059.405;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;355;-4251.426,-467.8108;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;356;-4338.426,-341.8108;Inherit;False;Constant;_Float1;Float 1;10;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;6;-2936.748,-695.6764;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;11;-2984.94,-1159.306;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;266;-2990.246,-1310.611;Inherit;False;265;WP;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;252;410.8967,-524.9412;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;422;-1403.794,-877.6658;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;481;-1338.651,-1653.111;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;490;505.0297,836.1638;Inherit;False;486;TransitionMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;491;-28.5061,1443.857;Inherit;False;486;TransitionMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;431;-687.2587,843.1638;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;493;-65.82971,-109.0153;Inherit;False;486;TransitionMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;495;-946.5613,-347.3707;Inherit;False;486;TransitionMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;494;-929.4034,-74.44041;Inherit;False;486;TransitionMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;478;-156.5254,-1486.316;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;480;29.34875,-1487.111;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;477;-798.5254,-1454.316;Inherit;False;Constant;_Float11;Float 11;30;0;Create;True;0;0;0;False;0;False;6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;404;-651.1353,-1655.003;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;484;-478.8505,-1654.238;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;485;-330.5684,-1653.579;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;405;192.0209,-1490.174;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;483;-1575.651,-1608.111;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;501;-597.4458,-1518.854;Inherit;False;Constant;_Float13;Float 13;30;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;487;-1817.203,-542.3784;Inherit;False;486;TransitionMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;425;-1545.553,-722.5274;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;419;-1210.533,-954.7063;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;427;-1796.161,-886.1038;Inherit;False;426;MaskMap;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;482;-1812.651,-1606.111;Inherit;False;1;0;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;488;-1831.883,-1500.934;Inherit;False;486;TransitionMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;503;-3281.735,-419.7721;Inherit;False;486;TransitionMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;504;-3018.735,-411.7721;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;505;-3208.735,-303.7721;Inherit;False;Constant;_Vector0;Vector 0;30;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.OneMinusNode;506;-2853.735,-415.7721;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;509;-2604.591,-414.2883;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;346;2310.702,-514.7877;Inherit;False;FinalAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;281;923.871,-632.1843;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;200;False;1;FLOAT;0
Node;AmplifyShaderEditor.CeilOpNode;299;1131.257,-515.6692;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;300;1417.082,-515.9026;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;241;676.5057,-524.498;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;489;-384.483,-1341.055;Inherit;False;486;TransitionMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;469;-2057.977,493.0377;Inherit;False;Property;_InverseDirection;InverseDirection;3;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;449;-3809.25,750.8223;Inherit;False;Property;_InverseAnimation;InverseAnimation;6;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;382;-4512.069,752.014;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;383;-4326.348,750.8581;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;448;-4020.25,625.8223;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;520;2602.275,-87.28857;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TransformDirectionNode;521;2368.275,102.0539;Inherit;False;Object;View;False;Fast;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalVertexDataNode;522;2194.756,-80.16858;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;20;-3492.076,903.207;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;451;-3939.25,1167.822;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;394;4009.466,1467.832;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;384;4356.954,1333.283;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;395;4180.294,1514.73;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;397;4834.856,1135.508;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;433;4475.12,1484.896;Inherit;False;Constant;_Float2;Float 2;19;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;310;5020.119,877.3251;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;312;4602.919,914.9927;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;492;4212.348,842.7131;Inherit;False;486;TransitionMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;527;3334.002,-440.868;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;529;3620.143,-671.5726;Inherit;False;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;539;-4496.079,580.4504;Inherit;False;Constant;_Float17;Float 17;34;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;535;-4340.026,643.3887;Inherit;False;$// Calculate a sine wave value that oscillates between 0 and 1 over time$float v = (sin(_Time * 2 * 3.14159 / _Period) + 1) * 0.5@$$return v @;1;Create;2;True;_Time;FLOAT;0;In;;Inherit;False;True;_Period;FLOAT;0;In;;Inherit;False;My Custom Expression;True;False;0;;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;553;-4372.846,895.6061;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;554;-4523.846,964.6061;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;3.14;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;43;-2062.805,1545.696;Inherit;True;Property;_MaskMap2;MaskMap2;12;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;436;-3447.036,-29.89886;Inherit;True;Property;_TransitionMap;TransitionMap;24;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;530;2987.614,-650.2409;Inherit;False;Property;_ColorPow;Color Pow;26;0;Create;False;0;0;0;False;0;False;1;5;0.25;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;345;5232.628,873.9532;Inherit;False;FinalColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;349;7091.35,991.4181;Inherit;False;346;FinalAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;528;2962.639,-424.661;Inherit;False;Property;_Desaturation;Desaturation;30;0;Create;False;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;519;2784.891,-98.79259;Float;False;float2 uv_matcap = normal *0.5 + float2(0.5,0.5)@ float2(0.5,0.5)@$$return uv_matcap@;2;Create;1;True;normal;FLOAT3;0,0,0;In;;Float;False;My Custom Expression;True;False;0;;False;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;435;-2814.193,4.68759;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;438;-2650.652,5.0921;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;292;378.6173,2257.608;Inherit;False;Constant;_Float6;Float 6;8;0;Create;True;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;454;47.6338,2573.535;Inherit;False;Constant;_Float8;Float 8;24;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;452;515.6338,2540.535;Inherit;False;Property;_InverseAnimation;InverseAnimation;0;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT4;0,0,0,0;False;0;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;608;7352.587,859.4264;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;0;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;609;7352.587,859.4264;Float;False;True;-1;2;UltimateDissolveFX_GUI;0;12;UltimateDissolveFX_Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Forward;0;1;Forward;19;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;True;1;1;False;;0;False;;1;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalForward;False;False;0;Hidden/InternalErrorShader;0;0;Standard;41;Workflow;1;0;Surface;0;0;  Refraction Model;0;0;  Blend;0;0;Two Sided;1;0;Fragment Normal Space,InvertActionOnDeselection;0;0;Forward Only;0;0;Transmission;0;0;  Transmission Shadow;0.5,False,;0;Translucency;0;0;  Translucency Strength;1,False,;0;  Normal Distortion;0.5,False,;0;  Scattering;2,False,;0;  Direct;0.9,False,;0;  Ambient;0.1,False,;0;  Shadow;0.5,False,;0;Cast Shadows;1;0;  Use Shadow Threshold;0;0;Receive Shadows;1;0;GPU Instancing;1;0;LOD CrossFade;1;0;Built-in Fog;1;0;_FinalColorxAlpha;0;0;Meta Pass;1;0;Override Baked GI;0;0;Extra Pre Pass;0;0;DOTS Instancing;0;0;Tessellation;0;0;  Phong;0;0;  Strength;0.5,False,;0;  Type;0;0;  Tess;16,False,;0;  Min;10,False,;0;  Max;25,False,;0;  Edge Length;16,False,;0;  Max Displacement;25,False,;0;Write Depth;0;0;  Early Z;0;0;Vertex Position,InvertActionOnDeselection;0;638162030333448931;Debug Display;0;0;Clear Coat;0;0;0;10;False;True;True;True;True;True;True;True;True;True;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;610;7352.587,859.4264;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=ShadowCaster;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;611;7352.587,859.4264;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;False;False;True;1;LightMode=DepthOnly;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;612;7352.587,859.4264;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;613;7352.587,859.4264;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Universal2D;0;5;Universal2D;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;True;1;1;False;;0;False;;1;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=Universal2D;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;614;7352.587,859.4264;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthNormals;0;6;DepthNormals;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=DepthNormals;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;615;7352.587,859.4264;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;GBuffer;0;7;GBuffer;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;True;1;1;False;;0;False;;1;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalGBuffer;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.ColorNode;307;3668.311,1138.224;Inherit;False;Property;_ColorTransition;ColorTransition;13;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;1,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;616;4002.021,1135.917;Inherit;False;Property;_UseMainTexture;UseMainTexture;39;0;Create;False;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;524;3879.478,-453.584;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;525;3537.774,-433.7516;Float;False;Property;_MainColorMult;MainColorMult;8;0;Create;False;0;0;0;False;0;False;1;6.84;0;24;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;548;3687.371,-51.52338;Inherit;True;Property;_MainMap;MainMap;28;1;[NoScaleOffset];Create;False;0;0;0;False;0;False;-1;d8cfe409d2fb65842a7151f63c8307c5;d8cfe409d2fb65842a7151f63c8307c5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;523;3123.29,-134.8277;Inherit;True;Property;_MainColorMap;MainColorMap;4;1;[NoScaleOffset];Create;False;0;0;0;False;0;False;-1;d8cfe409d2fb65842a7151f63c8307c5;6a72ff1481692c34d84392e2883a640c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TransformPositionNode;606;-494.4173,1702.82;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ClampOpNode;617;-376.8364,1951.454;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;-1.5,-1.5,-1.5;False;2;FLOAT3;1.5,1.5,1.5;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;132;-4002.236,-503.2314;Inherit;False;Constant;_Sub;Sub;9;0;Create;True;0;0;0;False;0;False;1;1;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;175;-4683.597,-624.1887;Inherit;False;Property;_Subdivision;Subdivision;12;0;Create;True;0;0;0;False;0;False;400;400;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;402;-1002.925,-1682.334;Inherit;True;Property;_Pattern;Pattern;17;0;Create;True;0;0;0;False;0;False;-1;b73f7b35313a28849849078e2ba59c1e;ade06192cd65b31478b0a59910ce24ae;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;475;428.0881,-1048.865;Inherit;False;Property;_CustomTexture;Custom Pattern Shape;1;0;Create;False;0;0;0;False;0;False;0;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;516;-4233.414,883.9509;Inherit;False;Property;_ManualAutomatic;Manual / Automatic;23;0;Create;False;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;450;-3808.25,1065.822;Inherit;False;Property;_InverseAnimation;InverseAnimation;0;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;603;-2931.759,177.1848;Inherit;False;Property;_TransitionXvsY;Transition Axis : X vs Y;36;0;Create;False;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;432;4625.119,1305.896;Inherit;False;Property;_DETAILES;Outlines (If Possible);16;0;Create;False;0;0;0;False;0;False;0;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;387;3732.561,1604.376;Inherit;False;Property;_STEP;(Outlines) Steps;15;0;Create;False;0;0;0;False;0;False;0.3;4;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;257;186.7833,1693.949;Inherit;False;Property;_Angle;Rotation Angle;11;0;Create;False;0;0;0;False;0;False;8;20.19;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;259;318.687,1035.193;Inherit;False;Property;_NormalizedRotationAxis;Rotation Axis;21;0;Create;False;0;0;0;False;0;False;0.05,0.2,1.1;0.05,0.2,1.1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldToObjectTransfNode;261;70.05881,2052.247;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TransformPositionNode;290;292.6753,2049.987;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;282;822.9169,1910.576;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector3Node;605;-751.8739,1937.654;Inherit;False;Property;_CustomPivotVec;CustomPivotVec;38;0;Create;False;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StaticSwitch;604;534.8599,1909.121;Inherit;False;Property;_CustomPivot;New Custom Pivot Position;37;0;Create;False;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector4Node;264;72.57391,2245.36;Inherit;False;Property;_OffsetPivot;Pivot Offset (Obj Pivot Offset);10;0;Create;False;0;0;0;False;0;False;10,0,0,1;-2.510567,0.4630182,-2.723376,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;274;570.7256,535.0792;Inherit;False;Property;_Push;Vertices Push Mult;9;0;Create;False;0;0;0;False;0;False;0;-3.78;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;618;7352.587,939.4264;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;SceneSelectionPass;0;8;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;619;7352.587,939.4264;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ScenePickingPass;0;9;ScenePickingPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Picking;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.SamplerNode;598;6117.19,1089.508;Inherit;True;Property;_NormalMap;Normal Map;33;0;Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;601;6564.288,1066.044;Inherit;False;Property;_UseNormalMap;UseNormalMap;35;0;Create;False;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;602;6450.288,1317.044;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;348;7068.35,855.4174;Inherit;False;345;FinalColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;588;6898.846,1018.649;Inherit;False;Constant;_Cutoff;Cutoff;3;0;Create;True;0;0;0;False;0;False;0.1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;350;7089.35,1242.418;Inherit;False;347;FinalDisplacement;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;502;-2399.765,-1014.042;Inherit;False;VirtualPlaneProjection;-1;;81;429a6c69c5ef8fc4e842944468f87c2b;0;6;44;FLOAT3;0,0,0;False;45;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;9;FLOAT3;0,0,0;False;18;FLOAT2;1,1;False;4;FLOAT;39;FLOAT3;36;FLOAT3;37;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;555;-3008.82,1538.854;Inherit;True;Property;_MaskMap;MaskMap;31;0;Create;True;0;0;0;False;0;False;acb2657f3ed7d0c468e2a4044a636b2b;acb2657f3ed7d0c468e2a4044a636b2b;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;447;4296.849,1042.219;Inherit;False;Property;_EmissiveFctor;Emissive Mult;24;0;Create;False;0;0;0;False;0;False;10;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;313;4160.559,925.7646;Inherit;False;Property;_SharpTransition;Transition Softness;14;0;Create;False;0;0;0;False;0;False;0.2;2;0.05;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;620;-328.0915,-1022.203;Inherit;False;SphereMsk;-1;;80;d24414f1729d7174c992f3a52f6ecfbf;0;4;9;FLOAT2;0,0;False;10;FLOAT;0;False;4;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;423;-1900.468,-701.4294;Inherit;False;Property;_Distortion;Pattern Distortion;18;0;Create;False;0;0;0;False;0;False;1;0;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;510;-2863.591,-298.2883;Inherit;False;Property;_SizeWhenTransition;SizeWhenTransition;2;0;Create;True;0;0;0;False;0;False;1;1;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;442;-3297.453,202.9318;Inherit;False;Property;_TransitionFactor;Transition Strength ;20;0;Create;False;0;0;0;False;0;False;0.2;-0.077;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;441;-3971.814,200.7191;Inherit;False;Property;_TilingTransition;TilingTransition;19;0;Create;True;0;0;0;False;0;False;1;3.09;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-4802.333,746.9182;Inherit;False;Property;_Transition;AnimationSpeed;5;0;Create;False;0;0;0;False;0;False;0.88;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-4180.502,1066.784;Inherit;False;Property;_Exp;Transition Falloff;6;0;Create;False;0;0;0;False;0;False;1;0.8;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;486;-1227.304,973.6429;Inherit;False;TransitionMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;446;4559.823,1139.132;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;627;4395.836,1235.544;Inherit;False;Constant;_Float14;Float 14;44;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-2532.323,1784.386;Inherit;False;Property;_Tiling;Tiling;7;0;Create;True;0;0;0;False;0;False;0.5;1;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;546;4317.757,-369.775;Inherit;False;Property;_ColorMap;Color / Map;25;0;Create;False;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;547;4086.567,-466.8803;Inherit;False;Property;_MapMatCap;Map / MatCap;27;0;Create;False;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;549;4067.738,-273.2442;Inherit;False;Property;_MainColor;MainColor;29;0;Create;True;0;0;0;False;0;False;0.1415094,0.1415094,0.1415094,0;0.3333333,0,0,0.3333333;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;599;6745.19,924.5081;Inherit;False;Property;_Metallic;Metallic;32;0;Create;True;0;0;0;False;0;False;0.91;0.063;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;600;6458.19,953.5081;Inherit;False;Property;_Smoothness;Smoothness;34;0;Create;False;0;0;0;False;0;False;0.4;0.462;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;515;-4809.414,884.9509;Inherit;False;Property;_ManualTransition;Manual Transition;22;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
WireConnection;27;0;20;0
WireConnection;28;0;27;0
WireConnection;29;0;469;0
WireConnection;29;1;28;0
WireConnection;33;0;29;0
WireConnection;34;0;33;0
WireConnection;35;0;34;0
WireConnection;35;1;36;0
WireConnection;37;0;35;0
WireConnection;277;0;276;0
WireConnection;277;1;275;0
WireConnection;14;0;17;0
WireConnection;14;1;18;0
WireConnection;14;2;494;0
WireConnection;13;0;15;0
WireConnection;13;1;16;0
WireConnection;13;2;495;0
WireConnection;256;0;255;0
WireConnection;256;1;257;0
WireConnection;275;1;293;0
WireConnection;275;2;490;0
WireConnection;255;0;491;0
WireConnection;255;1;426;0
WireConnection;258;0;455;0
WireConnection;258;1;256;0
WireConnection;258;2;282;0
WireConnection;258;3;289;0
WireConnection;293;0;274;0
WireConnection;293;1;294;0
WireConnection;291;0;452;0
WireConnection;291;1;292;0
WireConnection;295;0;438;0
WireConnection;295;1;296;0
WireConnection;297;0;295;0
WireConnection;32;0;297;0
WireConnection;32;1;46;0
WireConnection;347;0;279;0
WireConnection;44;0;43;1
WireConnection;44;1;45;0
WireConnection;46;0;44;0
WireConnection;46;1;47;0
WireConnection;298;0;431;0
WireConnection;242;0;298;0
WireConnection;242;2;493;0
WireConnection;426;0;46;0
WireConnection;240;0;39;0
WireConnection;240;1;41;0
WireConnection;440;0;439;0
WireConnection;440;1;441;0
WireConnection;437;0;436;1
WireConnection;437;1;442;0
WireConnection;289;0;286;0
WireConnection;279;0;277;0
WireConnection;279;1;445;0
WireConnection;445;0;258;0
WireConnection;305;0;304;2
WireConnection;453;0;264;0
WireConnection;453;1;454;0
WireConnection;460;0;257;0
WireConnection;460;1;459;0
WireConnection;458;1;257;0
WireConnection;458;0;460;0
WireConnection;456;0;259;0
WireConnection;456;1;457;0
WireConnection;455;1;259;0
WireConnection;455;0;456;0
WireConnection;470;0;32;0
WireConnection;178;0;176;0
WireConnection;176;0;1;0
WireConnection;10;0;182;0
WireConnection;10;1;2;0
WireConnection;2;0;265;0
WireConnection;2;1;132;0
WireConnection;265;0;174;0
WireConnection;174;0;177;0
WireConnection;174;1;175;0
WireConnection;177;0;178;0
WireConnection;177;1;176;2
WireConnection;177;2;176;1
WireConnection;179;0;180;0
WireConnection;179;1;181;2
WireConnection;179;2;181;1
WireConnection;181;0;9;0
WireConnection;182;0;179;0
WireConnection;182;1;175;0
WireConnection;5;0;4;0
WireConnection;5;1;132;0
WireConnection;4;0;2;0
WireConnection;180;0;181;0
WireConnection;355;0;174;0
WireConnection;355;1;356;0
WireConnection;6;0;5;0
WireConnection;6;1;7;0
WireConnection;11;0;10;0
WireConnection;252;0;475;0
WireConnection;422;0;427;0
WireConnection;422;1;425;0
WireConnection;481;0;419;0
WireConnection;481;2;483;0
WireConnection;431;1;46;0
WireConnection;431;2;37;0
WireConnection;478;0;485;0
WireConnection;478;1;489;0
WireConnection;480;0;478;0
WireConnection;404;0;402;1
WireConnection;404;1;477;0
WireConnection;484;0;404;0
WireConnection;484;1;501;0
WireConnection;485;0;484;0
WireConnection;405;0;480;0
WireConnection;483;0;482;0
WireConnection;483;1;488;0
WireConnection;425;1;423;0
WireConnection;425;2;487;0
WireConnection;419;0;502;0
WireConnection;419;1;422;0
WireConnection;504;0;503;0
WireConnection;504;1;505;0
WireConnection;506;0;504;0
WireConnection;509;0;506;0
WireConnection;509;1;510;0
WireConnection;346;0;300;0
WireConnection;281;0;241;0
WireConnection;299;0;241;0
WireConnection;300;0;299;0
WireConnection;241;0;252;0
WireConnection;241;1;242;0
WireConnection;469;1;32;0
WireConnection;469;0;470;0
WireConnection;449;1;516;0
WireConnection;449;0;448;0
WireConnection;382;0;19;0
WireConnection;383;0;382;0
WireConnection;448;0;516;0
WireConnection;520;0;521;0
WireConnection;521;0;522;0
WireConnection;20;0;449;0
WireConnection;20;1;450;0
WireConnection;451;0;21;0
WireConnection;394;0;252;0
WireConnection;394;1;387;0
WireConnection;384;0;395;0
WireConnection;395;0;394;0
WireConnection;397;0;446;0
WireConnection;397;1;432;0
WireConnection;310;0;546;0
WireConnection;310;1;397;0
WireConnection;310;2;312;0
WireConnection;312;0;492;0
WireConnection;312;1;313;0
WireConnection;527;0;523;0
WireConnection;527;1;528;0
WireConnection;529;0;527;0
WireConnection;529;1;530;0
WireConnection;535;0;382;0
WireConnection;535;1;539;0
WireConnection;553;0;554;0
WireConnection;554;2;515;0
WireConnection;43;0;555;0
WireConnection;43;1;240;0
WireConnection;436;0;555;0
WireConnection;436;1;440;0
WireConnection;345;0;310;0
WireConnection;519;0;520;0
WireConnection;435;0;437;0
WireConnection;435;1;603;0
WireConnection;438;0;435;0
WireConnection;452;1;264;0
WireConnection;452;0;453;0
WireConnection;609;0;348;0
WireConnection;609;3;599;0
WireConnection;609;4;600;0
WireConnection;609;6;349;0
WireConnection;609;7;588;0
WireConnection;609;8;350;0
WireConnection;609;10;601;0
WireConnection;616;1;307;0
WireConnection;616;0;548;0
WireConnection;524;0;529;0
WireConnection;524;1;525;0
WireConnection;524;2;307;0
WireConnection;523;1;519;0
WireConnection;606;0;605;0
WireConnection;617;0;605;0
WireConnection;402;1;481;0
WireConnection;475;0;620;0
WireConnection;475;1;405;0
WireConnection;516;1;515;0
WireConnection;516;0;535;0
WireConnection;450;1;21;0
WireConnection;450;0;451;0
WireConnection;603;1;30;2
WireConnection;603;0;30;1
WireConnection;432;0;433;0
WireConnection;432;1;384;0
WireConnection;290;0;261;0
WireConnection;282;0;604;0
WireConnection;282;1;291;0
WireConnection;604;1;290;0
WireConnection;604;0;617;0
WireConnection;601;1;602;0
WireConnection;601;0;598;0
WireConnection;502;44;266;0
WireConnection;502;45;182;0
WireConnection;502;1;11;0
WireConnection;502;2;6;0
WireConnection;502;18;509;0
WireConnection;620;9;419;0
WireConnection;620;10;369;0
WireConnection;620;4;13;0
WireConnection;620;3;14;0
WireConnection;486;0;37;0
WireConnection;446;0;616;0
WireConnection;446;1;447;0
WireConnection;546;1;547;0
WireConnection;546;0;549;0
WireConnection;547;1;548;0
WireConnection;547;0;524;0
ASEEND*/
//CHKSM=B1ED7099B650584DDE146C49A8ADA2A8A11EC51D