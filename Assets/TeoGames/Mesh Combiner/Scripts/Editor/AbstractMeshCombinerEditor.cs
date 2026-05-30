using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using TeoGames.Mesh_Combiner.Scripts.Combine;
using TeoGames.Mesh_Combiner.Scripts.Combine.Collider;
using TeoGames.Mesh_Combiner.Scripts.Combine.Interfaces;
using TeoGames.Mesh_Combiner.Scripts.Combine.MeshRendererManager;
using TeoGames.Mesh_Combiner.Scripts.Editor.MenuItems;
using TeoGames.Mesh_Combiner.Scripts.Extension;
using TeoGames.Mesh_Combiner.Scripts.Extension.Editor;
using UnityEditor;
using UnityEngine;
using TeoGames.Mesh_Combiner.Scripts.Combine.ChunkContainer;
using TeoGames.Mesh_Combiner.Scripts.Combine.Lod;

namespace TeoGames.Mesh_Combiner.Scripts.Editor {
	[CustomEditor(typeof(AbstractMeshCombiner), true)]
	[CanEditMultipleObjects]
	public class AbstractMeshCombinerEditor : BaseInspector {
		private static readonly int AssetExtensionLength = ".asset".Length;

		private static readonly FieldInfo InstancesField = typeof(ChunkMeshCombiner)
			.GetField("Instances", BindingFlags.NonPublic | BindingFlags.Instance);

		private static readonly FieldInfo CellsField = typeof(GridChunkContainer)
			.GetField("_Cells", BindingFlags.NonPublic | BindingFlags.Instance);

		private static int GetInstancesCount(ChunkMeshCombiner cmc) {
			return InstancesField?.GetValue(cmc) is System.Collections.IDictionary dict ? dict.Count : 0;
		}

		private static List<MeshCombiner> GetGridCells(GridChunkContainer grid) {
			return CellsField?.GetValue(grid) is Dictionary<string, MeshCombiner> dict
				? dict.Values.ToList()
				: new List<MeshCombiner>();
		}

		private static void FindCompatible(AbstractMeshCombiner combiner, out int combCount, out int lodCount) {
			combCount = 0;
			lodCount = 0;
			foreach (var cb in FindObjectsOfType<AbstractCombinable>(true)) {
				if (!cb.IsCompatible(combiner)) continue;
				combCount++;
				if (cb is LodCombinable) lodCount++;
			}
		}

		private static AbstractCombinable[] FindAllCompatible(AbstractMeshCombiner combiner) {
			return FindObjectsOfType<AbstractCombinable>(true).Where(cb => cb.IsCompatible(combiner)).ToArray();
		}

		private int _Tab;
		private int _LodPage;
		private int _ChunkPage;
		private readonly System.Collections.Generic.HashSet<int> _ExpandedChunks = new System.Collections.Generic.HashSet<int>();

		private SerializedProperty _Keys;
		private SerializedProperty _MaxBuildTime;
		private SerializedProperty _RendererTypes;
		private SerializedProperty _BakeMaterials;
		private SerializedProperty _SeparateBlendShapes;
		private SerializedProperty _ClearMaterialCache;
		private SerializedProperty _IndexFormat;
		private SerializedProperty _Lod;

		public override bool RequiresConstantRepaint() => Application.isPlaying;

		private void OnEnable() {
			_Keys = serializedObject.FindProperty("keys");
			_MaxBuildTime = serializedObject.FindProperty("maxBuildTime");
			_RendererTypes = serializedObject.FindProperty("rendererTypes");
			_BakeMaterials = serializedObject.FindProperty("bakeMaterials");
			_SeparateBlendShapes = serializedObject.FindProperty("separateBlendShapes");
			_ClearMaterialCache = serializedObject.FindProperty("clearMaterialCache");
			_IndexFormat = serializedObject.FindProperty("indexFormat");
			_Lod = serializedObject.FindProperty("lod");
		}

		public override void OnInspectorGUI() {
			InitStyles();
			serializedObject.Update();

			DrawTabs();
			EditorGUILayout.Space(4);
			DrawStatus();

			serializedObject.ApplyModifiedProperties();
		}

