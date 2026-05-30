using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

namespace AP3X {
    public class DestroyAfterTime : MonoBehaviour
    {
        [Header("Toggles")]
        public float time = 10.0f;
        public bool Use3Dtext = false;
        public bool UseBarGraph = false;
        [Header("Use Shrink Technique")]
        public bool ShrinkDestroy = false;
        public float shrinkDuration = 1.0f;
        [Header("Audio Setting")]
        public AudioClip destroySound;
        public AudioSource audioSource;
        [Header("UI settings")]
        public TMP_Text countdownText;
        [Header("For Time Graphic")]
        public LineRenderer barGraph;
        

        private float initialTime;
        private Vector3 initialScale;

        void Start()
        {
            initialTime = time;
            initialScale = transform.localScale;

            if (!Use3Dtext && countdownText != null && countdownText.gameObject.activeSelf)
            {
                countdownText.gameObject.SetActive(false);
            }

            if (!UseBarGraph && barGraph != null && barGraph.gameObject.activeSelf)
            {
                barGraph.gameObject.SetActive(false);
            }

            if (!Use3Dtext && !UseBarGraph)
            {
                Destroy(gameObject, time);
            }

            if (destroySound != null)
            {
                audioSource.clip = destroySound;
            }
        }

        void Update()
        {
            if (time > 0)
            {
                time -= Time.deltaTime;

                if (Use3Dtext && countdownText != null && countdownText.gameObject.activeSelf)
                {
                    countdownText.text = Mathf.CeilToInt(time).ToString();
                }

                if (UseBarGraph && barGraph != null && barGraph.gameObject.activeSelf)
                {
                    UpdateCircularProgress();
                }
            }
            else
            {
                if (ShrinkDestroy)
                {
                    StartCoroutine(ShrinkAndDestroy());
                }
                else
                {
                    PlayDestroySound();
                    Destroy(gameObject);
                }
            }
        }

        void UpdateCircularProgress()
        {
            int segments = 50;
            float progress = time / initialTime;
            float angleStep = 360.0f / segments;
            //float angleStep = 180.0f / segments;   // if you want to use semi circle.
            
            barGraph.positionCount = segments + 1;
            for (int i = 0; i <= segments; i++)
            {
                float angle = angleStep * i * progress;
                float radian = Mathf.Deg2Rad * angle;
                float radius = 1.0f;

                Vector3 position = new Vector3(Mathf.Cos(radian) * radius, Mathf.Sin(radian) * radius, 0);
                barGraph.SetPosition(i, position);
            }

        }

        IEnumerator ShrinkAndDestroy()
        {
            float t = 0;
            while (t < shrinkDuration)
            {
                t += Time.deltaTime;
                transform.localScale = Vector3.Lerp(initialScale, Vector3.zero, t / shrinkDuration);
                yield return null;
            }
            PlayDestroySound();
            Destroy(gameObject);
        }

        void PlayDestroySound()
        {
            if (audioSource != null && destroySound != null)
            {
                audioSource.PlayOneShot(destroySound);
            }
        }
    }
}
