/// <summary>
/// Project : Easy Build System
/// Class : Example_PlayerMirror.cs
/// Namespace : MindCodeInteractive.EasyBuildSystem.Packages.Integrations.Mirror.Code.Runtime
/// Copyright : © 2015 - 2026 Mind Code Interactive
/// </summary>

#if EASY_BUILD_SYSTEM_MIRROR

using UnityEngine;

using Mirror;

using MindCodeInteractive.EasyBuildSystem.Framework.Code.Runtime.Systems.Managers;

namespace MindCodeInteractive.EasyBuildSystem.Packages.Integrations.Mirror.Code.Runtime
{
    public class Example_PlayerMirror : NetworkBehaviour
    {
        [SerializeField] private Behaviour[] m_disableIfNotOwner;
        [SerializeField] private Behaviour[] m_disableIfOwner;

        [SerializeField] private GameObject[] m_disableGameObjectsIfNotOwner;
        [SerializeField] private GameObject[] m_disableGameObjectsIfOwner;

        [SerializeField] private Camera m_camera;

        public override void OnStartAuthority()
        {
            base.OnStartAuthority();
            ApplyOwnershipState(true);
        }

        public override void OnStartClient()
        {
            base.OnStartClient();
            ApplyOwnershipState(isLocalPlayer);
        }

        private void Start()
        {
            if (BuildingManager.Instance != null)
            {
                BuildingManager.Instance.GroupingSettings.EnableGrouping = false;
            }

            ApplyOwnershipState(isLocalPlayer);
        }

        private void ApplyOwnershipState(bool isOwner)
        {
            if (m_camera != null)
            {
                m_camera.gameObject.SetActive(isOwner);
            }

            if (m_disableIfNotOwner != null)
            {
                for (int i = 0; i < m_disableIfNotOwner.Length; i++)
                {
                    if (m_disableIfNotOwner[i] != null)
                    {
                        m_disableIfNotOwner[i].enabled = isOwner;
                    }
                }
            }

            if (m_disableIfOwner != null)
            {
                for (int i = 0; i < m_disableIfOwner.Length; i++)
                {
                    if (m_disableIfOwner[i] != null)
                    {
                        m_disableIfOwner[i].enabled = !isOwner;
                    }
                }
            }

            if (m_disableGameObjectsIfNotOwner != null)
            {
                for (int i = 0; i < m_disableGameObjectsIfNotOwner.Length; i++)
                {
                    if (m_disableGameObjectsIfNotOwner[i] != null)
                    {
                        m_disableGameObjectsIfNotOwner[i].SetActive(isOwner);
                    }
                }
            }

            if (m_disableGameObjectsIfOwner != null)
            {
                for (int i = 0; i < m_disableGameObjectsIfOwner.Length; i++)
                {
                    if (m_disableGameObjectsIfOwner[i] != null)
                    {
                        m_disableGameObjectsIfOwner[i].SetActive(!isOwner);
                    }
                }
            }
        }
    }
}

#endif