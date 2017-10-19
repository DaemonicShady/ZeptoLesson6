// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/PlaneShaderOld"
{
	Properties
	{
		//_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vertexShader
			#pragma fragment fragmentShader
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				//float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
			};

			//sampler2D _MainTex;
			//float4 _MainTex_ST;
			
			v2f vertexShader(appdata vertexData)
			{
				v2f output;
				float4 position = mul(UNITY_MATRIX_P, mul(UNITY_MATRIX_V, mul(unity_ObjectToWorld, vertexData.vertex)));
				output.vertex = position;
				return output;
			}
			
			fixed4 fragmentShader(v2f fragmentData) : SV_Target
			{
				// sample the texture
				//fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				//UNITY_APPLY_FOG(i.fogCoord, col);
				//return col;
				return fixed4(1.0f, 0.0f, 0.0f, 1.0f);
			}
			ENDCG
		}
	}
}
