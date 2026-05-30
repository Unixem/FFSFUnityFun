using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
#if UNITY_EDITOR
using UnityEditor;
#endif

namespace TeoGames.Mesh_Combiner.Scripts.Util {
#if UNITY_EDITOR
	[InitializeOnLoad]
#endif
	public static class StaticCache {
		private static readonly List<Action> ClearCallbacks = new List<Action>();
		private static readonly List<Action> ValidateCallbacks = new List<Action>();
		private static bool _Initialized;

#if UNITY_EDITOR
		static StaticCache() {
			EditorApplication.playModeStateChanged += state => {
				if (state == PlayModeStateChange.ExitingEditMode ||
				    state == PlayModeStateChange.ExitingPlayMode) ClearAll();
			};
		}
#endif

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void Init() {
			if (_Initialized) return;
			_Initialized = true;

			SceneManager.sceneUnloaded += _ => Validate();
		}

		public static void Register(Action clearAction, Action validateAction = null) {
			Init();
			ClearCallbacks.Add(clearAction);
			if (validateAction != null) ValidateCallbacks.Add(validateAction);
		}

		public static void ClearAll() {
			for (var i = 0; i < ClearCallbacks.Count; i++) ClearCallbacks[i]();
		}

		public static void Validate() {
			for (var i = 0; i < ValidateCallbacks.Count; i++) ValidateCallbacks[i]();
		}
	}
}
