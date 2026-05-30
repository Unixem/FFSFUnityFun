using System;
using System.Collections.Generic;
using UnityEditor.UIElements;
using UnityEngine.UIElements;

namespace Bewildered.SmartLibrary.UI
{
    /// <summary>
    /// A toggle using a dropdown to select the state.
    /// </summary>
#if UNITY_6000_0_OR_NEWER
    [UxmlElement]
    public partial class SelectToggle : BaseField<bool>
#else
    public class SelectToggle : BaseField<bool>
#endif
    {
        public new static readonly string ussClassName = "bewildered-library-selector-toggle";
        public static readonly string dropdownUssClassName = ussClassName + "__dropdown";
        
        public Func<bool, string> FormatSelectedValue { get; set; }
        public Func<bool, string> FormatDropdownValue { get; set; }
        
        private PopupField<bool> _dropdown;

        public SelectToggle() : this("") { }
        
        public SelectToggle(string label) : this(label, new VisualElement()) { }
        
        private SelectToggle(string label, VisualElement visualInput) : base(label, visualInput)
        {
            AddToClassList(ussClassName);
            
            _dropdown = new PopupField<bool>(new List<bool>() { false, true }, 
                defaultValue: false,
                formatSelectedValueCallback: HandleFormatSelectedValue,
                formatListItemCallback: HandleFormatDropdownValue);

            _dropdown.RegisterValueChangedCallback(HandleDropdownValueChanged);
            _dropdown.AddToClassList(dropdownUssClassName);
            
            visualInput.Add(_dropdown);
        }

        private void HandleDropdownValueChanged(ChangeEvent<bool> evt)
        {
            value = evt.newValue;
        }

        private string HandleFormatSelectedValue(bool value)
        {
            if (FormatSelectedValue != null)
                return FormatSelectedValue(value);

            return value ? "On" : "Off";
        }
        
        private string HandleFormatDropdownValue(bool value)
        {
            if (FormatDropdownValue != null)
                return FormatDropdownValue(value);

            return value ? "On" : "Off";
        }

        public override void SetValueWithoutNotify(bool newValue)
        {
            base.SetValueWithoutNotify(newValue);
            _dropdown.SetValueWithoutNotify(newValue);
        }
        
#if !UNITY_6000_0_OR_NEWER
        /// <summary>
        /// Instantiates a SelectToggle using the data read from a UXML file.
        /// </summary>
        public new class UxmlFactory : UxmlFactory<SelectToggle, SelectToggle.UxmlTraits>
        {
        }

        /// <summary>
        /// Defines UxmlTraits for the SelectToggle.
        /// </summary>
        public new class UxmlTraits : VisualElement.UxmlTraits
        {
        }
#endif
    }
}