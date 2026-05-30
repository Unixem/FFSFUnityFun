using System;
using System.Collections.Generic;
using UnityEngine;

namespace RNGNeeds
{
    /// <summary>
    /// Deck-like ordered operations for <see cref="ProbabilityList{T}"/>.
    /// Uses a card-deck metaphor where the top of the deck is index 0 and the bottom is the last index.
    /// These extensions are order-centric. Cross-deck value transfers move only raw values,
    /// letting the target list create fresh item context using its normal add rules. Random-position helpers
    /// use simple index-based RNG seeded from <see cref="ProbabilityList{T}.Seed"/>, not the list's weighted
    /// selection methods.
    /// Methods are null-safe. Depending on the overload, they return <c>default</c>, <c>null</c>, <c>false</c>,
    /// or perform a no-op when the list is null or cannot satisfy the request.
    /// </summary>
    public static class ProbabilityListDeckExtensions
    {
        /// <summary>
        /// Peeks at the item on top of the deck (index 0) without removing it.
        /// Returns the actual <see cref="ProbabilityItem{T}"/> reference.
        /// </summary>
        /// <param name="probabilityList">The probability list to peek into.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns>The top item reference, or <c>null</c> if the list is null or empty.</returns>
        public static ProbabilityItem<T> PeekTopItem<T>(this ProbabilityList<T> probabilityList)
        {
            return PeekAtItem(probabilityList, 0);
        }

        /// <summary>
        /// Tries to peek at the item on top of the deck (index 0) without removing it.
        /// Returns the actual <see cref="ProbabilityItem{T}"/> reference.
        /// </summary>
        /// <param name="probabilityList">The probability list to peek into.</param>
        /// <param name="item">When this method returns, contains the top item if successful; otherwise, <c>null</c>.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if the peek succeeded; <c>false</c> if the list is null or empty.</returns>
        public static bool TryPeekTopItem<T>(this ProbabilityList<T> probabilityList, out ProbabilityItem<T> item)
        {
            return TryPeekAtItem(probabilityList, 0, out item);
        }

        /// <summary>
        /// Peeks at the item on the bottom of the deck (last index) without removing it.
        /// Returns the actual <see cref="ProbabilityItem{T}"/> reference.
        /// </summary>
        /// <param name="probabilityList">The probability list to peek into.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns>The bottom item reference, or <c>null</c> if the list is null or empty.</returns>
        public static ProbabilityItem<T> PeekBottomItem<T>(this ProbabilityList<T> probabilityList)
        {
            return probabilityList == null ? null : PeekAtItem(probabilityList, probabilityList.ItemCount - 1);
        }

        /// <summary>
        /// Tries to peek at the item on the bottom of the deck (last index) without removing it.
        /// Returns the actual <see cref="ProbabilityItem{T}"/> reference.
        /// </summary>
        /// <param name="probabilityList">The probability list to peek into.</param>
        /// <param name="item">When this method returns, contains the bottom item if successful; otherwise, <c>null</c>.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if the peek succeeded; <c>false</c> if the list is null or empty.</returns>
        public static bool TryPeekBottomItem<T>(this ProbabilityList<T> probabilityList, out ProbabilityItem<T> item)
        {
            item = null;
            return probabilityList != null && TryPeekAtItem(probabilityList, probabilityList.ItemCount - 1, out item);
        }

        /// <summary>
        /// Peeks at the item at the specified index without removing it.
        /// Returns the actual <see cref="ProbabilityItem{T}"/> reference.
        /// </summary>
        /// <param name="probabilityList">The probability list to peek into.</param>
        /// <param name="index">The zero-based index to peek at.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns>The item reference at the specified index, or <c>null</c> if the list is null or the index is out of range.</returns>
        public static ProbabilityItem<T> PeekAtItem<T>(this ProbabilityList<T> probabilityList, int index)
        {
            return TryPeekAtItem(probabilityList, index, out var item) ? item : null;
        }

        /// <summary>
        /// Tries to peek at the item at the specified index without removing it.
        /// Returns the actual <see cref="ProbabilityItem{T}"/> reference.
        /// </summary>
        /// <param name="probabilityList">The probability list to peek into.</param>
        /// <param name="index">The zero-based index to peek at.</param>
        /// <param name="item">When this method returns, contains the item at the index if successful; otherwise, <c>null</c>.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if the index was valid and the peek succeeded; <c>false</c> otherwise.</returns>
        public static bool TryPeekAtItem<T>(this ProbabilityList<T> probabilityList, int index, out ProbabilityItem<T> item)
        {
            item = null;
            return probabilityList != null && probabilityList.TryGetProbabilityItem(index, out item);
        }

        /// <summary>
        /// Peeks at the value on top of the deck (index 0) without removing it.
        /// </summary>
        /// <param name="probabilityList">The probability list to peek into.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns>The top value, or <c>default</c> if the list is null or empty.</returns>
        public static T PeekTop<T>(this ProbabilityList<T> probabilityList)
        {
            return PeekAt(probabilityList, 0);
        }

        /// <summary>
        /// Tries to peek at the value on top of the deck (index 0) without removing it.
        /// </summary>
        /// <param name="probabilityList">The probability list to peek into.</param>
        /// <param name="value">When this method returns, contains the top value if successful; otherwise, <c>default</c>.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if the peek succeeded; <c>false</c> if the list is null or empty.</returns>
        public static bool TryPeekTop<T>(this ProbabilityList<T> probabilityList, out T value)
        {
            return TryPeekAt(probabilityList, 0, out value);
        }

        /// <summary>
        /// Peeks at the value on the bottom of the deck (last index) without removing it.
        /// </summary>
        /// <param name="probabilityList">The probability list to peek into.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns>The bottom value, or <c>default</c> if the list is null or empty.</returns>
        public static T PeekBottom<T>(this ProbabilityList<T> probabilityList)
        {
            return probabilityList == null ? default : PeekAt(probabilityList, probabilityList.ItemCount - 1);
        }

        /// <summary>
        /// Tries to peek at the value on the bottom of the deck (last index) without removing it.
        /// </summary>
        /// <param name="probabilityList">The probability list to peek into.</param>
        /// <param name="value">When this method returns, contains the bottom value if successful; otherwise, <c>default</c>.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if the peek succeeded; <c>false</c> if the list is null or empty.</returns>
        public static bool TryPeekBottom<T>(this ProbabilityList<T> probabilityList, out T value)
        {
            value = default;
            return probabilityList != null && TryPeekAt(probabilityList, probabilityList.ItemCount - 1, out value);
        }

        /// <summary>
        /// Peeks at the value at the specified index without removing it.
        /// </summary>
        /// <param name="probabilityList">The probability list to peek into.</param>
        /// <param name="index">The zero-based index to peek at.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns>The value at the specified index, or <c>default</c> if the list is null or the index is out of range.</returns>
        public static T PeekAt<T>(this ProbabilityList<T> probabilityList, int index)
        {
            return TryPeekAt(probabilityList, index, out var value) ? value : default;
        }

        /// <summary>
        /// Tries to peek at the value at the specified index without removing it.
        /// </summary>
        /// <param name="probabilityList">The probability list to peek into.</param>
        /// <param name="index">The zero-based index to peek at.</param>
        /// <param name="value">When this method returns, contains the value at the index if successful; otherwise, <c>default</c>.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if the index was valid and the peek succeeded; <c>false</c> otherwise.</returns>
        public static bool TryPeekAt<T>(this ProbabilityList<T> probabilityList, int index, out T value)
        {
            value = default;
            if (probabilityList == null || probabilityList.TryGetProbabilityItem(index, out var item) == false) return false;
            value = item.Value;
            return true;
        }

        /// <summary>
        /// Draws (removes and returns) the item from the top of the deck (index 0).
        /// Returns the actual <see cref="ProbabilityItem{T}"/> reference.
        /// This is a destructive operation — the item is removed from the list.
        /// </summary>
        /// <param name="probabilityList">The probability list to draw from.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns>The drawn item, or <c>null</c> if the list is null or empty.</returns>
        public static ProbabilityItem<T> DrawTopItem<T>(this ProbabilityList<T> probabilityList)
        {
            return DrawAtItem(probabilityList, 0);
        }

        /// <summary>
        /// Tries to draw (remove and return) the item from the top of the deck (index 0).
        /// Returns the actual <see cref="ProbabilityItem{T}"/> reference.
        /// This is a destructive operation — the item is removed from the list on success.
        /// </summary>
        /// <param name="probabilityList">The probability list to draw from.</param>
        /// <param name="item">When this method returns, contains the drawn item if successful; otherwise, <c>null</c>.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if an item was drawn; <c>false</c> if the list is null or empty.</returns>
        public static bool TryDrawTopItem<T>(this ProbabilityList<T> probabilityList, out ProbabilityItem<T> item)
        {
            return TryDrawAtItem(probabilityList, 0, out item);
        }

        /// <summary>
        /// Draws (removes and returns) the item from the bottom of the deck (last index).
        /// Returns the actual <see cref="ProbabilityItem{T}"/> reference.
        /// This is a destructive operation — the item is removed from the list.
        /// </summary>
        /// <param name="probabilityList">The probability list to draw from.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns>The drawn item, or <c>null</c> if the list is null or empty.</returns>
        public static ProbabilityItem<T> DrawBottomItem<T>(this ProbabilityList<T> probabilityList)
        {
            return probabilityList == null ? null : DrawAtItem(probabilityList, probabilityList.ItemCount - 1);
        }