		private void DrawTabs() {
			var isChunk = target is ChunkMeshCombiner;

			EditorGUILayout.BeginHorizontal();
			if (DrawTab("Settings", _Tab == 0)) _Tab = 0;
			if (DrawTab("Performance", _Tab == 1)) _Tab = 1;
			if (DrawTab("LOD", _Tab == 2)) _Tab = 2;
			GUILayout.FlexibleSpace();
			if (DrawTab("Actions", _Tab == 3)) _Tab = 3;
			EditorGUILayout.EndHorizontal();

			BeginSection();

			switch (_Tab) {
				case 0: DrawSettings(isChunk); break;
				case 1: DrawPerformance(); break;
				case 2: DrawLod(); break;
				case 3: DrawActions(); break;
			}

			EndSection();
		}

		private void DrawSettings(bool isChunk) {
			DrawRenderOutput();
			DrawGroups();
			DrawRendererTypes();

			SectionSeparator("Materials");
			EditorGUILayout.PropertyField(_BakeMaterials, new GUIContent("Bake Materials", "Combine materials into texture atlases. Only lit/simple lit materials without textures are supported."));

			SectionSeparator("Blend Shapes");
			EditorGUILayout.PropertyField(_SeparateBlendShapes, new GUIContent("Separate Blend Shapes", "Split blend shape models into a separate SkinnedMeshRenderer for better compatibility."));

			if (isChunk) {
				DrawChunkSeparator();
				EditorGUILayout.LabelField("Containers split combinables into spatial groups. Each group gets its own combiner.", MiniLabelWrap);
				EditorGUILayout.Space(2);
				DrawChunkContainers();
			}

		}

		private static bool _ShowProjectSettings;

		private static void DrawProjectSettings() {
			SectionSeparator("Project Settings");

			_ShowProjectSettings = EditorGUILayout.Foldout(_ShowProjectSettings, "Mesh Optimization (per-project)", true);
			if (!_ShowProjectSettings) return;

			EditorGUILayout.HelpBox("These settings affect all combiners in the project via scripting define symbols.", MessageType.Warning);

			var group = BuildPipeline.GetBuildTargetGroup(EditorUserBuildSettings.activeBuildTarget);
			var defines = PlayerSettings.GetScriptingDefineSymbolsForGroup(group);

			EditorGUI.indentLevel++;

			var removeUV = defines.Contains("DMC_REMOVE_UV");
			var newRemoveUV = EditorGUILayout.Toggle(
				new GUIContent("Remove Non-Zero UV", "Strip UV1-UV4 channels from combined meshes. Reduces memory."),
				removeUV);
			if (newRemoveUV != removeUV) ToggleDefine("DMC_REMOVE_UV", newRemoveUV, group, defines);

			var removeColors = defines.Contains("DMC_REMOVE_COLORS");
			var newRemoveColors = EditorGUILayout.Toggle(
				new GUIContent("Remove Vertex Colors", "Strip vertex color data from combined meshes. Reduces memory."),
				removeColors);
			if (newRemoveColors != removeColors) ToggleDefine("DMC_REMOVE_COLORS", newRemoveColors, group, defines);

			EditorGUI.indentLevel--;
		}

		private static void ToggleDefine(string symbol, bool enable, BuildTargetGroup group, string currentDefines) {
			if (enable) {
				if (!currentDefines.Contains(symbol)) {
					var newDefines = string.IsNullOrEmpty(currentDefines) ? symbol : currentDefines + ";" + symbol;
					PlayerSettings.SetScriptingDefineSymbolsForGroup(group, newDefines);
				}
			} else {
				var newDefines = currentDefines.Replace(symbol, "").Replace(";;", ";").Trim(';');
				PlayerSettings.SetScriptingDefineSymbolsForGroup(group, newDefines);
			}
		}

		private static readonly System.Type[] ContainerTypes = {
			typeof(GridChunkContainer),
			typeof(QuadChunkContainer),
			typeof(BoundsChunkContainer),
			typeof(ColliderChunkContainer),
		};

		private static readonly string[] ContainerNames = {
			"Grid (2D)",
			"Grid (3D)",
			"Bounds",
			"Collider",
		};

