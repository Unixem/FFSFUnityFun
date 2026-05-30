using System.Collections.Generic;
using System.Linq;
using TeoGames.Mesh_Combiner.Scripts.Extension;
using UnityEngine;

namespace TeoGames.Mesh_Combiner.Scripts.Combine.CombinedMaterial.MaterialBake.Texture {
	[CreateAssetMenu(
		menuName = "Mesh Combiner/MC Material Baker/Texture Baker Settings",
		fileName = "Texture Baker Settings"
	)]
	public class TextureBaker : AbstractShaderBaker {
		[SerializeField] private Material opaqueMaterial;
		[SerializeField] private Material transparentMaterial;
		[SerializeField] private TextureInfo[] textures;
		[SerializeField] private ShaderConfig[] shaders;
		[SerializeField] private int outputSize = 4048;
		[SerializeField] private int maxTextureSize = 1024;
		[SerializeField] private int colorBlockSize = 3;
		[SerializeField] private float smoothness;
		[SerializeField] private string[] keywords;

		private Material _Material;
		private TextureInfo _MainTexture;
		private Texture2D _FillTex;
		private int _ID;

		private readonly Dictionary<Shader, string> _MainColorProperty = new Dictionary<Shader, string>();
		private readonly List<RectInt> _FreeAreas = new List<RectInt>();

		private readonly Dictionary<TextureInfo, (MaterialTextureInfo info, int size, bool isTexture)> _AllSizes =
			new Dictionary<TextureInfo, (MaterialTextureInfo info, int size, bool isTexture)>();

		private void Awake() {
			textures.ForEach(
				t => {
					if (t.isDiffuseTexture) _MainTexture = t;
				}
			);

			_MainColorProperty.Clear();
			shaders.ForEach(
				s => {
					s.NameToProperty = s.properties.ToDictionary(
						p => p.textureName, p => {
							if (p.textureName == _MainTexture.textureName && p.colorPropertyName.Trim() != "") {
								_MainColorProperty.Add(s.shader, p.colorPropertyName);
							}

							return p;
						}
					);
				}
			);
		}

		public override void Inject(MaterialBaker instance) {
			shaders.ForEach(s => instance.RegisterBaker(s.shader, this));
		}

		protected override void Initialize(Material material) => ResetData(material);

		public override bool IsValidMaterial(Material material) {
			return Application.isPlaying && (material.GetTexture(_MainTexture.textureName) ||
			                                 _MainColorProperty.ContainsKey(material.shader));
		}

		protected override (Material bakedMaterial, MeshParser meshParser) BakeMaterial(Material material) =>
			BakeMaterial(material, false);

		private (Material bakedMaterial, MeshParser meshParser) BakeMaterial(Material material, bool isRetry) {
			var shader = shaders.First(s => s.shader == material.shader);
			var props = shader.NameToProperty;

			_AllSizes.Clear();
			textures.ForEach(
				t => {
					if (!props.TryGetValue(t.textureName, out var conf)) return;

					var tex = material.GetTexture(conf.shaderPropertyName);
					if (tex) {
						InitTexture(t);
						_AllSizes.Add(t, (conf, GetTexSize(tex), true));
					} else if (conf.colorPropertyName.Trim() != "") {
						InitTexture(t);
						_AllSizes.Add(t, (conf, colorBlockSize, false));
					}
				}
			);
			var size = FixSize(GetTexSize(_AllSizes), maxTextureSize);
			var rect = FindFreeArea(size, size);
			if (rect is { width: 0, height: 0 }) {
				if (isRetry) {
					Debug.LogWarning($"[MeshCombiner] Texture size {size}x{size} exceeds atlas size {outputSize}x{outputSize} for material '{material.name}'. Skipping bake.");
					return (material, null);
				}

				ResetData(material);
				return BakeMaterial(material, true);
			}

			_AllSizes.ForEach(
				pair => {
					var info = pair.Key;
					var data = pair.Value;
					if (data.isTexture) {
						var tex = material.GetTexture(data.Item1.shaderPropertyName) as Texture2D;
						tex.MarkAsReadable();
						var cpy = Resize(tex, size, size, info.format);
						info.texture.SetPixels(rect.x, rect.y, size, size, cpy.GetPixels());
						info.texture.Apply();
						Object.Destroy(cpy);
					} else {
						var col = material.GetColor(data.Item1.colorPropertyName);
						Fill(info.texture, col, rect);
					}
				}
			);

			var scale = new Vector2((float)size / outputSize, (float)size / outputSize);
			var offset = new Vector2((float)rect.x / outputSize, (float)rect.y / outputSize);
			if (!material.HasTextures()) {
				scale *= .5f;
				offset += scale / 2;
			}

			return (_Material, new MeshParser(scale, offset));
		}