        /// <summary>
        /// Tries to draw (remove and return) the item from the bottom of the deck (last index).
        /// Returns the actual <see cref="ProbabilityItem{T}"/> reference.
        /// This is a destructive operation — the item is removed from the list on success.
        /// </summary>
        /// <param name="probabilityList">The probability list to draw from.</param>
        /// <param name="item">When this method returns, contains the drawn item if successful; otherwise, <c>null</c>.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if an item was drawn; <c>false</c> if the list is null or empty.</returns>
        public static bool TryDrawBottomItem<T>(this ProbabilityList<T> probabilityList, out ProbabilityItem<T> item)
        {
            item = null;
            return probabilityList != null && TryDrawAtItem(probabilityList, probabilityList.ItemCount - 1, out item);
        }

        /// <summary>
        /// Draws (removes and returns) the item at the specified index.
        /// Returns the actual <see cref="ProbabilityItem{T}"/> reference.
        /// This is a destructive operation. On success, the item is removed from the list.
        /// </summary>
        /// <param name="probabilityList">The probability list to draw from.</param>
        /// <param name="index">The zero-based index to draw from.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns>The drawn item, or <c>null</c> if the list is null or the index is out of range.</returns>
        public static ProbabilityItem<T> DrawAtItem<T>(this ProbabilityList<T> probabilityList, int index)
        {
            return TryDrawAtItem(probabilityList, index, out var item) ? item : null;
        }

        /// <summary>
        /// Tries to draw (remove and return) the item at the specified index.
        /// Returns the actual <see cref="ProbabilityItem{T}"/> reference.
        /// This is a destructive operation — the item is removed from the list on success.
        /// </summary>
        /// <param name="probabilityList">The probability list to draw from.</param>
        /// <param name="index">The zero-based index to draw from.</param>
        /// <param name="item">When this method returns, contains the drawn item if successful; otherwise, <c>null</c>.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if the index was valid and an item was drawn; <c>false</c> otherwise.</returns>
        public static bool TryDrawAtItem<T>(this ProbabilityList<T> probabilityList, int index, out ProbabilityItem<T> item)
        {
            return TryRemoveItem(probabilityList, index, out item);
        }

        /// <summary>
        /// Draws (removes and returns) multiple items from the top of the deck (starting at index 0).
        /// The returned list preserves top-to-bottom order and contains the actual <see cref="ProbabilityItem{T}"/> references.
        /// This is a destructive operation — drawn items are removed from the list.
        /// </summary>
        /// <param name="probabilityList">The probability list to draw from.</param>
        /// <param name="count">The maximum number of items to draw. Clamped to available items.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns>A list of drawn items. Returns an empty list if the list is null, empty, or count is less than 1.</returns>
        public static List<ProbabilityItem<T>> DrawTopItems<T>(this ProbabilityList<T> probabilityList, int count)
        {
            return DrawItemRange(probabilityList, 0, count);
        }

        /// <summary>
        /// Draws (removes and returns) multiple items from the bottom of the deck.
        /// Items are returned in their original order and contain the actual <see cref="ProbabilityItem{T}"/> references.
        /// This is a destructive operation — drawn items are removed from the list.
        /// </summary>
        /// <param name="probabilityList">The probability list to draw from.</param>
        /// <param name="count">The maximum number of items to draw. Clamped to available items.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns>A list of drawn items. Returns an empty list if the list is null, empty, or count is less than 1.</returns>
        public static List<ProbabilityItem<T>> DrawBottomItems<T>(this ProbabilityList<T> probabilityList, int count)
        {
            if (probabilityList == null || count < 1 || probabilityList.ItemCount < 1) return new List<ProbabilityItem<T>>();
            var actualCount = Mathf.Min(count, probabilityList.ItemCount);
            return DrawItemRange(probabilityList, probabilityList.ItemCount - actualCount, actualCount);
        }

        /// <summary>
        /// Draws (removes and returns) multiple items starting at the specified index.
        /// The returned list contains the actual <see cref="ProbabilityItem{T}"/> references.
        /// This is a destructive operation. On success, the drawn items are removed from the list.
        /// </summary>
        /// <param name="probabilityList">The probability list to draw from.</param>
        /// <param name="index">The zero-based starting index.</param>
        /// <param name="count">The maximum number of items to draw. Clamped to items available from the index.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns>A list of drawn items. Returns an empty list if the list is null or the index is out of range.</returns>
        public static List<ProbabilityItem<T>> DrawAtItems<T>(this ProbabilityList<T> probabilityList, int index, int count)
        {
            return DrawItemRange(probabilityList, index, count);
        }

        /// <summary>
        /// Draws (removes and returns) a single item from a random position in the deck.
        /// Uses the list's <see cref="ProbabilityList{T}.Seed"/> for uniform index selection.
        /// This does not use the list's weighted selection methods or item probabilities.
        /// Returns the actual <see cref="ProbabilityItem{T}"/> reference.
        /// This is a destructive operation. On success, the item is removed from the list.
        /// </summary>
        /// <param name="probabilityList">The probability list to draw from.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns>The drawn item, or <c>null</c> if the list is null or empty.</returns>
        public static ProbabilityItem<T> DrawAtRandomItem<T>(this ProbabilityList<T> probabilityList)
        {
            if (probabilityList == null || probabilityList.ItemCount < 1) return null;
            var random = CreateRandom(probabilityList);
            return DrawAtItem(probabilityList, GetRandomIndex(probabilityList.ItemCount, random));
        }

        /// <summary>
        /// Draws (removes and returns) multiple items from random positions in the deck.
        /// The operation captures a single seed from <see cref="ProbabilityList{T}.Seed"/> and uses it for a
        /// uniform random stream across the entire draw. Random positions do not use the list's weighted
        /// selection methods. The returned list contains the actual <see cref="ProbabilityItem{T}"/> references.
        /// This is a destructive operation — drawn items are removed from the list.
        /// </summary>
        /// <param name="probabilityList">The probability list to draw from.</param>
        /// <param name="count">The maximum number of items to draw. Clamped to available items.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns>A list of drawn items. Returns an empty list if the list is null, empty, or count is less than 1.</returns>
        public static List<ProbabilityItem<T>> DrawAtRandomItems<T>(this ProbabilityList<T> probabilityList, int count)
        {
            if (probabilityList == null || count < 1 || probabilityList.ItemCount < 1) return new List<ProbabilityItem<T>>();
            return DrawRandomItems(probabilityList, Mathf.Min(count, probabilityList.ItemCount), CreateRandom(probabilityList));
        }

        /// <summary>
        /// Draws (removes and returns) a random number of items from random positions in the deck.
        /// The operation captures a single seed from <see cref="ProbabilityList{T}.Seed"/>, uses it to determine
        /// the draw count between <paramref name="min"/> and <paramref name="max"/> (inclusive), then continues
        /// using the same uniform random stream for the draw positions. This does not use the list's weighted
        /// selection methods. If <paramref name="min"/> exceeds <paramref name="max"/>, the values are swapped automatically.
        /// The returned list contains the actual <see cref="ProbabilityItem{T}"/> references.
        /// This is a destructive operation — drawn items are removed from the list.
        /// </summary>
        /// <param name="probabilityList">The probability list to draw from.</param>
        /// <param name="min">The minimum number of items to draw (inclusive). Clamped to the available range [0, ItemCount].</param>
        /// <param name="max">The maximum number of items to draw (inclusive). Clamped to the available range [0, ItemCount]. Returns empty if less than 1 after swap.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns>A list of drawn items. Returns an empty list if the list is null or empty.</returns>
        public static List<ProbabilityItem<T>> DrawAtRandomItems<T>(this ProbabilityList<T> probabilityList, int min, int max)
        {
            if (probabilityList == null || probabilityList.ItemCount < 1) return new List<ProbabilityItem<T>>();
            if (min > max) (min, max) = (max, min);

            min = Mathf.Clamp(min, 0, probabilityList.ItemCount);
            max = Mathf.Clamp(max, 0, probabilityList.ItemCount);
            if (max < 1) return new List<ProbabilityItem<T>>();

            var random = CreateRandom(probabilityList);
            var drawCount = random.Next(min, max + 1);
            return DrawRandomItems(probabilityList, drawCount, random);
        }

        /// <summary>
        /// Draws (removes and returns) the value from the top of the deck (index 0).
        /// This is a destructive operation — the item is removed from the list.
        /// </summary>
        /// <param name="probabilityList">The probability list to draw from.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns>The drawn value, or <c>default</c> if the list is null or empty.</returns>
        public static T DrawTop<T>(this ProbabilityList<T> probabilityList)
        {
            return DrawAt(probabilityList, 0);
        }

        /// <summary>
        /// Tries to draw (remove and return) the value from the top of the deck (index 0).
        /// This is a destructive operation — the item is removed from the list on success.
        /// </summary>
        /// <param name="probabilityList">The probability list to draw from.</param>
        /// <param name="value">When this method returns, contains the drawn value if successful; otherwise, <c>default</c>.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if a value was drawn; <c>false</c> if the list is null or empty.</returns>
        public static bool TryDrawTop<T>(this ProbabilityList<T> probabilityList, out T value)
        {
            return TryDrawAt(probabilityList, 0, out value);
        }