		private void DrawChunkSeparator() {
			EditorGUILayout.Space(6);
			var rect = EditorGUILayout.GetControlRect(false, 20);
			var lineY = rect.y + rect.height / 2;
			EditorGUI.DrawRect(new Rect(rect.x, lineY, rect.width, 1), new Color(0.5f, 0.5f, 0.5f, 0.3f));
			var bgColor = EditorGUIUtility.isProSkin ? new Color(0.22f, 0.22f, 0.22f) : new Color(0.92f, 0.92f, 0.92f);

			// "Chunks" label on left
			var labelContent = new GUIContent("Chunks");
			var labelSize = EditorStyles.miniLabel.CalcSize(labelContent);
			var labelRect = new Rect(rect.x, rect.y, labelSize.x + 8, rect.height);
			EditorGUI.DrawRect(labelRect, bgColor);
			GUI.Label(labelRect, labelContent, MiniLabelCenter);

			// "+ Add" button on right
			var btnWidth = 50f;
			var btnRect = new Rect(rect.xMax - btnWidth, rect.y + 1, btnWidth, rect.height - 2);
			EditorGUI.DrawRect(new Rect(btnRect.x - 4, rect.y, btnWidth + 8, rect.height), bgColor);

			if (GUI.Button(btnRect, "+ Add", EditorStyles.miniButton)) {
				var chunksProp = serializedObject.FindProperty("chunks");
				var go = ((Component)target).gameObject;
				var menu = new GenericMenu();
				for (var i = 0; i < ContainerTypes.Length; i++) {
					var type = ContainerTypes[i];
					var name = ContainerNames[i];
					menu.AddItem(new GUIContent(name), false, () => {
						var comp = go.AddComponent(type) as AbstractChunkContainer;
						var idx = chunksProp.arraySize;
						chunksProp.InsertArrayElementAtIndex(idx);
						chunksProp.GetArrayElementAtIndex(idx).objectReferenceValue = comp;
						serializedObject.ApplyModifiedProperties();
					});
				}
				menu.ShowAsContext();
			}
		}

		private void DrawChunkContainers() {
			var chunksProp = serializedObject.FindProperty("chunks");
			if (chunksProp == null) return;

			var go = ((Component)target).gameObject;
			var total = chunksProp.arraySize;

			if (total == 0) {
				EditorGUILayout.LabelField("No containers. Add one below.", EditorStyles.miniLabel);
			} else {
				const int pageSize = 5;
				var totalPages = Mathf.CeilToInt((float)total / pageSize);
				_ChunkPage = Mathf.Clamp(_ChunkPage, 0, totalPages - 1);
				var start = _ChunkPage * pageSize;
				var end = Mathf.Min(start + pageSize, total);

				for (var i = start; i < end; i++) {
					var element = chunksProp.GetArrayElementAtIndex(i);
					var container = element.objectReferenceValue as AbstractChunkContainer;
					var isExpanded = _ExpandedChunks.Contains(i);

					EditorGUILayout.BeginVertical(SectionBox);

					// Header: [▶] [object field]            [×]
					var headerRect = EditorGUILayout.GetControlRect(false, 18);

					// Foldout arrow
					var foldRect = new Rect(headerRect.x + 6, headerRect.y, 14, headerRect.height);
					var newExpanded = EditorGUI.Foldout(foldRect, isExpanded, GUIContent.none, true);
					if (newExpanded != isExpanded) {
						if (newExpanded) _ExpandedChunks.Add(i);
						else _ExpandedChunks.Remove(i);
					}

					// Object field
					var fieldRect = new Rect(headerRect.x + 22, headerRect.y, headerRect.width - 46, headerRect.height);
					GUI.enabled = false;
					EditorGUI.ObjectField(fieldRect, container, typeof(AbstractChunkContainer), true);
					GUI.enabled = true;

					// Remove button
					var removeRect = new Rect(headerRect.xMax - 20, headerRect.y, 20, headerRect.height);
					if (GUI.Button(removeRect, "\u00d7", EditorStyles.miniButton)) {
						if (container) DestroyImmediate(container);
						chunksProp.DeleteArrayElementAtIndex(i);
						if (i < chunksProp.arraySize && chunksProp.GetArrayElementAtIndex(i).objectReferenceValue == null)
							chunksProp.DeleteArrayElementAtIndex(i);
						_ExpandedChunks.Remove(i);
						break;
					}

					// Expanded content
					if (isExpanded && container) {
						if (container is ICombinerVisibilityTogglable vis) {
							var newVis = EditorGUILayout.Toggle(
								new GUIContent("Render Output", "When enabled, combined meshes are rendered and originals are hidden."),
								vis.IsVisible);
							if (newVis != vis.IsVisible) {
								vis.IsVisible = newVis;
								EditorUtility.SetDirty(container);
							}
						}

						var so = new SerializedObject(container);
						so.Update();
						var iter = so.GetIterator();
						iter.NextVisible(true); // skip m_Script
						while (iter.NextVisible(false)) {
							EditorGUILayout.PropertyField(iter, true);
						}
						so.ApplyModifiedProperties();
					} else if (isExpanded) {
						EditorGUILayout.HelpBox("Container reference is missing.", MessageType.Error);
					}

					EditorGUILayout.EndVertical();
					EditorGUILayout.Space(1);
				}

				// Pagination
				if (totalPages > 1) {
					EditorGUILayout.BeginHorizontal();
					GUI.enabled = _ChunkPage > 0;
					if (GUILayout.Button("\u25c0", EditorStyles.miniButtonLeft, GUILayout.Width(30))) _ChunkPage--;
					GUI.enabled = true;
					EditorGUILayout.LabelField($"{_ChunkPage + 1} / {totalPages}", MiniLabelCenter);
					GUI.enabled = _ChunkPage < totalPages - 1;
					if (GUILayout.Button("\u25b6", EditorStyles.miniButtonRight, GUILayout.Width(30))) _ChunkPage++;
					GUI.enabled = true;
					EditorGUILayout.EndHorizontal();
				}
			}

		}

