using UnityEditor;

namespace RNGNeeds.Editor.Editors
{
    [InitializeOnLoad]
    public class RNGNeedsStartup
    {
        static RNGNeedsStartup()
        {
            if (EditorPrefs.GetBool("RNGNeeds_WelcomeWindow_v1", false)) return;
            WelcomeWindow.ShowWindow();
            EditorPrefs.SetBool("RNGNeeds_WelcomeWindow_v1", true);
        }
    }
}