        /// <summary>
        /// Draws (removes and returns) the value from the bottom of the deck (last index).
        /// This is a destructive operation — the item is removed from the list.
        /// </summary>
        /// <param name="probabilityList">The probability list to draw from.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns>The drawn value, or <c>default</c> if the list is null or empty.</returns>
        public static T DrawBottom<T>(this ProbabilityList<T> probabilityList)
        {
            return probabilityList == null ? default : DrawAt(probabilityList, probabilityList.ItemCount - 1);
        }

        /// <summary>
        /// Tries to draw (remove and return) the value from the bottom of the deck (last index).
        /// This is a destructive operation — the item is removed from the list on success.
        /// </summary>
        /// <param name="probabilityList">The probability list to draw from.</param>
        /// <param name="value">When this method returns, contains the drawn value if successful; otherwise, <c>default</c>.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if a value was drawn; <c>false</c> if the list is null or empty.</returns>
        public static bool TryDrawBottom<T>(this ProbabilityList<T> probabilityList, out T value)
        {
            value = default;
            return probabilityList != null && TryDrawAt(probabilityList, probabilityList.ItemCount - 1, out value);
        }

        /// <summary>
        /// Draws (removes and returns) the value at the specified index.
        /// This is a destructive operation — the item is removed from the list.
        /// </summary>
        /// <param name="probabilityList">The probability list to draw from.</param>
        /// <param name="index">The zero-based index to draw from.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns>The drawn value, or <c>default</c> if the list is null or the index is out of range.</returns>
        public static T DrawAt<T>(this ProbabilityList<T> probabilityList, int index)
        {
            return TryDrawAt(probabilityList, index, out var value) ? value : default;
        }

        /// <summary>
        /// Tries to draw (remove and return) the value at the specified index.
        /// This is a destructive operation — the item is removed from the list on success.
        /// </summary>
        /// <param name="probabilityList">The probability list to draw from.</param>
        /// <param name="index">The zero-based index to draw from.</param>
        /// <param name="value">When this method returns, contains the drawn value if successful; otherwise, <c>default</c>.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if the index was valid and a value was drawn; <c>false</c> otherwise.</returns>
        public static bool TryDrawAt<T>(this ProbabilityList<T> probabilityList, int index, out T value)
        {
            value = default;
            if (TryRemoveItem(probabilityList, index, out var item) == false) return false;
            value = item.Value;
            return true;
        }

        /// <summary>
        /// Draws (removes and returns) multiple values from the top of the deck (starting at index 0).
        /// Items are removed in order; the returned list preserves top-to-bottom order.
        /// This is a destructive operation — drawn items are removed from the list.
        /// </summary>
        /// <param name="probabilityList">The probability list to draw from.</param>
        /// <param name="count">The maximum number of items to draw. Clamped to available items.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns>A list of drawn values. Returns an empty list if the list is null, empty, or count is less than 1.</returns>
        public static List<T> DrawTop<T>(this ProbabilityList<T> probabilityList, int count)
        {
            return DrawRange(probabilityList, 0, count);
        }

        /// <summary>
        /// Draws (removes and returns) multiple values from the bottom of the deck.
        /// Items are returned in their original order (not reversed).
        /// This is a destructive operation — drawn items are removed from the list.
        /// </summary>
        /// <param name="probabilityList">The probability list to draw from.</param>
        /// <param name="count">The maximum number of items to draw. Clamped to available items.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns>A list of drawn values. Returns an empty list if the list is null, empty, or count is less than 1.</returns>
        public static List<T> DrawBottom<T>(this ProbabilityList<T> probabilityList, int count)
        {
            if (probabilityList == null || count < 1 || probabilityList.ItemCount < 1) return new List<T>();
            var actualCount = Mathf.Min(count, probabilityList.ItemCount);
            return DrawRange(probabilityList, probabilityList.ItemCount - actualCount, actualCount);
        }

        /// <summary>
        /// Draws (removes and returns) multiple values starting at the specified index.
        /// This is a destructive operation — drawn items are removed from the list.
        /// </summary>
        /// <param name="probabilityList">The probability list to draw from.</param>
        /// <param name="index">The zero-based starting index.</param>
        /// <param name="count">The maximum number of items to draw. Clamped to items available from the index.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns>A list of drawn values. Returns an empty list if the list is null or the index is out of range.</returns>
        public static List<T> DrawAt<T>(this ProbabilityList<T> probabilityList, int index, int count)
        {
            return DrawRange(probabilityList, index, count);
        }

        /// <summary>
        /// Draws (removes and returns) a single value from a random position in the deck.
        /// Uses the list's <see cref="ProbabilityList{T}.Seed"/> for uniform index selection.
        /// This does not use the list's weighted selection methods or item probabilities.
        /// This is a destructive operation — the item is removed from the list.
        /// </summary>
        /// <param name="probabilityList">The probability list to draw from.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns>The drawn value, or <c>default</c> if the list is null or empty.</returns>
        public static T DrawAtRandom<T>(this ProbabilityList<T> probabilityList)
        {
            if (probabilityList == null || probabilityList.ItemCount < 1) return default;
            var random = CreateRandom(probabilityList);
            return DrawAt(probabilityList, GetRandomIndex(probabilityList.ItemCount, random));
        }

        /// <summary>
        /// Draws (removes and returns) multiple values from random positions in the deck.
        /// The operation captures a single seed from <see cref="ProbabilityList{T}.Seed"/> and uses it for a
        /// uniform random stream across the entire draw. Random positions do not use the list's weighted
        /// selection methods.
        /// This is a destructive operation — drawn items are removed from the list.
        /// </summary>
        /// <param name="probabilityList">The probability list to draw from.</param>
        /// <param name="count">The maximum number of items to draw. Clamped to available items.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns>A list of drawn values. Returns an empty list if the list is null, empty, or count is less than 1.</returns>
        public static List<T> DrawAtRandom<T>(this ProbabilityList<T> probabilityList, int count)
        {
            if (probabilityList == null || count < 1 || probabilityList.ItemCount < 1) return new List<T>();
            return DrawRandomValues(probabilityList, Mathf.Min(count, probabilityList.ItemCount), CreateRandom(probabilityList));
        }

        /// <summary>
        /// Draws (removes and returns) a random number of values from random positions in the deck.
        /// The operation captures a single seed from <see cref="ProbabilityList{T}.Seed"/>, uses it to determine
        /// the draw count between <paramref name="min"/> and <paramref name="max"/> (inclusive), then continues
        /// using the same uniform random stream for the draw positions. This does not use the list's weighted
        /// selection methods. If <paramref name="min"/> exceeds <paramref name="max"/>, the values are swapped automatically.
        /// This is a destructive operation — drawn items are removed from the list.
        /// </summary>
        /// <param name="probabilityList">The probability list to draw from.</param>
        /// <param name="min">The minimum number of items to draw (inclusive). Clamped to the available range [0, ItemCount].</param>
        /// <param name="max">The maximum number of items to draw (inclusive). Clamped to the available range [0, ItemCount]. Returns empty if less than 1 after swap.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns>A list of drawn values. Returns an empty list if the list is null or empty.</returns>
        public static List<T> DrawAtRandom<T>(this ProbabilityList<T> probabilityList, int min, int max)
        {
            if (probabilityList == null || probabilityList.ItemCount < 1) return new List<T>();
            if (min > max) (min, max) = (max, min);

            min = Mathf.Clamp(min, 0, probabilityList.ItemCount);
            max = Mathf.Clamp(max, 0, probabilityList.ItemCount);
            if (max < 1) return new List<T>();

            var random = CreateRandom(probabilityList);
            var drawCount = random.Next(min, max + 1);
            return DrawRandomValues(probabilityList, drawCount, random);
        }

        /// <summary>
        /// Places an item on top of the deck (index 0).
        /// This preserves the provided <see cref="ProbabilityItem{T}"/> reference. The target deck may still
        /// recalculate contextual distribution fields such as final probabilities.
        /// </summary>
        /// <param name="probabilityList">The probability list to place into. No-op if null.</param>
        /// <param name="item">The item to place.</param>
        /// <typeparam name="T">The value type.</typeparam>
        public static void PlaceItemOnTop<T>(this ProbabilityList<T> probabilityList, ProbabilityItem<T> item)
        {
            TryPlaceItemOnTop(probabilityList, item);
        }

        /// <summary>
        /// Tries to place an item on top of the deck (index 0).
        /// This preserves the provided <see cref="ProbabilityItem{T}"/> reference. The target deck may still
        /// recalculate contextual distribution fields such as final probabilities.
        /// </summary>
        /// <param name="probabilityList">The probability list to place into.</param>
        /// <param name="item">The item to place.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if the item was placed; <c>false</c> if the list is null, the item is null, or insertion would create an invalid target state.</returns>
        public static bool TryPlaceItemOnTop<T>(this ProbabilityList<T> probabilityList, ProbabilityItem<T> item)
        {
            return TryPlaceAtItem(probabilityList, 0, item);
        }

        /// <summary>
        /// Places an item on the bottom of the deck (last index).
        /// This preserves the provided <see cref="ProbabilityItem{T}"/> reference. The target deck may still
        /// recalculate contextual distribution fields such as final probabilities.
        /// </summary>
        /// <param name="probabilityList">The probability list to place into. No-op if null.</param>
        /// <param name="item">The item to place.</param>
        /// <typeparam name="T">The value type.</typeparam>
        public static void PlaceItemOnBottom<T>(this ProbabilityList<T> probabilityList, ProbabilityItem<T> item)
        {
            TryPlaceItemOnBottom(probabilityList, item);
        }

