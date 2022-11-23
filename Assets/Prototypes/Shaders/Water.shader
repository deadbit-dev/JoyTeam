Shader "Unlit/Water"
{
    Properties
    {
        _BaseColor ("Base Color", Color) = (0, 0, 1, 1)
        _ShallowWaterColor ("Shallow Water Color", Color) = (0, 0, 0.5, 1)
        _Depth ("Depth", float) = 0.5
        _Strength ("Strength", float) = 0.3

    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
        }

        Pass
        {
            ZWrite On

            HLSLPROGRAM

            #pragma vertex VertexPass
            #pragma fragment FragmentPass

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            #define UNITY_MATRIX_MVP mul(UNITY_MATRIX_VP, UNITY_MATRIX_M)

            struct MeshData
            {
                float4 vertex : POSITION;
                float4 normal : NORMAL;
            };

            struct FragmentData
            {
                float4 position : SV_POSITION;
            };

            CBUFFER_START(UnityPerMaterial)
                float4 _BaseColor;
                float4 _ShallowWaterColor;
                float _Depth;
                float _Strength;
            CBUFFER_END

            FragmentData VertexPass(MeshData input)
            {
                FragmentData output;
                output.position = mul(UNITY_MATRIX_MVP, input.vertex);
                return output;
            }

            float4 FragmentPass(FragmentData input) : SV_Target
            {
                return _ShallowWaterColor;
            }

            ENDHLSL
        }
    }

    FallBack "Hidden/InternalErrorShader"
}