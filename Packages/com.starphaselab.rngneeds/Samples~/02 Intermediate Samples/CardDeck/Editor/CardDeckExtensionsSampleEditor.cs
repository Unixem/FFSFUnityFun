using System;
using UnityEditor;
using UnityEngine;

namespace RNGNeeds.Samples.CardDeck.Editor
{
    [CustomEditor(typeof(CardDeckExtensionsSample))]
    public class CardDeckExtensionsSampleEditor : UnityEditor.Editor
    {
        private const string NotesIconPath = "Packages/com.starphaselab.rngneeds/Editor/Assets/RNGNeedsArrowShape.png";

        private CardDeckExtensionsSample m_Sample;
        private SerializedProperty p_StartingDeckRecipe;
        private SerializedProperty p_OpeningHandSize;
        private SerializedProperty p_CardsToDraw;
        private SerializedProperty p_CardsToPeek;
        private SerializedProperty p_SelectedHandIndex;
        private SerializedProperty p_CutIndex;
        private SerializedProperty p_ShuffleOnReset;
        private SerializedProperty p_ReshuffleDiscardWhenDrawPileEmpty;

        private const float ZoneHeaderHeight = 22f;
        private const float ZoneRowHeight = 22f;
        private const float HandRowHeight = 24f;
        private const float ZoneToolbarHeight = 22f;
        private const float EmptyZoneHeight = 18f;
        private const float ZoneVerticalSpacing = 6f;
        private const float ZonePaddingVertical = 16f;
        private const float BadgeColumnWidth = 66f;
        private const float PlayButtonWidth = 40f;
        private const float ActionButtonSpacing = 4f;
        private const float IndexColumnWidth = 18f;
        private const float RowOuterPadding = 8f;

        private readonly Color separatorColor = new Color(.5f, .6f, .7f);
        private readonly Color headerColorDark = new Color(.23f, .27f, .31f, 1f);
        private readonly Color headerColorLight = new Color(.68f, .74f, .79f, 1f);
        private GUIStyle m_BoxStyle;
        private GUIStyle m_HeaderStyle;
        private GUIStyle m_CardStyle;
        private GUIStyle m_BadgeStyle;
        private GUIStyle m_CountStyle;
        private GUIStyle m_SectionTitleStyle;
        private GUIStyle m_HintStyle;
        private GUIStyle m_NotesBoxStyle;
        private GUIStyle m_NotesTextStyle;
        private GUIStyle m_NotesIconStyle;
        private Texture2D m_LightSkinBackgroundTexture;
        private Texture2D m_NotesIcon;

        private void OnEnable()
        {
            m_Sample = (CardDeckExtensionsSample)serializedObject.targetObject;
            p_StartingDeckRecipe = serializedObject.FindProperty("startingDeckRecipe");
            p_OpeningHandSize = serializedObject.FindProperty("openingHandSize");
            p_CardsToDraw = serializedObject.FindProperty("cardsToDraw");
            p_CardsToPeek = serializedObject.FindProperty("cardsToPeek");
            p_SelectedHandIndex = serializedObject.FindProperty("selectedHandIndex");
            p_CutIndex = serializedObject.FindProperty("cutIndex");
            p_ShuffleOnReset = serializedObject.FindProperty("shuffleOnReset");
            p_ReshuffleDiscardWhenDrawPileEmpty = serializedObject.FindProperty("reshuffleDiscardWhenDrawPileEmpty");
        }

        private void OnDisable()
        {
            if (m_LightSkinBackgroundTexture == null) return;
            DestroyImmediate(m_LightSkinBackgroundTexture);
            m_LightSkinBackgroundTexture = null;
        }

        public override void OnInspectorGUI()
        {
            if (EnsureStyles() == false) return;

            serializedObject.Update();
            DrawConfiguration();
            serializedObject.ApplyModifiedProperties();

            DrawSeparator();
            DrawTeachingGuide();
            DrawSeparator();
            DrawZones();
            DrawSeparator();
            DrawStatus();
        }

