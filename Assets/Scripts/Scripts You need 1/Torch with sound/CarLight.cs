using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace AP3X {
    public class CarLight : MonoBehaviour
    {
        [Header("Keycodes")]
        public KeyCode headlightToggle = KeyCode.H;
        public KeyCode brakeLightToggle = KeyCode.B;
        public KeyCode leftIndicatorToggle = KeyCode.LeftArrow;
        public KeyCode rightIndicatorToggle = KeyCode.RightArrow;
        [Header("All Car's Lights")]
        public List<Light> headLights = new List<Light>();
        public List<Light> brakeLights = new List<Light>();
        public List<Light> leftIndicatorLights = new List<Light>();
        public List<Light> rightIndicatorLights = new List<Light>();
        [Header("Audio Settings")]
        public AudioClip headlightSound;
        public AudioClip brakeLightSound;
        public AudioClip indicatorSound;

        private AudioSource audioSource;

        private bool isLeftIndicatorOn = false;
        private bool isRightIndicatorOn = false;
        private bool isBrakeLightOn = false;

        private float pulseSpeed = 5f; // Increased indicator speed

        private void Start()
        {
            audioSource = GetComponent<AudioSource>();

            foreach (Light light in headLights)
            {
                light.enabled = false;
            }

            foreach (Light light in brakeLights)
            {
                light.enabled = false;
            }

            foreach (Light light in leftIndicatorLights)
            {
                light.enabled = false;
            }

            foreach (Light light in rightIndicatorLights)
            {
                light.enabled = false;
            }
        }

        private void Update()
        {
            if (Input.GetKeyDown(headlightToggle))
            {
                ToggleHeadlights();
            }

            if (Input.GetKeyDown(leftIndicatorToggle))
            {
                ToggleLeftIndicators();
            }

            if (Input.GetKeyDown(rightIndicatorToggle))
            {
                ToggleRightIndicators();
            }

            if (Input.GetKey(brakeLightToggle))
            {
                EnableBrakeLights();
            }
            else
            {
                DisableBrakeLights();
            }

            if (isLeftIndicatorOn)
            {
                PulseIndicators(leftIndicatorLights);
            }

            if (isRightIndicatorOn)
            {
                PulseIndicators(rightIndicatorLights);
            }
        }

        private void ToggleHeadlights()
        {
            foreach (Light light in headLights)
            {
                light.enabled = !light.enabled;
            }

            audioSource.PlayOneShot(headlightSound);
        }

        private void ToggleLeftIndicators()
        {
            isLeftIndicatorOn = !isLeftIndicatorOn;

            foreach (Light light in leftIndicatorLights)
            {
                light.enabled = isLeftIndicatorOn;
            }

            audioSource.PlayOneShot(indicatorSound);
        }

        private void ToggleRightIndicators()
        {
            isRightIndicatorOn = !isRightIndicatorOn;

            foreach (Light light in rightIndicatorLights)
            {
                light.enabled = isRightIndicatorOn;
            }

            audioSource.PlayOneShot(indicatorSound);
        }

        private void EnableBrakeLights()
        {
            if (!isBrakeLightOn)
            {
                isBrakeLightOn = true;
                audioSource.PlayOneShot(brakeLightSound);
            }

            foreach (Light light in brakeLights)
            {
                light.enabled = true;
            }
        }

        private void DisableBrakeLights()
        {
            if (isBrakeLightOn)
            {
                isBrakeLightOn = false;
                audioSource.PlayOneShot(brakeLightSound);
            }

            foreach (Light light in brakeLights)
            {
                light.enabled = false;
            }
        }

        private float pulseTimer = 0f;
        private void PulseIndicators(List<Light> indicators)
        {
            float pulse = Mathf.PingPong(Time.time * pulseSpeed, 2f);
            foreach (Light light in indicators)
            {
                light.intensity = pulse;
            }

            if (Time.time - pulseTimer >= 0.5f)
            {
                pulseTimer = Time.time;
                audioSource.PlayOneShot(indicatorSound);
            }
        }
    }
}