        /// <summary>
        /// Tries to place an item on the bottom of the deck (last index).
        /// This preserves the provided <see cref="ProbabilityItem{T}"/> reference. The target deck may still
        /// recalculate contextual distribution fields such as final probabilities.
        /// </summary>
        /// <param name="probabilityList">The probability list to place into.</param>
        /// <param name="item">The item to place.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if the item was placed; <c>false</c> if the list is null, the item is null, or insertion would create an invalid target state.</returns>
        public static bool TryPlaceItemOnBottom<T>(this ProbabilityList<T> probabilityList, ProbabilityItem<T> item)
        {
            return probabilityList != null && TryPlaceAtItem(probabilityList, probabilityList.ItemCount, item);
        }

        /// <summary>
        /// Places an item at the specified index.
        /// This is a permissive operation: the index is clamped to the valid range [0, ItemCount].
        /// The target deck may still recalculate contextual distribution fields such as final probabilities.
        /// </summary>
        /// <param name="probabilityList">The probability list to place into. No-op if null.</param>
        /// <param name="index">The zero-based index to place at. Clamped to [0, ItemCount] internally.</param>
        /// <param name="item">The item to place.</param>
        /// <typeparam name="T">The value type.</typeparam>
        public static void PlaceAtItem<T>(this ProbabilityList<T> probabilityList, int index, ProbabilityItem<T> item)
        {
            TryPlaceItemInternal(probabilityList, index, item, false);
        }

        /// <summary>
        /// Tries to place an item at the specified index with strict index validation.
        /// This preserves the provided <see cref="ProbabilityItem{T}"/> reference. The target deck may still
        /// recalculate contextual distribution fields such as final probabilities.
        /// </summary>
        /// <param name="probabilityList">The probability list to place into.</param>
        /// <param name="index">The zero-based index to place at. Must be in range [0, ItemCount].</param>
        /// <param name="item">The item to place.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if the item was placed; <c>false</c> if the list is null, the item is null, the index is out of range, or insertion would create an invalid target state.</returns>
        public static bool TryPlaceAtItem<T>(this ProbabilityList<T> probabilityList, int index, ProbabilityItem<T> item)
        {
            return TryPlaceItemInternal(probabilityList, index, item, true);
        }

        /// <summary>
        /// Places multiple items on top of the deck (starting at index 0).
        /// This preserves the provided <see cref="ProbabilityItem{T}"/> references. The whole batch is validated first,
        /// then inserted atomically if the target deck can legally accept all items.
        /// </summary>
        /// <param name="probabilityList">The probability list to place into. No-op if null.</param>
        /// <param name="items">The items to place. No-op if null or empty.</param>
        /// <param name="preserveOrder">If <c>true</c> (default), the first element in <paramref name="items"/>
        /// becomes the new top (index 0). If <c>false</c>, the sequence is reversed before insertion.</param>
        /// <typeparam name="T">The value type.</typeparam>
        public static void PlaceItemsOnTop<T>(this ProbabilityList<T> probabilityList, IEnumerable<ProbabilityItem<T>> items, bool preserveOrder = true)
        {
            TryPlaceItemsOnTop(probabilityList, items, preserveOrder);
        }

        /// <summary>
        /// Tries to place multiple items on top of the deck (starting at index 0).
        /// This preserves the provided <see cref="ProbabilityItem{T}"/> references. The whole batch is validated first,
        /// then inserted atomically if the target deck can legally accept all items.
        /// </summary>
        /// <param name="probabilityList">The probability list to place into.</param>
        /// <param name="items">The items to place.</param>
        /// <param name="preserveOrder">If <c>true</c> (default), the first element in <paramref name="items"/>
        /// becomes the new top (index 0). If <c>false</c>, the sequence is reversed before insertion.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if the items were placed; <c>false</c> if the list or items are null, items is empty, the batch contains invalid references, or insertion would create an invalid target state.</returns>
        public static bool TryPlaceItemsOnTop<T>(this ProbabilityList<T> probabilityList, IEnumerable<ProbabilityItem<T>> items, bool preserveOrder = true)
        {
            return TryPlaceAtItems(probabilityList, 0, items, preserveOrder);
        }

        /// <summary>
        /// Places multiple items on the bottom of the deck (appended after the last index).
        /// This preserves the provided <see cref="ProbabilityItem{T}"/> references. The whole batch is validated first,
        /// then inserted atomically if the target deck can legally accept all items.
        /// </summary>
        /// <param name="probabilityList">The probability list to place into. No-op if null.</param>
        /// <param name="items">The items to place. No-op if null or empty.</param>
        /// <param name="preserveOrder">If <c>true</c> (default), the first element in <paramref name="items"/>
        /// is placed first (closest to the existing bottom). If <c>false</c>, the sequence is reversed before appending.</param>
        /// <typeparam name="T">The value type.</typeparam>
        public static void PlaceItemsOnBottom<T>(this ProbabilityList<T> probabilityList, IEnumerable<ProbabilityItem<T>> items, bool preserveOrder = true)
        {
            TryPlaceItemsOnBottom(probabilityList, items, preserveOrder);
        }

        /// <summary>
        /// Tries to place multiple items on the bottom of the deck (appended after the last index).
        /// This preserves the provided <see cref="ProbabilityItem{T}"/> references. The whole batch is validated first,
        /// then inserted atomically if the target deck can legally accept all items.
        /// </summary>
        /// <param name="probabilityList">The probability list to place into.</param>
        /// <param name="items">The items to place.</param>
        /// <param name="preserveOrder">If <c>true</c> (default), the first element in <paramref name="items"/>
        /// is placed first (closest to the existing bottom). If <c>false</c>, the sequence is reversed before appending.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if the items were placed; <c>false</c> if the list or items are null, items is empty, the batch contains invalid references, or insertion would create an invalid target state.</returns>
        public static bool TryPlaceItemsOnBottom<T>(this ProbabilityList<T> probabilityList, IEnumerable<ProbabilityItem<T>> items, bool preserveOrder = true)
        {
            return probabilityList != null && TryPlaceAtItems(probabilityList, probabilityList.ItemCount, items, preserveOrder);
        }

        /// <summary>
        /// Places multiple items at the specified index.
        /// This is a permissive operation: the index is clamped to the valid range [0, ItemCount].
        /// The whole batch is validated first, then inserted atomically if the target deck can legally accept all items.
        /// </summary>
        /// <param name="probabilityList">The probability list to place into. No-op if null.</param>
        /// <param name="index">The zero-based index to insert at. Clamped to [0, ItemCount] internally.</param>
        /// <param name="items">The items to place. No-op if null or empty.</param>
        /// <param name="preserveOrder">If <c>true</c> (default), items maintain their enumeration order.
        /// If <c>false</c>, the sequence is reversed before insertion.</param>
        /// <typeparam name="T">The value type.</typeparam>
        public static void PlaceAtItems<T>(this ProbabilityList<T> probabilityList, int index, IEnumerable<ProbabilityItem<T>> items, bool preserveOrder = true)
        {
            TryPlaceItemsInternal(probabilityList, index, items, preserveOrder, false);
        }

        /// <summary>
        /// Tries to place multiple items at the specified index with strict index validation.
        /// This preserves the provided <see cref="ProbabilityItem{T}"/> references. The whole batch is validated first,
        /// then inserted atomically if the target deck can legally accept all items.
        /// </summary>
        /// <param name="probabilityList">The probability list to place into.</param>
        /// <param name="index">The zero-based index to insert at. Must be in range [0, ItemCount].</param>
        /// <param name="items">The items to place.</param>
        /// <param name="preserveOrder">If <c>true</c> (default), items maintain their enumeration order.
        /// If <c>false</c>, the sequence is reversed before insertion.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if the items were placed; <c>false</c> if the list or items are null, the index is out of range, items is empty, the batch contains invalid references, or insertion would create an invalid target state.</returns>
        public static bool TryPlaceAtItems<T>(this ProbabilityList<T> probabilityList, int index, IEnumerable<ProbabilityItem<T>> items, bool preserveOrder = true)
        {
            return TryPlaceItemsInternal(probabilityList, index, items, preserveOrder, true);
        }

        /// <summary>
        /// Places a value on top of the deck (index 0).
        /// This is a permissive operation that succeeds whenever the list is not null.
        /// Equivalent to calling <see cref="PlaceAt{T}(ProbabilityList{T}, int, T)"/> with index 0.
        /// </summary>
        /// <param name="probabilityList">The probability list to place into. No-op if null.</param>
        /// <param name="value">The value to place.</param>
        /// <typeparam name="T">The value type.</typeparam>
        public static void PlaceOnTop<T>(this ProbabilityList<T> probabilityList, T value)
        {
            TryPlaceOnTop(probabilityList, value);
        }

        /// <summary>
        /// Tries to place a value on top of the deck (index 0).
        /// </summary>
        /// <param name="probabilityList">The probability list to place into.</param>
        /// <param name="value">The value to place.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if the value was placed; <c>false</c> if the list is null.</returns>
        public static bool TryPlaceOnTop<T>(this ProbabilityList<T> probabilityList, T value)
        {
            return TryPlaceAt(probabilityList, 0, value);
        }

