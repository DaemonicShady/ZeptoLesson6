Shader "Unlit/Cook-Torrance"
{
	Properties
	{
		_ObjectColor ("Color", Vector) = (1.0, 1.0, 1.0, 1.0)
		_SpecularColor("Specular color", Vector) = (0.5, 0.5, 0.5, 1.0)
		_SpecularPower("Specular power", float) = 1.0
		_LightPosition("LightPosition", Vector) = (0.0, 0.0, 0.0, 1.0)
		_Roughness ("Roughness", float) = 1.0
		_FresnelCoeff ("Fresnel coeff", float) = 1.0
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
				float3 normalDirection : TEXCOORD0;
				float3 lightDirection : TEXCOORD1;
				float3 eyeDirection: TEXCOORD2;
				float3 bisectorDirection : TEXCOORD3;
			};

			fixed4 _ObjectColor;
			fixed4 _SpecularColor;
			float _SpecularPower;
			float4 _LightPosition;
			float _Roughness;
			float _FresnelCoeff;

			float fresnel(float param)
			{
				return (_FresnelCoeff + (1.0f - _FresnelCoeff) * pow(1.0f - param, 5.0f));
			}

			v2f vertexShader(appdata_base vertexData)
			{
				v2f output;
				float4 position = mul(unity_ObjectToWorld, vertexData.vertex);
				half3 worldNormal = UnityObjectToWorldNormal(vertexData.normal);
				float3 eyeDirection = normalize(_WorldSpaceCameraPos - position.xyz);
				float3 lightDirection = normalize(_LightPosition.xyz - position.xyz);

				output.lightDirection = lightDirection;
				output.eyeDirection = eyeDirection;
				output.bisectorDirection = normalize(lightDirection + eyeDirection);
				output.normalDirection = normalize(worldNormal);
				output.vertex = UnityObjectToClipPos(vertexData.vertex);
				return output;
			}
			
			fixed4 fragmentShader(v2f fragmentData) : SV_Target
			{
				const float e = 2.7182818284;
				const float pi = 3.1415926;

				float3 lightDirection = normalize(fragmentData.lightDirection);
				float3 normalDirection = normalize(fragmentData.normalDirection);
				float3 eyeDirection = normalize(fragmentData.eyeDirection);
				float3 bisectorDirection = normalize(fragmentData.bisectorDirection);

				float nh = dot(normalDirection, bisectorDirection);
				float nv = dot(normalDirection, eyeDirection);
				float nl = dot(normalDirection, lightDirection);

				float squaredRoughness = _Roughness * _Roughness;
				float squaredNh = nh * nh;
				float exponent = -(1.0f - squaredNh) / (squaredNh * squaredRoughness);
				float dPart = pow(e, exponent) / (squaredRoughness * squaredNh * squaredNh);

				float fresnelPart = fresnel(nv);

				float x = 2.0f * nh / dot(eyeDirection, bisectorDirection);
				float attenuation = min(1.0f, min(x * nl, x * nv));
				float cookTorrance = dPart * fresnelPart * attenuation / (nv * nl * 4.0f);

				fixed4 diffuseColor = _ObjectColor * max(0.0f, nl);
				fixed4 specularColor = _SpecularColor * max(0.0f, cookTorrance);
				return diffuseColor + specularColor;
			}
			ENDCG
		}
	}
}