        private void DrawConfiguration()
        {
            DrawConfigSection(null, null, () =>
            {
                DrawNotesBox("<b>Starting deck</b>\nAuthor a ProbabilityList recipe here, then reset to rebuild the physical draw pile. Units become card copies.");
                GUILayout.Space(4f);

                EditorGUI.indentLevel++;
                EditorGUILayout.PropertyField(p_StartingDeckRecipe, GUIContent.none, true);
                EditorGUI.indentLevel--;
                GUILayout.Space(4f);

                if (GUILayout.Button("Reset Sample", GUILayout.Height(24f)))
                {
                    serializedObject.ApplyModifiedProperties();
                    ExecuteAction("Reset Card Deck Extensions Sample", m_Sample.ResetSample);
                    GUIUtility.ExitGUI();
                }
            });

            DrawConfigSection("Deck Setup", null, () =>
            {
                DrawPropertyRow(p_OpeningHandSize, "Opening Hand Size", "How many cards to draw when using Draw Opening Hand.");
                DrawPropertyRow(p_CutIndex, "Cut Index", "Where the draw pile is cut when using Cut Draw Pile.");
                DrawPropertyRow(p_ShuffleOnReset, "Shuffle On Reset", "Shuffle the freshly built draw pile after reset.");
            }, true);

            DrawConfigSection("Turn & Flow", null, () =>
            {
                DrawPropertyRow(p_CardsToDraw, "Cards To Draw", "How many cards Draw Card will take from the top of the draw pile.");
                DrawPropertyRow(p_CardsToPeek, "Cards To Peek", "How many top cards Peek Top Cards will preview.");
                DrawPropertyRow(p_ReshuffleDiscardWhenDrawPileEmpty, "Auto Recycle Discard", "When enabled, the discard pile is shuffled back into the draw pile automatically when needed.");
            }, true);
        }

        private void DrawTeachingGuide()
        {
            DrawNotesBox("<b>Card flow</b>\nDraw from the draw pile into your hand, play to the table, move used cards to discard, then reshuffle discard back into the draw pile when needed.");
        }

        private void DrawStatus()
        {
            if (string.IsNullOrWhiteSpace(m_Sample.lastAction)) return;
            EditorGUILayout.HelpBox(m_Sample.lastAction, MessageType.Info);
        }

        private void DrawZones()
        {
            var handCount = m_Sample.hand?.ItemCount ?? 0;
            var tableCount = m_Sample.tablePile?.ItemCount ?? 0;
            var drawPileCount = m_Sample.drawPile?.ItemCount ?? 0;
            var discardCount = m_Sample.discardPile?.ItemCount ?? 0;

            var topRowHeight = Mathf.Max(GetZonePanelHeight(handCount, HandRowHeight, true), GetZonePanelHeight(tableCount, ZoneRowHeight, true));
            var bottomRowHeight = Mathf.Max(GetZonePanelHeight(drawPileCount, ZoneRowHeight, true), GetZonePanelHeight(discardCount, ZoneRowHeight, true));
            var verticalGapHeight = ZoneVerticalSpacing + 22f;
            const float middleArrowColumnWidth = 24f;
            const float middleArrowTopSpacer = 28f;
            const float sideSpacing = 6f;
            var availableWidth = EditorGUIUtility.currentViewWidth - 40f;
            var columnWidth = Mathf.Max(0f, (availableWidth - middleArrowColumnWidth - (sideSpacing * 2f)) * 0.5f);

            EditorGUILayout.BeginHorizontal();

            DrawZoneColumn(
                () => DrawHandZone(topRowHeight),
                () => DrawZone("Draw Pile", m_Sample.drawPile, -1, bottomRowHeight, DrawDrawPileToolbar),
                (rect) => DrawVerticalFlowArrow(rect, true),
                verticalGapHeight,
                columnWidth);

            GUILayout.Space(sideSpacing);

            DrawMiddleFlowColumn(topRowHeight, bottomRowHeight, verticalGapHeight, middleArrowTopSpacer, middleArrowColumnWidth);

            GUILayout.Space(sideSpacing);

            DrawZoneColumn(
                () => DrawZone("Table", m_Sample.tablePile, -1, topRowHeight, DrawTableToolbar),
                () => DrawZone("Discard", m_Sample.discardPile, -1, bottomRowHeight, DrawDiscardToolbar),
                (rect) => DrawVerticalFlowArrow(rect, false),
                verticalGapHeight,
                columnWidth);

            EditorGUILayout.EndHorizontal();
        }

