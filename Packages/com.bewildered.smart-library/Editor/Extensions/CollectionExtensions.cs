using System.Collections.Generic;

namespace Bewildered.SmartLibrary
{
    public static class CollectionExtensions
    {
        public static bool Contains<T>(this IReadOnlyList<T> list, T item)
        {
            for (int i = 0; i < list.Count; i++)
            {
                if (Equals(list[i], item))
                    return true;
            }

            return false;
        }
    }
}