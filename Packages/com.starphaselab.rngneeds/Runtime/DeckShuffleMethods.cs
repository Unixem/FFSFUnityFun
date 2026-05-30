using System;
using System.Collections.Generic;

namespace RNGNeeds
{
    /// <summary>
    /// Describes a deck-order shuffle method that can build an inspectable shuffle plan for any probability list.
    /// </summary>
    public interface IDeckShuffleMethod
    {
        string Identifier { get; }
        string DisplayName { get; }
        DeckShufflePlan CreatePlan(IProbabilityList list, Random random);
    }

    /// <summary>
    /// Semantic categories for shuffle-plan steps.
    /// </summary>
    public enum DeckShuffleStepType
    {
        Split,
        Cut,
        Interleave,
        PacketMove,
        Merge,
        Reverse,
        RandomSwap,
        Reorder
    }

    /// <summary>
    /// One inspectable stage of a shuffle plan.
    /// </summary>
    [Serializable]
    public sealed class DeckShuffleStep
    {
        public DeckShuffleStepType StepType { get; }
        public string Description { get; }
        public IReadOnlyList<int> SourceIndices { get; }
        public IReadOnlyList<int> ResultIndices { get; }

        public DeckShuffleStep(DeckShuffleStepType stepType, string description, IReadOnlyList<int> sourceIndices = null, IReadOnlyList<int> resultIndices = null)
        {
            StepType = stepType;
            Description = description ?? string.Empty;
            SourceIndices = sourceIndices ?? Array.Empty<int>();
            ResultIndices = resultIndices ?? Array.Empty<int>();
        }
    }

    /// <summary>
    /// A deterministic deck shuffle plan expressed through semantic steps and a final order map.
    /// FinalOrder maps new index to previous index.
    /// </summary>
    [Serializable]
    public sealed class DeckShufflePlan
    {
        public string MethodId { get; }
        public string DisplayName { get; }
        public IReadOnlyList<DeckShuffleStep> Steps { get; }
        public IReadOnlyList<int> FinalOrder { get; }

        public DeckShufflePlan(string methodId, string displayName, IReadOnlyList<DeckShuffleStep> steps, IReadOnlyList<int> finalOrder)
        {
            MethodId = methodId ?? string.Empty;
            DisplayName = displayName ?? string.Empty;
            Steps = steps ?? Array.Empty<DeckShuffleStep>();
            FinalOrder = finalOrder ?? Array.Empty<int>();
        }
    }

    /// <summary>
    /// Built-in deck shuffle methods for deck extensions.
    /// </summary>
    public static class DeckShuffleMethods
    {
        public static IDeckShuffleMethod Default { get; } = new UniformDeckShuffleMethod();
        public static IDeckShuffleMethod Uniform { get; } = Default;
        public static IDeckShuffleMethod Riffle { get; } = new RiffleDeckShuffleMethod();
        public static IDeckShuffleMethod Overhand { get; } = new OverhandDeckShuffleMethod();
        public static IDeckShuffleMethod CutNearHalf { get; } = new CutNearHalfDeckShuffleMethod();
    }

    public sealed class UniformDeckShuffleMethod : IDeckShuffleMethod
    {
        public string Identifier => "uniform";
        public string DisplayName => "Uniform Shuffle";

        public DeckShufflePlan CreatePlan(IProbabilityList list, Random random)
        {
            var count = DeckShufflePlanningUtility.GetItemCount(list);
            var order = DeckShufflePlanningUtility.CreateIdentityOrder(count);
            var steps = new List<DeckShuffleStep>();

            for (var i = count - 1; i > 0; i--)
            {
                var swapIndex = random.Next(0, i + 1);
                if (swapIndex != i)
                {
                    (order[i], order[swapIndex]) = (order[swapIndex], order[i]);
                    steps.Add(new DeckShuffleStep(
                        DeckShuffleStepType.RandomSwap,
                        $"Swap positions {i} and {swapIndex}.",
                        new[] { i, swapIndex },
                        new[] { swapIndex, i }));
                }
            }

            DeckShufflePlanningUtility.AppendFinalReorderStep(steps, order, DisplayName);
            return new DeckShufflePlan(Identifier, DisplayName, steps, order);
        }
    }

    public sealed class RiffleDeckShuffleMethod : IDeckShuffleMethod
    {
        public string Identifier => "riffle";
        public string DisplayName => "Riffle Shuffle";

        public DeckShufflePlan CreatePlan(IProbabilityList list, Random random)
        {
            var count = DeckShufflePlanningUtility.GetItemCount(list);
            var steps = new List<DeckShuffleStep>();
            var order = DeckShufflePlanningUtility.CreateIdentityOrder(count);
            if (count < 2) return new DeckShufflePlan(Identifier, DisplayName, steps, order);

            var half = count / 2;
            var variance = Math.Min(1, Math.Max(0, count - 2));
            var cutIndex = Math.Max(1, Math.Min(count - 1, half + random.Next(-variance, variance + 1)));
            var left = DeckShufflePlanningUtility.RangeArray(0, cutIndex);
            var right = DeckShufflePlanningUtility.RangeArray(cutIndex, count - cutIndex);

            steps.Add(new DeckShuffleStep(DeckShuffleStepType.Split, $"Split deck at index {cutIndex}.", left, right));

            var interleaved = new List<int>(count);
            var leftPointer = 0;
            var rightPointer = 0;
            while (leftPointer < left.Length || rightPointer < right.Length)
            {
                if (leftPointer >= left.Length)
                {
                    interleaved.Add(right[rightPointer++]);
                    continue;
                }

                if (rightPointer >= right.Length)
                {
                    interleaved.Add(left[leftPointer++]);
                    continue;
                }

                var takeLeft = random.Next(0, 2) == 0;
                interleaved.Add(takeLeft ? left[leftPointer++] : right[rightPointer++]);
            }

            order = interleaved.ToArray();
            steps.Add(new DeckShuffleStep(DeckShuffleStepType.Interleave, "Interleave both packets into a new order.", DeckShufflePlanningUtility.CreateIdentityOrder(count), order));
            steps.Add(new DeckShuffleStep(DeckShuffleStepType.Merge, "Square the deck back into one stack.", order, order));
            DeckShufflePlanningUtility.AppendFinalReorderStep(steps, order, DisplayName);
            return new DeckShufflePlan(Identifier, DisplayName, steps, order);
        }
    }

