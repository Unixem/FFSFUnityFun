using System;
using UnityEditor;
using UnityEditor.Callbacks;
using UnityEngine;

namespace RNGNeeds.Samples.CardBattle.Editor
{
    public class CardBattleWindow : EditorWindow
    {
        private const float CardTileWidth = 123f;
        private const float CardTileHeight = 152f;
        private const float MinionTileWidth = 126f;
        private const float MinionTileHeight = 102f;
        private const float SidebarWidth = 280f;
        private const float HeroPanelWidth = 236f;
        private const float BoardLaneMinHeight = 136f;

        private CardBattleWindowSample m_Sample;
        private Vector2 m_TopHandScroll;
        private Vector2 m_BottomHandScroll;
        private Vector2 m_HistoryScroll;
        private GUIStyle m_TitleStyle;
        private GUIStyle m_SubtitleStyle;
        private GUIStyle m_HeroStyle;
        private GUIStyle m_HeroMutedStyle;
        private GUIStyle m_BoxStyle;
        private GUIStyle m_ZoneStyle;
        private GUIStyle m_ActiveZoneStyle;
        private GUIStyle m_BoardStyle;
        private GUIStyle m_BoardLaneStyle;
        private GUIStyle m_HeroCardStyle;
        private GUIStyle m_ActiveHeroCardStyle;
        private GUIStyle m_PlayableMinionCardStyle;
        private GUIStyle m_PlayableSpellCardStyle;
        private GUIStyle m_CardTitleStyle;
        private GUIStyle m_CardTextStyle;
        private GUIStyle m_CardMetaStyle;
        private GUIStyle m_CardTypeTagStyle;
        private GUIStyle m_StatStyle;
        private GUIStyle m_ChipStyle;
        private GUIStyle m_InfoChipStyle;
        private GUIStyle m_DeckChipStyle;
        private GUIStyle m_LogStyle;
        private GUIStyle m_LogActorStyle;
        private GUIStyle m_SelectionStyle;
        private GUIStyle m_SectionLabelStyle;
        private Texture2D m_DefaultBoxTexture;
        private Texture2D m_ZoneTexture;
        private Texture2D m_ActiveZoneTexture;
        private Texture2D m_BoardTexture;
        private Texture2D m_BoardLaneTexture;
        private Texture2D m_HeroCardTexture;
        private Texture2D m_ActiveHeroCardTexture;
        private Texture2D m_PlayableMinionCardTexture;
        private Texture2D m_PlayableSpellCardTexture;
        private Texture2D m_InfoChipTexture;
        private Texture2D m_DeckChipTexture;
        private int m_SelectedAttackerIndex = -1;
        private bool m_StylesBuiltForProSkin;

        public static void ShowWindow()
        {
            ShowWindow(null);
        }

        public static void ShowWindow(CardBattleWindowSample sample)
        {
            var window = GetWindow<CardBattleWindow>("Card Battle");
            window.minSize = new Vector2(1100f, 760f);
            if (sample != null)
            {
                window.m_Sample = sample;
                Selection.activeObject = sample;
            }
            window.Show();
        }

        private void OnEnable()
        {
            titleContent = new GUIContent("Card Battle");
            ResetStyles();
            if (Selection.activeObject is CardBattleWindowSample selectedSample) m_Sample = selectedSample;
        }

        private void OnDisable()
        {
            ResetStyles();
        }

        private void OnSelectionChange()
        {
            if (Selection.activeObject is CardBattleWindowSample selectedSample)
            {
                m_Sample = selectedSample;
                Repaint();
            }
        }

        private void OnGUI()
        {
            EnsureStyles();
            DrawToolbar();
            GUILayout.Space(6f);

            if (m_Sample == null)
            {
                DrawEmptyState();
                return;
            }

            EnsureSelectionValidity();
            DrawStatusBar();
            GUILayout.Space(6f);

            EditorGUILayout.BeginHorizontal();
            DrawBattlefield();
            GUILayout.Space(8f);
            DrawSidebar();
            EditorGUILayout.EndHorizontal();
        }

        private void DrawToolbar()
        {
            EditorGUILayout.BeginHorizontal(EditorStyles.toolbar);
            var nextSample = (CardBattleWindowSample)EditorGUILayout.ObjectField(m_Sample, typeof(CardBattleWindowSample), false, GUILayout.Width(280f));
            if (nextSample != m_Sample)
            {
                m_Sample = nextSample;
                ClearSelectedAttacker();
            }

            if (GUILayout.Button("Create Sample Asset", EditorStyles.toolbarButton, GUILayout.Width(128f)))
            {
                CreateSampleAsset();
            }

            EditorGUI.BeginDisabledGroup(m_Sample == null);
            if (GUILayout.Button("Reset Duel", EditorStyles.toolbarButton, GUILayout.Width(84f)))
            {
                RunMutation("Reset Card Battle Sample", () =>
                {
                    m_Sample.ResetSample();
                    ClearSelectedAttacker();
                    return true;
                });
            }

            if (GUILayout.Button("Ping Asset", EditorStyles.toolbarButton, GUILayout.Width(74f)))
            {
                EditorGUIUtility.PingObject(m_Sample);
                Selection.activeObject = m_Sample;
            }
            EditorGUI.EndDisabledGroup();

            GUILayout.FlexibleSpace();
            GUILayout.Label("Two-player card battle", EditorStyles.miniLabel);
            EditorGUILayout.EndHorizontal();
        }

