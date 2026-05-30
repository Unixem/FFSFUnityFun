using System;
using TeoGames.Mesh_Combiner.Scripts.Combine;
using TeoGames.Mesh_Combiner.Scripts.Combine.Lod;
using TeoGames.Mesh_Combiner.Scripts.Combine.MeshRendererManager;
using TeoGames.Mesh_Combiner.Scripts.Editor.MenuItems;
using TeoGames.Mesh_Combiner.Scripts.Extension;
using UnityEditor;
using UnityEngine;
using Object = UnityEngine.Object;

namespace TeoGames.Mesh_Combiner.Scripts.Editor {
	[CustomEditor(typeof(Combinable), true)]
	[CanEditMultipleObjects]
	public class CombinableEditor : BaseInspector {
		private int _Tab;

		private SerializedProperty _Key;
		private SerializedProperty _IsStatic;
		private SerializedProperty _CombinerSource;
		private SerializedProperty _DisableRenderer;
		private SerializedProperty _RemoveMaterials;
		private SerializedProperty _Cache;
		private SerializedProperty _BsEnabled;
		private SerializedProperty _BsMerge;
		private SerializedProperty _BsLiveSync;

		public override bool RequiresConstantRepaint() => Application.isPlaying;

		private void OnEnable() {
			_Key = serializedObject.FindProperty("key");
			_IsStatic = serializedObject.FindProperty("isStatic");
			_CombinerSource = serializedObject.FindProperty("combinerSource");
			_DisableRenderer = serializedObject.FindProperty("disableRenderer");
			_RemoveMaterials = serializedObject.FindProperty("removeMaterials");
			_Cache = serializedObject.FindProperty("cache");
			_BsEnabled = serializedObject.FindProperty("cache.blendShape.enabled");
			_BsMerge = serializedObject.FindProperty("cache.blendShape.merge");
			_BsLiveSync = serializedObject.FindProperty("cache.blendShape.liveSync");
		}

		public override void OnInspectorGUI() {
			InitStyles();
			serializedObject.Update();

			DrawTabs();

			foreach (var t in targets) {
				try {
					Utils.ClearCache((AbstractCombinable)t);
				} catch (Exception ex) {
					Debug.LogException(ex);
				}
			}

			EditorGUILayout.Space(4);
			DrawStatus();

			serializedObject.ApplyModifiedProperties();
		}

		private bool HasBlendShapes() {
			var cache = ((AbstractCombinable)target).GetCache();
			return cache.isSkinnedMesh && cache.mesh && cache.mesh.blendShapeCount > 0;
		}

		private void DrawTabs() {
			var showBlendShapes = HasBlendShapes();

			EditorGUILayout.BeginHorizontal();
			if (DrawTab("Settings", _Tab == 0)) _Tab = 0;

			if (showBlendShapes) {
				if (DrawTab("Blend Shapes", _Tab == 1)) _Tab = 1;
			} else if (_Tab == 1) {
				_Tab = 0;
			}

			GUILayout.FlexibleSpace();

			if (DrawTab("Cache", _Tab == 2)) _Tab = 2;
			EditorGUILayout.EndHorizontal();

			BeginSection();

			if (_Tab == 1 && showBlendShapes) {
				DrawBlendShapesTab();
			} else if (_Tab == 2) {
				DrawCacheTab();
			} else {
				DrawSettingsTab();
			}

			EndSection();
		}