        /// <summary>
        /// Places multiple values on top of the deck (starting at index 0).
        /// </summary>
        /// <param name="probabilityList">The probability list to place into. No-op if null.</param>
        /// <param name="values">The values to place. No-op if null or empty.</param>
        /// <param name="preserveOrder">If <c>true</c> (default), the first element in <paramref name="values"/>
        /// becomes the new top (index 0). If <c>false</c>, the sequence is reversed before insertion.</param>
        /// <typeparam name="T">The value type.</typeparam>
        public static void PlaceOnTop<T>(this ProbabilityList<T> probabilityList, IEnumerable<T> values, bool preserveOrder = true)
        {
            TryPlaceOnTop(probabilityList, values, preserveOrder);
        }

        /// <summary>
        /// Tries to place multiple values on top of the deck (starting at index 0).
        /// </summary>
        /// <param name="probabilityList">The probability list to place into.</param>
        /// <param name="values">The values to place.</param>
        /// <param name="preserveOrder">If <c>true</c> (default), the first element in <paramref name="values"/>
        /// becomes the new top (index 0). If <c>false</c>, the sequence is reversed before insertion.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if values were placed; <c>false</c> if the list or values are null, or values is empty.</returns>
        public static bool TryPlaceOnTop<T>(this ProbabilityList<T> probabilityList, IEnumerable<T> values, bool preserveOrder = true)
        {
            return TryPlaceValues(probabilityList, 0, values, preserveOrder, true);
        }

        /// <summary>
        /// Places a value on the bottom of the deck (last index).
        /// </summary>
        /// <param name="probabilityList">The probability list to place into. No-op if null.</param>
        /// <param name="value">The value to place.</param>
        /// <typeparam name="T">The value type.</typeparam>
        public static void PlaceOnBottom<T>(this ProbabilityList<T> probabilityList, T value)
        {
            TryPlaceOnBottom(probabilityList, value);
        }

        /// <summary>
        /// Tries to place a value on the bottom of the deck (last index).
        /// </summary>
        /// <param name="probabilityList">The probability list to place into.</param>
        /// <param name="value">The value to place.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if the value was placed; <c>false</c> if the list is null.</returns>
        public static bool TryPlaceOnBottom<T>(this ProbabilityList<T> probabilityList, T value)
        {
            return probabilityList != null && TryPlaceAt(probabilityList, probabilityList.ItemCount, value);
        }

        /// <summary>
        /// Places multiple values on the bottom of the deck (appended after the last index).
        /// </summary>
        /// <param name="probabilityList">The probability list to place into. No-op if null.</param>
        /// <param name="values">The values to place. No-op if null or empty.</param>
        /// <param name="preserveOrder">If <c>true</c> (default), the first element in <paramref name="values"/>
        /// is placed first (closest to the existing bottom). If <c>false</c>, the sequence is reversed before appending.</param>
        /// <typeparam name="T">The value type.</typeparam>
        public static void PlaceOnBottom<T>(this ProbabilityList<T> probabilityList, IEnumerable<T> values, bool preserveOrder = true)
        {
            TryPlaceOnBottom(probabilityList, values, preserveOrder);
        }

        /// <summary>
        /// Tries to place multiple values on the bottom of the deck (appended after the last index).
        /// </summary>
        /// <param name="probabilityList">The probability list to place into.</param>
        /// <param name="values">The values to place.</param>
        /// <param name="preserveOrder">If <c>true</c> (default), the first element in <paramref name="values"/>
        /// is placed first (closest to the existing bottom). If <c>false</c>, the sequence is reversed before appending.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if values were placed; <c>false</c> if the list or values are null, or values is empty.</returns>
        public static bool TryPlaceOnBottom<T>(this ProbabilityList<T> probabilityList, IEnumerable<T> values, bool preserveOrder = true)
        {
            return probabilityList != null && TryPlaceValues(probabilityList, probabilityList.ItemCount, values, preserveOrder, true);
        }

        /// <summary>
        /// Places a value at the specified index.
        /// This is a permissive operation: the index is clamped to the valid range [0, ItemCount],
        /// so out-of-range indices are silently adjusted rather than rejected.
        /// For strict index validation, use <see cref="TryPlaceAt{T}(ProbabilityList{T}, int, T)"/> instead.
        /// </summary>
        /// <param name="probabilityList">The probability list to place into. No-op if null.</param>
        /// <param name="index">The zero-based index to place at. Clamped to [0, ItemCount] internally.</param>
        /// <param name="value">The value to place.</param>
        /// <typeparam name="T">The value type.</typeparam>
        public static void PlaceAt<T>(this ProbabilityList<T> probabilityList, int index, T value)
        {
            if (probabilityList == null) return;
            probabilityList.AddItem(index, value);
            probabilityList.ClearHistory();
        }

        /// <summary>
        /// Tries to place a value at the specified index with strict index validation.
        /// Unlike <see cref="PlaceAt{T}(ProbabilityList{T}, int, T)"/>, this method returns <c>false</c>
        /// for out-of-range indices instead of clamping them.
        /// </summary>
        /// <param name="probabilityList">The probability list to place into.</param>
        /// <param name="index">The zero-based index to place at. Must be in range [0, ItemCount].</param>
        /// <param name="value">The value to place.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if the value was placed; <c>false</c> if the list is null or the index is out of range.</returns>
        public static bool TryPlaceAt<T>(this ProbabilityList<T> probabilityList, int index, T value)
        {
            if (probabilityList == null) return false;
            if (index < 0 || index > probabilityList.ItemCount) return false;
            probabilityList.AddItem(index, value);
            probabilityList.ClearHistory();
            return true;
        }

        /// <summary>
        /// Places multiple values at the specified index.
        /// This is a permissive operation: the index is clamped to the valid range [0, ItemCount].
        /// Batch placement follows the same probability rules as placing values one by one into the target list in final order.
        /// For strict index validation, use <see cref="TryPlaceAt{T}(ProbabilityList{T}, int, IEnumerable{T}, bool)"/> instead.
        /// </summary>
        /// <param name="probabilityList">The probability list to place into. No-op if null.</param>
        /// <param name="index">The zero-based index to insert at. Clamped to [0, ItemCount] internally.</param>
        /// <param name="values">The values to place. No-op if null or empty.</param>
        /// <param name="preserveOrder">If <c>true</c> (default), values maintain their enumeration order.
        /// If <c>false</c>, the sequence is reversed before insertion.</param>
        /// <typeparam name="T">The value type.</typeparam>
        public static void PlaceAt<T>(this ProbabilityList<T> probabilityList, int index, IEnumerable<T> values, bool preserveOrder = true)
        {
            TryPlaceValues(probabilityList, index, values, preserveOrder, false);
        }

        /// <summary>
        /// Tries to place multiple values at the specified index with strict index validation.
        /// Batch placement follows the same probability rules as placing values one by one into the target list
        /// in final order. Unlike <see cref="PlaceAt{T}(ProbabilityList{T}, int, IEnumerable{T}, bool)"/>,
        /// this method returns <c>false</c> for out-of-range indices instead of clamping them.
        /// </summary>
        /// <param name="probabilityList">The probability list to place into.</param>
        /// <param name="index">The zero-based index to insert at. Must be in range [0, ItemCount].</param>
        /// <param name="values">The values to place.</param>
        /// <param name="preserveOrder">If <c>true</c> (default), values maintain their enumeration order.
        /// If <c>false</c>, the sequence is reversed before insertion.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if values were placed; <c>false</c> if the list or values are null, the index is out of range, or values is empty.</returns>
        public static bool TryPlaceAt<T>(this ProbabilityList<T> probabilityList, int index, IEnumerable<T> values, bool preserveOrder = true)
        {
            return TryPlaceValues(probabilityList, index, values, preserveOrder, true);
        }

        /// <summary>
        /// Places a value at a random position in the deck.
        /// Uses the list's <see cref="ProbabilityList{T}.Seed"/> for uniform index selection.
        /// The index is chosen from the full insertion range [0, ItemCount] and does not use weighted selection methods.
        /// </summary>
        /// <param name="probabilityList">The probability list to place into. No-op if null.</param>
        /// <param name="value">The value to place.</param>
        /// <typeparam name="T">The value type.</typeparam>
        public static void PlaceAtRandom<T>(this ProbabilityList<T> probabilityList, T value)
        {
            if (probabilityList == null) return;
            var random = CreateRandom(probabilityList);
            var randomIndex = probabilityList.ItemCount < 1 ? 0 : GetRandomInsertIndex(probabilityList.ItemCount, random);
            PlaceAt(probabilityList, randomIndex, value);
        }

        /// <summary>
        /// Moves an item from one position to another within the deck.
        /// The <see cref="ProbabilityItem{T}"/> reference is preserved.
        /// </summary>
        /// <param name="probabilityList">The probability list to reorder. No-op if null.</param>
        /// <param name="fromIndex">The zero-based index to move from.</param>
        /// <param name="toIndex">The zero-based index to move to.</param>
        /// <typeparam name="T">The value type.</typeparam>
        public static void MoveTo<T>(this ProbabilityList<T> probabilityList, int fromIndex, int toIndex)
        {
            TryMoveTo(probabilityList, fromIndex, toIndex);
        }