        private void DrawMiddleFlowColumn(float topRowHeight, float bottomRowHeight, float gapHeight, float topSpacer, float width)
        {
            EditorGUILayout.BeginVertical(GUILayout.Width(width), GUILayout.ExpandHeight(true));
            GUILayout.Space(topSpacer + (topRowHeight * 0.5f) - 12f);
            DrawHorizontalFlowArrow(width, true);
            GUILayout.Space((topRowHeight * 0.5f) + gapHeight + (bottomRowHeight * 0.5f) - 24f);
            DrawHorizontalFlowArrow(width, false);
            EditorGUILayout.EndVertical();
        }

        private void DrawZoneColumn(Action topZone, Action bottomZone, Action<Rect> betweenZoneContent, float betweenHeight, float fixedWidth)
        {
            EditorGUILayout.BeginVertical(
                GUILayout.MinWidth(fixedWidth),
                GUILayout.MaxWidth(fixedWidth),
                GUILayout.ExpandWidth(false));

            topZone?.Invoke();
            DrawZoneGap(betweenHeight, betweenZoneContent);
            bottomZone?.Invoke();
            EditorGUILayout.EndVertical();
        }

        private void DrawZoneGap(float height, Action<Rect> content)
        {
            if (height <= 0f || content == null) return;
            var rect = EditorGUILayout.GetControlRect(false, height);
            content.Invoke(rect);
        }

        private float GetZonePanelHeight(int itemCount, float rowHeight, bool hasToolbar)
        {
            var bodyHeight = itemCount > 0 ? itemCount * rowHeight : EmptyZoneHeight;
            var toolbarHeight = hasToolbar ? ZoneToolbarHeight + 4f : 0f;
            return ZonePaddingVertical + ZoneHeaderHeight + toolbarHeight + bodyHeight;
        }

        private void DrawHandZone(float minHeight)
        {
            var count = m_Sample.hand?.ItemCount ?? 0;
            EditorGUILayout.BeginVertical(m_BoxStyle, GUILayout.MinHeight(minHeight));
            DrawZoneHeader("Hand", count);
            DrawHandToolbar(showDrawActions: false);

            if (count < 1)
            {
                GUILayout.FlexibleSpace();
                DrawHandDrawToolbar();
                EditorGUILayout.EndVertical();
                return;
            }

            PendingHandAction? pendingAction = null;
            for (var i = 0; i < count; i++)
            {
                if (m_Sample.hand.TryGetProbabilityItem(i, out var item) == false) continue;
                pendingAction = DrawHandCardRow(item, i, m_Sample.selectedHandIndex, count) ?? pendingAction;
            }

            GUILayout.Space(6f);
            DrawHandDrawToolbar();
            EditorGUILayout.EndVertical();

            if (pendingAction.HasValue == false) return;

            var action = pendingAction.Value;
            m_Sample.selectedHandIndex = action.Index;
            p_SelectedHandIndex.intValue = action.Index;
            GUI.changed = true;

            switch (action.Type)
            {
                case HandActionType.Play:
                    ExecuteAction($"Play Hand Card {action.Index}", () => m_Sample.PlayCardFromHand(action.Index));
                    break;
            }

            GUIUtility.ExitGUI();
        }

        private void DrawHandToolbar(bool showDrawActions)
        {
            var hasAvailableDrawSource = (m_Sample.drawPile != null && m_Sample.drawPile.ItemCount > 0) ||
                                         (m_Sample.discardPile != null && m_Sample.discardPile.ItemCount > 0);
            var hasHandCards = m_Sample.hand != null && m_Sample.hand.ItemCount > 0;

            if (showDrawActions)
            {
                DrawZoneToolbar(
                    new ButtonDefinition("Draw Opening Hand", () => ExecuteAction("Draw Opening Hand", m_Sample.DrawOpeningHand), hasAvailableDrawSource),
                    new ButtonDefinition("Draw Card", () => ExecuteAction("Draw Card", m_Sample.DrawCards), hasAvailableDrawSource),
                    new ButtonDefinition("Discard Card", () => ExecuteAction("Discard Selected Hand Card", m_Sample.DiscardSelectedHandCard), hasHandCards),
                    new ButtonDefinition("Discard Hand", () => ExecuteAction("Discard Hand", m_Sample.DiscardHand), hasHandCards));
                return;
            }

            DrawZoneToolbar(
                new ButtonDefinition("Discard Card", () => ExecuteAction("Discard Selected Hand Card", m_Sample.DiscardSelectedHandCard), hasHandCards),
                new ButtonDefinition("Discard Hand", () => ExecuteAction("Discard Hand", m_Sample.DiscardHand), hasHandCards));
        }

