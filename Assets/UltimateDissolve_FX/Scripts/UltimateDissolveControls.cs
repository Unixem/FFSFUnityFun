using UnityEngine;

public class UltimateDissolveControls : MonoBehaviour
{
    
    [TextArea]
    public string Instructions = " You need to Switch to Manual Mode in The Material ";

    [Space(10)]
    [Range(0f, 1f)]
    public float TransitionValue;

    private Material material;

    private void Start()
    {
        // Get the MeshRenderer component attached to this GameObject
        MeshRenderer meshRenderer = GetComponent<MeshRenderer>();

        if (meshRenderer != null)
        {
            // Get the material from the mesh renderer
            material = meshRenderer.material;
        }
        else
        {
            Debug.LogWarning("MeshRenderer component not found on the GameObject: " + gameObject.name);
            enabled = false; // Disable the script if MeshRenderer is not found
        }
    }

    private void Update()
    {
        // Change the value of the material parameter
        material.SetFloat("_ManualTransition", TransitionValue);
    }
}