        /// <summary>
        /// Tries to move an item from one position to another within the deck.
        /// The <see cref="ProbabilityItem{T}"/> reference is preserved.
        /// </summary>
        /// <param name="probabilityList">The probability list to reorder.</param>
        /// <param name="fromIndex">The zero-based index to move from. Must be a valid index.</param>
        /// <param name="toIndex">The zero-based index to move to. Must be a valid index and different from <paramref name="fromIndex"/>.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if the move succeeded; <c>false</c> if the list is null, either index is out of range, or both indices are equal.</returns>
        public static bool TryMoveTo<T>(this ProbabilityList<T> probabilityList, int fromIndex, int toIndex)
        {
            if (probabilityList == null) return false;
            var items = probabilityList.ProbabilityItems;
            if (IsValidIndex(fromIndex, items.Count) == false || IsValidIndex(toIndex, items.Count) == false || fromIndex == toIndex) return false;
            var item = items[fromIndex];
            items.RemoveAt(fromIndex);
            items.Insert(toIndex, item);
            probabilityList.ClearHistory();
            return true;
        }

        /// <summary>
        /// Swaps two items at the specified indices. Both <see cref="ProbabilityItem{T}"/> references are preserved.
        /// </summary>
        /// <param name="probabilityList">The probability list to reorder. No-op if null.</param>
        /// <param name="indexA">The zero-based index of the first item.</param>
        /// <param name="indexB">The zero-based index of the second item.</param>
        /// <typeparam name="T">The value type.</typeparam>
        public static void Swap<T>(this ProbabilityList<T> probabilityList, int indexA, int indexB)
        {
            TrySwap(probabilityList, indexA, indexB);
        }

        /// <summary>
        /// Tries to swap two items at the specified indices. Both <see cref="ProbabilityItem{T}"/> references are preserved.
        /// </summary>
        /// <param name="probabilityList">The probability list to reorder.</param>
        /// <param name="indexA">The zero-based index of the first item. Must be valid and different from <paramref name="indexB"/>.</param>
        /// <param name="indexB">The zero-based index of the second item. Must be valid and different from <paramref name="indexA"/>.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if the swap succeeded; <c>false</c> if the list is null, either index is out of range, or both indices are equal.</returns>
        public static bool TrySwap<T>(this ProbabilityList<T> probabilityList, int indexA, int indexB)
        {
            if (probabilityList == null) return false;
            var items = probabilityList.ProbabilityItems;
            if (IsValidIndex(indexA, items.Count) == false || IsValidIndex(indexB, items.Count) == false || indexA == indexB) return false;
            (items[indexA], items[indexB]) = (items[indexB], items[indexA]);
            probabilityList.ClearHistory();
            return true;
        }

        /// <summary>
        /// Swaps two randomly selected items in the deck.
        /// Uses the list's <see cref="ProbabilityList{T}.Seed"/> for uniform index selection.
        /// This does not use the list's weighted selection methods. <see cref="ProbabilityItem{T}"/> references are preserved.
        /// </summary>
        /// <param name="probabilityList">The probability list to reorder.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns>A tuple containing: Success (<c>true</c> if swapped), the values and previous indices of both items.
        /// Returns <c>(false, default, -1, default, -1)</c> if the list is null or has fewer than 2 items.</returns>
        public static (bool Success, T ItemA, int PreviousIndexA, T ItemB, int PreviousIndexB) SwapRandom<T>(this ProbabilityList<T> probabilityList)
        {
            if (probabilityList == null || probabilityList.ItemCount < 2) return (false, default, -1, default, -1);
            var random = CreateRandom(probabilityList);
            var firstIndex = GetRandomIndex(probabilityList.ItemCount, random);
            var secondIndex = random.Next(0, probabilityList.ItemCount - 1);
            if (secondIndex >= firstIndex) secondIndex++;

            var itemA = probabilityList.GetProbabilityItem(firstIndex).Value;
            var itemB = probabilityList.GetProbabilityItem(secondIndex).Value;
            Swap(probabilityList, firstIndex, secondIndex);
            return (true, itemA, firstIndex, itemB, secondIndex);
        }

        /// <summary>
        /// Cuts the deck at the specified index, moving all items before the index to the bottom.
        /// Similar to cutting a physical deck of cards. <see cref="ProbabilityItem{T}"/> references are preserved.
        /// </summary>
        /// <param name="probabilityList">The probability list to cut. No-op if null.</param>
        /// <param name="index">The zero-based index to cut at. Items [0, index) move to the bottom.</param>
        /// <typeparam name="T">The value type.</typeparam>
        public static void Cut<T>(this ProbabilityList<T> probabilityList, int index)
        {
            TryCut(probabilityList, index);
        }

        /// <summary>
        /// Tries to cut the deck at the specified index, moving all items before the index to the bottom.
        /// Similar to cutting a physical deck of cards. <see cref="ProbabilityItem{T}"/> references are preserved.
        /// </summary>
        /// <param name="probabilityList">The probability list to cut.</param>
        /// <param name="index">The zero-based index to cut at. Must be greater than 0 and less than ItemCount.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if the cut succeeded; <c>false</c> if the list is null, has fewer than 2 items,
        /// or the index is at the boundary (0 or ItemCount).</returns>
        public static bool TryCut<T>(this ProbabilityList<T> probabilityList, int index)
        {
            if (probabilityList == null) return false;
            var items = probabilityList.ProbabilityItems;
            if (items.Count < 2 || index <= 0 || index >= items.Count) return false;
            var movedItems = items.GetRange(0, index);
            items.RemoveRange(0, index);
            items.AddRange(movedItems);
            probabilityList.ClearHistory();
            return true;
        }

        /// <summary>
        /// Reverses the order of all items in the deck. <see cref="ProbabilityItem{T}"/> references are preserved.
        /// </summary>
        /// <param name="probabilityList">The probability list to reverse. No-op if null or has fewer than 2 items.</param>
        /// <typeparam name="T">The value type.</typeparam>
        public static void ReverseDeck<T>(this ProbabilityList<T> probabilityList)
        {
            TryReverseDeck(probabilityList);
        }

        /// <summary>
        /// Tries to reverse the order of all items in the deck. <see cref="ProbabilityItem{T}"/> references are preserved.
        /// </summary>
        /// <param name="probabilityList">The probability list to reverse.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if the deck was reversed; <c>false</c> if the list is null or has fewer than 2 items.</returns>
        public static bool TryReverseDeck<T>(this ProbabilityList<T> probabilityList)
        {
            if (probabilityList == null || probabilityList.ItemCount < 2) return false;
            probabilityList.ProbabilityItems.Reverse();
            probabilityList.ClearHistory();
            return true;
        }

        /// <summary>
        /// Creates a shuffle plan using the default built-in shuffle method.
        /// </summary>
        /// <param name="probabilityList">The probability list to plan for.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns>A deterministic plan describing how the deck order will change.</returns>
        public static DeckShufflePlan CreateShufflePlan<T>(this ProbabilityList<T> probabilityList)
        {
            return CreateShufflePlan(probabilityList, DeckShuffleMethods.Default);
        }

        /// <summary>
        /// Creates a shuffle plan using the provided shuffle method.
        /// </summary>
        /// <param name="probabilityList">The probability list to plan for.</param>
        /// <param name="shuffleMethod">The shuffle method used to build the plan.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns>A deterministic plan describing how the deck order will change.</returns>
        public static DeckShufflePlan CreateShufflePlan<T>(this ProbabilityList<T> probabilityList, IDeckShuffleMethod shuffleMethod)
        {
            if (probabilityList == null) return new DeckShufflePlan(string.Empty, string.Empty, Array.Empty<DeckShuffleStep>(), Array.Empty<int>());
            shuffleMethod ??= DeckShuffleMethods.Default;
            return shuffleMethod.CreatePlan(probabilityList, CreateRandom(probabilityList));
        }

        /// <summary>
        /// Applies a previously created shuffle plan to the deck.
        /// </summary>
        /// <param name="probabilityList">The probability list to reorder.</param>
        /// <param name="shufflePlan">The plan to apply.</param>
        /// <typeparam name="T">The value type.</typeparam>
        public static void ApplyShufflePlan<T>(this ProbabilityList<T> probabilityList, DeckShufflePlan shufflePlan)
        {
            TryApplyShufflePlan(probabilityList, shufflePlan);
        }

        /// <summary>
        /// Tries to apply a previously created shuffle plan to the deck.
        /// </summary>
        /// <param name="probabilityList">The probability list to reorder.</param>
        /// <param name="shufflePlan">The plan to apply.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if the plan was applied; otherwise, <c>false</c>.</returns>
        public static bool TryApplyShufflePlan<T>(this ProbabilityList<T> probabilityList, DeckShufflePlan shufflePlan)
        {
            if (probabilityList == null || shufflePlan == null) return false;
            var items = probabilityList.ProbabilityItems;
            if (shufflePlan.FinalOrder.Count != items.Count) return false;
            var reorderedItems = new List<ProbabilityItem<T>>(items.Count);
            for (var i = 0; i < shufflePlan.FinalOrder.Count; i++)
            {
                var sourceIndex = shufflePlan.FinalOrder[i];
                if (sourceIndex < 0 || sourceIndex >= items.Count) return false;
                reorderedItems.Add(items[sourceIndex]);
            }

            items.Clear();
            items.AddRange(reorderedItems);
            probabilityList.ClearHistory();
            return true;
        }

