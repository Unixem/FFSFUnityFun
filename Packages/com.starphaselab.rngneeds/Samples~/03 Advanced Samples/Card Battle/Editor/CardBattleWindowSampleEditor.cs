using RNGNeeds.Samples.CardBattle;
using UnityEditor;
using UnityEngine;

namespace RNGNeeds.Samples.CardBattle.Editor
{
    [CustomEditor(typeof(CardBattleWindowSample))]
    public class CardBattleWindowSampleEditor : UnityEditor.Editor
    {
        private const string NotesIconPath = "Packages/com.starphaselab.rngneeds/Editor/Assets/RNGNeedsArrowShape.png";

        private GUIStyle m_NotesBoxStyle;
        private GUIStyle m_NotesTextStyle;
        private GUIStyle m_NotesIconStyle;
        private GUIStyle m_OpenWindowButtonStyle;
        private GUIStyle m_SectionHeaderStyle;
        private GUIStyle m_SectionBoxStyle;
        private Texture2D m_NotesIcon;

        private SerializedProperty p_SampleTitle;
        private SerializedProperty p_SampleSummary;
        private SerializedProperty p_StartingHeroHealth;
        private SerializedProperty p_OpeningHandSize;
        private SerializedProperty p_BoardLimit;
        private SerializedProperty p_MaxManaCap;
        private SerializedProperty p_ShuffleDecksOnReset;
        private SerializedProperty p_PlayerOne;
        private SerializedProperty p_PlayerTwo;
        private SerializedProperty p_PlayerOneStartingDeck;
        private SerializedProperty p_PlayerTwoStartingDeck;
        private SerializedProperty p_CurrentPlayerIndex;
        private SerializedProperty p_TurnNumber;
        private SerializedProperty p_GameOver;
        private SerializedProperty p_WinnerName;
        private SerializedProperty p_LastAction;
        private SerializedProperty p_History;

        private void OnEnable()
        {
            p_SampleTitle = serializedObject.FindProperty("sampleTitle");
            p_SampleSummary = serializedObject.FindProperty("sampleSummary");
            p_StartingHeroHealth = serializedObject.FindProperty("startingHeroHealth");
            p_OpeningHandSize = serializedObject.FindProperty("openingHandSize");
            p_BoardLimit = serializedObject.FindProperty("boardLimit");
            p_MaxManaCap = serializedObject.FindProperty("maxManaCap");
            p_ShuffleDecksOnReset = serializedObject.FindProperty("shuffleDecksOnReset");
            p_PlayerOne = serializedObject.FindProperty("playerOne");
            p_PlayerTwo = serializedObject.FindProperty("playerTwo");
            p_PlayerOneStartingDeck = serializedObject.FindProperty("playerOneStartingDeck");
            p_PlayerTwoStartingDeck = serializedObject.FindProperty("playerTwoStartingDeck");
            p_CurrentPlayerIndex = serializedObject.FindProperty("currentPlayerIndex");
            p_TurnNumber = serializedObject.FindProperty("turnNumber");
            p_GameOver = serializedObject.FindProperty("gameOver");
            p_WinnerName = serializedObject.FindProperty("winnerName");
            p_LastAction = serializedObject.FindProperty("lastAction");
            p_History = serializedObject.FindProperty("history");
        }

        public override void OnInspectorGUI()
        {
            EnsureStyles();
            serializedObject.Update();

            DrawDeveloperGuide();
            GUILayout.Space(8f);
            DrawSampleSetup();
            GUILayout.Space(8f);
            DrawOpenWindowButton();
            GUILayout.Space(8f);
            DrawHeroSetup();
            GUILayout.Space(8f);
            DrawStarterDecks();
            GUILayout.Space(8f);
            DrawRuntimeState();
            GUILayout.Space(10f);

            serializedObject.ApplyModifiedProperties();
        }

