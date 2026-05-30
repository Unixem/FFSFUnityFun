using UnityEditor;
using UnityEngine;

namespace RNGNeeds.Editor
{
    public class WelcomeWindow : EditorWindow
    {
        private const string ApiReferenceUrl = "https://docs.rngneeds.com/api-reference/api-overview";
        private const string TwitterUrl = "https://x.com/StarphaseLab";
        private const string TwitterLogoPath = "Packages/com.starphaselab.rngneeds/Editor/Assets/twitter-logo.png";

        private static readonly Vector2 windowSize = new Vector2(340f, 530f);
        private GUIStyle leadStyle;
        private GUIStyle headingStyle;
        private GUIStyle versionStyle;
        private GUIStyle docsLinkStyle;
        private GUIStyle paragraphStyle;
        private GUIStyle followTitleStyle;
        private GUIStyle followSubtitleStyle;
        private GUIStyle followIconStyle;
        
        private readonly Color separatorColor = new Color(.5f, .6f, .7f);
        private readonly Color followButtonColor = new Color(.17f, .21f, .27f);
        private readonly Color followButtonBorderColor = new Color(.33f, .48f, .61f);
        private readonly Color mysteryAccentColor = new Color(.55f, .28f, .08f);
        private readonly Color mysteryAccentBorderColor = new Color(.98f, .66f, .25f);
        private Texture2D rngneedsIcon;
        private Texture2D twitterLogo;
        private string version;
        private bool Initialized;
        private string[] RandomNeeds;
        private string MysteryButtonText;
        private GUIStyle MysteryButtonStyle;
        
        private void Initialize()
        {
            leadStyle = new GUIStyle(GUI.skin.label) { wordWrap = true, fontStyle = FontStyle.Bold };
            headingStyle = new GUIStyle(GUI.skin.label) { fontSize = 12, fontStyle = FontStyle.Bold};
            versionStyle = new GUIStyle(GUI.skin.label) { fontSize = 10, alignment = TextAnchor.MiddleCenter };
            docsLinkStyle = new GUIStyle(EditorStyles.linkLabel) { alignment = TextAnchor.MiddleLeft };
            paragraphStyle = new GUIStyle(GUI.skin.label) { fontSize = 12, wordWrap = true};
            followTitleStyle = new GUIStyle(GUI.skin.label) { fontSize = 12, fontStyle = FontStyle.Bold, alignment = TextAnchor.MiddleLeft, normal = { textColor = Color.white } };
            followSubtitleStyle = new GUIStyle(GUI.skin.label) { fontSize = 10, alignment = TextAnchor.MiddleLeft, normal = { textColor = new Color(.80f, .86f, .93f) } };
            followIconStyle = new GUIStyle(GUI.skin.label) { fontSize = 14, fontStyle = FontStyle.Bold, alignment = TextAnchor.MiddleCenter, normal = { textColor = Color.white } };
            version = RNGNStaticData.CurrentVersion;
            rngneedsIcon = AssetDatabase.LoadAssetAtPath<Texture2D>("Packages/com.starphaselab.rngneeds/Editor/Assets/RNGNeeds_Icon.png");
            twitterLogo = AssetDatabase.LoadAssetAtPath<Texture2D>(TwitterLogoPath);
            
            var fileContent = System.IO.File.ReadAllText("Packages/com.starphaselab.rngneeds/Editor/Assets/RandomNeeds.txt");
            var decryptedString = EncryptDecrypt(fileContent, 1234);
            var deserializedWrapper = JsonUtility.FromJson<StringWrapper>(decryptedString);
            RandomNeeds = deserializedWrapper.strings;
            MysteryButtonText = "Get inspired by a random need ...";
            
            MysteryButtonStyle = new GUIStyle
            {
                normal =
                {
                    background = AssetDatabase.LoadAssetAtPath<Texture2D>("Packages/com.starphaselab.rngneeds/Editor/Assets/PL_InputField_00000.png"),
                    textColor = Color.white
                },
                active =
                {
                    background = AssetDatabase.LoadAssetAtPath<Texture2D>("Packages/com.starphaselab.rngneeds/Editor/Assets/PL_SectionButtonOn_00000.png"),
                    textColor = Color.white
                },
                alignment = TextAnchor.MiddleCenter,
                fontSize = 13,
                wordWrap = true,
                border = new RectOffset(8, 8, 8, 8),
                padding = new RectOffset(8, 8, 8, 8)
            };

            Initialized = true;
        }

