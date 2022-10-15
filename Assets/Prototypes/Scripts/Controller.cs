using UnityEngine;

public class Controller : MonoBehaviour
{
    [SerializeField] private Output output;
    private RenderTexture[] renderTextures;

    private void Start()
    {
        renderTextures = new RenderTexture [output.Cameras.Length];

        for(var i = 0; i < output.Cameras.Length; i++)
        {
            renderTextures[i] = new RenderTexture(
                1920,
                1080,
                16,
                RenderTextureFormat.ARGB32,
                RenderTextureReadWrite.sRGB
            );

            output.Cameras[i].targetTexture = renderTextures[i];
        }
    }

    private void Update()
    {
        for(var i = 0; i < renderTextures.Length; i++)
            renderTextures[i].Release();
    }

    private void OnGUI()
    {
        for(var i = 0; i < renderTextures.Length; i++)
            output.UI.Parts[i].texture = renderTextures[i];
    }
}