        /// <summary>
        /// Shuffles all items in the deck using the default built-in shuffle method.
        /// </summary>
        /// <param name="probabilityList">The probability list to shuffle. No-op if null or has fewer than 2 items.</param>
        /// <typeparam name="T">The value type.</typeparam>
        public static void ShuffleDeck<T>(this ProbabilityList<T> probabilityList)
        {
            TryShuffleDeck(probabilityList);
        }

        /// <summary>
        /// Tries to shuffle all items in the deck using the default built-in shuffle method.
        /// </summary>
        /// <param name="probabilityList">The probability list to shuffle.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if the deck was shuffled; <c>false</c> if the list is null or has fewer than 2 items.</returns>
        public static bool TryShuffleDeck<T>(this ProbabilityList<T> probabilityList)
        {
            return TryShuffleDeck(probabilityList, DeckShuffleMethods.Default);
        }

        /// <summary>
        /// Shuffles all items in the deck using a provided shuffle method.
        /// </summary>
        /// <param name="probabilityList">The probability list to shuffle. No-op if null or has fewer than 2 items.</param>
        /// <param name="shuffleMethod">The shuffle method that will build the order plan.</param>
        /// <typeparam name="T">The value type.</typeparam>
        public static void ShuffleDeck<T>(this ProbabilityList<T> probabilityList, IDeckShuffleMethod shuffleMethod)
        {
            TryShuffleDeck(probabilityList, shuffleMethod);
        }

        /// <summary>
        /// Tries to shuffle all items in the deck using a provided shuffle method.
        /// </summary>
        /// <param name="probabilityList">The probability list to shuffle.</param>
        /// <param name="shuffleMethod">The shuffle method that will build the order plan.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if the deck was shuffled; <c>false</c> if the list is null, has fewer than 2 items, or the plan could not be applied.</returns>
        public static bool TryShuffleDeck<T>(this ProbabilityList<T> probabilityList, IDeckShuffleMethod shuffleMethod)
        {
            if (probabilityList == null || probabilityList.ItemCount < 2) return false;
            return TryApplyShufflePlan(probabilityList, CreateShufflePlan(probabilityList, shuffleMethod));
        }

        /// <summary>
        /// Creates and applies a riffle shuffle plan.
        /// </summary>
        public static void RiffleShuffle<T>(this ProbabilityList<T> probabilityList)
        {
            TryShuffleDeck(probabilityList, DeckShuffleMethods.Riffle);
        }

        /// <summary>
        /// Tries to create and apply a riffle shuffle plan.
        /// </summary>
        public static bool TryRiffleShuffle<T>(this ProbabilityList<T> probabilityList)
        {
            return TryShuffleDeck(probabilityList, DeckShuffleMethods.Riffle);
        }

        /// <summary>
        /// Creates and applies an overhand shuffle plan.
        /// </summary>
        public static void OverhandShuffle<T>(this ProbabilityList<T> probabilityList)
        {
            TryShuffleDeck(probabilityList, DeckShuffleMethods.Overhand);
        }

        /// <summary>
        /// Tries to create and apply an overhand shuffle plan.
        /// </summary>
        public static bool TryOverhandShuffle<T>(this ProbabilityList<T> probabilityList)
        {
            return TryShuffleDeck(probabilityList, DeckShuffleMethods.Overhand);
        }

        /// <summary>
        /// Creates and applies a near-half cut plan.
        /// </summary>
        public static void CutNearHalf<T>(this ProbabilityList<T> probabilityList)
        {
            TryShuffleDeck(probabilityList, DeckShuffleMethods.CutNearHalf);
        }

        /// <summary>
        /// Tries to create and apply a near-half cut plan.
        /// </summary>
        public static bool TryCutNearHalf<T>(this ProbabilityList<T> probabilityList)
        {
            return TryShuffleDeck(probabilityList, DeckShuffleMethods.CutNearHalf);
        }

        /// <summary>
        /// Deals the top item from the source deck to the bottom of the target deck.
        /// This preserves the moved <see cref="ProbabilityItem{T}"/> reference.
        /// The target deck may still recalculate contextual distribution fields such as final probabilities.
        /// This is a destructive operation on the source. On success, the top item is removed from source and placed on the bottom of target.
        /// </summary>
        /// <param name="source">The source deck to draw from.</param>
        /// <param name="target">The target deck to place into.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns>The dealt item, or <c>null</c> if either deck is null, the source is empty, or the target cannot legally accept the item.</returns>
        public static ProbabilityItem<T> DealItemToDeck<T>(this ProbabilityList<T> source, ProbabilityList<T> target)
        {
            if (TryDealItemToDeck(source, target, out var item) == false) return null;
            return item;
        }

        /// <summary>
        /// Tries to deal the top item from the source deck to the bottom of the target deck.
        /// This preserves the moved <see cref="ProbabilityItem{T}"/> reference.
        /// The target deck may still recalculate contextual distribution fields such as final probabilities.
        /// This is a destructive operation on the source. On success, the top item is removed from source and placed on the bottom of target.
        /// </summary>
        /// <param name="source">The source deck to draw from.</param>
        /// <param name="target">The target deck to place into.</param>
        /// <param name="item">When this method returns, contains the dealt item if successful; otherwise, <c>null</c>.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if the item was dealt; <c>false</c> if either deck is null, the source is empty, or the target cannot legally accept the item.</returns>
        public static bool TryDealItemToDeck<T>(this ProbabilityList<T> source, ProbabilityList<T> target, out ProbabilityItem<T> item)
        {
            item = null;
            if (source == null || target == null || ReferenceEquals(source, target) || source.TryPeekTopItem(out var peekedItem) == false) return false;
            if (CanAcceptItemInTarget(target, peekedItem) == false) return false;
            if (source.TryDrawTopItem(out item) == false) return false;
            if (target.TryPlaceItemOnBottom(item)) return true;
            item = null;
            return false;
        }

        /// <summary>
        /// Deals multiple items from the top of the source deck to the bottom of the target deck.
        /// Items maintain their relative order in the target deck and preserve their actual <see cref="ProbabilityItem{T}"/> references.
        /// The whole transfer is validated first, then performed atomically.
        /// </summary>
        /// <param name="source">The source deck to draw from.</param>
        /// <param name="target">The target deck to place into.</param>
        /// <param name="count">The maximum number of items to deal. Clamped to available items in the source.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns>A list of dealt items. Returns an empty list if either deck is null, count is less than 1, the source is empty, or the target cannot legally accept the whole batch.</returns>
        public static List<ProbabilityItem<T>> DealItemsToDeck<T>(this ProbabilityList<T> source, ProbabilityList<T> target, int count)
        {
            return TryDealItemsToDeck(source, target, count, out var items) ? items : new List<ProbabilityItem<T>>();
        }

        /// <summary>
        /// Tries to deal multiple items from the top of the source deck to the bottom of the target deck.
        /// Items maintain their relative order in the target deck and preserve their actual <see cref="ProbabilityItem{T}"/> references.
        /// The whole transfer is validated first, then performed atomically.
        /// </summary>
        /// <param name="source">The source deck to draw from.</param>
        /// <param name="target">The target deck to place into.</param>
        /// <param name="count">The maximum number of items to deal. Clamped to available items in the source.</param>
        /// <param name="items">When this method returns, contains the dealt items if successful; otherwise, an empty list.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns><c>true</c> if the items were dealt; <c>false</c> if either deck is null, count is less than 1, the source is empty, the source and target are the same deck, or the target cannot legally accept the whole batch.</returns>
        public static bool TryDealItemsToDeck<T>(this ProbabilityList<T> source, ProbabilityList<T> target, int count, out List<ProbabilityItem<T>> items)
        {
            items = new List<ProbabilityItem<T>>();
            if (source == null || target == null || ReferenceEquals(source, target) || count < 1 || source.ItemCount < 1) return false;

            var actualCount = Mathf.Min(count, source.ItemCount);
            var sourceItems = source.ProbabilityItems.GetRange(0, actualCount);
            if (CanAcceptItemsInTarget(target, sourceItems) == false) return false;

            items = DrawTopItems(source, actualCount);
            return target.TryPlaceItemsOnBottom(items);
        }

        /// <summary>
        /// Deals the top value from the source deck to the bottom of the target deck.
        /// This is a value transfer: only the drawn <typeparamref name="T"/> value is moved.
        /// The target deck creates fresh item context using its normal add rules rather than preserving the source item's metadata.
        /// This is a destructive operation on the source. On success, the top item is removed from source and its value is added to the bottom of target.
        /// </summary>
        /// <param name="source">The source deck to draw from.</param>
        /// <param name="target">The target deck to place into.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns>The dealt value, or <c>default</c> if either deck is null or the source is empty.</returns>
        public static T DealToDeck<T>(this ProbabilityList<T> source, ProbabilityList<T> target)
        {
            if (source == null || target == null || source.ItemCount < 1) return default;
            var value = source.DrawTop();
            target.PlaceOnBottom(value);
            return value;
        }

        /// <summary>
        /// Deals multiple values from the top of the source deck to the bottom of the target deck.
        /// Dealt values maintain their relative order in the target deck.
        /// This is a value transfer: only the drawn <typeparamref name="T"/> values are moved.
        /// The target deck creates fresh item context using its normal add rules rather than preserving the source items' metadata.
        /// This is a destructive operation on the source. On success, the drawn items are removed from source and their values are added to the bottom of target.
        /// </summary>
        /// <param name="source">The source deck to draw from.</param>
        /// <param name="target">The target deck to place into.</param>
        /// <param name="count">The maximum number of items to deal. Clamped to available items in the source.</param>
        /// <typeparam name="T">The value type.</typeparam>
        /// <returns>A list of dealt values. Returns an empty list if either deck is null, the source is empty, or count is less than 1.</returns>
        public static List<T> DealToDeck<T>(this ProbabilityList<T> source, ProbabilityList<T> target, int count)
        {
            if (source == null || target == null) return new List<T>();
            var dealtValues = DrawTop(source, count);
            target.PlaceOnBottom(dealtValues);
            return dealtValues;
        }