        public static void ShowWindow()
        {
            WelcomeWindow window = (WelcomeWindow)GetWindow(typeof(WelcomeWindow), true, "Welcome to RNGNeeds!");
            window.maxSize = windowSize;
            window.minSize = windowSize;
            window.Show();
        }

        private void OnGUI()
        {
            if (Initialized == false) Initialize();
            EnsureStyleFallbacks();
            
            GUILayout.BeginHorizontal();
                GUILayout.BeginVertical();
                    GUILayout.Label(rngneedsIcon, GUILayout.Width(64f), GUILayout.Height(64f));
                    GUILayout.Label($"RNGNeeds\nv{version}", versionStyle);
                GUILayout.EndVertical();
                GUILayout.BeginVertical();
                    GUILayout.Label("Thank you for installing RNGNeeds.", leadStyle);
                    GUILayout.Label("Welcome to the realm of intuitive probability distribution. We're excited to have you on board and wish you the highest odds of an exceptional RNG journey!", paragraphStyle);
                    if (GUILayout.Button("Open RNGNeeds Preferences"))
                    {
                        SettingsService.OpenUserPreferences("Preferences/RNGNeeds");
                    }
                EditorGUILayout.EndVertical();
            GUILayout.EndHorizontal();

            DrawFollowButton();
            
            DrawSeparator();
            GUILayout.Label("Useful Links", headingStyle);
            DrawLinkButton("Documentation / Manual", RNGNStaticData.LinkDocumentationManual);
            DrawLinkButton("Quick Start Guide", RNGNStaticData.LinkDocsQuickStartGuide);
            DrawLinkButton("Samples Overview", RNGNStaticData.LinkDocsSamplesOverview);
            DrawLinkButton("API Reference", ApiReferenceUrl);
            
            DrawSeparator();
            GUILayout.Label("Importing Samples", headingStyle);
            GUILayout.Label("To import samples, navigate to the RNGNeeds package in the Package Manager (click the button below)", paragraphStyle);
            if (GUILayout.Button("Open RNGNeeds in Package Manager"))
            {
                UnityEditor.PackageManager.UI.Window.Open("com.starphaselab.rngneeds");
            }
            
            GUILayout.Label("Once there, find the 'Samples' section. From the list, simply click the 'Import' button adjacent to the samples you'd like to add to your project.", paragraphStyle);
            
            GUILayout.Label("Detailed step-by-step instructions:", paragraphStyle);
            DrawLinkButton("Importing Samples Guide", RNGNStaticData.LinkDocsImportingSamples);
            
            DrawSeparator();
            
            var controlRect = EditorGUILayout.GetControlRect(false, 68f);
            GUI.BeginGroup(controlRect);
            var mysteryOuterRect = new Rect(0f, 0f, controlRect.width, 68f);
            EditorGUI.DrawRect(mysteryOuterRect, mysteryAccentColor);
            EditorGUI.DrawRect(new Rect(0f, 0f, mysteryOuterRect.width, 1f), mysteryAccentBorderColor);
            EditorGUI.DrawRect(new Rect(0f, mysteryOuterRect.height - 1f, mysteryOuterRect.width, 1f), mysteryAccentBorderColor);
            EditorGUI.DrawRect(new Rect(0f, 0f, 1f, mysteryOuterRect.height), mysteryAccentBorderColor);
            EditorGUI.DrawRect(new Rect(mysteryOuterRect.width - 1f, 0f, 1f, mysteryOuterRect.height), mysteryAccentBorderColor);

            var previousColor = GUI.color;
            GUI.color = new Color(1f, 0.93f, 0.82f);
            var mysteryButtonRect = new Rect(4f, 4f, controlRect.width - 8f, 60f);
            if (GUI.Button(mysteryButtonRect, MysteryButtonText, MysteryButtonStyle)) MysteryButtonText = RandomNeeds[Random.Range(0, RandomNeeds.Length)];
            GUI.color = previousColor;
            GUI.EndGroup();
        }
        
