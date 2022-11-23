Shader "Unlit/LodTest"
{
    Properties
    {
        _farColor ("Far Color", Color) = (1, 1, 1, 1)
        _nearColor ("Near Color", Color) = (0, 0, 0, 1)
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 1

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            float4 _farColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = TransformObjectToHClip(v.vertex.xyz);

                return o;
            }

            float4 frag () : SV_Target
            {
                return _farColor;
            }

            ENDHLSL
        }
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 0

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            float4 _nearColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = TransformObjectToHClip(v.vertex.xyz);

                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                return _nearColor;
            }

            ENDHLSL
        }
    }
}