		private string _NewGroupName = "";

		private void DrawGroups() {
			// Input row on same line as label
			EditorGUILayout.BeginHorizontal();
			EditorGUILayout.PrefixLabel(new GUIContent("Groups", "List of groups to accept. Accepts any combinable if empty."));

			var evt = Event.current;
			var enterPressed = evt.type == EventType.KeyDown && evt.keyCode == KeyCode.Return
			                   && GUI.GetNameOfFocusedControl() == "GroupInput";

			GUI.SetNextControlName("GroupInput");
			_NewGroupName = EditorGUILayout.TextField(_NewGroupName, GUILayout.ExpandWidth(true));

			var canAdd = !string.IsNullOrWhiteSpace(_NewGroupName);

			if (canAdd && enterPressed) {
				AddGroup();
				evt.Use();
			}

			GUI.enabled = canAdd;
			if (GUILayout.Button("+", EditorStyles.miniButton, GUILayout.Width(20))) {
				AddGroup();
			}
			GUI.enabled = true;

			EditorGUILayout.EndHorizontal();

			// Tags below
			if (_Keys.arraySize > 0) {
				EditorGUILayout.BeginHorizontal();
				GUILayout.Space(EditorGUIUtility.labelWidth + 2);

				for (var i = 0; i < _Keys.arraySize; i++) {
					var val = _Keys.GetArrayElementAtIndex(i).stringValue;
					var content = new GUIContent($" {val} \u00d7 ");
					var size = EditorStyles.miniButton.CalcSize(content);

					if (GUILayout.Button(content, EditorStyles.miniButton, GUILayout.Width(size.x))) {
						_Keys.DeleteArrayElementAtIndex(i);
						break;
					}
				}

				EditorGUILayout.EndHorizontal();
			} else {
				EditorGUILayout.BeginHorizontal();
				GUILayout.Space(EditorGUIUtility.labelWidth + 2);
				EditorGUILayout.LabelField("Accepts any combinable", EditorStyles.miniLabel);
				EditorGUILayout.EndHorizontal();
			}
		}

		private void AddGroup() {
			_Keys.InsertArrayElementAtIndex(_Keys.arraySize);
			_Keys.GetArrayElementAtIndex(_Keys.arraySize - 1).stringValue = _NewGroupName.Trim();
			_NewGroupName = "";
			GUI.FocusControl(null);
		}

