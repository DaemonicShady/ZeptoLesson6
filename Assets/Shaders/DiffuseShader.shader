Shader "Unlit/DiffuseShader"
{
	Properties
	{
		//_MainTex ("Texture", 2D) = "white" {}
		//_LightDirection("LightDirection", Color) = (0.0f, -1.0f, 0.0f, 0.0f)
		_LightDirection("LightDirection", Vector) = (0.0, -1.0, 0.0, 0.0)
	}
	SubShader
	{
		//Tags { "RenderType"="Opaque" }
		Tags {"LightMode"="ForwardBase"}
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
				float3 normal : NORMAL;
				//float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				fixed4 diffuseColor : COLOR0;
				float4 vertex : SV_POSITION;
				float3 lightDirection : NORMAL1;
				float3 normal : NORMAL0;
			};

			//sampler2D _MainTex;
			//float4 _MainTex_ST;
			//float4 _LightDirection;
			
			//v2f vertexShader(appdata vertexData)
			v2f vertexShader(appdata_base vertexData)
			{
				v2f output;
				//float4 position = mul(UNITY_MATRIX_V, mul(unity_ObjectToWorld, vertexData.vertex));
				float4 position = mul(unity_ObjectToWorld, vertexData.vertex);
				half3 worldNormal = UnityObjectToWorldNormal(vertexData.normal);
				output.lightDirection = normalize(_WorldSpaceLightPos0.xyz - position.xyz);
				//half intensity = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
				//output.diffuseColor = intensity * fixed4(1.0f, 0.0f, 0.0f, 1.0f);
				output.normal = normalize(worldNormal);
				output.vertex = UnityObjectToClipPos(vertexData.vertex);
				return output;
			}
			
			fixed4 fragmentShader(v2f fragmentData) : SV_Target
			{
				const fixed4 diffuseColor = fixed4(1.0f, 0.0f, 0.0f, 1.0f);

				float3 lightDirection = normalize(fragmentData.lightDirection);
				float3 normal = normalize(fragmentData.normal);
				fixed4 outputColor = diffuseColor * max(0.0f, dot(normal, lightDirection));
				return outputColor;
			}
			ENDCG
		}
	}

}