		private void ResetData(Material material) {
			textures.ForEach(t => t.texture = null);

			_FreeAreas.Clear();
			_FreeAreas.Add(new RectInt(0, 0, outputSize, outputSize));

			var basicMat = material.renderQueue >= 3000 ? transparentMaterial : opaqueMaterial;
			_Material = new Material(basicMat) {
				name = $"[{material.renderQueue}] [TEX:{_ID++:00}] {basicMat.shader.name}",
				renderQueue = material.renderQueue,
			};

			_Material.SetFloat("_Smoothness", smoothness);
			keywords.ForEach(_Material.EnableKeyword);
			InitTexture(textures.First(t => t.isDiffuseTexture));
		}

		private void InitTexture(TextureInfo t) {
			if (t.texture) return;

			_Material.SetTexture(
				t.textureName, t.texture = new Texture2D(outputSize, outputSize, t.format, false, t.linear) {
					filterMode = t.filterMode,
					name = $"[B] {t.textureName}",
				}
			);
			Fill(t.texture, t.defaultColor);
			t.keywords.ForEach(_Material.EnableKeyword);
		}

		private void BlitToTexture(UnityEngine.Texture source, Texture2D dest, int x, int y, int width, int height,
			Vector2? scale = null, Vector2? offset = null) {
			var rt = new RenderTexture(width, height, 24);
			RenderTexture.active = rt;
			Graphics.Blit(source, rt, scale ?? Vector2.one, offset ?? Vector2.zero);
			dest.ReadPixels(new Rect(0, 0, width, height), x, y);
			dest.Apply();
			RenderTexture.active = null;
			rt.Release();
			Object.Destroy(rt);
		}

		private Texture2D Resize(Texture2D texture2D, int targetX, int targetY, TextureFormat format) {
			var result = new Texture2D(targetX, targetY, format, false, false);
			BlitToTexture(texture2D, result, 0, 0, targetX, targetY);
			return result;
		}

		private void Fill(Texture2D tex, Color color) => Fill(tex, color, new RectInt(0, 0, tex.width, tex.height));

		private void Fill(Texture2D tex, Color color, RectInt rect) {
			if (!_FillTex) _FillTex = new Texture2D(1, 1, TextureFormat.RGBA32, false, false);
			_FillTex.SetPixel(0, 0, color);
			_FillTex.Apply();

			BlitToTexture(_FillTex, tex, rect.x, rect.y, rect.width, rect.height,
				new Vector2(rect.width, rect.width), Vector2.zero);
		}

		private int FixSize(int val, int max) => 1 << Mathf.RoundToInt(Mathf.Log(Mathf.Min(val, max), 2));

		private int GetTexSize(Dictionary<TextureInfo, (MaterialTextureInfo info, int size, bool isTexture)> sizes) {
			return sizes.TryGetValue(_MainTexture, out var size) && size.isTexture
				? size.size
				: sizes.Values.OrderByDescending(p => p.size).First().size;
		}

		private int GetTexSize(UnityEngine.Texture tex) {
			if (!tex) return colorBlockSize;

			return tex.width > tex.height ? tex.width : tex.height;
		}

		// Function to find a free area in the texture atlas for a given texture size
		private RectInt FindFreeArea(int width, int height) {
			var bestArea = new RectInt(0, 0, 0, 0);
			var bestShortSide = int.MaxValue;
			var bestLongSide = int.MaxValue;

			// Loop through the free areas to find a suitable one
			foreach (var freeArea in _FreeAreas) {
				if (freeArea.width >= width && freeArea.height >= height) {
					var leftoverX = freeArea.width - width;
					var leftoverY = freeArea.height - height;
					var shortSide = Mathf.Min(leftoverX, leftoverY);
					var longSide = Mathf.Max(leftoverX, leftoverY);

					if (shortSide < bestShortSide || (shortSide == bestShortSide && longSide < bestLongSide)) {
						bestArea = freeArea;
						bestShortSide = shortSide;
						bestLongSide = longSide;
					}
				}
			}

			if (bestArea.width > 0) {
				UpdateFreeAreas(bestArea, width, height);
				return new RectInt(bestArea.x, bestArea.y, width, height);
			}

			// No suitable free area found
			return new RectInt(0, 0, 0, 0);
		}

		private void UpdateFreeAreas(RectInt used, int width, int height) {
			var cpy = _FreeAreas.ToArray();
			_FreeAreas.Clear();

			foreach (var area in cpy) {
				if (area.Overlaps(used)) {
					if (area.width <= area.height) {
						AddFreeArea(new RectInt(area.x, area.y + height, area.width, area.height - height));
						AddFreeArea(new RectInt(area.x + width, area.y, area.width - width, height));
					} else {
						AddFreeArea(new RectInt(area.x + width, area.y, area.width - width, area.height));
						AddFreeArea(new RectInt(area.x, area.y + height, width, area.height - height));
					}
				} else {
					AddFreeArea(area);
				}
			}
		}
		
		private void AddFreeArea(RectInt area) {
			if (area.width <= 0 || area.height <= 0) return;
			
			_FreeAreas.Add(area);
		}
	}
}