		private void DrawSettingsTab() {
			DrawGroupField();

			var wantStatic = _IsStatic.boolValue;
			var isMR = wantStatic;
			var forced = false;

			var combinable = target as Combinable;
			var combiner = combinable
				? (Application.isPlaying ? combinable.GetCombiner() : combinable.GetCurrentCombiner())
				: null;
			if (combiner) {
				var supportsMR = (combiner.rendererTypes & TargetRendererType.MeshRenderer) != 0;
				var supportsSMR = (combiner.rendererTypes & TargetRendererType.SkinnerMeshRenderer) != 0;
				if (wantStatic && !supportsMR) { isMR = false; forced = true; }
				else if (!wantStatic && !supportsSMR) { isMR = true; forced = true; }
			}

			var rendererTag = isMR ? "MR" : "SMR";
			var rendererTooltip = forced
				? $"Combiner only supports {rendererTag} — overrides Bake as Static setting"
				: isMR
					? "Will bake into MeshRenderer — cheaper, no runtime movement"
					: "Will bake into SkinnedMeshRenderer — supports runtime movement, higher cost";
			var rendererColor = forced ? ColorYellow : isMR ? ColorGreen : AccentColor;

			var rect = EditorGUILayout.GetControlRect();
			EditorGUI.PropertyField(rect, _IsStatic, new GUIContent("Bake as Static", "When enabled, bakes into a MeshRenderer (cheaper draw calls, static batching). When disabled, bakes into a SkinnedMeshRenderer with bones (supports runtime movement)."));

			var tagRect = new Rect(rect.xMax - 30, rect.y, 30, rect.height);
			var prevTagColor = GUI.contentColor;
			GUI.contentColor = rendererColor;
			GUI.Label(tagRect, new GUIContent(rendererTag, rendererTooltip), EditorStyles.miniBoldLabel);
			GUI.contentColor = prevTagColor;

			DrawSourceField();

			SectionSeparator("When Combined");
			EditorGUILayout.PropertyField(_DisableRenderer, new GUIContent("Hide Renderer", "Disable the original renderer when combined."));
			EditorGUILayout.PropertyField(_RemoveMaterials, new GUIContent("Clear Materials", "Remove materials from the original renderer when combined. Saves memory if the original is hidden."));
		}

		private void DrawBlendShapesTab() {
			if (_BsEnabled == null || _BsLiveSync == null) return;

			var cache = ((AbstractCombinable)target).GetCache();
			var blendShapeCount = cache.mesh.blendShapeCount;

			EditorGUILayout.PropertyField(_BsEnabled, new GUIContent("Bake Blend Shapes"));
			if (!_BsEnabled.boolValue) return;

			EditorGUILayout.PropertyField(_BsMerge, new GUIContent("Merge Blend Shapes"));

			var syncCount = _BsLiveSync.arraySize;

			// Separator with All/None buttons
			EditorGUILayout.Space(4);
			var sepRect = EditorGUILayout.GetControlRect(false, 20);
			var lineY = sepRect.y + sepRect.height / 2;
			EditorGUI.DrawRect(new Rect(sepRect.x, lineY, sepRect.width, 1), new Color(0.5f, 0.5f, 0.5f, 0.3f));

			var labelText = $"Live Sync ({syncCount}/{blendShapeCount})";
			var labelSize = EditorStyles.miniLabel.CalcSize(new GUIContent(labelText));
			var bgColor = EditorGUIUtility.isProSkin ? new Color(0.22f, 0.22f, 0.22f) : new Color(0.92f, 0.92f, 0.92f);

			var labelRect = new Rect(sepRect.x, sepRect.y, labelSize.x + 8, sepRect.height);
			EditorGUI.DrawRect(labelRect, bgColor);
			GUI.Label(labelRect, labelText, MiniLabelLeft);

			var btnWidth = 36f;
			var noneRect = new Rect(sepRect.xMax - btnWidth, sepRect.y + 1, btnWidth, sepRect.height - 2);
			var allRect = new Rect(noneRect.x - btnWidth - 2, sepRect.y + 1, btnWidth, sepRect.height - 2);
			EditorGUI.DrawRect(new Rect(allRect.x - 4, sepRect.y, btnWidth * 2 + 10, sepRect.height), bgColor);

			if (GUI.Button(allRect, "All", EditorStyles.miniButtonLeft)) {
				_BsLiveSync.ClearArray();
				for (var i = 0; i < blendShapeCount; i++) {
					_BsLiveSync.InsertArrayElementAtIndex(i);
					_BsLiveSync.GetArrayElementAtIndex(i).stringValue = cache.mesh.GetBlendShapeName(i);
				}
			}
			if (GUI.Button(noneRect, "None", EditorStyles.miniButtonRight)) {
				_BsLiveSync.ClearArray();
			}

			var syncedNames = new System.Collections.Generic.HashSet<string>();
			for (var i = 0; i < _BsLiveSync.arraySize; i++)
				syncedNames.Add(_BsLiveSync.GetArrayElementAtIndex(i).stringValue);

			for (var i = 0; i < blendShapeCount; i++) {
				var shapeName = cache.mesh.GetBlendShapeName(i);
				var isEnabled = syncedNames.Contains(shapeName);
				var newState = EditorGUILayout.Toggle(shapeName, isEnabled);
				if (newState == isEnabled) continue;

				if (newState) {
					_BsLiveSync.InsertArrayElementAtIndex(_BsLiveSync.arraySize);
					_BsLiveSync.GetArrayElementAtIndex(_BsLiveSync.arraySize - 1).stringValue = shapeName;
				} else {
					for (var j = 0; j < _BsLiveSync.arraySize; j++) {
						if (_BsLiveSync.GetArrayElementAtIndex(j).stringValue == shapeName) {
							_BsLiveSync.DeleteArrayElementAtIndex(j);
							break;
						}
					}
				}
			}
		}