        private void DrawHandDrawToolbar()
        {
            var hasAvailableDrawSource = (m_Sample.drawPile != null && m_Sample.drawPile.ItemCount > 0) ||
                                         (m_Sample.discardPile != null && m_Sample.discardPile.ItemCount > 0);

            DrawZoneToolbar(
                new ButtonDefinition("Draw Opening Hand", () => ExecuteAction("Draw Opening Hand", m_Sample.DrawOpeningHand), hasAvailableDrawSource),
                new ButtonDefinition("Draw Card", () => ExecuteAction("Draw Card", m_Sample.DrawCards), hasAvailableDrawSource));
        }

        private void DrawDrawPileToolbar()
        {
            DrawZoneToolbar(
                new ButtonDefinition("Shuffle", () => ExecuteAction("Shuffle Draw Pile", m_Sample.ShuffleDrawPile), m_Sample.drawPile != null && m_Sample.drawPile.ItemCount > 1),
                new ButtonDefinition("Peek Top", () => ExecuteAction("Peek Top Cards", m_Sample.PeekTopCards), m_Sample.drawPile != null && m_Sample.drawPile.ItemCount > 0),
                new ButtonDefinition("Cut", () => ExecuteAction("Cut Draw Pile", m_Sample.CutDrawPile), m_Sample.drawPile != null && m_Sample.drawPile.ItemCount > 1));
        }

        private void DrawTableToolbar()
        {
            var hasTableCards = m_Sample.tablePile != null && m_Sample.tablePile.ItemCount > 0;
            DrawZoneToolbar(
                new ButtonDefinition("Discard Top Card", () => ExecuteAction("Discard Top Table Card", m_Sample.DiscardTopTableCard), hasTableCards),
                new ButtonDefinition("Discard Table", () => ExecuteAction("Discard Table", m_Sample.DiscardTable), hasTableCards));
        }

        private void DrawDiscardToolbar()
        {
            DrawZoneToolbar(
                new ButtonDefinition("Reshuffle Discard", () => ExecuteAction("Reshuffle Discard", m_Sample.RecycleDiscardIntoDrawPile), m_Sample.discardPile != null && m_Sample.discardPile.ItemCount > 0));
        }

        private void DrawZoneToolbar(params ButtonDefinition[] buttons)
        {
            if (buttons == null || buttons.Length < 1) return;

            var buttonRect = EditorGUILayout.GetControlRect(false, ZoneToolbarHeight);
            var spacing = 4f;
            var buttonWidth = (buttonRect.width - (spacing * (buttons.Length - 1))) / buttons.Length;
            var x = buttonRect.x;

            for (var i = 0; i < buttons.Length; i++)
            {
                var button = buttons[i];
                var rect = new Rect(x, buttonRect.y, buttonWidth, buttonRect.height);

                EditorGUI.BeginDisabledGroup(button.Enabled == false);
                if (GUI.Button(rect, button.Label)) button.Action?.Invoke();
                EditorGUI.EndDisabledGroup();

                x += buttonWidth + spacing;
            }

            GUILayout.Space(4f);
        }

        private void DrawZone(string title, ProbabilityList<Card> zone, int highlightedIndex = -1, float minHeight = 0f, Action toolbarDrawer = null)
        {
            var count = zone?.ItemCount ?? 0;
            EditorGUILayout.BeginVertical(m_BoxStyle, GUILayout.MinHeight(minHeight));
            DrawZoneHeader(title, count);
            toolbarDrawer?.Invoke();

            if (count < 1)
            {
                var emptyRect = EditorGUILayout.GetControlRect(false, EditorGUIUtility.singleLineHeight);
                GUI.Label(emptyRect, "Empty", EditorStyles.miniLabel);
                EditorGUILayout.EndVertical();
                return;
            }

            for (var i = 0; i < count; i++)
            {
                if (zone.TryGetProbabilityItem(i, out var item) == false) continue;
                DrawCardRow(item, i, highlightedIndex, count);
            }

            EditorGUILayout.EndVertical();
        }

