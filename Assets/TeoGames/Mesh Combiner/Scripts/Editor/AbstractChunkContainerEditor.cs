using TeoGames.Mesh_Combiner.Scripts.Combine;
using TeoGames.Mesh_Combiner.Scripts.Combine.ChunkContainer;
using TeoGames.Mesh_Combiner.Scripts.Combine.Interfaces;
using UnityEditor;
using UnityEngine;

namespace TeoGames.Mesh_Combiner.Scripts.Editor {
	[CustomEditor(typeof(AbstractChunkContainer), true)]
	[CanEditMultipleObjects]
	public class AbstractChunkContainerEditor : BaseInspector {
		public override bool RequiresConstantRepaint() => Application.isPlaying;

		public override void OnInspectorGUI() {
			InitStyles();
			serializedObject.Update();

			var container = (AbstractChunkContainer)target;

			// Container-specific fields
			DrawContainerFields(container);

			EditorGUILayout.Space(4);

			// Status
			DrawStatus(container);

			serializedObject.ApplyModifiedProperties();
		}

		private void DrawContainerFields(AbstractChunkContainer container) {
			BeginSection();

			DrawRenderOutput();

			switch (container) {
				case GridChunkContainer grid: {
					var sizeProp = serializedObject.FindProperty("size");
					var containerProp = serializedObject.FindProperty("container");
					EditorGUILayout.PropertyField(sizeProp, new GUIContent("Cell Size", "Size of each spatial cell in world units."));
					EditorGUILayout.PropertyField(containerProp, new GUIContent("Parent", "Transform where chunk combiners will be created. Uses this object if empty."));

					if (grid is QuadChunkContainer) {
						EditorGUILayout.LabelField("Uses 3D spatial grid (X, Y, Z).", MiniLabelWrap);
					} else {
						EditorGUILayout.LabelField("Uses 2D spatial grid (X, Z). Ignores height.", MiniLabelWrap);
					}
					break;
				}

				case BoundsChunkContainer: {
					var boundsProp = serializedObject.FindProperty("bounds");
					var acceptProp = serializedObject.FindProperty("acceptClosest");
					EditorGUILayout.PropertyField(boundsProp, new GUIContent("Bounds", "The area this container covers."));
					EditorGUILayout.PropertyField(acceptProp, new GUIContent("Accept Closest", "If a combinable is outside bounds, accept it if this is the closest container."));

					if (GUILayout.Button("Recalculate from Renderers", EditorStyles.miniButton)) {
						((BoundsChunkContainer)container).RecalculateBounds();
						EditorUtility.SetDirty(container);
					}
					break;
				}

				case ColliderChunkContainer: {
					var colProp = serializedObject.FindProperty("col");
					var acceptProp = serializedObject.FindProperty("acceptClosest");
					EditorGUILayout.PropertyField(colProp, new GUIContent("Collider", "Collider defining the container area."));
					EditorGUILayout.PropertyField(acceptProp, new GUIContent("Accept Closest", "If a combinable is outside the collider, accept it if this is the closest container."));
					break;
				}
			}

			EndSection();
		}

		private void DrawStatus(AbstractChunkContainer container) {
			if (!Application.isPlaying) return;

			BeginSection();
			EditorGUILayout.BeginHorizontal();

			var renderers = container.GetRenderers();
			var totalVerts = 0;
			foreach (var r in renderers) {
				if (!r) continue;
				Mesh mesh = null;
				if (r is SkinnedMeshRenderer smr) mesh = smr.sharedMesh;
				else if (r.TryGetComponent<MeshFilter>(out var mf)) mesh = mf.sharedMesh;
				if (mesh) totalVerts += mesh.vertexCount;
			}

			var vertsStr = totalVerts >= 1000000 ? $"{totalVerts / 1000000f:0.#}M"
				: totalVerts >= 1000 ? $"{totalVerts / 1000f:0.#}K"
				: totalVerts.ToString();

			EditorGUILayout.LabelField($"{renderers.Length} renderers  |  {vertsStr} vertices", EditorStyles.miniLabel);

			var isActive = renderers.Length > 0;
			StatusBadge(isActive ? "Active" : "Idle", isActive ? ColorGreen : ColorGrey);

			EditorGUILayout.EndHorizontal();
			EndSection();
		}
	}
}