        private void DrawEmptyState()
        {
            EditorGUILayout.BeginVertical(m_BoxStyle);
            GUILayout.Space(12f);
            EditorGUILayout.LabelField("Card Battle", m_TitleStyle);
            EditorGUILayout.LabelField("Open or create a Card Battle asset to start a duel.", m_SubtitleStyle);
            GUILayout.Space(12f);
            EditorGUILayout.HelpBox("Create a Card Battle asset, then use Reset Duel to begin.", MessageType.Info);
            GUILayout.Space(8f);
            if (GUILayout.Button("Create Sample Asset", GUILayout.Height(28f))) CreateSampleAsset();
            EditorGUILayout.EndVertical();
        }

        private void DrawStatusBar()
        {
            using (new EditorGUILayout.VerticalScope(m_BoxStyle))
            {
                EditorGUILayout.LabelField(m_Sample.sampleTitle, m_TitleStyle);
                if (string.IsNullOrWhiteSpace(m_Sample.sampleSummary) == false)
                {
                    EditorGUILayout.LabelField(m_Sample.sampleSummary, m_SubtitleStyle);
                }

                GUILayout.Space(4f);
                EditorGUILayout.BeginHorizontal();
                GUILayout.Label($"Turn {m_Sample.turnNumber}", m_ChipStyle, GUILayout.Width(72f));
                GUILayout.Label(m_Sample.gameOver ? "Duel Over" : $"Active: {m_Sample.GetCurrentPlayer().displayName}", m_ChipStyle, GUILayout.Width(170f));
                GUILayout.Label($"Board Limit: {m_Sample.boardLimit}", m_ChipStyle, GUILayout.Width(96f));
                if (m_Sample.gameOver == false && HasSelectedAttacker())
                {
                    GUILayout.Label($"Attacker: {GetSelectedAttackerName()}", m_ChipStyle, GUILayout.Width(176f));
                }
                if (m_Sample.gameOver)
                {
                    GUILayout.Label($"Winner: {m_Sample.winnerName}", m_ChipStyle, GUILayout.Width(160f));
                }
                GUILayout.FlexibleSpace();
                EditorGUILayout.EndHorizontal();

                if (string.IsNullOrWhiteSpace(m_Sample.lastAction) == false)
                {
                    GUILayout.Space(4f);
                    EditorGUILayout.HelpBox(m_Sample.lastAction, MessageType.None);
                }
            }
        }

        private void DrawBattlefield()
        {
            using (new EditorGUILayout.VerticalScope(GUILayout.ExpandWidth(true)))
            {
                DrawHandSection(1, true);
                GUILayout.Space(8f);
                DrawBoardArena();
                GUILayout.Space(8f);
                DrawHandSection(0, false);
            }
        }

        private void DrawHandSection(int playerIndex, bool isTopHand)
        {
            var player = m_Sample.GetPlayer(playerIndex);
            var isCurrent = m_Sample.currentPlayerIndex == playerIndex;
            var zoneStyle = isCurrent ? m_ActiveZoneStyle : m_ZoneStyle;
            var handWidth = GetCenteredHandWidth(player.hand != null ? player.hand.ItemCount : 0);
            var scroll = isTopHand ? m_TopHandScroll : m_BottomHandScroll;

            EditorGUILayout.BeginHorizontal();
            GUILayout.FlexibleSpace();
            using (new EditorGUILayout.HorizontalScope(GUILayout.Width(handWidth + HeroPanelWidth + 10f)))
            {
                if (isTopHand == false)
                {
                    DrawHandHeroCard(playerIndex);
                    GUILayout.Space(8f);
                }

                using (new EditorGUILayout.VerticalScope(zoneStyle, GUILayout.Width(handWidth)))
                {
                    EditorGUILayout.BeginHorizontal();
                    GUILayout.FlexibleSpace();
                    GUILayout.Label(isTopHand ? "Top Player Hand" : "Bottom Player Hand", m_SectionLabelStyle);
                    GUILayout.FlexibleSpace();
                    EditorGUILayout.EndHorizontal();

                    GUILayout.Space(4f);
                    scroll = EditorGUILayout.BeginScrollView(scroll, GUILayout.Height(CardTileHeight + 40f));
                    EditorGUILayout.BeginHorizontal();
                    GUILayout.FlexibleSpace();
                    if (player.hand == null || player.hand.ItemCount < 1)
                    {
                        GUILayout.Label("No cards in hand.", EditorStyles.centeredGreyMiniLabel, GUILayout.Width(240f));
                    }
                    else
                    {
                        for (var i = 0; i < player.hand.ItemCount; i++)
                        {
                            if (player.hand.TryGetProbabilityItem(i, out var item) == false) continue;
                            DrawHandCard(i, item.Value, isCurrent, player.currentMana, m_Sample.gameOver);
                            GUILayout.Space(6f);
                        }
                    }
                    GUILayout.FlexibleSpace();
                    EditorGUILayout.EndHorizontal();
                    EditorGUILayout.EndScrollView();
                }

                if (isTopHand)
                {
                    GUILayout.Space(8f);
                    DrawHandHeroCard(playerIndex);
                }
            }
            GUILayout.FlexibleSpace();
            EditorGUILayout.EndHorizontal();

            if (isTopHand) m_TopHandScroll = scroll;
            else m_BottomHandScroll = scroll;
        }