        private void DrawDeveloperGuide()
        {
            DrawNotesBox("Start with CardBattleWindowSample.Zones.cs to see how ProbabilityList and Card Deck Extensions power the sample. Gameplay lives in CardBattleWindowSample.Gameplay.cs, and starter content lives in CardBattleWindowSample.StarterDecks.cs.");

            EditorGUILayout.BeginHorizontal();
            DrawScriptButton("Ping Zone Logic", "CardBattleWindowSample.Zones");
            DrawScriptButton("Ping Gameplay", "CardBattleWindowSample.Gameplay");
            DrawScriptButton("Ping Starter Decks", "CardBattleWindowSample.StarterDecks");
            EditorGUILayout.EndHorizontal();
        }

        private void DrawSampleSetup()
        {
            BeginSection("Sample Setup");
            EditorGUILayout.PropertyField(p_SampleTitle);
            EditorGUILayout.PropertyField(p_SampleSummary);
            GUILayout.Space(4f);
            EditorGUILayout.PropertyField(p_StartingHeroHealth);
            EditorGUILayout.PropertyField(p_OpeningHandSize);
            EditorGUILayout.PropertyField(p_BoardLimit);
            EditorGUILayout.PropertyField(p_MaxManaCap);
            EditorGUILayout.PropertyField(p_ShuffleDecksOnReset, new GUIContent("Shuffle Decks On Reset"));
            EndSection();
        }

        private void DrawOpenWindowButton()
        {
            var sample = (CardBattleWindowSample)target;
            EditorGUILayout.BeginHorizontal();
            GUILayout.Space(6f);
            if (GUILayout.Button("Open Card Battle Window", m_OpenWindowButtonStyle, GUILayout.Height(36f)))
            {
                CardBattleWindow.ShowWindow(sample);
            }
            GUILayout.Space(6f);
            EditorGUILayout.EndHorizontal();
        }

        private void DrawHeroSetup()
        {
            BeginSection("Hero Setup");
            DrawIndentedProperty(p_PlayerOne);
            GUILayout.Space(2f);
            DrawIndentedProperty(p_PlayerTwo);
            EndSection();
        }

        private void DrawStarterDecks()
        {
            BeginSection("Starter Decks");
            DrawNotesBox("These authored ProbabilityLists are setup-only deck recipes. Units become card quantities, duplicate entries are respected, 0-unit entries are skipped, and probability values are ignored when the sample builds the runtime deck instances on reset.");
            GUILayout.Space(4f);
            EditorGUILayout.PropertyField(p_PlayerOneStartingDeck, new GUIContent("Player One Starting Deck"), true);
            GUILayout.Space(4f);
            EditorGUILayout.PropertyField(p_PlayerTwoStartingDeck, new GUIContent("Player Two Starting Deck"), true);
            EndSection();
        }

        private void DrawRuntimeState()
        {
            BeginSection("Runtime State");
            EditorGUI.BeginDisabledGroup(EditorApplication.isPlaying == false);
            EditorGUILayout.PropertyField(p_CurrentPlayerIndex);
            EditorGUILayout.PropertyField(p_TurnNumber);
            EditorGUILayout.PropertyField(p_GameOver);
            EditorGUILayout.PropertyField(p_WinnerName);
            EditorGUILayout.PropertyField(p_LastAction);
            GUILayout.Space(2f);
            DrawIndentedProperty(p_History);
            EditorGUI.EndDisabledGroup();
            EndSection();
        }