		private void DrawCacheTab() {
			GUI.enabled = false;
			var iter = _Cache.Copy();
			var end = iter.GetEndProperty();
			iter.NextVisible(true);
			while (!SerializedProperty.EqualContents(iter, end)) {
				EditorGUILayout.PropertyField(iter, true);
				if (!iter.NextVisible(false)) break;
			}
			GUI.enabled = true;

			SectionSeparator("Actions");
			if (GUILayout.Button("Reset Cache")) {
				Selection.gameObjects.ForEach(o => o
					.GetComponentsInChildren<AbstractCombinable>()
					.ForEach(Utils.LogClearCache));
			}
		}

		private void DrawStatus() {
			var comb = (AbstractCombinable)target;
			var cache = comb.GetCache();

			string statusLabel;
			Color statusColor;

			var hasCombiner = comb is Combinable cb && (Application.isPlaying ? cb.GetCombiner() : cb.GetCurrentCombiner());

			if (Application.isPlaying && comb is Combinable c && GetBakeStatus(c) == Combinable.BakeStatus.Baked) {
				statusLabel = "Combined";
				statusColor = ColorGreen;
			} else if (!hasCombiner && cache.status >= CacheStatus.Cached) {
				statusLabel = "No Combiner";
				statusColor = ColorRed;
			} else {
				switch (cache.status) {
					case CacheStatus.Baked:
						statusLabel = "Baked";
						statusColor = ColorGreen;
						break;
					case CacheStatus.Cached:
						statusLabel = "Ready";
						statusColor = StatusRight.normal.textColor;
						break;
					case CacheStatus.MeshUpdated:
						statusLabel = "Outdated";
						statusColor = ColorYellow;
						break;
					default:
						statusLabel = "New";
						statusColor = ColorGrey;
						break;
				}
			}

			BeginSection();

			EditorGUILayout.BeginHorizontal();
			if (cache.mesh) {
				var verts = cache.mesh.vertexCount;
				var vertsStr = verts >= 1000 ? $"{verts / 1000f:0.#}K" : verts.ToString();
				var type = cache.isSkinnedMesh ? "Skinned" : "Static";
				var matCount = cache.materials != null ? cache.materials.Length : 0;
				var blendCount = cache.mesh.blendShapeCount;
				var info = $"{cache.mesh.name}  |  {vertsStr} verts, {type}  |  {matCount} mat";
				var tooltip = $"Mesh: {cache.mesh.name}\nVertices: {verts}\nType: {type}\nMaterials: {matCount}";
				if (blendCount > 0) {
					var syncCount = cache.blendShape?.liveSync?.Count ?? 0;
					info += $"  |  {syncCount}/{blendCount} BS";
					tooltip += $"\nBlend Shapes: {syncCount} active / {blendCount} total";
				}
				EditorGUILayout.LabelField(new GUIContent(info, tooltip), EditorStyles.miniLabel);
			} else {
				EditorGUILayout.LabelField("No mesh", EditorStyles.miniLabel);
			}

			StatusBadge(statusLabel, statusColor);
			EditorGUILayout.EndHorizontal();

			if (comb is Combinable combinable) {
				var combiner = Application.isPlaying ? combinable.GetCombiner() : combinable.GetCurrentCombiner();

				GUI.enabled = false;
				EditorGUILayout.ObjectField("Combiner", combiner, typeof(AbstractMeshCombiner), true);
				GUI.enabled = true;

				if (!combiner) {
					EditorGUILayout.HelpBox("No compatible combiner found.", MessageType.Error);
				}

				if (combinable is LodCombinable lodCombinable) {
					SectionSeparator("LOD");
					DrawLodInfo(lodCombinable);
				}
			}

			EndSection();

			if (cache.mesh && !cache.mesh.isReadable) {
				EditorGUILayout.Space(2);
				EditorGUILayout.BeginHorizontal();
				EditorGUILayout.HelpBox("Mesh is not marked as Read/Write.", MessageType.Error);
				if (GUILayout.Button("Fix", GUILayout.Width(40), GUILayout.Height(38))) {
					cache.mesh.MarkAsReadable();
				}
				EditorGUILayout.EndHorizontal();
			}
		}