        private void DrawBoardArena()
        {
            using (new EditorGUILayout.VerticalScope(m_BoardStyle))
            {
                EditorGUILayout.BeginHorizontal();
                EditorGUILayout.LabelField("Board", m_TitleStyle);
                GUILayout.FlexibleSpace();
                if (HasSelectedAttacker())
                {
                    GUILayout.Label($"Choose a target for {GetSelectedAttackerName()}", m_SelectionStyle);
                }
                else if (m_Sample.gameOver == false)
                {
                    GUILayout.Label("Select a ready minion, then choose a target.", EditorStyles.miniLabel);
                }
                EditorGUILayout.EndHorizontal();

                if (m_Sample.gameOver)
                {
                    GUILayout.Space(6f);
                    using (new EditorGUILayout.VerticalScope(m_ActiveZoneStyle))
                    {
                        GUILayout.Label($"{m_Sample.winnerName.ToUpperInvariant()} WINS", m_HeroStyle);
                    }
                }

                GUILayout.Space(4f);
                DrawBoardLane(1, true);
                GUILayout.Space(8f);
                DrawBoardLane(0, false);
            }
        }

        private void DrawHandHeroCard(int playerIndex)
        {
            var player = m_Sample.GetPlayer(playerIndex);
            var isCurrent = m_Sample.currentPlayerIndex == playerIndex;
            var isWinner = m_Sample.gameOver && string.Equals(m_Sample.winnerName, player.displayName, StringComparison.Ordinal);
            var isLoser = m_Sample.gameOver && isWinner == false;
            var canTargetHero = HasSelectedAttacker() && isCurrent == false && m_Sample.gameOver == false;
            var canEndTurn = isCurrent && m_Sample.gameOver == false;
            var actionLabel = m_Sample.gameOver
                ? "Duel Over"
                : canTargetHero
                    ? $"Attack Hero ({Mathf.Max(player.heroHealth, 0)})"
                    : canEndTurn
                        ? "End Turn"
                        : "Waiting";

            var cardStyle = isCurrent ? m_ActiveHeroCardStyle : m_HeroCardStyle;
            using (new EditorGUILayout.VerticalScope(cardStyle, GUILayout.Width(HeroPanelWidth), GUILayout.Height(CardTileHeight + 40f)))
            {
                GUILayout.Label(player.displayName, isCurrent ? m_HeroStyle : m_HeroMutedStyle);
                if (m_Sample.gameOver)
                {
                    GUILayout.Space(2f);
                    GUILayout.Label(isWinner ? "VICTORY" : "DEFEATED", m_SelectionStyle);
                }
                GUILayout.Space(6f);

                EditorGUILayout.BeginHorizontal();
                DrawInfoChip($"♥ {Mathf.Max(player.heroHealth, 0)}", 0f, true, GUILayout.Height(28f), GUILayout.ExpandWidth(true));
                GUILayout.Space(6f);
                DrawInfoChip($"✦ {player.currentMana}/{Mathf.Max(player.maxMana, 0)}", 0f, true, GUILayout.Height(28f), GUILayout.ExpandWidth(true));
                EditorGUILayout.EndHorizontal();

                GUILayout.Space(8f);
                DrawDeckChip($"DECK • {player.drawPile.ItemCount} CARDS", GUILayout.Height(32f), GUILayout.ExpandWidth(true));

                GUILayout.Space(6f);
                EditorGUILayout.BeginHorizontal();
                DrawInfoChip($"Graveyard {player.graveyard.ItemCount}", 0f, GUILayout.Height(24f), GUILayout.ExpandWidth(true));
                GUILayout.Space(6f);
                DrawInfoChip($"Fatigue {player.fatigueCounter}", 0f, GUILayout.Height(24f), GUILayout.ExpandWidth(true));
                EditorGUILayout.EndHorizontal();

                GUILayout.FlexibleSpace();

                var actionLayout = new[] { GUILayout.Height(32f), GUILayout.ExpandWidth(true) };

                if (canTargetHero || canEndTurn)
                {
                    var previousColor = GUI.backgroundColor;
                    GUI.backgroundColor = player.heroColor;
                    if (GUILayout.Button(actionLabel, actionLayout))
                    {
                        if (canTargetHero)
                        {
                            var attackerIndex = m_SelectedAttackerIndex;
                            RunMutation("Attack Enemy Hero", () => m_Sample.AttackEnemyHero(attackerIndex));
                            ClearSelectedAttacker();
                        }
                        else if (canEndTurn)
                        {
                            RunMutation("End Card Battle Turn", () =>
                            {
                                ClearSelectedAttacker();
                                return m_Sample.EndTurn();
                            });
                        }
                    }
                    GUI.backgroundColor = previousColor;
                }
                else
                {
                    EditorGUI.BeginDisabledGroup(true);
                    GUILayout.Button(actionLabel, actionLayout);
                    EditorGUI.EndDisabledGroup();
                }
            }
        }

