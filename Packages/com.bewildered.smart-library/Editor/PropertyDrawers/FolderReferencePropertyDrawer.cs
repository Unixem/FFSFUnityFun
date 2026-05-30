using System;
using System.Linq;
using UnityEngine.UIElements;
using UnityEditor;
using UnityEditor.UIElements;

namespace Bewildered.SmartLibrary.UI
{
    [CustomPropertyDrawer(typeof(FolderReference))]
    internal class FolderReferencePropertyDrawer : PropertyDrawer
    {
        public static readonly string ussClassName = "bewildered-library-folder-reference";
        private static readonly string _matchOptionUssClassName = ussClassName + "__match-option";
        private static readonly string _folderUssClassName = ussClassName + "__folder";

        public override VisualElement CreatePropertyGUI(SerializedProperty property)
        {
            var rootElement = new VisualElement();
            rootElement.AddToClassList(ussClassName);

            var stateLabel = new Label("assets");

            var includeToggle = new SelectToggle();
            includeToggle.tooltip = "Whether to include or exclude files from this folder.";
            includeToggle.BindProperty(property.FindPropertyRelative("_doInclude"));
            includeToggle.FormatSelectedValue = v => v ? "Include" : "Exclude";
            includeToggle.FormatDropdownValue = v => v ? "Include" : "Exclude";
            rootElement.Add(includeToggle);

            rootElement.Add(stateLabel);
            
            // Must be an int field inorder for an enum property to bind to it.
            var filterTypeField = new PopupField<int>(Enum.GetValues(typeof(FolderMatchOption)).Cast<int>().ToList(), 
                (int)FolderMatchOption.AnyDepth,
                FormatSelectedValueCallback,
                FormatListItemCallback);
            filterTypeField.RegisterValueChangedCallback(evt =>
            {
                stateLabel.text = evt.newValue == (int)FolderMatchOption.AnyDepth ? "assets at" : "assets";
            });
            filterTypeField.AddToClassList(_matchOptionUssClassName);
            filterTypeField.BindProperty(property.FindPropertyRelative("_matchOption"));
            rootElement.Add(filterTypeField);

            var inLabel = new Label("in");
            rootElement.Add(inLabel);
            
            var field = new FolderField();
            field.AddToClassList(_folderUssClassName);
            field.BindProperty(property.FindPropertyRelative("_folderGuid"));
            rootElement.Add(field);

            return rootElement;
        }

        private string FormatListItemCallback(int option)
        {
            return (FolderMatchOption)option switch
            {
                FolderMatchOption.AnyDepth => "Any Depth",
                FolderMatchOption.TopOnly => "Direct",
                _ => throw new ArgumentOutOfRangeException(nameof(option), option, null)
            };
        }

        private string FormatSelectedValueCallback(int option)
        {
            return (FolderMatchOption)option switch
            {
                FolderMatchOption.AnyDepth => "Any Depth",
                FolderMatchOption.TopOnly => "Directly",
                _ => throw new ArgumentOutOfRangeException(nameof(option), option, null)
            };
        }
    }

}