		private void DrawSourceField() {
			var rect = EditorGUILayout.GetControlRect();
			var labelWidth = EditorGUIUtility.labelWidth;

			var label = new GUIContent("Source", "Where to search for a compatible combiner.");
			EditorGUI.BeginProperty(rect, label, _CombinerSource);
			EditorGUI.PrefixLabel(rect, label);

			var val = (CombinerSourceType)_CombinerSource.intValue;
			var buttonsWidth = rect.width - labelWidth - 2;
			var halfWidth = (buttonsWidth - 2) / 2;
			var x = rect.x + labelWidth + 2;

			EditorGUI.BeginChangeCheck();
			var newHierarchy = GUI.Toggle(new Rect(x, rect.y, halfWidth, rect.height),
				(val & CombinerSourceType.SearchHierarchy) != 0,
				new GUIContent("Hierarchy", "Search parent objects for a combiner"),
				EditorStyles.miniButtonLeft);
			var newScene = GUI.Toggle(new Rect(x + halfWidth + 2, rect.y, halfWidth, rect.height),
				(val & CombinerSourceType.SceneCombiner) != 0,
				new GUIContent("Scene", "Search the scene combiner registry"),
				EditorStyles.miniButtonRight);
			if (EditorGUI.EndChangeCheck()) {
				var newVal = (CombinerSourceType)0;
				if (newHierarchy) newVal |= CombinerSourceType.SearchHierarchy;
				if (newScene) newVal |= CombinerSourceType.SceneCombiner;
				_CombinerSource.intValue = (int)newVal;
			}

			EditorGUI.EndProperty();
		}

