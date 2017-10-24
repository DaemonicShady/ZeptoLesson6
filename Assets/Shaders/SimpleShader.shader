Shader "Unlit/SimpleShader"
{
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

			struct Appdata
			{
				float4 vertex : POSITION;
			};

			struct VaryingData
			{
				float4 vertex : SV_POSITION;
			};
			
			VaryingData vertexShader(Appdata vertexData)
			{
				VaryingData output;
				output.vertex = mul(UNITY_MATRIX_P, mul(UNITY_MATRIX_V, mul(unity_ObjectToWorld, vertexData.vertex)));

				return output;
			}
			
			fixed4 fragmentShader(VaryingData fragmentData) : SV_Target
			{
				return fixed4(1.0f, 0.0f, 0.0f, 1.0f);
			}
			ENDCG
		}
	}
}
