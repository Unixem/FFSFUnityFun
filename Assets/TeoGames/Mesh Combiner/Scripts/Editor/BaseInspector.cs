using TeoGames.Mesh_Combiner.Scripts.Combine.Interfaces;
using UnityEditor;
using UnityEngine;

namespace TeoGames.Mesh_Combiner.Scripts.Editor {
	public abstract class BaseInspector : UnityEditor.Editor {
		protected static GUIStyle TabNormal;
		protected static GUIStyle TabSelected;
		protected static GUIStyle SectionBox;
		protected static GUIStyle StatusRight;
		protected static GUIStyle HeaderStyle;
		protected static GUIStyle MiniLabelCenter;
		protected static GUIStyle MiniLabelLeft;
		protected static GUIStyle MiniLabelWrap;

		protected static readonly Color AccentColor = new Color(0.2f, 0.7f, 0.9f);
		protected static readonly Color ColorGrey = new Color(0.6f, 0.6f, 0.6f);
		protected static readonly Color ColorYellow = new Color(0.9f, 0.8f, 0.2f);
		protected static readonly Color ColorGreen = new Color(0.3f, 0.85f, 0.4f);
		protected static readonly Color ColorRed = new Color(0.9f, 0.3f, 0.3f);

		protected static void InitStyles() {
			if (TabNormal != null) return;

			var boxBg = EditorGUIUtility.isProSkin
				? new Color(0.25f, 0.25f, 0.25f)
				: new Color(0.92f, 0.92f, 0.92f);
			var tabSelectedBg = new Texture2D(1, 1);
			tabSelectedBg.SetPixel(0, 0, boxBg);
			tabSelectedBg.Apply();

			TabNormal = new GUIStyle(EditorStyles.miniButton) {
				fontSize = 12,
				fixedHeight = 26,
				margin = new RectOffset(0, 4, 8, 0),
				padding = new RectOffset(12, 12, 4, 4),
				border = new RectOffset(4, 4, 4, 0),
			};

			TabSelected = new GUIStyle(TabNormal) {
				fontStyle = FontStyle.Bold,
				normal = {
					background = tabSelectedBg,
					scaledBackgrounds = new[] { tabSelectedBg },
					textColor = AccentColor,
				},
				hover = {
					background = tabSelectedBg,
					scaledBackgrounds = new[] { tabSelectedBg },
					textColor = AccentColor,
				},
			};

			HeaderStyle = new GUIStyle(EditorStyles.boldLabel) {
				fontSize = 13,
				normal = { textColor = AccentColor },
				margin = new RectOffset(0, 0, 8, 4),
			};

			SectionBox = new GUIStyle("HelpBox") {
				padding = new RectOffset(10, 10, 8, 8),
				margin = new RectOffset(0, 0, 0, 2),
			};

			StatusRight = new GUIStyle(EditorStyles.label) {
				alignment = TextAnchor.MiddleRight,
				fontStyle = FontStyle.Italic,
				wordWrap = false,
			};

			MiniLabelCenter = new GUIStyle(EditorStyles.miniLabel) {
				alignment = TextAnchor.MiddleCenter,
			};

			MiniLabelLeft = new GUIStyle(EditorStyles.miniLabel) {
				alignment = TextAnchor.MiddleLeft,
			};

			MiniLabelWrap = new GUIStyle(EditorStyles.miniLabel) {
				wordWrap = true,
			};
		}

		protected static bool DrawTab(string label, bool isSelected) {
			return GUILayout.Button(label, isSelected ? TabSelected : TabNormal, GUILayout.ExpandWidth(false));
		}

		protected static void BeginSection() {
			EditorGUILayout.BeginVertical(SectionBox);
		}

		protected static void EndSection() {
			EditorGUILayout.EndVertical();
		}

		protected static void StatusBadge(string label, Color color) {
			var prevColor = GUI.contentColor;
			GUI.contentColor = color;
			EditorGUILayout.LabelField($"\u25cf {label}", StatusRight, GUILayout.Width(90));
			GUI.contentColor = prevColor;
		}

		protected void DrawRenderOutput() {
			foreach (var t in targets) {
				if (t is ICombinerVisibilityTogglable comb) {
					var newVal = EditorGUILayout.Toggle(
						new GUIContent("Render Output", "When enabled, combined meshes are rendered and originals are hidden. Disable to show original meshes instead."),
						comb.IsVisible);
					if (newVal != comb.IsVisible) {
						comb.IsVisible = newVal;
						EditorUtility.SetDirty(t);
					}
				}
			}
		}

		protected static void SectionSeparator(string text) {
			EditorGUILayout.Space(6);
			var rect = EditorGUILayout.GetControlRect(false, 16);
			var lineY = rect.y + rect.height / 2;
			EditorGUI.DrawRect(new Rect(rect.x, lineY, rect.width, 1), new Color(0.5f, 0.5f, 0.5f, 0.3f));
			var content = new GUIContent(text);
			var textSize = EditorStyles.miniLabel.CalcSize(content);
			var textRect = new Rect(rect.center.x - textSize.x / 2 - 4, rect.y, textSize.x + 8, rect.height);
			var bgColor = EditorGUIUtility.isProSkin ? new Color(0.22f, 0.22f, 0.22f) : new Color(0.92f, 0.92f, 0.92f);
			EditorGUI.DrawRect(textRect, bgColor);
			GUI.Label(textRect, content, MiniLabelCenter);
		}

		public static bool Toggle(Object obj, string label, bool curVal) {
			var res = EditorGUILayout.Toggle(label, curVal);
			if (res != curVal) EditorUtility.SetDirty(obj);
			return res;
		}
	}
}
