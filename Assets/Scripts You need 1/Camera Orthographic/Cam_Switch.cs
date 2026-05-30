using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.UI;

namespace AP3X {
    public class Cam_Switch : MonoBehaviour
    {
        public List<Camera> Kamera; 
        public TextMeshProUGUI KamTag; 
        private int groovyCamIndex = 0;
        public Image fadeImage; 
        public float fadeDuration = 1f; 
        public AudioSource switchSound;
        public AudioSource modeSound; 

        void Start()
        {
            
            if (Kamera.Count == 0)
            {
                Debug.LogError("Kamera list is empty!");
                return;
            }

            
            for (int i = 1; i < Kamera.Count; i++)
            {
                Kamera[i].gameObject.SetActive(false);
            }
            if (Kamera.Count > 0)
            {
                Kamera[0].gameObject.SetActive(true);
            }

            
            foreach (var cam in Kamera)
            {
                var audioListener = cam.GetComponent<AudioListener>();
                if (audioListener != null)
                {
                    audioListener.enabled = false;
                }
            }
            if (Kamera[0].GetComponent<AudioListener>() != null)
            {
                Kamera[0].GetComponent<AudioListener>().enabled = true;
            }

            fadeImage.gameObject.SetActive(false); 
            UpdateFunkyLabel();
        }

        void Update()
        {
            if (Input.GetKeyUp(KeyCode.X))
            {
                
                if (Kamera.Count > 0)
                {
                    Camera currentCam = Kamera[groovyCamIndex];
                    currentCam.orthographic = !currentCam.orthographic;
                    modeSound.Play(); 
                    UpdateFunkyLabel();
                }
            }

            if (Input.GetKeyUp(KeyCode.Q))
            {
                
                StartCoroutine(SwitchFunkyCamera((groovyCamIndex - 1 + Kamera.Count) % Kamera.Count));
            }

            if (Input.GetKeyUp(KeyCode.E))
            {
                
                StartCoroutine(SwitchFunkyCamera((groovyCamIndex + 1) % Kamera.Count));
            }
        }

        IEnumerator SwitchFunkyCamera(int newCamIndex)
        {
            if (Kamera.Count == 0) yield break;

          
            yield return StartCoroutine(Fade(1f));

           
            Kamera[groovyCamIndex].gameObject.SetActive(false);
            groovyCamIndex = newCamIndex;
            Kamera[groovyCamIndex].gameObject.SetActive(true);
            switchSound.Play(); 

           
            foreach (var cam in Kamera)
            {
                var audioListener = cam.GetComponent<AudioListener>();
                if (audioListener != null)
                {
                    audioListener.enabled = false;
                }
            }
            if (Kamera[groovyCamIndex].GetComponent<AudioListener>() != null)
            {
                Kamera[groovyCamIndex].GetComponent<AudioListener>().enabled = true;
            }

          
            yield return StartCoroutine(Fade(0f));

            UpdateFunkyLabel();
        }

        IEnumerator Fade(float targetAlpha)
        {
            fadeImage.gameObject.SetActive(true); 

            float startAlpha = fadeImage.color.a;
            float elapsedTime = 0f;

            while (elapsedTime < fadeDuration)
            {
                elapsedTime += Time.deltaTime;
                float newAlpha = Mathf.Lerp(startAlpha, targetAlpha, elapsedTime / fadeDuration);
                fadeImage.color = new Color(fadeImage.color.r, fadeImage.color.g, fadeImage.color.b, newAlpha);
                yield return null;
            }

            fadeImage.color = new Color(fadeImage.color.r, fadeImage.color.g, fadeImage.color.b, targetAlpha);

            if (targetAlpha == 0f)
            {
                fadeImage.gameObject.SetActive(false); // Hide now
            }
        }

        void UpdateFunkyLabel()
        {
            if (Kamera.Count > 0)
            {
                string mode = Kamera[groovyCamIndex].orthographic ? "Ortho" : "Persp";
                KamTag.text = $"{Kamera[groovyCamIndex].name}\nMode: {mode}";
            }
        }
    }
}
