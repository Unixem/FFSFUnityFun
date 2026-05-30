using UnityEngine;

namespace AP3X {
    public class Cam_Zoom : MonoBehaviour
    {
        public float maxZoom = 125f;
        public float minZoom = 5f;
        public float sensitivity = 5f;
        public KeyCode zoomInKey = KeyCode.PageUp;
        public KeyCode zoomOutKey = KeyCode.PageDown;
        public AudioClip zoomInClip;
        public AudioClip zoomOutClip;
        public AudioSource audioSource;
        public GameObject[] objectsToEnableAtMinZoom; // objects to enable at min zoom

        private bool isAtMinZoom = false;

        void Update()
        {
            if (Input.GetKey(zoomInKey) || Input.GetAxis("Mouse ScrollWheel") > 0)
            {
                if (Camera.main.fieldOfView > minZoom)
                {
                    Camera.main.fieldOfView -= sensitivity;
                    PlaySound(zoomOutClip);
                }
            }

            if (Input.GetKey(zoomOutKey) || Input.GetAxis("Mouse ScrollWheel") < 0)
            {
                if (Camera.main.fieldOfView < maxZoom)
                {
                    Camera.main.fieldOfView += sensitivity;
                    PlaySound(zoomInClip);
                }
            }

            CheckMinZoomState();
        }

        void CheckMinZoomState()
        {
            if (Camera.main.fieldOfView <= minZoom)
            {
                if (!isAtMinZoom)
                {
                    EnableObjectsAtMinZoom();
                    isAtMinZoom = true;
                }
            }
            else
            {
                if (isAtMinZoom)
                {
                    DisableObjectsAtMinZoom();
                    isAtMinZoom = false;
                }
            }
        }

        void EnableObjectsAtMinZoom()
        {
            foreach (GameObject obj in objectsToEnableAtMinZoom)
            {
                obj.SetActive(true);
            }
        }

        void DisableObjectsAtMinZoom()
        {
            foreach (GameObject obj in objectsToEnableAtMinZoom)
            {
                obj.SetActive(false);
            }
        }

        void PlaySound(AudioClip clip)
        {
            if (clip != null && audioSource != null)
            {
                audioSource.clip = clip;
                audioSource.Play();
            }
        }
    }
}