        private void DrawBoardLane(int playerIndex, bool headerOnTop)
        {
            var player = m_Sample.GetPlayer(playerIndex);
            var isCurrent = m_Sample.currentPlayerIndex == playerIndex;

            using (new EditorGUILayout.VerticalScope(m_BoardLaneStyle, GUILayout.MinHeight(BoardLaneMinHeight)))
            {
                if (headerOnTop)
                {
                    DrawBoardLaneHeader(playerIndex, player);
                    GUILayout.Space(4f);
                }

                EditorGUILayout.BeginHorizontal();
                GUILayout.FlexibleSpace();
                if (player.board == null || player.board.Count < 1)
                {
                    GUILayout.Label(isCurrent ? "No friendly minions on board." : "No enemy minions on board.", EditorStyles.centeredGreyMiniLabel, GUILayout.Width(280f));
                }
                else
                {
                    for (var i = 0; i < player.board.Count; i++)
                    {
                        DrawBoardCard(playerIndex, i, player.board[i], isCurrent);
                        GUILayout.Space(6f);
                    }
                }
                GUILayout.FlexibleSpace();
                EditorGUILayout.EndHorizontal();
                GUILayout.FlexibleSpace();

                if (headerOnTop == false)
                {
                    GUILayout.Space(4f);
                    DrawBoardLaneHeader(playerIndex, player);
                }
            }
        }

        private void DrawBoardLaneHeader(int playerIndex, CardBattleWindowSample.PlayerState player)
        {
            var isCurrent = m_Sample.currentPlayerIndex == playerIndex;
            var label = m_Sample.gameOver
                ? $"{player.displayName} Board"
                : isCurrent ? "Current Board" : "Opponent Board";
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(label, m_SectionLabelStyle);
            GUILayout.FlexibleSpace();
            GUILayout.Label($"{player.board.Count}/{m_Sample.boardLimit} minions", m_ChipStyle, GUILayout.Width(96f));
            EditorGUILayout.EndHorizontal();
        }

        private void DrawSidebar()
        {
            using (new EditorGUILayout.VerticalScope(m_BoxStyle, GUILayout.Width(SidebarWidth), GUILayout.ExpandHeight(true)))
            {
                EditorGUILayout.LabelField("Action History", m_TitleStyle);
                GUILayout.Space(6f);

                m_HistoryScroll = EditorGUILayout.BeginScrollView(m_HistoryScroll);
                if (m_Sample.history == null || m_Sample.history.Count < 1)
                {
                    EditorGUILayout.LabelField("No actions yet. Reset Duel to begin.", EditorStyles.miniLabel);
                }
                else
                {
                    foreach (var record in m_Sample.history)
                    {
                        DrawHistoryRow(record);
                    }
                }
                EditorGUILayout.EndScrollView();
            }
        }

        private void DrawHistoryRow(CardBattleWindowSample.PlayRecord record)
        {
            if (record == null) return;
            using (new EditorGUILayout.VerticalScope(m_ZoneStyle))
            {
                EditorGUILayout.BeginHorizontal();
                GUILayout.Label($"{record.symbol} T{record.turnNumber}", m_ChipStyle, GUILayout.Width(54f));
                GUILayout.Label(record.actor, m_LogActorStyle);
                GUILayout.FlexibleSpace();
                EditorGUILayout.EndHorizontal();
                GUILayout.Label(record.action, m_LogStyle);
            }
        }

        private void DrawInfoChip(string label, float width, params GUILayoutOption[] options)
        {
            DrawInfoChip(label, width, false, options);
        }

        private void DrawInfoChip(string label, float width, bool emphasize, params GUILayoutOption[] options)
        {
            var style = emphasize ? m_DeckChipStyle : m_InfoChipStyle;
            if (width > 0f)
            {
                GUILayout.Label(label, style, PrependOption(options, GUILayout.Width(width)));
                return;
            }

            GUILayout.Label(label, style, options);
        }

        private void DrawDeckChip(string label, params GUILayoutOption[] options)
        {
            GUILayout.Label(label, m_DeckChipStyle, options);
        }

        private static GUILayoutOption[] PrependOption(GUILayoutOption[] options, GUILayoutOption first)
        {
            var result = new GUILayoutOption[(options?.Length ?? 0) + 1];
            result[0] = first;
            if (options != null && options.Length > 0)
            {
                Array.Copy(options, 0, result, 1, options.Length);
            }

            return result;
        }

