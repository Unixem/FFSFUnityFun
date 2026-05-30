/// <summary>
/// Project : Easy Build System
/// Class : MirrorBuildingControllerAdapter.cs
/// Namespace : MindCodeInteractive.EasyBuildSystem.Packages.Integrations.Mirror.Code.Runtime
/// Copyright : © 2015 - 2026 Mind Code Interactive
/// </summary>

#if EASY_BUILD_SYSTEM_MIRROR

using UnityEngine;

using Mirror;

using MindCodeInteractive.Common.Framework.Code.Runtime.Systems.EventSystem;
using MindCodeInteractive.EasyBuildSystem.Framework.Code.Runtime.Systems.Commands.Implementations;
using MindCodeInteractive.EasyBuildSystem.Framework.Code.Runtime.Systems.Controllers.States.Events;
using MindCodeInteractive.EasyBuildSystem.Framework.Code.Runtime.Systems.Managers;
using MindCodeInteractive.EasyBuildSystem.Framework.Code.Runtime.Systems.Networking.Interfaces;
using MindCodeInteractive.EasyBuildSystem.Framework.Code.Runtime.Systems.Parts;
using MindCodeInteractive.EasyBuildSystem.Framework.Code.Runtime.Systems.Sockets;

namespace MindCodeInteractive.EasyBuildSystem.Packages.Integrations.Mirror.Code.Runtime
{
    [RequireComponent(typeof(NetworkIdentity))]
    public class MirrorBuildingControllerAdapter : NetworkBehaviour, INetworkBuildingControllerAdapter
    {
        public bool IsConnected => NetworkClient.isConnected;

        private void Start()
        {
            BuildingManager.SetNetworkAdapter(this);
        }

        private void OnDestroy()
        {
            BuildingManager.SetNetworkAdapter(null);
        }

        public void ExecutePlaceCommand(BuildingPart part, Vector3 position, Quaternion rotation, Vector3 scale, BuildingSocket socket = null)
        {
            string socketId = socket != null ? socket.UniqueId : string.Empty;
            CmdPlace(part.PrefabId, position, rotation, scale, socketId);
        }

        public void ExecuteAdjustCommand(BuildingPart part, Vector3 newPosition, Quaternion newRotation)
        {
            NetworkIdentity identity = part.GetComponent<NetworkIdentity>();
            if (identity == null || identity.netId == 0)
            {
                Debug.LogWarning("BuildingPart does not have a valid NetworkIdentity.");
                return;
            }

            CmdAdjust(identity.netId, newPosition, newRotation);
        }

        public void ExecuteDestroyCommand(BuildingPart part)
        {
            NetworkIdentity identity = part.GetComponent<NetworkIdentity>();
            if (identity == null || identity.netId == 0)
            {
                Debug.LogWarning("BuildingPart does not have a valid NetworkIdentity.");
                return;
            }

            CmdDestroy(identity.netId);
        }

        public void ExecuteUpgradeCommand(BuildingPart part, int upgradeIndex)
        {
            NetworkIdentity identity = part.GetComponent<NetworkIdentity>();
            if (identity == null || identity.netId == 0)
            {
                Debug.LogWarning("BuildingPart does not have a valid NetworkIdentity.");
                return;
            }

            CmdUpgrade(identity.netId, upgradeIndex);
        }

        [Command(requiresAuthority = false)]
        private void CmdPlace(string prefabId, Vector3 position, Quaternion rotation, Vector3 scale, string socketId)
        {
            if (!NetworkServer.active)
            {
                return;
            }

            BuildingPart prefab = BuildingManager.Instance?.GetPartByPrefabId(prefabId);
            if (prefab == null)
            {
                Debug.LogWarning($"Prefab with ID {prefabId} not found in BuildingManager.");
                return;
            }

            GameObject obj = Instantiate(prefab.gameObject, position, rotation);
            if (obj != null)
            {
                obj.transform.localScale = scale;

                BuildingPart placedPart = obj.GetComponent<BuildingPart>();
                if (placedPart != null)
                {
                    placedPart.SetState(BuildingPart.BuildingState.Placed);
                    placedPart.IsRuntimeInstantiated = true;

                    if (!string.IsNullOrEmpty(socketId))
                    {
                        BuildingSocket socket = BuildingSocket.GetSocketById(socketId);
                        if (socket != null)
                        {
                            placedPart.SetSocket(socket);
                        }
                    }

                    if (!placedPart.IsRegistered && BuildingManager.Instance != null)
                    {
                        BuildingManager.Instance.Register(placedPart);
                    }

                    EventPublisher.Publish(new BuildingStateEvent.PlacedEventArgs(placedPart));
                }

                NetworkServer.Spawn(obj);
            }
        }

        [Command(requiresAuthority = false)]
        private void CmdAdjust(uint netId, Vector3 newPosition, Quaternion newRotation)
        {
            if (!NetworkServer.active)
            {
                return;
            }

            if (!NetworkServer.spawned.ContainsKey(netId))
            {
                return;
            }

            NetworkIdentity identity = NetworkServer.spawned[netId];
            BuildingPart part = identity.GetComponent<BuildingPart>();
            if (part == null)
            {
                return;
            }

            AdjustCommand cmd = new AdjustCommand(part, newPosition, newRotation);
            cmd.Execute();

            RpcAdjust(netId, newPosition, newRotation);
        }

        [ClientRpc]
        private void RpcAdjust(uint netId, Vector3 newPosition, Quaternion newRotation)
        {
            if (NetworkServer.active)
            {
                return;
            }

            if (!NetworkClient.spawned.ContainsKey(netId))
            {
                return;
            }

            NetworkIdentity identity = NetworkClient.spawned[netId];
            BuildingPart part = identity.GetComponent<BuildingPart>();
            if (part == null)
            {
                return;
            }

            part.transform.SetPositionAndRotation(newPosition, newRotation);
        }

        [Command(requiresAuthority = false)]
        private void CmdDestroy(uint netId)
        {
            if (!NetworkServer.active)
            {
                return;
            }

            if (!NetworkServer.spawned.ContainsKey(netId))
            {
                return;
            }

            NetworkIdentity identity = NetworkServer.spawned[netId];
            if (identity != null)
            {
                NetworkServer.Destroy(identity.gameObject);
            }
        }

        [Command(requiresAuthority = false)]
        private void CmdUpgrade(uint netId, int upgradeIndex)
        {
            if (!NetworkServer.active)
            {
                return;
            }

            if (!NetworkServer.spawned.ContainsKey(netId))
            {
                return;
            }

            NetworkIdentity identity = NetworkServer.spawned[netId];
            BuildingPart part = identity.GetComponent<BuildingPart>();
            if (part == null)
            {
                return;
            }

            UpgradeCommand cmd = new UpgradeCommand(part, upgradeIndex);
            cmd.Execute();

            RpcUpgrade(netId, upgradeIndex);
        }

        [ClientRpc]
        private void RpcUpgrade(uint netId, int upgradeIndex)
        {
            if (NetworkServer.active)
            {
                return;
            }

            if (!NetworkClient.spawned.ContainsKey(netId))
            {
                return;
            }

            NetworkIdentity identity = NetworkClient.spawned[netId];
            BuildingPart part = identity.GetComponent<BuildingPart>();
            if (part == null)
            {
                return;
            }

            UpgradeCommand cmd = new UpgradeCommand(part, upgradeIndex);
            cmd.Execute();
        }
    }
}

#endif