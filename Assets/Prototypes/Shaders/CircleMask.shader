Shader "Unlit/CircleMask"
{
    Properties
    {
        _RenderTexture ("Render Texture", 2D) = "white" {}

        _CenterX ("CenterX", Range(0, 1)) = 0.5
        _CenterY ("CenterY", Range(0, 1)) = 0.5
        _Radius ("Radius", Range(0, 0.5)) = 0.3
    }
    SubShader
    {
        Tags { 
            "RenderType"="Transparent"
            "Queue"="Transparent"
        }

        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "../ShaderLibrary/utils.hlsl"

            struct app2vert
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct vert2frag
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            cbuffer UnityPerMaterial {
                sampler2D _RenderTexture;
                float4 _RenderTexture_ST;
                float _CenterX;
                float _CenterY;
                float _Radius;
            };

            vert2frag vert(app2vert input)
            {
                vert2frag output;

                output.vertex = TransformObjectToHClip(input.vertex.xyz);
                output.uv = TRANSFORM_TEX(input.uv, _RenderTexture);

                return output;
            }

            float4 frag(vert2frag input) : SV_Target
            {
                float shape = circle(input.uv, float2(_CenterX, _CenterY), _Radius);
                float4 color = tex2D(_RenderTexture, input.uv);
                return float4(shape * color.xyz, shape);
            }

            ENDHLSL
        }
    }
}