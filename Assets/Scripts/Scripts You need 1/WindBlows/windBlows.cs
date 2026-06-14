using UnityEngine;

namespace AP3X {
    public class WindBlows : MonoBehaviour
    {
        [Range(0f, 50f)]
        public float minBlow = 5f;
        [Range(0f, 50f)]
        public float maxBlow = 20f;
        public float windTurbulence = 2f;
        public float effectRadius = 50f;
        public float windChangeInterval = 3f;

        [Header("Simulate a Hurricane")]
        public bool GoneMad = false;
        public float madnessMultiplier = 5f;
        public bool randomizeRotation = false;
        public float rotationSmoothTime = 2f; // adjust for smoothness

        private float currentWindStrength;
        private float howLongToChange;
        private float rotationSpeed = 100f;
        private float targetVolume;
        private float currentVolume;
        private Vector3 targetRotation;
        private AudioSource windAudioSource;

        private void Start()
        {
            currentWindStrength = Random.Range(minBlow, maxBlow);
            windAudioSource = GetComponent<AudioSource>();
            if (windAudioSource != null)
            {
                windAudioSource.loop = true;
                windAudioSource.Play();
            }
            UpdateWindAudioVolume();
            howLongToChange = Time.time + windChangeInterval;
            if (randomizeRotation)
            {
                targetRotation = Quaternion.Euler(Random.Range(0f, 360f), Random.Range(0f, 360f), Random.Range(0f, 360f)).eulerAngles;
            }
        }

        private void FixedUpdate()
        {
            if (GoneMad)
            {
                transform.Rotate(Vector3.up, rotationSpeed * Time.deltaTime);
            }
            if (Time.time >= howLongToChange)
            {
                ChangeWindStrength();
                howLongToChange = Time.time + windChangeInterval;
            }
            ApplyWindToNearbyObjects();
            if (windAudioSource != null)
            {
                currentVolume = Mathf.Lerp(currentVolume, targetVolume, 0.1f);
                windAudioSource.volume = currentVolume;
            }
            if (randomizeRotation)
            {
                transform.rotation = Quaternion.Euler(Mathf.LerpAngle(transform.eulerAngles.x, targetRotation.x, rotationSmoothTime * Time.deltaTime),
                                                      Mathf.LerpAngle(transform.eulerAngles.y, targetRotation.y, rotationSmoothTime * Time.deltaTime),
                                                      Mathf.LerpAngle(transform.eulerAngles.z, targetRotation.z, rotationSmoothTime * Time.deltaTime));
                if (Vector3.Distance(transform.eulerAngles, targetRotation) < 1f)
                {
                    targetRotation = Quaternion.Euler(Random.Range(0f, 360f), Random.Range(0f, 360f), Random.Range(0f, 360f)).eulerAngles;
                }
            }
        }

        private void ApplyWindToNearbyObjects()
        {
            Collider[] colliders = Physics.OverlapSphere(transform.position, effectRadius);
            foreach (Collider collider in colliders)
            {
                Rigidbody rb = collider.GetComponent<Rigidbody>();
                if (rb != null)
                {
                    Vector3 windVector = CalculateWindForce(rb.transform.position);
                    rb.AddForce(windVector, ForceMode.Acceleration);
                }
            }
        }

        private Vector3 CalculateWindForce(Vector3 objectPosition)
        {
            Vector3 windDirection = transform.forward;
            Vector3 directionToObject = objectPosition - transform.position;
            float distance = directionToObject.magnitude;
            float attenuation = Mathf.Clamp01(1f - (distance / effectRadius));
            Vector3 windForce = windDirection * currentWindStrength * attenuation;
            if (GoneMad)
            {
                windForce *= madnessMultiplier;
            }
            windForce += new Vector3(Random.Range(-windTurbulence, windTurbulence), Random.Range(-windTurbulence, windTurbulence), Random.Range(-windTurbulence, windTurbulence));
            return windForce;
        }

        private void ChangeWindStrength()
        {
            float blowMax = GoneMad ? 100f : maxBlow;
            currentWindStrength = Random.Range(minBlow, blowMax);
            UpdateWindAudioVolume();
        }

        private void UpdateWindAudioVolume()
        {
            if (windAudioSource != null)
            {
                float blowMax = GoneMad ? 100f : maxBlow;
                targetVolume = Mathf.InverseLerp(minBlow, blowMax, currentWindStrength);
            }
        }
    }
}