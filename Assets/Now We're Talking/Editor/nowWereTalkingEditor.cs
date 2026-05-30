using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace NWT
{
    [CustomEditor(typeof(nowWereTalking))]
    public class nowWereTalkingEditor : Editor
    {
        private static readonly string[] Excludes = new string[] {"m_Script", "useMicrophone", "selectedMicrophone"};

        private SerializedProperty _useMicrophone;
        private SerializedProperty _selectedMicrophone;
        private int _deviceID;

        private void OnEnable()
        {
            _useMicrophone = serializedObject.FindProperty("useMicrophone");
            _selectedMicrophone = serializedObject.FindProperty("selectedMicrophone");
        }

        public override void OnInspectorGUI()
        {
            serializedObject.Update();

            DrawPropertiesExcluding(serializedObject, Excludes);

            EditorGUILayout.Separator();

            EditorGUILayout.PropertyField(_useMicrophone);

            if (_useMicrophone.boolValue && Microphone.devices.Length > 0)
            {
                EditorGUI.BeginChangeCheck();
                _deviceID = EditorGUILayout.Popup("Microphone", _deviceID, Microphone.devices, EditorStyles.popup);
                if (_selectedMicrophone.stringValue == "" || EditorGUI.EndChangeCheck())
                {
                    _selectedMicrophone.stringValue = Microphone.devices[_deviceID];
                }
            }

            Repaint();
            serializedObject.ApplyModifiedProperties();
        }
    }
}