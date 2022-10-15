Shader "Unlit/Circle"
{
    Properties
    {
        _CenterX ("CenterX", Range(0, 1)) = 0.5
        _CenterY ("CenterY", Range(0, 1)) = 0.5
        _Smooth ("Smooth", Range(0, 0.5)) = 0.0
        _Radius ("Radius", Range(0, 0.5)) = 0.3
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent"}
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float _CenterX;
            float _CenterY;
            float _Smooth;
            float _Radius;

            float4 modelToClipSpace (float4 vertex)
            {
                return mul(
                    mul(UNITY_MATRIX_P, UNITY_MATRIX_V),
                    mul(UNITY_MATRIX_M, vertex)
                );
            }

            float2 texModification (float2 pos, float4 tex)
            {
                return pos.xy * tex.xy + tex.zw;
            }

            float iLerp (float a, float b, float v)
            {
                float t = (v - a) / (b - a);
                return clamp(t, 0, 1);
            }

            float cubicCurve (float t)
            {
                return t * t * (3 - 2 * t);
            }

            float smoothing (float a, float b, float v)
            {
                float t = iLerp(a, b, v);
                return cubicCurve(t);
            }

            float vectorLength (float2 v)
            {
                return sqrt(dot(v, v));
            }

            float circle (float2 pos, float2 center, float radius)
            {
                float2 shift = pos - center;
                return vectorLength(shift) - radius;
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = modelToClipSpace(v.vertex);
                o.uv = v.uv;
                
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float shape = circle(i.uv, float2(_CenterX, _CenterY), _Radius);
                return smoothing(shape - _Smooth, shape + _Smooth, _Radius).xxxx;
            }

            ENDCG
        }
    }
}