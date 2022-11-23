using UnityEngine;
using UnityEditor;

[ExecuteAlways]
public class Lod: MonoBehaviour
{
    [SerializeField] private Shader lodShader;
    
    void Update()
    {
        var view = SceneView.lastActiveSceneView;

        if(view == null) return;

        var delta = Vector3.Distance(view.camera.transform.position, transform.position);
        lodShader.maximumLOD = (delta > 10) ? 1 : 0;
        
        Debug.Log(delta);
    }
}