#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "utils.hlsl"

struct app2vert
{
    float4 vertex : POSITION;
    float2 uv : TEXCOORD0;
};

struct vert2frag
{
    float2 uv : TEXCOORD0;
    float4 vertex : SV_POSITION;
    float4 screenPos : TEXCOORD1;
};

cbuffer UnityPerDraw {
    sampler2D _CameraOpaqueTexture;
};

cbuffer UnityPerMaterial {
    float _CenterX;
    float _CenterY;
    float _Smooth;
    float _Radius;
    float _Zoom;
};

vert2frag vert (app2vert input)
{
    vert2frag output;
    output.uv = input.uv;
    output.vertex = TransformObjectToHClip(input.vertex.xyz);
    /* 
        TransformObjectToHClip = mul(
            mul(UNITY_MATRIX_P, UNITY_MATRIX_V),
            mul(UNITY_MATRIX_M, input.vertex)
        );
    */
    output.screenPos = ComputeScreenPos(output.vertex);
    /*
        ComputeScreenPos = float4(
            (float2(output.vertex.x, -output.vertex.y) + output.vertex.w) * 0.5,
            output.vertex.zw
        );
    */
    return output;
}

float4 frag (vert2frag input) : SV_Target
{
    float shape = circle(input.uv, float2(_CenterX, _CenterY), _Radius);
    float zoom = smoothstep(1, 8, _Zoom); 
    float2 coord = float2(input.screenPos.xy * (1 - zoom) + (input.screenPos.zw + (zoom * 0.5).xx));
    float4 sceneColor = tex2D(_CameraOpaqueTexture, coord);
    return shape * sceneColor;
}