        private void DrawFollowButton()
        {
            GUILayout.Space(6f);
            var controlRect = EditorGUILayout.GetControlRect(false, 46f);
            GUI.BeginGroup(controlRect);

            var backgroundRect = new Rect(0f, 0f, controlRect.width, 42f);
            EditorGUI.DrawRect(backgroundRect, followButtonColor);
            EditorGUI.DrawRect(new Rect(0f, 0f, backgroundRect.width, 1f), followButtonBorderColor);
            EditorGUI.DrawRect(new Rect(0f, backgroundRect.height - 1f, backgroundRect.width, 1f), followButtonBorderColor);
            EditorGUI.DrawRect(new Rect(0f, 0f, 1f, backgroundRect.height), followButtonBorderColor);
            EditorGUI.DrawRect(new Rect(backgroundRect.width - 1f, 0f, 1f, backgroundRect.height), followButtonBorderColor);

            var iconRect = new Rect(10f, 7f, 28f, 28f);
            if (twitterLogo != null)
            {
                GUI.DrawTexture(iconRect, twitterLogo, ScaleMode.ScaleToFit, true);
            }
            else
            {
                EditorGUI.DrawRect(iconRect, new Color(.09f, .11f, .14f));
                GUI.Label(iconRect, "t", followIconStyle);
            }

            GUI.Label(new Rect(48f, 7f, backgroundRect.width - 58f, 16f), "Follow @StarphaseLab on Twitter / X", followTitleStyle);
            GUI.Label(new Rect(48f, 22f, backgroundRect.width - 58f, 14f), "RNG tricks, release news & dev tips", followSubtitleStyle);

            EditorGUIUtility.AddCursorRect(backgroundRect, MouseCursor.Link);
            if (GUI.Button(backgroundRect, GUIContent.none, GUIStyle.none))
            {
                Application.OpenURL(TwitterUrl);
            }

            GUI.EndGroup();
            GUILayout.Space(2f);
        }

        private void EnsureStyleFallbacks()
        {
            leadStyle = leadStyle ?? GUI.skin.label;
            headingStyle = headingStyle ?? GUI.skin.label;
            versionStyle = versionStyle ?? GUI.skin.label;
            docsLinkStyle = docsLinkStyle ?? EditorStyles.linkLabel;
            paragraphStyle = paragraphStyle ?? GUI.skin.label;
            followTitleStyle = followTitleStyle ?? GUI.skin.label;
            followSubtitleStyle = followSubtitleStyle ?? GUI.skin.label;
            followIconStyle = followIconStyle ?? GUI.skin.label;
            MysteryButtonStyle = MysteryButtonStyle ?? GUI.skin.button;
        }

        private void DrawLinkButton(string label, string url)
        {
            var rect = EditorGUILayout.GetControlRect(false, EditorGUIUtility.singleLineHeight);
            EditorGUIUtility.AddCursorRect(rect, MouseCursor.Link);
            if (GUI.Button(rect, label, docsLinkStyle))
            {
                Application.OpenURL(url);
            }
        }

        private void DrawSeparator()
        {
            var controlRect = EditorGUILayout.GetControlRect(true, 10f);
            GUI.BeginGroup(controlRect);
            EditorGUI.DrawRect(new Rect(0f, 4f, controlRect.xMax, 1f), separatorColor);
            GUI.EndGroup();
        }

        private static string EncryptDecrypt(string text, int key)
        {
            var chars = text.ToCharArray();
            for (var i = 0; i < chars.Length; i++)
            {
                chars[i] = (char)(chars[i] ^ key);
            }
            return new string(chars);
        }
    }
}