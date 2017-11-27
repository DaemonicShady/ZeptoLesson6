Shader "Unlit/VertexAnimation"
{
	Properties
	{
		_Coeff ("coeff", float) = 0.0
		_Phase ("phase", float) = 0.0
		_PhaseMultiplier ("phase multiplier", float) = 0.0
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
			};

			float _Coeff;
			float _Phase;
			float _PhaseMultiplier;

			struct varyingData
			{
				float4 vertex : SV_POSITION;
			};
			
			varyingData vertexShader(appdata vertexData)
			{
				varyingData output;

				vertexData.vertex.y += _Coeff * sin(vertexData.vertex.x * _Phase * _PhaseMultiplier);
				output.vertex = mul(UNITY_MATRIX_P, mul(UNITY_MATRIX_V, mul(unity_ObjectToWorld, vertexData.vertex)));

				return output;
			}
			
			fixed4 fragmentShader(varyingData fragmentData) : SV_Target
			{
				return fixed4(1.0f, 0.0f, 0.0f, 1.0f);
			}
			ENDCG
		}
	}
}
