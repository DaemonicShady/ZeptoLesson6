Shader "Unlit/PointDiffuseShader"
{
	Properties
	{
		_ObjectColor ("Color", Vector) = (1.0, 1.0, 1.0, 1.0)
		_LightPosition("LightPosition", Vector) = (0.0, 0.0, 0.0, 1.0)
	}
	SubShader
	{
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
			};

			struct v2f
			{
				fixed4 diffuseColor : COLOR0;
				float4 vertex : SV_POSITION;
				float3 lightDirection : NORMAL1;
				float3 normalDirection : NORMAL0;
			};

			fixed4 _ObjectColor;
			float4 _LightPosition;

			v2f vertexShader(appdata_base vertexData)
			{
				v2f output;
				float4 position = mul(unity_ObjectToWorld, vertexData.vertex);
				half3 worldNormal = UnityObjectToWorldNormal(vertexData.normal);
				//output.lightDirection = normalize(_WorldSpaceLightPos0.xyz - position.xyz);
				output.lightDirection = normalize(_LightPosition.xyz - position.xyz);
				output.normalDirection = normalize(worldNormal);
				output.vertex = UnityObjectToClipPos(vertexData.vertex);
				return output;
			}
			
			fixed4 fragmentShader(v2f fragmentData) : SV_Target
			{
				float3 lightDirection = normalize(fragmentData.lightDirection);
				float3 normalDirection = normalize(fragmentData.normalDirection);
				fixed4 outputColor = _ObjectColor * max(0.0f, dot(normalDirection, lightDirection));
				return outputColor;
			}
			ENDCG
		}
	}

}