        private void DrawZoneHeader(string title, int count)
        {
            var controlRect = EditorGUILayout.GetControlRect(false, ZoneHeaderHeight);
            EditorGUI.DrawRect(controlRect, EditorGUIUtility.isProSkin ? headerColorDark : headerColorLight);
            GUI.Label(new Rect(controlRect.x + 8f, controlRect.y + 2f, controlRect.width - 16f, controlRect.height - 4f), $"{title} ({count})", m_HeaderStyle);
        }

        private void DrawCardRow(ProbabilityItem<Card> item, int index, int highlightedIndex, int itemCount)
        {
            var card = item.Value;
            var color = card == null ? Color.magenta : card.ItemColor;
            var rowRect = EditorGUILayout.GetControlRect(false, ZoneRowHeight);
            if (index == highlightedIndex)
            {
                var highlightColor = EditorGUIUtility.isProSkin ? new Color(.2f, .28f, .38f, 1f) : new Color(.73f, .82f, .9f, 1f);
                EditorGUI.DrawRect(rowRect, highlightColor);
            }

            m_CardStyle.normal.textColor = color;
            var badge = GetBadge(index, itemCount);
            var cardName = card == null ? "Missing Card" : card.name;

            var badgeRect = new Rect(rowRect.x + RowOuterPadding, rowRect.y + 2f, BadgeColumnWidth, rowRect.height - 4f);
            var indexRect = new Rect(rowRect.xMax - RowOuterPadding - IndexColumnWidth, rowRect.y + 2f, IndexColumnWidth, rowRect.height - 4f);
            var nameRect = new Rect(badgeRect.xMax + 4f, rowRect.y + 2f, indexRect.x - badgeRect.xMax - 8f, rowRect.height - 4f);

            GUI.Label(badgeRect, badge, m_BadgeStyle);
            GUI.Label(nameRect, cardName, m_CardStyle);
            GUI.Label(indexRect, index.ToString(), m_CountStyle);
        }

        private PendingHandAction? DrawHandCardRow(ProbabilityItem<Card> item, int index, int highlightedIndex, int itemCount)
        {
            var card = item.Value;
            var color = card == null ? Color.magenta : card.ItemColor;
            var rowRect = EditorGUILayout.GetControlRect(false, HandRowHeight);
            if (index == highlightedIndex)
            {
                var highlightColor = EditorGUIUtility.isProSkin ? new Color(.2f, .28f, .38f, 1f) : new Color(.73f, .82f, .9f, 1f);
                EditorGUI.DrawRect(rowRect, highlightColor);
            }

            m_CardStyle.normal.textColor = color;
            var badge = GetBadge(index, itemCount);
            var cardName = card == null ? "Missing Card" : card.name;

            var indexRect = new Rect(rowRect.xMax - RowOuterPadding - IndexColumnWidth, rowRect.y + 2f, IndexColumnWidth, rowRect.height - 4f);
            var playRect = new Rect(indexRect.x - ActionButtonSpacing - PlayButtonWidth, rowRect.y + 1f, PlayButtonWidth, rowRect.height - 2f);
            var badgeRect = new Rect(rowRect.x + RowOuterPadding, rowRect.y + 2f, BadgeColumnWidth, rowRect.height - 4f);
            var nameRect = new Rect(badgeRect.xMax + 4f, rowRect.y + 2f, playRect.x - badgeRect.xMax - 8f, rowRect.height - 4f);
            var selectRect = new Rect(rowRect.x, rowRect.y, playRect.x - rowRect.x - 4f, rowRect.height);

            HandleHandRowSelection(selectRect, index);

            GUI.Label(badgeRect, badge, m_BadgeStyle);
            GUI.Label(nameRect, cardName, m_CardStyle);
            GUI.Label(indexRect, index.ToString(), m_CountStyle);

            if (GUI.Button(playRect, "Play")) return new PendingHandAction(index, HandActionType.Play);
            return null;
        }