        private void EnsureStyles()
        {
            if (m_NotesIcon == null)
            {
                m_NotesIcon = AssetDatabase.LoadAssetAtPath<Texture2D>(NotesIconPath);
            }

            if (m_NotesBoxStyle == null)
            {
                m_NotesBoxStyle = new GUIStyle(EditorStyles.helpBox)
                {
                    padding = new RectOffset(10, 10, 8, 8),
                    margin = new RectOffset(4, 4, 4, 6)
                };
            }

            m_NotesBoxStyle.normal.textColor = GUI.contentColor;

            if (m_NotesTextStyle == null)
            {
                m_NotesTextStyle = new GUIStyle(EditorStyles.wordWrappedLabel)
                {
                    richText = true,
                    fontSize = 12,
                    alignment = TextAnchor.UpperLeft
                };
            }

            if (m_NotesIconStyle == null)
            {
                m_NotesIconStyle = new GUIStyle
                {
                    alignment = TextAnchor.MiddleCenter,
                    margin = new RectOffset(0, 12, 0, 0),
                    padding = new RectOffset(0, 0, 0, 0)
                };
            }

            if (m_OpenWindowButtonStyle == null)
            {
                m_OpenWindowButtonStyle = new GUIStyle(GUI.skin.button)
                {
                    fontSize = 13,
                    fontStyle = FontStyle.Bold,
                    alignment = TextAnchor.MiddleCenter,
                    margin = new RectOffset(0, 0, 2, 2)
                };
            }

            if (m_SectionHeaderStyle == null)
            {
                m_SectionHeaderStyle = new GUIStyle(EditorStyles.boldLabel)
                {
                    fontSize = 12,
                    margin = new RectOffset(0, 0, 0, 6)
                };
            }

            if (m_SectionBoxStyle == null)
            {
                m_SectionBoxStyle = new GUIStyle(EditorStyles.helpBox)
                {
                    padding = new RectOffset(10, 10, 8, 10),
                    margin = new RectOffset(0, 0, 0, 0)
                };
            }

            m_NotesTextStyle.normal.textColor = EditorGUIUtility.isProSkin
                ? new Color(0.83f, 0.9f, 1f)
                : new Color(0.16f, 0.22f, 0.32f);
        }

        private void DrawNotesBox(string text)
        {
            var previousBackground = GUI.backgroundColor;
            GUI.backgroundColor = EditorGUIUtility.isProSkin
                ? new Color(0.22f, 0.25f, 0.31f)
                : new Color(0.9f, 0.94f, 1f);

            EditorGUILayout.BeginVertical(m_NotesBoxStyle);
            GUI.backgroundColor = previousBackground;

            EditorGUILayout.BeginHorizontal();

            if (m_NotesIcon != null)
            {
                EditorGUILayout.BeginVertical(GUILayout.Width(38f), GUILayout.Height(38f));
                GUILayout.FlexibleSpace();
                GUILayout.Label(m_NotesIcon, m_NotesIconStyle, GUILayout.Width(32f), GUILayout.Height(32f));
                GUILayout.FlexibleSpace();
                EditorGUILayout.EndVertical();
            }

            EditorGUILayout.LabelField(text, m_NotesTextStyle);
            EditorGUILayout.EndHorizontal();
            EditorGUILayout.EndVertical();
        }

        private void BeginSection(string title)
        {
            EditorGUILayout.BeginVertical(m_SectionBoxStyle);
            EditorGUILayout.LabelField(title, m_SectionHeaderStyle);
        }

        private void EndSection()
        {
            EditorGUILayout.EndVertical();
        }

        private static void DrawIndentedProperty(SerializedProperty property)
        {
            EditorGUILayout.BeginHorizontal();
            GUILayout.Space(10f);
            EditorGUILayout.PropertyField(property, true);
            EditorGUILayout.EndHorizontal();
        }

        private static void DrawScriptButton(string label, string scriptName)
        {
            var script = FindScriptAsset(scriptName);
            EditorGUI.BeginDisabledGroup(script == null);
            if (GUILayout.Button(label, GUILayout.Height(22f)) && script != null)
            {
                EditorGUIUtility.PingObject(script);
                Selection.activeObject = script;
            }
            EditorGUI.EndDisabledGroup();
        }

        private static MonoScript FindScriptAsset(string scriptName)
        {
            var guids = AssetDatabase.FindAssets($"{scriptName} t:script");
            if (guids == null || guids.Length < 1) return null;
            var path = AssetDatabase.GUIDToAssetPath(guids[0]);
            return AssetDatabase.LoadAssetAtPath<MonoScript>(path);
        }
    }
}
