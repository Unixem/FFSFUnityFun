using TeoGames.Mesh_Combiner.Scripts.Extension;
using TeoGames.Mesh_Combiner.Scripts.Profile;
using UnityEngine;
using UnityEngine.Rendering;

namespace TeoGames.Mesh_Combiner.Scripts.Combine.MeshRendererManager {
	public class StaticMeshRenderer : AbstractMeshRenderer {
		private readonly MeshRenderer _Renderer;
		private readonly MeshFilter _Filter;

		public override Renderer Renderer => _Renderer;

		public StaticMeshRenderer(ShadowCastingMode shadow, IndexFormat indexFormat, GameObject obj) : base(shadow, indexFormat) {
			obj.name = $"[MR] [S={shadow.ToString()}] {obj.name}";
			obj.isStatic = !Application.isPlaying;

			_Filter = obj.AddComponent<MeshFilter>();

			_Renderer = obj.AddComponent<MeshRenderer>();
			_Renderer.shadowCastingMode = shadow;
		}

		public override bool Validate(bool blendShapes, bool isStatic, ShadowCastingMode shadow) =>
			isStatic && shadow == Shadow;

		public override Renderer BuildRenderer() {
			if (!IsChanged) {
				ProfilerModule.MeshRenderers.Value++;
				return _Renderer;
			}

			IsChanged = false;

			var isEnabled = ShouldBeActive;
			_Renderer.gameObject.SetActive(isEnabled);
			if (!isEnabled) return null;

			ProfilerModule.MeshRenderers.Value++;

			_Filter.sharedMesh = OutMesh;

			// Assign materials
			_Renderer.materials = Materials.Convert(m => m.material);
			return _Renderer;
		}
	}
}