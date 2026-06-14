using UnityEngine;
using UnityEditor;

public class UltimateDissolveFX_GUI : ShaderGUI
{

    MaterialEditor editor;
    MaterialProperty[] properties;
    bool ShapeMode;

    //get preperties function
    MaterialProperty FindProperty(string name)
    {
        return FindProperty(name, properties);
    }
    //

    ////
    static GUIContent staticLabel = new GUIContent();
    static GUIContent MakeLabel(MaterialProperty property, string tooltip = null)
    {
        staticLabel.text = property.displayName;
        staticLabel.tooltip = tooltip;
        return staticLabel;
    }
    ////

    public override void OnGUI(MaterialEditor editor, MaterialProperty[] properties)
    {
        this.editor = editor;
        this.properties = properties;
        DoMain();

    }


    // GUI FUNCTION	
    void DoMain()
    {
        //--- Logo
        Texture2D myGUITexture = (Texture2D)Resources.Load("UltimateDissolveFX_GUI");
        GUILayout.Label(myGUITexture, EditorStyles.centeredGreyMiniLabel);

        //LABELS
        GUILayout.Label("/---------------/ Ultimate Dissolve FX PACK /---------------/", EditorStyles.centeredGreyMiniLabel);
        GUILayout.Label("COLORS", EditorStyles.helpBox);








        MaterialProperty _ColorMap = FindProperty("_ColorMap");
        editor.ShaderProperty(_ColorMap, MakeLabel(_ColorMap));
       
        float Condition4 = _ColorMap.floatValue;
        
        if (Condition4 == 1)
        {
            MaterialProperty _MainColor = FindProperty("_MainColor");
            editor.ShaderProperty(_MainColor, MakeLabel(_MainColor));
        }
        else
        {
            MaterialProperty _MapMatCap = FindProperty("_MapMatCap");
            editor.ShaderProperty(_MapMatCap, MakeLabel(_MapMatCap));
            float Condition5 = _MapMatCap.floatValue;

            if (Condition5 == 1)
            {
                MaterialProperty _MainColorMap = ShaderGUI.FindProperty("_MainColorMap", properties);
                EditorGUILayout.BeginHorizontal();
                EditorGUILayout.PrefixLabel("Color Map");
                _MainColorMap.textureValue = (Texture)EditorGUILayout.ObjectField(_MainColorMap.textureValue, typeof(Texture), false, GUILayout.Width(100), GUILayout.Height(100));
                EditorGUILayout.EndHorizontal();

                MaterialProperty _MainColorMult = FindProperty("_MainColorMult");
                editor.ShaderProperty(_MainColorMult, MakeLabel(_MainColorMult));

                MaterialProperty _ColorPow = FindProperty("_ColorPow");
                editor.ShaderProperty(_ColorPow, MakeLabel(_ColorPow));

                MaterialProperty _Desaturation = FindProperty("_Desaturation");
                editor.ShaderProperty(_Desaturation, MakeLabel(_Desaturation));
            }
            else
            {
                MaterialProperty _MainMap = ShaderGUI.FindProperty("_MainMap", properties);
                EditorGUILayout.BeginHorizontal();
                EditorGUILayout.PrefixLabel("Main Map");
                _MainMap.textureValue = (Texture)EditorGUILayout.ObjectField(_MainMap.textureValue, typeof(Texture), false, GUILayout.Width(100), GUILayout.Height(100));
                EditorGUILayout.EndHorizontal();

                 
            }

        }

        MaterialProperty _Smoothness = FindProperty("_Smoothness");
        editor.ShaderProperty(_Smoothness, MakeLabel(_Smoothness));

        MaterialProperty _Metallic = FindProperty("_Metallic");
        editor.ShaderProperty(_Metallic, MakeLabel(_Metallic));

        MaterialProperty _UseNormalMap = FindProperty("_UseNormalMap");
        editor.ShaderProperty(_UseNormalMap, MakeLabel(_UseNormalMap));

        float Condition6 = _UseNormalMap.floatValue;
        if (Condition6 == 1)
        {
            MaterialProperty _NormalMap = ShaderGUI.FindProperty("_NormalMap", properties);

            //Add to GUI
            editor.TexturePropertySingleLine(MakeLabel(_NormalMap, "_NormalMap Map"), _NormalMap);
        }


        // Map 
        // get properties





        //MaterialProperty _MainColorMult2 = FindProperty("_MainColorMult2");
        //editor.ShaderProperty(_MainColorMult2, MakeLabel(_MainColorMult2));



        // DISSOLVE MASK
        // get properties
        GUILayout.Label("Ultimate Dissolve", EditorStyles.helpBox);
        MaterialProperty _MaskMap = ShaderGUI.FindProperty("_MaskMap", properties);
        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.PrefixLabel("Dissolve Mask Map");
        _MaskMap.textureValue = (Texture)EditorGUILayout.ObjectField(_MaskMap.textureValue, typeof(Texture), false, GUILayout.Width(100), GUILayout.Height(100));
        EditorGUILayout.EndHorizontal();

        /*
        MaterialProperty _MaskMap = ShaderGUI.FindProperty("_MaskMap", properties);

        //Add to GUI
        editor.TexturePropertySingleLine(MakeLabel(_MaskMap, "Dissolve Map"), _MaskMap);
        */


        //TILING
        MaterialProperty _Tiling = FindProperty("_Tiling");
        editor.ShaderProperty(_Tiling, MakeLabel(_Tiling));



        // dissolve shape
        //GUILayout.Label("Element Shape [By Default Dots]", EditorStyles.helpBox);


        

        // Pattern Settings
        GUILayout.Label("Pattern Settings", EditorStyles.helpBox);

        //MaterialProperty _Subdivisions = FindProperty("_Subdivisions");
        //editor.ShaderProperty(_Subdivisions, MakeLabel(_Subdivisions));

        MaterialProperty _Subdivision = FindProperty("_Subdivision");
        editor.ShaderProperty(_Subdivision, MakeLabel(_Subdivision));
		
		//Shape
       
GUILayout.Label("Element Shape [By Default Dots]", EditorStyles.centeredGreyMiniLabel);
        MaterialProperty _CustomTexture = FindProperty("_CustomTexture");
        editor.ShaderProperty(_CustomTexture, MakeLabel(_CustomTexture));

        float Condition = _CustomTexture.floatValue;
        if (Condition == 1)
        {
            //Custom texture
            // get properties
            /*
            MaterialProperty _Pattern = ShaderGUI.FindProperty("_Pattern", properties);

            //Add to GUI
            editor.TexturePropertySingleLine(MakeLabel(_Pattern, "Custom shape Tex"), _Pattern);
            */

            MaterialProperty _Pattern = ShaderGUI.FindProperty("_Pattern", properties);
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.PrefixLabel("Custom shape Tex");
            _Pattern.textureValue = (Texture)EditorGUILayout.ObjectField(_Pattern.textureValue, typeof(Texture), false, GUILayout.Width(100), GUILayout.Height(100));
            EditorGUILayout.EndHorizontal();
        }

        MaterialProperty _SizeWhenTransition = FindProperty("_SizeWhenTransition");
        editor.ShaderProperty(_SizeWhenTransition, MakeLabel(_SizeWhenTransition));


        // Animation Settings
        GUILayout.Label("Animation Settings", EditorStyles.helpBox);

        MaterialProperty _ManualAutomatic = FindProperty("_ManualAutomatic");
        editor.ShaderProperty(_ManualAutomatic, MakeLabel(_ManualAutomatic));
        float Condition3 = _ManualAutomatic.floatValue;
        if (Condition3 == 0)
        {
            MaterialProperty _ManualTransition = FindProperty("_ManualTransition");
            editor.ShaderProperty(_ManualTransition, MakeLabel(_ManualTransition));

        }
        else
        {
            MaterialProperty _Transition = FindProperty("_Transition");
            editor.ShaderProperty(_Transition, MakeLabel(_Transition));
        }

        

        MaterialProperty _Exp = FindProperty("_Exp");
        editor.ShaderProperty(_Exp, MakeLabel(_Exp));

        

       MaterialProperty _TransitionXvsY = FindProperty("_TransitionXvsY");
        editor.ShaderProperty(_TransitionXvsY, MakeLabel(_TransitionXvsY));

        MaterialProperty _InverseDirection = FindProperty("_InverseDirection");
        editor.ShaderProperty(_InverseDirection, MakeLabel(_InverseDirection));

        MaterialProperty _InverseAnimation = FindProperty("_InverseAnimation");
        editor.ShaderProperty(_InverseAnimation, MakeLabel(_InverseAnimation));




        // Transition Settings
        GUILayout.Label("Transition Settings", EditorStyles.helpBox);

        MaterialProperty _UseMainTexture = FindProperty("_UseMainTexture");
        editor.ShaderProperty(_UseMainTexture, MakeLabel(_UseMainTexture));
        float Condition9 = _UseMainTexture.floatValue;
        if (Condition9 == 0)
        {
            MaterialProperty _ColorTransition = FindProperty("_ColorTransition");
            editor.ShaderProperty(_ColorTransition, MakeLabel(_ColorTransition));
        }

        MaterialProperty _EmissiveFctor = FindProperty("_EmissiveFctor");
        editor.ShaderProperty(_EmissiveFctor, MakeLabel(_EmissiveFctor));



        MaterialProperty _SharpTransition = FindProperty("_SharpTransition");
        editor.ShaderProperty(_SharpTransition, MakeLabel(_SharpTransition));

        ///////// Details
        MaterialProperty _DETAILES = FindProperty("_DETAILES");
        editor.ShaderProperty(_DETAILES, MakeLabel(_DETAILES));
        float Condition2 = _DETAILES.floatValue;
        if (Condition2 == 1)
        {
            MaterialProperty _STEP = FindProperty("_STEP");
            editor.ShaderProperty(_STEP, MakeLabel(_STEP));
        }


        MaterialProperty _Distortion = FindProperty("_Distortion");
        editor.ShaderProperty(_Distortion, MakeLabel(_Distortion));


        ///////// Distortion Mask Transition
        MaterialProperty _TransitionFactor = FindProperty("_TransitionFactor");
        editor.ShaderProperty(_TransitionFactor, MakeLabel(_TransitionFactor));



        ///// DISPLACEMENT
        GUILayout.Label("Displacement Settings", EditorStyles.helpBox);

        //Normal
        MaterialProperty _NormalizedRotationAxis = FindProperty("_NormalizedRotationAxis");
        editor.ShaderProperty(_NormalizedRotationAxis, MakeLabel(_NormalizedRotationAxis));

        

			MaterialProperty _OffsetPivot = FindProperty("_OffsetPivot");
            editor.ShaderProperty(_OffsetPivot, MakeLabel(_OffsetPivot));
			
			GUILayout.Label("--IF YOU NEED TO OVERRIDE OBJ PIVOT POSITION--", EditorStyles.centeredGreyMiniLabel);
			MaterialProperty _CustomPivot = FindProperty("_CustomPivot");
        editor.ShaderProperty(_CustomPivot, MakeLabel(_CustomPivot));
        float Condition8 = _CustomPivot.floatValue;

        if (Condition8 == 1)
        {
            MaterialProperty _CustomPivotVec = FindProperty("_CustomPivotVec");
            editor.ShaderProperty(_CustomPivotVec, MakeLabel(_CustomPivotVec));
        }

        
        

        MaterialProperty _Push = FindProperty("_Push");
        editor.ShaderProperty(_Push, MakeLabel(_Push));

        MaterialProperty _Angle = FindProperty("_Angle");
        editor.ShaderProperty(_Angle, MakeLabel(_Angle));



        /*
        // MASK
        // get properties
        MaterialProperty _MASK_ = ShaderGUI.FindProperty("_MASK_", properties);

        //Add to GUI
        editor.TexturePropertySingleLine(MakeLabel(_MASK_, "Mask Map"), _MASK_);

        // Ring
        // get properties
        MaterialProperty _Ring = ShaderGUI.FindProperty("_Ring", properties);

        //Add to GUI
        editor.TexturePropertySingleLine(MakeLabel(_Ring, "Ring Map"), _Ring);



        //Outline Map
        // get properties
        MaterialProperty _Outline = ShaderGUI.FindProperty("_Outline", properties);

        //Add to GUI
        editor.TexturePropertySingleLine(MakeLabel(_Outline, "Outline Map"), _Outline);


        GUILayout.Label("Colors Settings", EditorStyles.helpBox);

        MaterialProperty _SurfaceOpacity = FindProperty("_SurfaceOpacity");
        editor.ShaderProperty(_SurfaceOpacity, MakeLabel(_SurfaceOpacity));

        MaterialProperty _ColorsHue = FindProperty("_ColorsHue");
        editor.ShaderProperty(_ColorsHue, MakeLabel(_ColorsHue));

        GUILayout.Label("Outline Settings", EditorStyles.helpBox);
        MaterialProperty _OutlineMult = FindProperty("_OutlineMult");
        editor.ShaderProperty(_OutlineMult, MakeLabel(_OutlineMult));

        MaterialProperty _TransitionOutlineMult = FindProperty("_TransitionOutlineMult");
        editor.ShaderProperty(_TransitionOutlineMult, MakeLabel(_TransitionOutlineMult));

        GUILayout.Label("Image Distortion Settings", EditorStyles.helpBox);
        MaterialProperty _ChromaticAberationMult = FindProperty("_ChromaticAberationMult");
        editor.ShaderProperty(_ChromaticAberationMult, MakeLabel(_TransitionOutlineMult));

        MaterialProperty _BlurMult = FindProperty("_BlurMult");
        editor.ShaderProperty(_BlurMult, MakeLabel(_BlurMult));

        GUILayout.Label("Displacement Settings", EditorStyles.helpBox);
        MaterialProperty _PushMult = FindProperty("_PushMult");
        editor.ShaderProperty(_PushMult, MakeLabel(_PushMult));

        GUILayout.Label("Dynamic Settings", EditorStyles.helpBox);
        MaterialProperty _WallOpening = FindProperty("_WallOpening");
        editor.ShaderProperty(_WallOpening, MakeLabel(_WallOpening));

        MaterialProperty _SpeedAnimatedMode = FindProperty("_SpeedAnimatedMode");
        editor.ShaderProperty(_SpeedAnimatedMode, MakeLabel(_SpeedAnimatedMode));

        MaterialProperty _AnimatedOpening = FindProperty("_AnimatedOpening");
        editor.ShaderProperty(_AnimatedOpening, MakeLabel(_AnimatedOpening));


        GUILayout.Label("Debug Settings", EditorStyles.helpBox);
        MaterialProperty _DebugColor = FindProperty("_DebugColor");
        editor.ShaderProperty(_DebugColor, MakeLabel(_DebugColor));

    */


    }
}