using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace AP3X {
    public class WheelControl : MonoBehaviour
    {
        public float maxRotationSpeed = 100.0f;
        public KeyCode accelerationKey = KeyCode.W;
        public KeyCode decelerationKey = KeyCode.S;
        public float accelerationTorque = 5.0f;
        public float decelerationTorque = 3.0f;
        public int axis = 2;

        public bool KontrolLight = false;
        public List<Light> lights = new List<Light>(); 

        private float rotationSpeed = 0.0f;

        void Update()
        {
            if (Input.GetKey(accelerationKey))
            {
                rotationSpeed = Mathf.MoveTowards(rotationSpeed, maxRotationSpeed, accelerationTorque * Time.deltaTime);
            }

            if (Input.GetKey(decelerationKey))
            {
                rotationSpeed = Mathf.MoveTowards(rotationSpeed, -maxRotationSpeed, decelerationTorque * Time.deltaTime);
            }

            if (!Input.GetKey(accelerationKey) && !Input.GetKey(decelerationKey))
            {
                rotationSpeed = Mathf.MoveTowards(rotationSpeed, 0, decelerationTorque * Time.deltaTime);
            }

            if ((rotationSpeed > 0 && Input.GetKey(decelerationKey)) || (rotationSpeed < 0 && Input.GetKey(accelerationKey)))
            {
                rotationSpeed = Mathf.MoveTowards(rotationSpeed, 0, decelerationTorque * Time.deltaTime);
            }

            if (KontrolLight)
            {
                UpdateLightIntensity();
            }

            Vector3 rotationAxis = new Vector3(0, 0, 0);
            rotationAxis[axis] = rotationSpeed;
            transform.Rotate(rotationAxis * Time.deltaTime);
        }

        void UpdateLightIntensity()
        {
            foreach (Light light in lights)
            {
                light.intensity = Mathf.Abs(rotationSpeed) / maxRotationSpeed; 
            }

        }

        void OnDisable()
        {
            rotationSpeed = 0.0f;
        }
    }
}
