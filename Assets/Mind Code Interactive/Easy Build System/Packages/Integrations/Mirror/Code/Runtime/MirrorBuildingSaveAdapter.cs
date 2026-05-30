/// <summary>
/// Project : Easy Build System
/// Class : MirrorBuildingSaverAdapter.cs
/// Namespace : MindCodeInteractive.EasyBuildSystem.Packages.Integrations.Mirror.Code.Runtime
/// Copyright : © 2015 - 2026 Mind Code Interactive
/// </summary>

#if EASY_BUILD_SYSTEM_MIRROR

using UnityEngine;

using Mirror;

using MindCodeInteractive.EasyBuildSystem.Framework.Code.Runtime.Systems.Managers;
using MindCodeInteractive.EasyBuildSystem.Framework.Code.Runtime.Systems.Managers.Implementations.Save.Data;
using MindCodeInteractive.EasyBuildSystem.Framework.Code.Runtime.Systems.Networking.Interfaces;
using MindCodeInteractive.EasyBuildSystem.Framework.Code.Runtime.Systems.Parts;
using MindCodeInteractive.EasyBuildSystem.Framework.Code.Runtime.Systems.Parts.Data;

namespace MindCodeInteractive.EasyBuildSystem.Packages.Integrations.Mirror.Code.Runtime
{
    public class MirrorBuildingSaveAdapter : MonoBehaviour, INetworkBuildingSaveAdapter
    {
        private bool m_loaded;

        public bool IsAuthority => NetworkServer.active;

        public bool ShouldSaveLocally => NetworkServer.active;

        private void Awake()
        {
            BuildingManager manager = BuildingManager.Instance;

            if (manager?.SaveSystem != null)
            {
                manager.SaveSettings.SaveMode = SaveModeType.Manual;
                manager.SaveSettings.AutoSave = false;
            }

            BuildingManager.SetNetworkSaveAdapter(this);
        }

        private void OnDestroy()
        {
            BuildingManager.SetNetworkSaveAdapter(null);
        }

        private void FixedUpdate()
        {
            if (!NetworkServer.active || m_loaded)
            {
                return;
            }

            BuildingManager.Instance?.SaveSystem?.LoadBuildings();
            m_loaded = true;
        }

        private void OnApplicationQuit()
        {
            if (NetworkServer.active)
            {
                BuildingManager.Instance?.SaveSystem?.SaveBuildings();
            }
        }

        public void OnBeforeLoad() { }

        public void OnAfterLoad() { }

        public void SpawnLoadedBuilding(BuildingPartData data)
        {
            if (!NetworkServer.active)
            {
                return;
            }

            BuildingPart prefab = BuildingManager.Instance?.GetPartByPrefabId(data.PrefabId);
            if (prefab == null)
            {
                return;
            }

            GameObject obj = Instantiate(prefab.gameObject, data.Position, data.Rotation);
            if (obj == null)
            {
                return;
            }

            obj.transform.localScale = data.Scale;

            BuildingPart part = obj.GetComponent<BuildingPart>();
            if (part != null)
            {
                part.LoadSaveData(data);
            }

            NetworkServer.Spawn(obj);
        }
    }
}

#endif