        private static bool TryPlaceItemInternal<T>(ProbabilityList<T> probabilityList, int index, ProbabilityItem<T> item, bool strictIndex)
        {
            if (probabilityList == null || item == null) return false;
            if (strictIndex && (index < 0 || index > probabilityList.ItemCount)) return false;
            if (probabilityList.ProbabilityItems.Contains(item)) return false;
            if (CanAcceptItemInTarget(probabilityList, item) == false) return false;

            var insertIndex = strictIndex ? index : Mathf.Clamp(index, 0, probabilityList.ItemCount);
            probabilityList.ProbabilityItems.Insert(insertIndex, item);
            FinalizeAddRemove(probabilityList);
            return true;
        }

        private static bool TryPlaceItemsInternal<T>(ProbabilityList<T> probabilityList, int index, IEnumerable<ProbabilityItem<T>> items, bool preserveOrder, bool strictIndex)
        {
            if (probabilityList == null || items == null) return false;
            if (strictIndex && (index < 0 || index > probabilityList.ItemCount)) return false;

            var orderedItems = CreateOrderedItems(items, preserveOrder);
            if (orderedItems.Count < 1) return false;
            if (CanAcceptItemsInTarget(probabilityList, orderedItems) == false) return false;

            var insertIndex = strictIndex ? index : Mathf.Clamp(index, 0, probabilityList.ItemCount);
            probabilityList.ProbabilityItems.InsertRange(insertIndex, orderedItems);
            FinalizeAddRemove(probabilityList);
            return true;
        }

        private static bool CanAcceptItemInTarget<T>(ProbabilityList<T> probabilityList, ProbabilityItem<T> item)
        {
            if (probabilityList == null || item == null) return false;

            var totalBaseProbability = item.BaseProbability;
            var unlockedProbability = item.Locked ? 0f : item.BaseProbability;
            var unlockedCount = item.Locked ? 0 : 1;

            foreach (var existingItem in probabilityList.ProbabilityItems)
            {
                totalBaseProbability += existingItem.BaseProbability;
                if (existingItem.Locked) continue;
                unlockedProbability += existingItem.BaseProbability;
                unlockedCount++;
            }

            var lockedProbability = totalBaseProbability - unlockedProbability;
            if (lockedProbability > 1.0001f) return false;
            if (unlockedCount < 1) return Mathf.Abs(totalBaseProbability - 1f) <= 0.0001f;
            if (unlockedProbability <= 0f) return Mathf.Abs(lockedProbability - 1f) <= 0.0001f;
            return true;
        }

        private static bool CanAcceptItemsInTarget<T>(ProbabilityList<T> probabilityList, IEnumerable<ProbabilityItem<T>> items)
        {
            if (probabilityList == null || items == null) return false;

            var seenItems = new HashSet<ProbabilityItem<T>>();
            var totalBaseProbability = 0f;
            var unlockedProbability = 0f;
            var unlockedCount = 0;

            foreach (var existingItem in probabilityList.ProbabilityItems)
            {
                totalBaseProbability += existingItem.BaseProbability;
                if (existingItem.Locked) continue;
                unlockedProbability += existingItem.BaseProbability;
                unlockedCount++;
            }

            foreach (var item in items)
            {
                if (item == null || seenItems.Add(item) == false || probabilityList.ProbabilityItems.Contains(item)) return false;
                totalBaseProbability += item.BaseProbability;
                if (item.Locked) continue;
                unlockedProbability += item.BaseProbability;
                unlockedCount++;
            }

            var lockedProbability = totalBaseProbability - unlockedProbability;
            if (lockedProbability > 1.0001f) return false;
            if (unlockedCount < 1) return Mathf.Abs(totalBaseProbability - 1f) <= 0.0001f;
            if (unlockedProbability <= 0f) return Mathf.Abs(lockedProbability - 1f) <= 0.0001f;
            return true;
        }

        private static List<ProbabilityItem<T>> DrawItemRange<T>(ProbabilityList<T> probabilityList, int index, int count)
        {
            var drawnItems = new List<ProbabilityItem<T>>();
            if (probabilityList == null || count < 1 || IsValidIndex(index, probabilityList.ItemCount) == false) return drawnItems;
            var actualCount = Mathf.Min(count, probabilityList.ItemCount - index);
            if (actualCount < 1) return drawnItems;
            var items = probabilityList.ProbabilityItems;
            drawnItems = items.GetRange(index, actualCount);
            items.RemoveRange(index, actualCount);
            FinalizeAddRemove(probabilityList);
            return drawnItems;
        }

        private static List<T> DrawRange<T>(ProbabilityList<T> probabilityList, int index, int count)
        {
            var drawnValues = new List<T>();
            if (probabilityList == null || count < 1 || IsValidIndex(index, probabilityList.ItemCount) == false) return drawnValues;
            var actualCount = Mathf.Min(count, probabilityList.ItemCount - index);
            if (actualCount < 1) return drawnValues;
            var items = probabilityList.ProbabilityItems;
            var removedItems = items.GetRange(index, actualCount);
            items.RemoveRange(index, actualCount);
            FinalizeAddRemove(probabilityList);
            drawnValues.Capacity = removedItems.Count;
            foreach (var item in removedItems) drawnValues.Add(item.Value);
            return drawnValues;
        }

        private static List<T> DrawRandomValues<T>(ProbabilityList<T> probabilityList, int count, System.Random random)
        {
            var drawnValues = new List<T>();
            if (probabilityList == null || count < 1 || probabilityList.ItemCount < 1) return drawnValues;
            drawnValues.Capacity = count;
            for (var i = 0; i < count; i++)
            {
                drawnValues.Add(DrawAt(probabilityList, GetRandomIndex(probabilityList.ItemCount, random)));
            }

            return drawnValues;
        }

        private static List<ProbabilityItem<T>> DrawRandomItems<T>(ProbabilityList<T> probabilityList, int count, System.Random random)
        {
            var drawnItems = new List<ProbabilityItem<T>>();
            if (probabilityList == null || count < 1 || probabilityList.ItemCount < 1) return drawnItems;
            drawnItems.Capacity = count;
            for (var i = 0; i < count; i++)
            {
                drawnItems.Add(DrawAtItem(probabilityList, GetRandomIndex(probabilityList.ItemCount, random)));
            }

            return drawnItems;
        }

        private static bool TryRemoveItem<T>(ProbabilityList<T> probabilityList, int index, out ProbabilityItem<T> item)
        {
            item = null;
            if (probabilityList == null) return false;
            var items = probabilityList.ProbabilityItems;
            if (IsValidIndex(index, items.Count) == false) return false;
            item = items[index];
            items.RemoveAt(index);
            FinalizeAddRemove(probabilityList);
            return true;
        }

        private static bool TryPlaceValues<T>(ProbabilityList<T> probabilityList, int index, IEnumerable<T> values, bool preserveOrder, bool strictIndex)
        {
            if (probabilityList == null || values == null) return false;
            if (strictIndex && (index < 0 || index > probabilityList.ItemCount)) return false;

            var orderedValues = CreateOrderedValues(values, preserveOrder);
            if (orderedValues.Count < 1) return false;

            var insertIndex = strictIndex ? index : Mathf.Clamp(index, 0, probabilityList.ItemCount);
            for (var i = 0; i < orderedValues.Count; i++) probabilityList.AddItem(insertIndex + i, orderedValues[i]);
            probabilityList.ClearHistory();
            return true;
        }

        private static List<T> CreateOrderedValues<T>(IEnumerable<T> values, bool preserveOrder)
        {
            var orderedValues = new List<T>();
            foreach (var value in values) orderedValues.Add(value);
            if (preserveOrder == false) orderedValues.Reverse();
            return orderedValues;
        }

        private static List<ProbabilityItem<T>> CreateOrderedItems<T>(IEnumerable<ProbabilityItem<T>> items, bool preserveOrder)
        {
            var orderedItems = new List<ProbabilityItem<T>>();
            foreach (var item in items) orderedItems.Add(item);
            if (preserveOrder == false) orderedItems.Reverse();
            return orderedItems;
        }

        private static void FinalizeAddRemove<T>(ProbabilityList<T> probabilityList)
        {
            probabilityList.NormalizeProbabilities();
            probabilityList.RecalibrateWeights();
            if (probabilityList.WeightsPriority) probabilityList.CalculatePercentageFromWeights();
            probabilityList.ClearHistory();
        }

        private static System.Random CreateRandom<T>(ProbabilityList<T> probabilityList)
        {
            return new System.Random(unchecked((int)probabilityList.Seed));
        }

        private static int GetRandomIndex(int count, System.Random random)
        {
            return count < 1 ? -1 : random.Next(0, count);
        }

        private static int GetRandomInsertIndex(int count, System.Random random)
        {
            return random.Next(0, count + 1);
        }

        private static bool IsValidIndex(int index, int count)
        {
            return index >= 0 && index < count;
        }
    }
}
