Shader "Unlit/DirectionDiffuseShader"
{
    Properties
    {
    }
    SubShader
    {
        Pass
        {
            // indicate that our pass is the "base" pass in forward
            // rendering pipeline. It gets ambient and main directional
            // light data set up; light direction in _WorldSpaceLightPos0
            // and color in _LightColor0
            Tags {"LightMode"="ForwardBase"}
        
            CGPROGRAM
            #pragma vertex vertexShader
            #pragma fragment fragmentShader
            #include "UnityCG.cginc" // for UnityObjectToWorldNormal
            #include "UnityLightingCommon.cginc" // for _LightColor0

            struct v2f
            {
                fixed4 color : COLOR0;
                float4 vertex : SV_POSITION;
            };

            // appdata_base is a Unity3D embedded struct with vertex position, normal and
            // texture coordinate.
            // https://docs.unity3d.com/Manual/SL-BuiltinIncludes.html
            v2f vertexShader(appdata_base v)
            {
                v2f output;

                output.vertex = UnityObjectToClipPos(v.vertex);
                half3 worldNormal = UnityObjectToWorldNormal(v.normal);

                half coeff = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
                output.color = coeff * _LightColor0;

                return output;
            }

            fixed4 fragmentShader(v2f fragmentData) : SV_Target
            {
                return fragmentData.color;
            }
            ENDCG
        }
    }
}
