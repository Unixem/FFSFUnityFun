using System.Linq;
using TeoGames.Mesh_Combiner.Scripts.Combine;
using TeoGames.Mesh_Combiner.Scripts.Editor.MenuItems;
using TeoGames.Mesh_Combiner.Scripts.Extension;
using UnityEditor;
using UnityEngine;

namespace TeoGames.Mesh_Combiner.Scripts.Editor {
    [CustomEditor(typeof(SkinnedMeshRenderer)), CanEditMultipleObjects]
    public class SkinnedMeshRendererEditor : UnityEditor.Editor {
        public override void OnInspectorGUI() {
            serializedObject.Update();
            DrawDefaultInspector();
            EditorGUILayout.Space();

            var hasCombiner = targets.Cast<SkinnedMeshRenderer>().Any(r => r.GetComponent<AbstractCombinable>());

            if (!hasCombiner) {
                if (GUILayout.Button("Combine mesh"))
                    targets.Cast<SkinnedMeshRenderer>().ForEach(Utils.AddDynamicCombiner);
            } else {
                if (GUILayout.Button("Remove mesh combiner"))
                    targets.Cast<SkinnedMeshRenderer>().ForEach(r => {
                        var comb = r.GetComponent<AbstractCombinable>();
                        if (comb) Utils.RemoveCombiner(comb);
                    });
            }
        }
    }
}