    public sealed class OverhandDeckShuffleMethod : IDeckShuffleMethod
    {
        public string Identifier => "overhand";
        public string DisplayName => "Overhand Shuffle";

        public DeckShufflePlan CreatePlan(IProbabilityList list, Random random)
        {
            var count = DeckShufflePlanningUtility.GetItemCount(list);
            var steps = new List<DeckShuffleStep>();
            var identity = DeckShufflePlanningUtility.CreateIdentityOrder(count);
            if (count < 2) return new DeckShufflePlan(Identifier, DisplayName, steps, identity);

            var packets = new List<int[]>();
            var index = 0;
            var maxPacketSize = Math.Max(1, Math.Min(5, count / 2));
            while (index < count)
            {
                var packetSize = Math.Min(count - index, random.Next(1, maxPacketSize + 1));
                packets.Add(DeckShufflePlanningUtility.RangeArray(index, packetSize));
                index += packetSize;
            }

            var finalOrder = new List<int>(count);
            foreach (var packet in packets)
            {
                finalOrder.InsertRange(0, packet);
            }

            var writeIndex = 0;
            for (var i = packets.Count - 1; i >= 0; i--)
            {
                var packet = packets[i];
                var resultIndices = DeckShufflePlanningUtility.RangeArray(writeIndex, packet.Length);
                steps.Add(new DeckShuffleStep(DeckShuffleStepType.PacketMove, $"Move packet of {packet.Length} cards.", packet, resultIndices));
                writeIndex += packet.Length;
            }

            var order = finalOrder.ToArray();
            steps.Add(new DeckShuffleStep(DeckShuffleStepType.Merge, "Square the transferred packets into one stack.", identity, order));
            DeckShufflePlanningUtility.AppendFinalReorderStep(steps, order, DisplayName);
            return new DeckShufflePlan(Identifier, DisplayName, steps, order);
        }
    }

    public sealed class CutNearHalfDeckShuffleMethod : IDeckShuffleMethod
    {
        public string Identifier => "cut_near_half";
        public string DisplayName => "Cut Near Half";

        public DeckShufflePlan CreatePlan(IProbabilityList list, Random random)
        {
            var count = DeckShufflePlanningUtility.GetItemCount(list);
            var steps = new List<DeckShuffleStep>();
            var identity = DeckShufflePlanningUtility.CreateIdentityOrder(count);
            if (count < 2) return new DeckShufflePlan(Identifier, DisplayName, steps, identity);

            var center = count / 2;
            var variance = Math.Max(1, Math.Min(3, count / 6));
            var cutIndex = Math.Max(1, Math.Min(count - 1, center + random.Next(-variance, variance + 1)));
            var topPacket = DeckShufflePlanningUtility.RangeArray(0, cutIndex);
            var bottomPacket = DeckShufflePlanningUtility.RangeArray(cutIndex, count - cutIndex);
            var order = new int[count];
            Array.Copy(bottomPacket, 0, order, 0, bottomPacket.Length);
            Array.Copy(topPacket, 0, order, bottomPacket.Length, topPacket.Length);

            steps.Add(new DeckShuffleStep(DeckShuffleStepType.Split, $"Split deck near the middle at index {cutIndex}.", topPacket, bottomPacket));
            steps.Add(new DeckShuffleStep(DeckShuffleStepType.Cut, "Move the top packet under the bottom packet.", topPacket, DeckShufflePlanningUtility.RangeArray(bottomPacket.Length, topPacket.Length)));
            steps.Add(new DeckShuffleStep(DeckShuffleStepType.Merge, "Square the deck after the cut.", identity, order));
            DeckShufflePlanningUtility.AppendFinalReorderStep(steps, order, DisplayName);
            return new DeckShufflePlan(Identifier, DisplayName, steps, order);
        }
    }

    internal static class DeckShufflePlanningUtility
    {
        internal static int GetItemCount(IProbabilityList list)
        {
            return list?.ItemCount ?? 0;
        }

        internal static int[] CreateIdentityOrder(int count)
        {
            var order = new int[count];
            for (var i = 0; i < count; i++) order[i] = i;
            return order;
        }

        internal static int[] RangeArray(int start, int count)
        {
            var result = new int[count];
            for (var i = 0; i < count; i++) result[i] = start + i;
            return result;
        }

        internal static void AppendFinalReorderStep(List<DeckShuffleStep> steps, IReadOnlyList<int> finalOrder, string displayName)
        {
            steps.Add(new DeckShuffleStep(DeckShuffleStepType.Reorder, $"Finalize {displayName} order.", CreateIdentityOrder(finalOrder.Count), Copy(finalOrder)));
        }

        internal static int[] Copy(IReadOnlyList<int> values)
        {
            var result = new int[values.Count];
            for (var i = 0; i < values.Count; i++) result[i] = values[i];
            return result;
        }
    }
}
