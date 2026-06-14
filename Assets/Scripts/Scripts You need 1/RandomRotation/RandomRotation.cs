using UnityEngine;

namespace AP3X {
    public class RandomRotation : MonoBehaviour
    {
        public bool rotateX = false;
        public bool rotateY = false;
        public bool rotateZ = false;

        public float minRotation = 0;
        public float maxRotation = 360;

        public float rotationSpeed = 0;
        public RotationMode rotationMode;

        public float rotationSpeedX = 0;
        public float rotationSpeedY = 0;
        public float rotationSpeedZ = 0;

        public int randomSeed = 0;

        void Awake()
        {
            Random.InitState(randomSeed);
            ApplyRandomRotation();
        }

        void Update()
        {
            if (rotationMode == RotationMode.Continuous)
            {
                ContinuousRotation();
            }
        }

        void ApplyRandomRotation()
        {
            float x = rotateX ? Random.Range(minRotation, maxRotation) : transform.localEulerAngles.x;
            float y = rotateY ? Random.Range(minRotation, maxRotation) : transform.localEulerAngles.y;
            float z = rotateZ ? Random.Range(minRotation, maxRotation) : transform.localEulerAngles.z;

            transform.localEulerAngles = new Vector3(x, y, z);
        }

        void ContinuousRotation()
        {
            float x = rotationSpeedX * Time.deltaTime;
            float y = rotationSpeedY * Time.deltaTime;
            float z = rotationSpeedZ * Time.deltaTime;

            if (rotateX || rotationSpeedX != 0) transform.localEulerAngles += new Vector3(x, 0, 0);
            if (rotateY || rotationSpeedY != 0) transform.localEulerAngles += new Vector3(0, y, 0);
            if (rotateZ || rotationSpeedZ != 0) transform.localEulerAngles += new Vector3(0, 0, z);

            transform.localEulerAngles = new Vector3(
                Mathf.Clamp(transform.localEulerAngles.x, minRotation, maxRotation),
                Mathf.Clamp(transform.localEulerAngles.y, minRotation, maxRotation),
                Mathf.Clamp(transform.localEulerAngles.z, minRotation, maxRotation)
            );
        }

        public enum RotationMode { RandomOnce, Continuous }
    }
}