		private void DrawRendererTypes() {
			var rect = EditorGUILayout.GetControlRect();
			var labelWidth = EditorGUIUtility.labelWidth;
			var label = new GUIContent("Renderer Types", "Which renderer types the combiner will output.");

			EditorGUI.BeginProperty(rect, label, _RendererTypes);
			EditorGUI.PrefixLabel(rect, label);

			var val = (TargetRendererType)_RendererTypes.intValue;
			var buttonsWidth = rect.width - labelWidth - 2;
			var halfWidth = (buttonsWidth - 2) / 2;
			var x = rect.x + labelWidth + 2;

			var hasMR = (val & TargetRendererType.MeshRenderer) != 0;
			var hasSMR = (val & TargetRendererType.SkinnerMeshRenderer) != 0;

			EditorGUI.BeginChangeCheck();
			var newMR = GUI.Toggle(new Rect(x, rect.y, halfWidth, rect.height), hasMR,
				new GUIContent("MeshRenderer", "Static combined meshes"), EditorStyles.miniButtonLeft);
			var newSMR = GUI.Toggle(new Rect(x + halfWidth + 2, rect.y, halfWidth, rect.height), hasSMR,
				new GUIContent("SkinnedMesh", "Dynamic combined meshes with bones"), EditorStyles.miniButtonRight);
			if (EditorGUI.EndChangeCheck()) {
				var newVal = (TargetRendererType)0;
				if (newMR) newVal |= TargetRendererType.MeshRenderer;
				if (newSMR) newVal |= TargetRendererType.SkinnerMeshRenderer;
				_RendererTypes.intValue = (int)newVal;
			}

			EditorGUI.EndProperty();

			if (!newMR && !newSMR) {
				EditorGUILayout.HelpBox("At least one renderer type must be selected.", MessageType.Error);
			}
		}

		private void DrawPerformance() {
			EditorGUILayout.PropertyField(_MaxBuildTime, new GUIContent("Frame Budget (ms)", "Maximum CPU time per frame for combining. Lower values reduce frame hitches but slow down baking."));
			EditorGUILayout.PropertyField(_IndexFormat, new GUIContent("Index Format", "UInt16 saves memory on mobile but limits meshes to 65K vertices. UInt32 supports larger meshes."));
			EditorGUILayout.PropertyField(_ClearMaterialCache, new GUIContent("Clear Material Cache", "Free material cache after each build. Saves memory but increases CPU usage on subsequent builds."));
		}

		private void DrawLod() {
			EditorGUILayout.LabelField("Automatically groups LOD levels from LODGroup components and combines each level separately. Requires LodCombinable on child renderers.", MiniLabelWrap);
			EditorGUILayout.Space(4);

			var chunkSize = _Lod.FindPropertyRelative("chunkSize");
			var transitionThreshold = _Lod.FindPropertyRelative("transitionThreshold");
			var use3dGrid = _Lod.FindPropertyRelative("use3dGrid");

			EditorGUILayout.PropertyField(chunkSize, new GUIContent("Chunk Size", "Max size of the LOD chunks."));
			EditorGUILayout.PropertyField(transitionThreshold, new GUIContent("Transition Threshold", "LODs will be merged if their transition difference is less than this value."));
			EditorGUILayout.PropertyField(use3dGrid, new GUIContent("Use 3D Grid", "Split LODs into 3D spatial chunks instead of 2D."));

			// Runtime LOD info
			var combiner = (AbstractMeshCombiner)target;
			if (!Application.isPlaying) {
				FindCompatible(combiner, out _, out var lodEditCount);
				if (lodEditCount == 0) {
					EditorGUILayout.Space(4);
					EditorGUILayout.HelpBox("No compatible LodCombinable components found in the scene. Add them to renderers inside LODGroup hierarchies.", MessageType.Info);
				}
			} else if (combiner.IsLodReady) {
				var lodCombiner = combiner.Lod.Combiner;
				var lodCells = GetGridCells(lodCombiner.chunk);

				SectionSeparator($"LOD Combiners ({lodCells.Count})");

				if (lodCells.Count > 0) {
					const int pageSize = 10;
					var totalPages = Mathf.CeilToInt((float)lodCells.Count / pageSize);
					_LodPage = Mathf.Clamp(_LodPage, 0, totalPages - 1);
					var start = _LodPage * pageSize;
					var end = Mathf.Min(start + pageSize, lodCells.Count);

					GUI.enabled = false;
					for (var i = start; i < end; i++) {
						EditorGUILayout.ObjectField(lodCells[i], typeof(MeshCombiner), true);
					}
					GUI.enabled = true;

					if (totalPages > 1) {
						EditorGUILayout.BeginHorizontal();
						GUI.enabled = _LodPage > 0;
						if (GUILayout.Button("\u25c0", EditorStyles.miniButtonLeft, GUILayout.Width(30))) _LodPage--;
						GUI.enabled = true;
						EditorGUILayout.LabelField($"{_LodPage + 1} / {totalPages}", MiniLabelCenter);
						GUI.enabled = _LodPage < totalPages - 1;
						if (GUILayout.Button("\u25b6", EditorStyles.miniButtonRight, GUILayout.Width(30))) _LodPage++;
						GUI.enabled = true;
						EditorGUILayout.EndHorizontal();
					}
				}
			}
		}

