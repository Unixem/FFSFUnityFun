using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

using UnityObject = UnityEngine.Object;

namespace Bewildered.SmartLibrary
{
    internal class PreviewCacheManager : ScriptableSingleton<PreviewCacheManager>
    {
#if UNITY_6000_4_OR_NEWER
        private static EntityId _sharedClientID = EntityId.None;
        
        [SerializeField] private SerializableDictionary<EntityId, PreviewCache> _caches = new ();
        
        public static Dictionary<EntityId, PreviewCache> Caches
        {
            get { return instance._caches; }
        }
#else
        private static int _sharedClientID = 0;

        [SerializeField] private SerializableDictionary<int, PreviewCache> _caches = new SerializableDictionary<int, PreviewCache>();
        
        public static Dictionary<int, PreviewCache> Caches
        {
            get { return instance._caches; }
        }
#endif
        
       

        public static Texture2D GetCachedPreview(string guid)
        {
            return GetCachedPreview(guid, _sharedClientID);
        }
        
#if UNITY_6000_4_OR_NEWER
        public static Texture2D GetCachedPreview(string guid, EntityId clientID)
#else
        public static Texture2D GetCachedPreview(string guid, int clientID)
#endif
        {
            if (Caches.TryGetValue(clientID, out PreviewCache cache))
            {
                return cache.GetCachedPreview(guid);
            }

            return null;
        }

        internal static IEnumerable<PreviewCacheNode> GetAllCachedNodesFor(string guid)
        {
            List<PreviewCacheNode> cachedPreviews = new List<PreviewCacheNode>();
            foreach (PreviewCache cache in Caches.Values)
            {
                var node = cache.GetCacheNode(guid);
                if (node != null)
                    cachedPreviews.Add(node);
            }

            return cachedPreviews;
        }

        public static void CachePreview(string guid, Texture2D preview)
        {
            CachePreview(guid, preview, _sharedClientID);
        }
        
#if UNITY_6000_4_OR_NEWER
        public static void CachePreview(string guid, Texture2D preview, EntityId clientID)
#else
        public static void CachePreview(string guid, Texture2D preview, int clientID)
#endif
        {
            if (!Caches.TryGetValue(clientID, out PreviewCache cache))
            {
                cache = new PreviewCache();
                Caches.Add(clientID, cache);
            }

            cache.CachePreview(guid, preview);
        }
        
#if UNITY_6000_4_OR_NEWER
        public static void SetPreviewCacheSize(int size, EntityId clientID)
#else
        public static void SetPreviewCacheSize(int size, int clientID)
#endif
        {
            if (!Caches.TryGetValue(clientID, out PreviewCache cache))
            {
                cache = new PreviewCache();
                Caches.Add(clientID, cache);
            }

            cache.SetCacheSize(size);
        }
        
#if UNITY_6000_4_OR_NEWER
        public static void ClearPreviewCache(EntityId clientID)
#else
        public static void ClearPreviewCache(int clientID)
#endif
        {
            if (Caches.TryGetValue(clientID, out PreviewCache cache))
            {
                cache.ClearCache();
                Caches.Remove(clientID);
            }
        }

        public static void ClearAllPreviewCaches()
        {
            foreach (PreviewCache cache in Caches.Values)
            {
                cache.ClearCache();
            }
        }
    } 
}
