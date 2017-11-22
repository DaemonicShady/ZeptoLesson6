Shader "Unlit/PhongShader"
{
	Properties
	{
		_ObjectColor ("Color", Vector) = (1.0, 1.0, 1.0, 1.0)
		_SpecularColor("Specular color", Vector) = (0.5, 0.5, 0.5, 1.0)
		_SpecularPower("Specular power", float) = 1.0
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
				float3 normalDirection : NORMAL0;
				float3 lightDirection : NORMAL1;
				float3 eyeDirection : NORMAL2;
			};

			fixed4 _ObjectColor;
			fixed4 _SpecularColor;
			float _SpecularPower;
			float4 _LightPosition;

			v2f vertexShader(appdata_base vertexData)
			{
				v2f output;
				float4 position = mul(unity_ObjectToWorld, vertexData.vertex);
				half3 worldNormal = UnityObjectToWorldNormal(vertexData.normal);
				//output.lightDirection = normalize(_WorldSpaceLightPos0.xyz - position.xyz);
				output.lightDirection = normalize(_LightPosition.xyz - position.xyz);
				output.eyeDirection = normalize(_WorldSpaceCameraPos - position.xyz);
				output.normalDirection = normalize(worldNormal);
				output.vertex = UnityObjectToClipPos(vertexData.vertex);
				return output;
			}
			
			fixed4 fragmentShader(v2f fragmentData) : SV_Target
			{
				float3 lightDirection = normalize(fragmentData.lightDirection);
				float3 normalDirection = normalize(fragmentData.normalDirection);
				float3 eyeDirection = normalize(fragmentData.eyeDirection);
				float3 reflected = reflect(-eyeDirection, normalDirection);
				fixed4 diffuseColor = _ObjectColor * max(0.0f, dot(normalDirection, lightDirection));
				fixed4 specularColor = _SpecularColor * pow(max(0.0f, dot(lightDirection, reflected)), _SpecularPower);
				return diffuseColor + specularColor;
			}
			ENDCG
		}
	}
}
