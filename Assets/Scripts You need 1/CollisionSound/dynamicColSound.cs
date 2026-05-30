using UnityEngine;
using System.Collections.Generic;


namespace AP3X {
    public class dynamicColSound : MonoBehaviour
    {
        [Header("Settings")]
        public bool playDefaultSound;
        public bool randVolPit;

        [Header("Materials")]
        public List<MaterialClips> materialClips;

        [Header("Tags")]
        public List<TagClips> tagClips;

        [Header("Default Sounds")]
        public List<AudioClip> defaultClips;

        [Header("Audio Settings")]
        public AudioSource src;
        public float volume = 0.8f;

        [System.Serializable]
        public class MaterialClips
        {
            public Material material;
            public List<AudioClip> clips;
        }

        [System.Serializable]
        public class TagClips
        {
            public string tag;
            public List<AudioClip> clips;
        }

        void OnCollisionEnter(Collision collision)
        {
            Bounce(collision);
        }

        void Bounce(Collision collision)
        {
            if (playDefaultSound && defaultClips.Count > 0)
            {
                PlayDefaultSound();
            }
            else
            {
                AudioClip clip = GetClipFromMaterial(collision) ?? GetClipFromTag(collision);
                if (clip != null)
                {
                    src.clip = clip;
                    SetRandomVolumeAndPitch();
                    src.Play();
                }
            }
        }

        void PlayDefaultSound()
        {
            if (defaultClips.Count > 0)
            {
                src.clip = defaultClips[Random.Range(0, defaultClips.Count)];
                SetRandomVolumeAndPitch();
                src.Play();
            }
        }

        void SetRandomVolumeAndPitch()
        {
            if (randVolPit)
            {
                src.volume = Random.Range(0f, 5f); // sound will be between 0 and 5
                src.pitch = Random.Range(0.5f, 1.5f); //  pitch wil between 0.5 and 1.5
            }
            else
            {
                src.volume = volume;  // normal volume
                src.pitch = 1f; // normal pitch
            }
        }

        AudioClip GetClipFromMaterial(Collision collision)
        {
            Renderer renderer = collision.collider.GetComponent<Renderer>();
            if (renderer != null)
            {
                foreach (var materialClip in materialClips)
                {
                    if (renderer.sharedMaterial == materialClip.material)
                    {
                        return materialClip.clips[Random.Range(0, materialClip.clips.Count)];
                    }
                }
            }
            return null;
        }

        AudioClip GetClipFromTag(Collision collision)
        {
            foreach (var tagClip in tagClips)
            {
                if (collision.gameObject.CompareTag(tagClip.tag))
                {
                    return tagClip.clips[Random.Range(0, tagClip.clips.Count)];
                }
            }
            return null;
        }
    }
}