        private void DrawBoardCard(int playerIndex, int boardIndex, CardBattleWindowSample.BattleCardInstance card, bool belongsToCurrentPlayer)
        {
            if (card == null) return;

            var isSelected = playerIndex == m_Sample.currentPlayerIndex && boardIndex == m_SelectedAttackerIndex && HasSelectedAttacker();
            var canAttack = playerIndex == m_Sample.currentPlayerIndex && m_Sample.CanAttackWithBoardCard(boardIndex);
            var canTarget = HasSelectedAttacker() && playerIndex != m_Sample.currentPlayerIndex && m_Sample.gameOver == false;
            var frameColor = isSelected ? Color.Lerp(card.accentColor, Color.white, .28f) : card.accentColor;

            var previousColor = GUI.backgroundColor;
            GUI.backgroundColor = frameColor;
            using (new EditorGUILayout.VerticalScope(m_PlayableMinionCardStyle, GUILayout.Width(MinionTileWidth), GUILayout.Height(MinionTileHeight)))
            {
                GUILayout.Label($"{card.symbol} {card.title}", m_CardTitleStyle);
                GUILayout.Label($"ATK {card.attack}    HP {card.currentHealth}/{card.maxHealth}", m_StatStyle);
                GUILayout.Label($"Cost {card.manaCost}", m_ChipStyle);
                if (isSelected)
                {
                    GUILayout.Label("Selected Attacker", m_SelectionStyle);
                }
                else if (canTarget)
                {
                    GUILayout.Label("Targetable", m_SelectionStyle);
                }
                else
                {
                    GUILayout.Space(18f);
                }

                GUILayout.FlexibleSpace();

                if (belongsToCurrentPlayer)
                {
                    var buttonText = isSelected ? "Selected" : canAttack ? "Attack" : "Spent";
                    EditorGUI.BeginDisabledGroup(m_Sample.gameOver || canAttack == false);
                    if (GUILayout.Button(buttonText, GUILayout.Height(22f)))
                    {
                        m_SelectedAttackerIndex = isSelected ? -1 : boardIndex;
                    }
                    EditorGUI.EndDisabledGroup();
                }
                else
                {
                    EditorGUI.BeginDisabledGroup(m_Sample.gameOver || canTarget == false);
                    if (GUILayout.Button(canTarget ? "Target" : "Enemy", GUILayout.Height(22f)))
                    {
                        var attackerIndex = m_SelectedAttackerIndex;
                        RunMutation("Attack Enemy Minion", () => m_Sample.AttackEnemyMinion(attackerIndex, boardIndex));
                        ClearSelectedAttacker();
                    }
                    EditorGUI.EndDisabledGroup();
                }
            }
            GUI.backgroundColor = previousColor;
        }

        private void DrawHandCard(int handIndex, CardBattleWindowSample.BattleCardInstance card, bool belongsToCurrentPlayer, int availableMana, bool gameOver)
        {
            if (card == null) return;
            var canPlay = belongsToCurrentPlayer && gameOver == false && availableMana >= card.manaCost;
            var previousColor = GUI.backgroundColor;
            GUI.backgroundColor = card.accentColor;
            var cardStyle = card.cardType == CardBattleWindowSample.BattleCardType.Spell
                ? m_PlayableSpellCardStyle
                : m_PlayableMinionCardStyle;

            using (new EditorGUILayout.VerticalScope(cardStyle, GUILayout.Width(CardTileWidth), GUILayout.Height(CardTileHeight)))
            {
                GUILayout.Label($"{card.symbol} {card.title}", m_CardTitleStyle);
                GUILayout.Label(card.cardType == CardBattleWindowSample.BattleCardType.Minion
                    ? $"{card.manaCost} mana • {card.attack}/{card.currentHealth}"
                    : $"{card.manaCost} mana • {card.spellDamage} dmg", m_CardMetaStyle);
                GUILayout.Label(card.cardType == CardBattleWindowSample.BattleCardType.Minion ? "MINION" : "SPELL", m_CardTypeTagStyle);
                GUILayout.Space(1f);
                GUILayout.Label(string.IsNullOrWhiteSpace(card.rulesText) ? "No text" : card.rulesText, m_CardTextStyle, GUILayout.Height(46f));
                GUILayout.FlexibleSpace();
                EditorGUI.BeginDisabledGroup(gameOver || canPlay == false);
                if (GUILayout.Button(canPlay ? "Play" : belongsToCurrentPlayer ? "Need Mana" : "Waiting", GUILayout.Height(24f)))
                {
                    RunMutation("Play Hand Card", () => m_Sample.PlayCardFromHand(handIndex));
                    ClearSelectedAttacker();
                }
                EditorGUI.EndDisabledGroup();
            }
            GUI.backgroundColor = previousColor;
        }

        private void RunMutation(string undoName, Func<bool> action)
        {
            if (m_Sample == null || action == null) return;
            Undo.RecordObject(m_Sample, undoName);
            var changed = action.Invoke();
            if (changed)
            {
                EditorUtility.SetDirty(m_Sample);
            }
            Repaint();
        }

        private bool HasSelectedAttacker()
        {
            return m_SelectedAttackerIndex >= 0;
        }

        private string GetSelectedAttackerName()
        {
            if (HasSelectedAttacker() == false || m_Sample == null) return "None";
            var currentPlayer = m_Sample.GetCurrentPlayer();
            if (currentPlayer?.board == null || m_SelectedAttackerIndex < 0 || m_SelectedAttackerIndex >= currentPlayer.board.Count) return "None";
            var card = currentPlayer.board[m_SelectedAttackerIndex];
            return card != null ? card.title : "None";
        }