		private void DrawActions() {
			if (Application.isPlaying) {
				EditorGUILayout.HelpBox("Actions are not available during play mode.", MessageType.Info);
				return;
			}

			var c = (AbstractMeshCombiner)target;
			var go = c.gameObject;

			// Combinables management
			EditorGUILayout.LabelField("Manage Combinable components on child renderers.", MiniLabelWrap);
			EditorGUILayout.BeginHorizontal();
			if (GUILayout.Button("Add Combinables")) {
				go.GetComponentsInChildren<MeshRenderer>(true).ForEach(Utils.AddStaticCombiner);
				go.GetComponentsInChildren<SkinnedMeshRenderer>(true).ForEach(Utils.AddDynamicCombiner);
			}
			if (GUILayout.Button("Remove Combinables")) {
				go.GetComponentsInChildren<Combinable>(true).ForEach(Utils.RemoveCombiner);
			}
			EditorGUILayout.EndHorizontal();

			EditorGUILayout.Space(2);
			EditorGUILayout.LabelField("Refresh cached mesh and material data on all compatible combinables.", MiniLabelWrap);
			if (GUILayout.Button("Clear Cache")) {
				FindAllCompatible(c).ForEach(Utils.LogClearCache);
			}

			SectionSeparator("Baking");

			if (targets.Length != 1) {
				EditorGUILayout.HelpBox("Mesh baking works with a single selected combiner.", MessageType.Info);
				return;
			}

			EditorGUILayout.LabelField("Generate combined meshes and save as assets. Original meshes will be disabled.", MiniLabelWrap);
			if (GUILayout.Button("Bake Mesh")) {
				var isPrefab = go.scene.name == null;
				var (obj, folder) = isPrefab || go.scene.path == ""
					? go.OpenPrefab()
					: (go, go.scene.path.RemoveLast(AssetExtensionLength) + "/");

				BakingUtils.Bake(obj, folder).Then(() => {
					if (isPrefab) obj.SaveAndClosePrefab();
				});
			}

			if (BakingUtils.IsBaked(go) && GUILayout.Button("Remove Baked Mesh")) {
				var obj = go.scene.name != null ? go : go.OpenPrefab().root;
				BakingUtils.RemoveBake(obj);
				obj.SaveAndClosePrefab();
				GUIUtility.ExitGUI();
			}

			if (c is IRenderListener) {
				SectionSeparator("Colliders");

				EditorGUILayout.LabelField("Auto-generate mesh colliders from combined renderers.", MiniLabelWrap);
				var col = go.GetComponents<ColliderGenerator>().FirstOrDefault(o => o.combiner == c);
				if (col) {
					if (GUILayout.Button("Remove Mesh Collider Generator")) {
						DestroyImmediate(col, true);
						EditorUtility.SetDirty(go);
					}
				} else {
					if (GUILayout.Button("Add Mesh Collider Generator")) {
						col = go.gameObject.AddComponent<ColliderGenerator>();
						col.combiner = c;
						EditorUtility.SetDirty(col);
					}
				}
			}

			DrawProjectSettings();
		}

