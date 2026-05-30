using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace AP3X {
    public class MovingPlatform : MonoBehaviour
    {
        public List<Transform> points;
        [Header("Control Movements")]
        public float maxSpeed = 3.0f;
        public float acceleration = 0.5f;
        public float deceleration = 0.5f;
        [Header("Use Loop audio ")]
        public AudioSource movSound;

        [Header("Reverse the platform movement")]
        public bool ReverseTheRoute = false;
        private int currentTargetIndex = 0;
        private float currentSpeed = 0f;
        private bool isMoving;
        private AudioSource audioSRC;
        private int direction = 1;

        void Start()
        {
            audioSRC = GetComponent<AudioSource>();
            if (movSound != null)
            {
                audioSRC.clip = movSound.clip;
                audioSRC.loop = true;
                audioSRC.Play();
            }
        }

        void Update()
        {
            if (points.Count < 2) return;

            Transform targetPoint = points[currentTargetIndex];

            float step = currentSpeed * Time.deltaTime;
            transform.position = Vector3.MoveTowards(transform.position, targetPoint.position, step);

            if (Vector3.Distance(transform.position, targetPoint.position) < 0.1f)
            {
                if (currentSpeed > 0f)
                {
                    currentSpeed -= deceleration * Time.deltaTime;
                }

                MoveToNextPoint();
            }
            else
            {
                if (currentSpeed < maxSpeed)
                {
                    currentSpeed += acceleration * Time.deltaTime;
                }
            }
        }

        void MoveToNextPoint()
        {
            if (ReverseTheRoute)
            {
                if (currentTargetIndex == points.Count - 1)
                {
                    direction = -1;
                }
                else if (currentTargetIndex == 0)
                {
                    direction = 1;
                }
            }

            currentTargetIndex += direction;
            currentTargetIndex = Mathf.Clamp(currentTargetIndex, 0, points.Count - 1);
        }
    }
}