        private void HandleHandRowSelection(Rect selectRect, int index)
        {
            EditorGUIUtility.AddCursorRect(selectRect, MouseCursor.Link);
            var currentEvent = Event.current;
            if (currentEvent.type != EventType.MouseDown || currentEvent.button != 0 || selectRect.Contains(currentEvent.mousePosition) == false)
                return;

            m_Sample.selectedHandIndex = index;
            p_SelectedHandIndex.intValue = index;
            GUI.changed = true;
            Repaint();
            currentEvent.Use();
        }

        private void DrawVerticalFlowArrow(Rect rect, bool pointsUp)
        {
            var arrowStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                alignment = TextAnchor.MiddleCenter,
                fontSize = 24,
                normal =
                {
                    textColor = new Color(0.95f, 0.78f, 0.26f, 0.98f)
                }
            };

            GUI.Label(rect, pointsUp ? "↑" : "↓", arrowStyle);
        }

        private void DrawHorizontalFlowArrow(float width, bool pointsRight)
        {
            var rect = EditorGUILayout.GetControlRect(false, 20f, GUILayout.Width(width));
            var arrowStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                alignment = TextAnchor.MiddleCenter,
                fontSize = 24,
                normal =
                {
                    textColor = new Color(0.95f, 0.78f, 0.26f, 0.98f)
                }
            };