		private void DrawStatus() {
			var c = (AbstractMeshCombiner)target;

			// Gather input count
			var inputCount = 0;
			if (c is MeshCombiner mc) {
				inputCount = mc.CombinableCount;
			} else if (c is ChunkMeshCombiner cmc) {
				inputCount = GetInstancesCount(cmc);
			}

			string statusLabel;
			Color statusColor;
			if (Application.isPlaying && inputCount > 0) {
				statusLabel = "Active";
				statusColor = ColorGreen;
			} else if (BakingUtils.IsBaked(c.gameObject)) {
				statusLabel = "Baked";
				statusColor = ColorGreen;
			} else {
				statusLabel = "Idle";
				statusColor = ColorGrey;
			}

			BeginSection();

			if (Application.isPlaying) {
				var totalVerts = 0;
				var outputMeshCount = 0;
				var outputMaterials = new System.Collections.Generic.HashSet<Material>();

				void CountOutput(Renderer[] renderers) {
					foreach (var r in renderers) {
						if (!r) continue;
						outputMeshCount++;
						foreach (var m in r.sharedMaterials)
							if (m) outputMaterials.Add(m);
						Mesh mesh = null;
						if (r is SkinnedMeshRenderer smr) mesh = smr.sharedMesh;
						else if (r.TryGetComponent<MeshFilter>(out var mf)) mesh = mf.sharedMesh;
						if (mesh) totalVerts += mesh.vertexCount;
					}
				}

				CountOutput(c.GetRenderers());

				var vertsStr = FormatCount(totalVerts);

				// Row 1: Meshes
				var meshSaved = inputCount > outputMeshCount ? inputCount - outputMeshCount : 0;
				EditorGUILayout.BeginHorizontal();
				EditorGUILayout.LabelField("Meshes", EditorStyles.miniBoldLabel, GUILayout.Width(65));
				EditorGUILayout.LabelField($"{inputCount} \u2192 {outputMeshCount}  ({FormatCount(meshSaved)} saved)", EditorStyles.miniLabel);
				StatusBadge(statusLabel, statusColor);
				EditorGUILayout.EndHorizontal();

				// Row 2: Materials + vertices
				EditorGUILayout.BeginHorizontal();
				EditorGUILayout.LabelField("Output", EditorStyles.miniBoldLabel, GUILayout.Width(65));
				EditorGUILayout.LabelField($"{outputMaterials.Count} materials  |  {vertsStr} vertices", EditorStyles.miniLabel);
				EditorGUILayout.EndHorizontal();

				// Row 3: Extra info
				var hasExtra = c.IsLodReady || c is ChunkMeshCombiner;
				if (hasExtra) {
					EditorGUILayout.BeginHorizontal();
					EditorGUILayout.LabelField("", GUILayout.Width(65));
					var parts = new System.Collections.Generic.List<string>();
					if (c.IsLodReady) parts.Add("LOD active");
					if (c is ChunkMeshCombiner cmc3) {
						var dynCount = cmc3.updateQueue.UpdatesCount;
						parts.Add($"{dynCount} dynamic");
					}
					EditorGUILayout.LabelField(string.Join("  |  ", parts), EditorStyles.miniLabel);
					EditorGUILayout.EndHorizontal();
				}
			} else {
				FindCompatible(c, out var combCount, out var lodCount);
				var rendererTypes = (TargetRendererType)_RendererTypes.intValue;
				var hasMR = (rendererTypes & TargetRendererType.MeshRenderer) != 0;
				var hasSMR = (rendererTypes & TargetRendererType.SkinnerMeshRenderer) != 0;
				var typeStr = hasMR && hasSMR ? "MR + SMR" : hasMR ? "MR only" : hasSMR ? "SMR only" : "None";

				EditorGUILayout.BeginHorizontal();
				var editInfo = $"{combCount} combinables";
				var editTooltip = $"Combinables: {combCount}";
				if (lodCount > 0) {
					editInfo += $"  |  {lodCount} LOD";
					editTooltip += $"\nLOD Combinables: {lodCount}";
				}
				editInfo += $"  |  {typeStr}";
				editTooltip += $"\nRenderer Types: {typeStr}\nFrame Budget: {_MaxBuildTime.intValue}ms\nIndex Format: {(_IndexFormat.enumValueIndex == 0 ? "UInt16" : "UInt32")}";

				EditorGUILayout.LabelField(new GUIContent(editInfo, editTooltip), EditorStyles.miniLabel);
				StatusBadge(statusLabel, statusColor);
				EditorGUILayout.EndHorizontal();
			}

			EndSection();
		}

		private static string FormatCount(int count) {
			if (count >= 1000000) return $"{count / 1000000f:0.#}M";
			if (count >= 1000) return $"{count / 1000f:0.#}K";
			return count.ToString();
		}
	}
}