        private void ClearSelectedAttacker()
        {
            m_SelectedAttackerIndex = -1;
        }

        private void EnsureSelectionValidity()
        {
            if (HasSelectedAttacker() == false) return;
            var currentPlayer = m_Sample.GetCurrentPlayer();
            if (currentPlayer?.board == null || m_SelectedAttackerIndex >= currentPlayer.board.Count)
            {
                ClearSelectedAttacker();
                return;
            }

            if (m_Sample.CanAttackWithBoardCard(m_SelectedAttackerIndex) == false)
            {
                ClearSelectedAttacker();
            }
        }

        private float GetCenteredHandWidth(int cardCount)
        {
            var contentWidth = Mathf.Max(430f, cardCount * (CardTileWidth + 6f) + 52f);
            var maxWidth = Mathf.Max(560f, position.width - SidebarWidth - 72f);
            return Mathf.Clamp(contentWidth, 560f, Mathf.Min(980f, maxWidth));
        }

        private void CreateSampleAsset()
        {
            var path = EditorUtility.SaveFilePanelInProject(
                "Create Card Battle Sample",
                "Card Battle Window Sample",
                "asset",
                "Choose a location for the Card Battle sample asset.");

            if (string.IsNullOrWhiteSpace(path)) return;

            var sample = CreateInstance<CardBattleWindowSample>();
            sample.ResetSample();
            AssetDatabase.CreateAsset(sample, path);
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
            m_Sample = sample;
            Selection.activeObject = sample;
            EditorGUIUtility.PingObject(sample);
            ClearSelectedAttacker();
        }

        private void EnsureStyles()
        {
            if (m_TitleStyle != null &&
                m_DefaultBoxTexture != null &&
                m_ZoneTexture != null &&
                m_ActiveZoneTexture != null &&
                m_BoardTexture != null &&
                m_BoardLaneTexture != null &&
                m_HeroCardTexture != null &&
                m_ActiveHeroCardTexture != null &&
                m_PlayableMinionCardTexture != null &&
                m_PlayableSpellCardTexture != null &&
                m_InfoChipTexture != null &&
                m_DeckChipTexture != null &&
                m_StylesBuiltForProSkin == EditorGUIUtility.isProSkin)
            {
                return;
            }

            ResetStyles();
            m_StylesBuiltForProSkin = EditorGUIUtility.isProSkin;

            m_DefaultBoxTexture = CreateSolidTexture(EditorGUIUtility.isProSkin ? new Color(.2f, .2f, .22f, 1f) : new Color(.95f, .97f, .99f, 1f));
            m_ZoneTexture = CreateSolidTexture(EditorGUIUtility.isProSkin ? new Color(.18f, .2f, .24f, 1f) : new Color(.93f, .95f, .99f, 1f));
            m_ActiveZoneTexture = CreateSolidTexture(EditorGUIUtility.isProSkin ? new Color(.16f, .27f, .34f, 1f) : new Color(.86f, .93f, 1f, 1f));
            m_BoardTexture = CreateSolidTexture(EditorGUIUtility.isProSkin ? new Color(.2f, .16f, .24f, 1f) : new Color(.95f, .92f, .98f, 1f));
            m_BoardLaneTexture = CreateSolidTexture(EditorGUIUtility.isProSkin ? new Color(.24f, .2f, .3f, 1f) : new Color(.97f, .95f, .99f, 1f));
            m_HeroCardTexture = CreateBorderTexture(EditorGUIUtility.isProSkin ? new Color(.18f, .28f, .36f, 1f) : new Color(.9f, .95f, 1f, 1f), EditorGUIUtility.isProSkin ? new Color(.24f, .32f, .4f, 1f) : new Color(.72f, .79f, .9f, 1f));
            m_ActiveHeroCardTexture = CreateBorderTexture(EditorGUIUtility.isProSkin ? new Color(.18f, .28f, .36f, 1f) : new Color(.9f, .95f, 1f, 1f), EditorGUIUtility.isProSkin ? new Color(.82f, .7f, .34f, 1f) : new Color(.82f, .66f, .22f, 1f));
            m_PlayableMinionCardTexture = CreateRoundedBorderTexture(EditorGUIUtility.isProSkin ? new Color(.24f, .29f, .34f, 1f) : new Color(.91f, .95f, .99f, 1f), EditorGUIUtility.isProSkin ? new Color(.54f, .68f, .8f, 1f) : new Color(.62f, .72f, .84f, 1f), 9);
            m_PlayableSpellCardTexture = CreateRoundedBorderTexture(EditorGUIUtility.isProSkin ? new Color(.31f, .33f, .24f, 1f) : new Color(.95f, .97f, .9f, 1f), EditorGUIUtility.isProSkin ? new Color(.72f, .75f, .54f, 1f) : new Color(.78f, .8f, .62f, 1f), 9);
            m_InfoChipTexture = CreateBorderTexture(EditorGUIUtility.isProSkin ? new Color(.3f, .36f, .44f, 1f) : new Color(.86f, .9f, .95f, 1f), EditorGUIUtility.isProSkin ? new Color(.4f, .45f, .52f, 1f) : new Color(.7f, .74f, .8f, 1f));
            m_DeckChipTexture = CreateBorderTexture(EditorGUIUtility.isProSkin ? new Color(.22f, .34f, .5f, 1f) : new Color(.8f, .9f, 1f, 1f), EditorGUIUtility.isProSkin ? new Color(.42f, .65f, .95f, 1f) : new Color(.45f, .62f, .9f, 1f));

            m_TitleStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                fontSize = 13,
                wordWrap = true
            };