            GUI.Label(rect, pointsRight ? "→" : "←", arrowStyle);
        }

        private void DrawConfigSection(string title, string subtitle, Action content, bool expandWidth = true)
        {
            EditorGUILayout.BeginVertical(m_BoxStyle, expandWidth ? GUILayout.ExpandWidth(true) : GUILayout.ExpandWidth(false));

            if (string.IsNullOrWhiteSpace(title) == false)
            {
                EditorGUILayout.LabelField(title, m_SectionTitleStyle);
            }

            if (string.IsNullOrWhiteSpace(subtitle) == false)
            {
                if (string.IsNullOrWhiteSpace(title) == false)
                {
                    GUILayout.Space(1f);
                }
                EditorGUILayout.LabelField(subtitle, m_HintStyle);
            }

            if (string.IsNullOrWhiteSpace(title) == false || string.IsNullOrWhiteSpace(subtitle) == false)
            {
                GUILayout.Space(4f);
            }

            content?.Invoke();
            EditorGUILayout.EndVertical();
        }

        private void DrawPropertyRow(SerializedProperty property, string label, string tooltip = null)
        {
            EditorGUILayout.PropertyField(property, new GUIContent(label, tooltip), true);
        }


        private void DrawNotesBox(string text)
        {
            EditorGUILayout.BeginHorizontal(m_NotesBoxStyle);
            if (m_NotesIcon != null)
            {
                GUILayout.Label(m_NotesIcon, m_NotesIconStyle, GUILayout.Width(28f), GUILayout.Height(28f));
            }
            else
            {
                GUILayout.Space(4f);
            }

            var normalizedText = text.Replace("<br/>", "\n").Replace("<br>", "\n");
            GUILayout.Label(normalizedText, m_NotesTextStyle, GUILayout.ExpandWidth(true));
            EditorGUILayout.EndHorizontal();
        }

        private string GetBadge(int index, int itemCount)
        {
            if (itemCount == 1) return "TOP";
            if (index == 0) return "TOP";
            if (index == itemCount - 1) return "BOT";
            return string.Empty;
        }

        private void ExecuteAction(string undoName, Action action)
        {
            Undo.RecordObject(m_Sample, undoName);
            action?.Invoke();
            EditorUtility.SetDirty(m_Sample);
            AssetDatabase.SaveAssets();
            GUI.changed = true;
            Repaint();
        }

        private void ExecuteAction<T>(string undoName, Func<T> action)
        {
            Undo.RecordObject(m_Sample, undoName);
            action?.Invoke();
            EditorUtility.SetDirty(m_Sample);
            AssetDatabase.SaveAssets();
            GUI.changed = true;
            Repaint();
        }

        private void DrawSeparator()
        {
            var controlRect = EditorGUILayout.GetControlRect(true, 6f);
            GUI.BeginGroup(controlRect);
            EditorGUI.DrawRect(new Rect(0f, 2f, controlRect.xMax - 12f, 1f), separatorColor);
            GUI.EndGroup();
        }

        private bool EnsureStyles()
        {
            if (m_NotesIcon == null)
            {
                m_NotesIcon = AssetDatabase.LoadAssetAtPath<Texture2D>(NotesIconPath);
            }

            if (m_BoxStyle != null && m_HeaderStyle != null && m_CardStyle != null && m_BadgeStyle != null && m_CountStyle != null && m_SectionTitleStyle != null && m_HintStyle != null && m_NotesBoxStyle != null && m_NotesTextStyle != null && m_NotesIconStyle != null)
                return true;

            if (EditorStyles.label == null || EditorStyles.helpBox == null || EditorStyles.boldLabel == null || EditorStyles.miniBoldLabel == null || EditorStyles.miniLabel == null || EditorStyles.wordWrappedMiniLabel == null)
                return false;

            BuildStyles();
            return m_BoxStyle != null;
        }

        private void BuildStyles()
        {
            m_BoxStyle = new GUIStyle(EditorStyles.helpBox)
            {
                padding = new RectOffset(8, 8, 8, 8),
                margin = new RectOffset(0, 0, 0, 6)
            };

            m_HeaderStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                alignment = TextAnchor.MiddleLeft,
                normal = { textColor = Color.white }
            };

            m_SectionTitleStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                alignment = TextAnchor.MiddleLeft,
                fontSize = 11
            };

            m_CardStyle = new GUIStyle(EditorStyles.label)
            {
                padding = new RectOffset(6, 0, 0, 0),
                alignment = TextAnchor.MiddleLeft
            };

            m_BadgeStyle = new GUIStyle(EditorStyles.miniBoldLabel)
            {
                alignment = TextAnchor.MiddleCenter,
                normal = { textColor = Color.white }
            };

            m_CountStyle = new GUIStyle(EditorStyles.miniLabel)
            {
                alignment = TextAnchor.MiddleRight
            };

            m_HintStyle = new GUIStyle(EditorStyles.wordWrappedMiniLabel)
            {
                richText = false
            };

            m_NotesBoxStyle = new GUIStyle(EditorStyles.helpBox)
            {
                padding = new RectOffset(10, 10, 8, 8),
                margin = new RectOffset(4, 4, 4, 6)
            };

            m_NotesTextStyle = new GUIStyle(EditorStyles.wordWrappedLabel)
            {
                richText = true,
                fontSize = 12,
                alignment = TextAnchor.UpperLeft,
                wordWrap = true
            };

            m_NotesIconStyle = new GUIStyle
            {
                alignment = TextAnchor.UpperCenter,
                margin = new RectOffset(0, 14, 2, 0),
                padding = new RectOffset(0, 0, 0, 0)
            };

            m_NotesTextStyle.normal.textColor = EditorGUIUtility.isProSkin
                ? new Color(0.9f, 0.93f, 0.97f)
                : new Color(0.16f, 0.2f, 0.25f);

            m_NotesBoxStyle.normal.textColor = GUI.contentColor;

            if (EditorGUIUtility.isProSkin) return;

            if (m_LightSkinBackgroundTexture != null)
                DestroyImmediate(m_LightSkinBackgroundTexture);

            m_LightSkinBackgroundTexture = new Texture2D(1, 1)
            {
                hideFlags = HideFlags.HideAndDontSave
            };
            m_LightSkinBackgroundTexture.SetPixel(0, 0, new Color(.92f, .94f, .96f, 1f));
            m_LightSkinBackgroundTexture.Apply();
            m_BoxStyle.normal.background = m_LightSkinBackgroundTexture;
        }

        private readonly struct ButtonDefinition
        {
            public readonly string Label;
            public readonly Action Action;
            public readonly bool Enabled;

            public ButtonDefinition(string label, Action action, bool enabled = true)
            {
                Label = label;
                Action = action;
                Enabled = enabled;
            }
        }

        private enum HandActionType
        {
            Play
        }

        private readonly struct PendingHandAction
        {
            public readonly int Index;
            public readonly HandActionType Type;

            public PendingHandAction(int index, HandActionType type)
            {
                Index = index;
                Type = type;
            }
        }
    }
}
