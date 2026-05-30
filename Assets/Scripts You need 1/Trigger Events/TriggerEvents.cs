using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.Events;

namespace AP3X {
    public class OnTriggerEvents : MonoBehaviour
    {
        [Header("Audio Settings")]
        [SerializeField] private bool playAudio = false;
        [SerializeField] private AudioClip audioClip;
        private AudioSource audioSource;

        [Header("Object Enable/Disable Settings")]
        [SerializeField] private bool enableObject = false;
        [SerializeField] private bool disableObject = false;
        [SerializeField] private GameObject objectToEnableDisable;

        [Header("Scene Loading Settings")]
        [SerializeField] private bool loadScene = false;
        [SerializeField] private string sceneName;

        [Header("Teleport Settings")]
        [SerializeField] private bool teleport = false;
        [SerializeField] private Transform teleportTarget;

        [Header("Object Duplication Settings")]
        [SerializeField] private bool duplicateObject = false;
        [SerializeField] private GameObject objectToDuplicate;
        [SerializeField] private int maxDuplicates = 5;
        private int duplicateCount = 0;

        [Header("Event Handling Settings")]
        [SerializeField] private bool eventHandle = false;
        [SerializeField] private UnityEvent eventToHandle;

        private void Start()
        {
            if (playAudio)
            {
                audioSource = gameObject.AddComponent<AudioSource>();
                audioSource.clip = audioClip;
            }
        }

        private void OnTriggerEnter(Collider other)
        {
            if (other.gameObject.CompareTag("Player"))
            {
                if (playAudio)
                {
                    audioSource.Play();
                }

                if (enableObject)
                {
                    objectToEnableDisable.SetActive(true);
                }

                if (disableObject)
                {
                    objectToEnableDisable.SetActive(false);
                }

                if (loadScene)
                {
                    SceneManager.LoadScene(sceneName);
                }

                if (teleport)
                {
                    other.transform.position = teleportTarget.position;
                }

                if (duplicateObject && duplicateCount < maxDuplicates)
                {
                    Instantiate(objectToDuplicate, transform.position, Quaternion.identity);
                    duplicateCount++;
                }
                else if (duplicateObject && duplicateCount >= maxDuplicates)
                {
                    Debug.Log("Max duplicates reached.");
                }

                if (eventHandle)
                {
                    eventToHandle.Invoke();
                }
            }
        }

        private void OnDisable()
        {
            duplicateCount = 0;
        }
    }
}

