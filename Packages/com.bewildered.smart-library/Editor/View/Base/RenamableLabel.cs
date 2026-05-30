using UnityEngine;
using UnityEngine.UIElements;

namespace Bewildered.SmartLibrary.UI
{
    /// <summary>
    /// A label that can be renamed when double-clicked.
    /// </summary>
    internal class RenamableLabel : TextElement
    {
        public new static readonly string ussClassName = "bewildered-renamable-label";
        public static readonly string fieldUssClassName = ussClassName + "__field";
        public static readonly string editingUssClassName = ussClassName + "--editing";

        /// <summary>
        /// The field used for renaming the label.
        /// </summary>
        public TextField fieldElement { get; }

        public bool canBeRenamed { get; set; }

        public RenamableLabel()
        {
            AddToClassList(ussClassName);
            RegisterCallback<MouseDownEvent>(OnMouseDown);

            fieldElement = new TextField
            {
                isDelayed = true,
            };
            fieldElement.AddToClassList(fieldUssClassName);
            fieldElement.RegisterValueChangedCallback(OnFieldValueChange);
            
#if UNITY_6000_0_OR_NEWER
#else
            fieldElement.SetDisplay(false);
#endif
            
            fieldElement.Q(TextField.textInputUssName).RegisterCallback<KeyDownEvent>(OnInputFieldKeyDown);
            fieldElement.RegisterCallback<FocusOutEvent>(evt => EndRenaming());     
            
            Add(fieldElement);
        }
        
        public void BeginRenaming()
        {
            if (canBeRenamed)
            {
                fieldElement.SetValueWithoutNotify(text);
                AddToClassList(editingUssClassName);
#if UNITY_6000_0_OR_NEWER
#else
                fieldElement.SetDisplay(true);
#endif
                
#if UNITY_6000_0_OR_NEWER
                // Unity change it so you can't focus a display:none element, and change is not processed immediately,
                // so we have to delay until it registers th change in display.
                fieldElement.schedule.Execute(fieldElement.Focus).ExecuteLater(10);
#else
                fieldElement.Q(TextField.textInputUssName).Focus();
#endif
            }
        }

        private void OnMouseDown(MouseDownEvent evt)
        {
            if (evt.clickCount == 2)
                BeginRenaming();
        }

        private void EndRenaming()
        {
            RemoveFromClassList(editingUssClassName);
            
#if UNITY_6000_0_OR_NEWER
#else
            fieldElement.SetDisplay(false);
#endif
            
        }

        private void OnFieldValueChange(ChangeEvent<string> evt)
        {
            text = evt.newValue;
        }

        private void OnInputFieldKeyDown(KeyDownEvent evt)
        {
            if (evt.keyCode == KeyCode.Return)
                EndRenaming();
        }
    }
}