            m_SubtitleStyle = new GUIStyle(EditorStyles.miniLabel)
            {
                wordWrap = true
            };

            m_HeroStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                fontSize = 14,
                alignment = TextAnchor.MiddleCenter,
                normal = { textColor = Color.white }
            };

            m_HeroMutedStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                fontSize = 14,
                alignment = TextAnchor.MiddleCenter,
                normal = { textColor = EditorGUIUtility.isProSkin ? new Color(.82f, .82f, .82f) : new Color(.22f, .22f, .22f) }
            };

            m_BoxStyle = CreatePanelStyle(m_DefaultBoxTexture, new RectOffset(10, 10, 8, 8));
            m_ZoneStyle = CreatePanelStyle(m_ZoneTexture, new RectOffset(10, 10, 8, 8));
            m_ActiveZoneStyle = CreatePanelStyle(m_ActiveZoneTexture, new RectOffset(10, 10, 8, 8));
            m_BoardStyle = CreatePanelStyle(m_BoardTexture, new RectOffset(12, 12, 10, 10));
            m_BoardLaneStyle = CreatePanelStyle(m_BoardLaneTexture, new RectOffset(10, 10, 8, 8));
            m_HeroCardStyle = CreatePanelStyle(m_HeroCardTexture, new RectOffset(12, 12, 10, 10), new RectOffset(2, 2, 2, 2));
            m_ActiveHeroCardStyle = CreatePanelStyle(m_ActiveHeroCardTexture, new RectOffset(12, 12, 10, 10), new RectOffset(2, 2, 2, 2));
            m_PlayableMinionCardStyle = CreatePanelStyle(m_PlayableMinionCardTexture, new RectOffset(11, 11, 9, 9), new RectOffset(8, 8, 8, 8));
            m_PlayableSpellCardStyle = CreatePanelStyle(m_PlayableSpellCardTexture, new RectOffset(11, 11, 9, 9), new RectOffset(8, 8, 8, 8));

            m_CardTitleStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                wordWrap = true,
                alignment = TextAnchor.UpperCenter
            };

            m_CardTextStyle = new GUIStyle(EditorStyles.miniLabel)
            {
                wordWrap = true,
                richText = false,
                alignment = TextAnchor.MiddleCenter
            };

            m_CardMetaStyle = new GUIStyle(EditorStyles.miniLabel)
            {
                alignment = TextAnchor.MiddleCenter,
                fontStyle = FontStyle.Bold,
                wordWrap = false,
                clipping = TextClipping.Clip
            };

            m_CardTypeTagStyle = new GUIStyle(EditorStyles.miniLabel)
            {
                alignment = TextAnchor.MiddleCenter,
                fontStyle = FontStyle.Bold,
                fontSize = 9,
                wordWrap = false
            };
            m_CardTypeTagStyle.normal.textColor = EditorGUIUtility.isProSkin
                ? new Color(.78f, .8f, .84f, 1f)
                : new Color(.34f, .38f, .46f, 1f);

            m_StatStyle = new GUIStyle(EditorStyles.label)
            {
                fontStyle = FontStyle.Bold,
                alignment = TextAnchor.MiddleCenter,
                fontSize = 11
            };

            m_ChipStyle = new GUIStyle(EditorStyles.miniButton)
            {
                alignment = TextAnchor.MiddleCenter
            };

            m_InfoChipStyle = new GUIStyle(EditorStyles.label)
            {
                alignment = TextAnchor.MiddleCenter,
                fontSize = 12,
                fontStyle = FontStyle.Bold,
                padding = new RectOffset(8, 8, 6, 6),
                margin = new RectOffset(0, 0, 0, 0)
            };
            m_InfoChipStyle.normal.background = m_InfoChipTexture;

            m_DeckChipStyle = new GUIStyle(m_InfoChipStyle)
            {
                fontSize = 13,
                fontStyle = FontStyle.Bold,
                fixedHeight = 32f,
                alignment = TextAnchor.MiddleCenter,
                normal = { textColor = Color.white }
            };
            m_DeckChipStyle.normal.background = m_DeckChipTexture;

            m_LogStyle = new GUIStyle(EditorStyles.wordWrappedMiniLabel)
            {
                wordWrap = true
            };

            m_LogActorStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                fontSize = 11
            };

            m_SelectionStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                normal = { textColor = EditorGUIUtility.isProSkin ? new Color(1f, .85f, .4f) : new Color(.55f, .35f, .02f) },
                wordWrap = false,
                alignment = TextAnchor.MiddleCenter,
                clipping = TextClipping.Clip,
                fontSize = 11
            };

            m_SectionLabelStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                fontSize = 12,
                wordWrap = true
            };
        }

        [DidReloadScripts]
        private static void HandleScriptsReloaded()
        {
            foreach (var window in Resources.FindObjectsOfTypeAll<CardBattleWindow>())
            {
                window.ResetStyles();
                window.Repaint();
            }
        }

        private void ResetStyles()
        {
            m_TitleStyle = null;
            m_SubtitleStyle = null;
            m_HeroStyle = null;
            m_HeroMutedStyle = null;
            m_BoxStyle = null;
            m_ZoneStyle = null;
            m_ActiveZoneStyle = null;
            m_BoardStyle = null;
            m_BoardLaneStyle = null;
            m_HeroCardStyle = null;
            m_ActiveHeroCardStyle = null;
            m_PlayableMinionCardStyle = null;
            m_PlayableSpellCardStyle = null;
            m_CardTitleStyle = null;
            m_CardTextStyle = null;
            m_CardMetaStyle = null;
            m_CardTypeTagStyle = null;
            m_StatStyle = null;
            m_ChipStyle = null;
            m_InfoChipStyle = null;
            m_DeckChipStyle = null;
            m_LogStyle = null;
            m_LogActorStyle = null;
            m_SelectionStyle = null;
            m_SectionLabelStyle = null;
            m_StylesBuiltForProSkin = false;

            DestroyTexture(ref m_DefaultBoxTexture);
            DestroyTexture(ref m_ZoneTexture);
            DestroyTexture(ref m_ActiveZoneTexture);
            DestroyTexture(ref m_BoardTexture);
            DestroyTexture(ref m_BoardLaneTexture);
            DestroyTexture(ref m_HeroCardTexture);
            DestroyTexture(ref m_ActiveHeroCardTexture);
            DestroyTexture(ref m_PlayableMinionCardTexture);
            DestroyTexture(ref m_PlayableSpellCardTexture);
            DestroyTexture(ref m_InfoChipTexture);
            DestroyTexture(ref m_DeckChipTexture);
        }

        private static GUIStyle CreatePanelStyle(Texture2D background, RectOffset padding)
        {
            return CreatePanelStyle(background, padding, new RectOffset(6, 6, 6, 6));
        }

        private static GUIStyle CreatePanelStyle(Texture2D background, RectOffset padding, RectOffset border)
        {
            var style = new GUIStyle(EditorStyles.helpBox)
            {
                padding = padding,
                margin = new RectOffset(4, 4, 4, 4)
            };
            style.normal.background = background;
            style.border = border;
            return style;
        }

        private static Texture2D CreateSolidTexture(Color color)
        {
            var texture = new Texture2D(1, 1);
            texture.SetPixel(0, 0, color);
            texture.Apply();
            return texture;
        }

        private static Texture2D CreateBorderTexture(Color fillColor, Color borderColor)
        {
            var texture = new Texture2D(3, 3);
            texture.SetPixels(new[]
            {
                borderColor, borderColor, borderColor,
                borderColor, fillColor,   borderColor,
                borderColor, borderColor, borderColor
            });
            texture.Apply();
            return texture;
        }

        private static Texture2D CreateRoundedBorderTexture(Color fillColor, Color borderColor, int radius)
        {
            const int size = 32;
            var texture = new Texture2D(size, size, TextureFormat.RGBA32, false)
            {
                alphaIsTransparency = true,
                wrapMode = TextureWrapMode.Clamp,
                filterMode = FilterMode.Bilinear
            };

            var transparent = new Color(0f, 0f, 0f, 0f);
            var max = size - 1;
            var inner = Mathf.Max(0, radius - 1.5f);

            for (var y = 0; y < size; y++)
            {
                for (var x = 0; x < size; x++)
                {
                    var dx = x < radius ? radius - 1 - x : (x > max - radius ? x - (max - radius + 1) : 0);
                    var dy = y < radius ? radius - 1 - y : (y > max - radius ? y - (max - radius + 1) : 0);
                    if (dx == 0 && dy == 0)
                    {
                        texture.SetPixel(x, y, fillColor);
                        continue;
                    }

                    var dist = Mathf.Sqrt(dx * dx + dy * dy);
                    if (dist > radius + 0.35f)
                    {
                        texture.SetPixel(x, y, transparent);
                    }
                    else if (dist > radius - 0.85f)
                    {
                        texture.SetPixel(x, y, Color.Lerp(borderColor, transparent, Mathf.Clamp01((dist - (radius - 0.85f)) / 1.2f)));
                    }
                    else if (dist > inner)
                    {
                        texture.SetPixel(x, y, borderColor);
                    }
                    else
                    {
                        texture.SetPixel(x, y, fillColor);
                    }
                }
            }

            texture.Apply();
            return texture;
        }

        private static void DestroyTexture(ref Texture2D texture)
        {
            if (texture == null) return;
            DestroyImmediate(texture);
            texture = null;
        }
    }
}