		private void DrawGroupField() {
			var rect = EditorGUILayout.GetControlRect();
			var labelWidth = EditorGUIUtility.labelWidth;
			var buttonWidth = 18f;
			var warningWidth = 16f;

			var label = new GUIContent("Group", "Only combiners with matching group will accept this object. Leave empty to match any combiner.");
			EditorGUI.BeginProperty(rect, label, _Key);
			EditorGUI.PrefixLabel(rect, label);

			var currentKey = _Key.stringValue;

			var combiners = FindObjectsOfType<AbstractMeshCombiner>();
			var allKeys = new System.Collections.Generic.HashSet<string>();
			foreach (var c in combiners) {
				if (c.keys == null) continue;
				foreach (var k in c.keys)
					if (!string.IsNullOrEmpty(k)) allKeys.Add(k);
			}

			var hasWildcard = false;
				foreach (var c in combiners) {
					if (c.keys == null || c.keys.Length == 0) { hasWildcard = true; break; }
				}

				var hasWarning = !string.IsNullOrEmpty(currentKey) && !hasWildcard && !allKeys.Contains(currentKey);

			var fieldEnd = rect.xMax;
			if (hasWarning) {
				var warnRect = new Rect(fieldEnd - warningWidth, rect.y, warningWidth, rect.height);
				GUI.Label(warnRect, new GUIContent(
					EditorGUIUtility.IconContent("console.warnicon.sml").image,
					$"No combiner in the scene has group \"{currentKey}\""));
				fieldEnd -= warningWidth + 2;
			}

			var dropRect = new Rect(fieldEnd - buttonWidth, rect.y, buttonWidth, rect.height);
			fieldEnd -= buttonWidth + 2;

			var fieldRect = new Rect(rect.x + labelWidth + 2, rect.y, fieldEnd - rect.x - labelWidth - 2, rect.height);
			EditorGUI.BeginChangeCheck();
			var newVal = EditorGUI.TextField(fieldRect, currentKey);
			if (EditorGUI.EndChangeCheck()) {
				_Key.stringValue = newVal;
			}

			if (allKeys.Count > 0 && GUI.Button(dropRect, "+", EditorStyles.miniButton)) {
				var menu = new GenericMenu();
				menu.AddItem(new GUIContent("(any)"), string.IsNullOrEmpty(currentKey), () => {
					_Key.stringValue = "";
					serializedObject.ApplyModifiedProperties();
				});
				menu.AddSeparator("");
				foreach (var key in allKeys) {
					var k = key;
					menu.AddItem(new GUIContent(k), currentKey == k, () => {
						_Key.stringValue = k;
						serializedObject.ApplyModifiedProperties();
					});
				}
				menu.ShowAsContext();
			}

			EditorGUI.EndProperty();
		}

		private static void DrawLodInfo(LodCombinable lodCombinable) {
			var group = lodCombinable.GetComponentInParent<LODGroup>();
			if (!group) {
				EditorGUILayout.HelpBox("No LODGroup found in parent hierarchy.", MessageType.Warning);
				return;
			}

			GUI.enabled = false;
			EditorGUILayout.ObjectField("LOD Group", group, typeof(LODGroup), true);
			GUI.enabled = true;

			var lods = group.GetLODs();
			var cache = lodCombinable.GetCache();
			var level = -1;
			for (var i = 0; i < lods.Length; i++) {
				if (cache.renderer && System.Array.IndexOf(lods[i].renderers, cache.renderer) >= 0) {
					level = i;
					break;
				}
			}

			if (level >= 0) {
				var transition = $"{lods[level].screenRelativeTransitionHeight * 100:0.#}%";
				EditorGUILayout.LabelField(
					new GUIContent($"LOD {level}", "Which LOD level this renderer belongs to"),
					new GUIContent($"transition at {transition}", $"Screen size threshold: {transition}")
				);
			} else {
				EditorGUILayout.HelpBox("Renderer not found in any LOD level.", MessageType.Warning);
			}
		}

		private static System.Reflection.FieldInfo _IsBakedField;

		private static Combinable.BakeStatus GetBakeStatus(Combinable combinable) {
			if (_IsBakedField == null)
				_IsBakedField = typeof(Combinable).GetField("_IsBaked",
					System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Instance);
			return _IsBakedField != null
				? (Combinable.BakeStatus)_IsBakedField.GetValue(combinable)
				: Combinable.BakeStatus.None;
		}
	}
}
