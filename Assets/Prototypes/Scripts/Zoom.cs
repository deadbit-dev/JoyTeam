using UnityEngine;

[ExecuteAlways]
public class Zoom : MonoBehaviour
{
    [SerializeField] private Camera zoomCamera;
    [SerializeField] private Material zoomMaterial;
    [SerializeField] [Range(1, 50)] private int zoomFactor = 1;

    RenderTexture renderTarget;

    private void Start() {
        renderTarget = new RenderTexture(
            1920,
            1080,
            16,
            RenderTextureFormat.ARGB32,
            RenderTextureReadWrite.sRGB
        );

        zoomCamera.targetTexture = renderTarget;
    }

    private void Update() {
        zoomMaterial.SetTexture("_RenderTexture", renderTarget);
        zoomCamera.fieldOfView = Mathf.Lerp(1f, 60.0f, Mathf.InverseLerp(50, 1, zoomFactor));
    }
}