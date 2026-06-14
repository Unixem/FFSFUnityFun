using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.Events;


namespace AP3X {
    public class BornSwarm : MonoBehaviour
    {
        [System.Serializable]
        public class SwarmRound
        {
            public List<GameObject> EnemyDudes;
            public int maxCNT;
            public string roundName;
            public UnityEvent onRoundCompleted;
        }

        [System.Serializable]
        public class SpawnArea
        {
            public Transform centerPoint;
            public float bornArea;
        }
        [Header("Swarm Settings")]
        public List<SwarmRound> swarmRounds;
        public List<SpawnArea> spawnAreas;
        [Header("time Settings")]
        public float preparationTime = 10f;

        [Header("UI and Prompt Settings")]
        public TMP_Text roundNameText;
        public TMP_Text enemiesLeftText;
        public TMP_Text preparationTimeText;
        public GameObject roundEndPopup;

        [Header("Audio Settings")]
        public AudioClip roundStartSound;
        public AudioClip roundEndSound;
        private AudioSource audioSRC;

        private int currentRoundIndex = 0;
        private int spawnedCount = 0;
        private List<GameObject> spawnedDudePrefabs = new List<GameObject>();

        private void Start()
        {
            audioSRC = GetComponent<AudioSource>();
            roundEndPopup.SetActive(false);
            StartCoroutine(StartNextRound());
        }

        private IEnumerator StartNextRound()
        {
            if (currentRoundIndex >= swarmRounds.Count)
            {
                yield break;
            }

            SwarmRound currentRound = swarmRounds[currentRoundIndex];
            roundNameText.text = "Round: " + currentRound.roundName;
            enemiesLeftText.text = "Enemies Left: " + currentRound.maxCNT;

            for (float timer = preparationTime; timer >= 0; timer -= Time.deltaTime)
            {
                preparationTimeText.text = "Preparation Time: " + Mathf.Ceil(timer).ToString();
                yield return null;
            }

            preparationTimeText.text = "";
            PlayRoundStartSound();
            SpawnTheDudes();

            while (spawnedCount > 0)
            {
                yield return null;
            }

            PlayRoundEndSound();
            StartCoroutine(ShowRoundEndPopup());

            currentRound.onRoundCompleted.Invoke();

            currentRoundIndex++;
            StartCoroutine(StartNextRound());
        }

        private void PlayRoundStartSound()
        {
            if (roundStartSound != null)
            {
                audioSRC.PlayOneShot(roundStartSound);
            }
        }

        private void PlayRoundEndSound()
        {
            if (roundEndSound != null)
            {
                audioSRC.PlayOneShot(roundEndSound);
            }
        }

        private void SpawnTheDudes()
        {
            SwarmRound currentRound = swarmRounds[currentRoundIndex];
            for (int i = 0; i < currentRound.maxCNT; i++)
            {
                Vector3 spawnPosition = GetRandomPointInArea();
                GameObject prefab = currentRound.EnemyDudes[Random.Range(0, currentRound.EnemyDudes.Count)];
                GameObject spawnedPrefab = Instantiate(prefab, spawnPosition, Quaternion.identity);
                spawnedDudePrefabs.Add(spawnedPrefab);
                spawnedCount++;
            }
        }

        private Vector3 GetRandomPointInArea()
        {
            SpawnArea area = spawnAreas[Random.Range(0, spawnAreas.Count)];
            Vector2 randomPoint = Random.insideUnitCircle * area.bornArea;
            return new Vector3(randomPoint.x, 0, randomPoint.y) + area.centerPoint.position;
        }

        private void Update()
        {
            for (int i = spawnedDudePrefabs.Count - 1; i >= 0; i--)
            {
                if (spawnedDudePrefabs[i] == null)
                {
                    spawnedDudePrefabs.RemoveAt(i);
                    spawnedCount--;
                    enemiesLeftText.text = "Enemies Left: " + spawnedCount;
                }
            }
        }

        private IEnumerator ShowRoundEndPopup()
        {
            roundEndPopup.SetActive(true);
            yield return new WaitForSeconds(2f);
            roundEndPopup.SetActive(false);
        }

        private void OnDrawGizmos()
        {
            Gizmos.color = Color.red;
            foreach (SpawnArea area in spawnAreas)
            {
                Gizmos.DrawWireSphere(area.centerPoint.position, area.bornArea);
            }
        }
    }
}

