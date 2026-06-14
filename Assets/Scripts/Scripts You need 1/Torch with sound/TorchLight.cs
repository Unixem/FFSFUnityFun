using UnityEngine;

namespace AP3X {
    public class TorchLight : MonoBehaviour
    {
        public Light linkedLight;
        [Header("Audio Settings")]
        public AudioClip snd_on;
        public AudioClip snd_intensity;
        public AudioClip snd_range;
        [Header("Keycodes")]
        public KeyCode toggleKey = KeyCode.F;
        public KeyCode increaseRangeKey = KeyCode.E;
        public KeyCode decreaseRangeKey = KeyCode.Q;
        [Header("Control Range/Intensity ?")]
        public bool kontrolIntensity = true;
        public bool kontrolRange = true;
        [Header("Light Settings")]
        public float minIntensity = 0.1f;
        public float maxIntensity = 8.0f;
        public float intensityStep = 0.1f;
        public float minRange = 1.0f;
        public float maxRange = 10.0f;
        public float rangeStep = 0.1f;

        private AudioSource audioSource;

        void Start()
        {
            audioSource = GetComponent<AudioSource>();
        }

        void Update()
        {
            if (Input.GetKeyDown(toggleKey))
            {
                linkedLight.enabled = !linkedLight.enabled;
                audioSource.PlayOneShot(snd_on);
            }

            if (kontrolIntensity)
            {
                if (Input.mouseScrollDelta.y > 0 && linkedLight.intensity < maxIntensity)
                {
                    linkedLight.intensity = Mathf.Min(linkedLight.intensity + intensityStep, maxIntensity);
                    audioSource.PlayOneShot(snd_intensity);
                }
                else if (Input.mouseScrollDelta.y < 0 && linkedLight.intensity > minIntensity)
                {
                    linkedLight.intensity = Mathf.Max(linkedLight.intensity - intensityStep, minIntensity);
                    audioSource.PlayOneShot(snd_intensity);
                }
            }

            if (kontrolRange)
            {
                if (Input.GetKey(increaseRangeKey) && linkedLight.range < maxRange)
                {
                    linkedLight.range = Mathf.Min(linkedLight.range + rangeStep, maxRange);
                    audioSource.PlayOneShot(snd_range);
                }
                else if (Input.GetKey(decreaseRangeKey) && linkedLight.range > minRange)
                {
                    linkedLight.range = Mathf.Max(linkedLight.range - rangeStep, minRange);
                    audioSource.PlayOneShot(snd_range);
                }
            }
        }

        void LightOff()
        {
            linkedLight.enabled = false;
        }
    }
}
