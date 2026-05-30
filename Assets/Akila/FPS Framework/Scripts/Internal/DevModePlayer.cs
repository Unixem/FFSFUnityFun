using Akila.FPSFramework;
using UnityEngine;

#if UNITY_EDITOR
public class DevModePlayer : MonoBehaviour
{
    private void Update()
    {
        if(FPSFrameworkCore.IsDeveloperMode == false)
        {
            //FPSFrameworkCore.DisposeDevMode();

            DestroyImmediate(gameObject);
        }
    }
}
#endif