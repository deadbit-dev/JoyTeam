Shader "Unlit/Zoom"
{
    Properties
    {
        _CenterX ("CenterX", Range(0, 1)) = 0.5
        _CenterY ("CenterY", Range(0, 1)) = 0.5
        _Smooth ("Smooth", Range(0, 0.5)) = 0.0
        _Radius ("Radius", Range(0, 0.5)) = 0.3
        _Zoom ("Zoom", Range(1, 8)) = 2
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

            #include "../ShaderLibrary/zoom.hlsl"

            ENDHLSL
        }
    }

    FallBack "Hidden/InternalErrorShader"
}