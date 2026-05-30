using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace NWT
{
    [CreateAssetMenu(fileName = "New Sprite Mouth", menuName = "Now We're Talking!/Sprite Mouth")]

    public class spriteMouths : ScriptableObject
    {
        public string mouthName;
        public string mouthDescription;


        public List<Sprite> sprites = new List<Sprite>();
        public List<Sprite> emotions = new List<Sprite>();  // added November 2022 PMC

    }
}