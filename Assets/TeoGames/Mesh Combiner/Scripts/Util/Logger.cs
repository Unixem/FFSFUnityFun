using TeoGames.Mesh_Combiner.Scripts.Profile;
using UnityEngine;

namespace TeoGames.Mesh_Combiner.Scripts.Util {
    public abstract class TestLogger {
        private static long LAST;

        public static void Log(string message, Object context = null) {
            var ns = Timer.NanoTime() / 1000;
            var diff = (int)(LAST > 0 ? ns - LAST : 0);
            LAST = ns;

            if (diff > 0) {
                var col = diff > 1000 ? $"<color=#ff5555>{diff}</color>" : $"{diff}";
                Debug.LogError($"[{col}] {message}", context);
            }
            else Debug.LogError(message);
        }
    }
}