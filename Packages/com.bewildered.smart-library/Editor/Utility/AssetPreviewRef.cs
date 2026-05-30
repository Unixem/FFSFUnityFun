using System;
using UnityEngine;
using UnityEditor;

namespace Bewildered.SmartLibrary
{
    internal static class AssetPreviewRef
    {

        
       
#if UNITY_6000_4_OR_NEWER
        private static Action<int, EntityId> _setPreviewTextureCacheSize;
        private static Func<string, EntityId, Texture2D> _getAssetPreviewFromGUID;
        private static Action<EntityId> _deletePreviewTextureManagerByID;
        private static Func<EntityId, EntityId, Texture2D> _getAssetPreview;
#else
        private static Action<int, int> _setPreviewTextureCacheSize;
        private static Func<string, int, Texture2D> _getAssetPreviewFromGUID;
        private static Action<int> _deletePreviewTextureManagerByID;
    #if UNITY_6000_2_OR_NEWER
        private static Func<EntityId, int, Texture2D> _getAssetPreview;
    #else
        private static Func<int, int, Texture2D> _getAssetPreview;
    #endif
#endif
        
        private static Func<int, Texture2D> _getMiniTypeThumbnailFromClassID;
        
        

#if UNITY_6000_4_OR_NEWER
        
        public static Texture2D GetAssetPreview(EntityId instanceId, EntityId clientID)
        {
            if (_getAssetPreview == null)
            {
                _getAssetPreview = TypeAccessor.GetMethod<AssetPreview>("GetAssetPreview", typeof(EntityId), typeof(EntityId))
                    .CreateDelegate<Func<EntityId, EntityId, Texture2D>>();
            }

            return _getAssetPreview(instanceId, clientID);
        }
        
        public static Texture2D GetAssetPreviewFromGUID(string guid, EntityId clientID)
        {
            if (_getAssetPreviewFromGUID == null)
                _getAssetPreviewFromGUID = TypeAccessor.GetMethod<AssetPreview>("GetAssetPreviewFromGUID", typeof(string), typeof(int))
                    .CreateDelegate<Func<string, EntityId, Texture2D>>();

            return _getAssetPreviewFromGUID(guid, clientID);
        }
        
        public static void SetPreviewTextureCacheSize(int size, EntityId clientID)
        {

            if (_setPreviewTextureCacheSize == null)
                _setPreviewTextureCacheSize = TypeAccessor.GetMethod<AssetPreview>("SetPreviewTextureCacheSize", typeof(int), typeof(EntityId))
                    .CreateDelegate<Action<int, EntityId>>(); 

            _setPreviewTextureCacheSize(size, clientID);
        }
        
        public static void DeletePreviewTextureManagerByID(EntityId clientID)
        {
            if (_deletePreviewTextureManagerByID == null)
                _deletePreviewTextureManagerByID = TypeAccessor.GetMethod<AssetPreview>("DeletePreviewTextureManagerByID", typeof(EntityId))
                    .CreateDelegate<Action<EntityId>>();

            _deletePreviewTextureManagerByID(clientID);
        }
#else

        public static Texture2D GetAssetPreview(int instanceId, int clientID)
        {
            if (_getAssetPreview == null)
            {
#if UNITY_6000_2_OR_NEWER
                _getAssetPreview = TypeAccessor.GetMethod<AssetPreview>("GetAssetPreview", typeof(EntityId), typeof(int))
                    .CreateDelegate<Func<EntityId, int, Texture2D>>();
#else
                _getAssetPreview = TypeAccessor.GetMethod<AssetPreview>("GetAssetPreview", typeof(int), typeof(int))
                    .CreateDelegate<Func<int, int, Texture2D>>();
#endif
            }

            return _getAssetPreview(instanceId, clientID);
        }

        public static Texture2D GetAssetPreviewFromGUID(string guid, int clientID)
        {
            if (_getAssetPreviewFromGUID == null)
                _getAssetPreviewFromGUID = TypeAccessor.GetMethod<AssetPreview>("GetAssetPreviewFromGUID", typeof(string), typeof(int))
                    .CreateDelegate<Func<string, int, Texture2D>>();

            return _getAssetPreviewFromGUID(guid, clientID);
        }

        public static void SetPreviewTextureCacheSize(int size, int clientID)
        {
            if (_setPreviewTextureCacheSize == null)
                _setPreviewTextureCacheSize = TypeAccessor.GetMethod<AssetPreview>("SetPreviewTextureCacheSize", typeof(int), typeof(int))
                    .CreateDelegate<Action<int, int>>();

            _setPreviewTextureCacheSize(size, clientID);
        }
        
         public static void DeletePreviewTextureManagerByID(int clientID)
        {
            if (_deletePreviewTextureManagerByID == null)
                _deletePreviewTextureManagerByID = TypeAccessor.GetMethod<AssetPreview>("DeletePreviewTextureManagerByID", typeof(int))
                    .CreateDelegate<Action<int>>();

            _deletePreviewTextureManagerByID(clientID);
        }
#endif

       

        public static Texture2D GetMiniTypeThumbnailFromClassID(int classID)
        {
            if (_getMiniTypeThumbnailFromClassID == null)
                _getMiniTypeThumbnailFromClassID = TypeAccessor.GetMethod<AssetPreview>("GetMiniTypeThumbnailFromClassID", typeof(int))
                    .CreateDelegate<Func<int, Texture2D>>();

            return _getMiniTypeThumbnailFromClassID(classID);
        }
    }
}