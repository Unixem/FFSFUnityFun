using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

namespace RNGNeeds
{
    public enum DeckShufflePrintMode
    {
        StepsOnly,
        StepsWithIndices,
        Full
    }

    /// <summary>
    /// Debug-print helpers for <see cref="DeckShufflePlan"/>.
    /// </summary>
    public static class DeckShufflePlanDebugExtensions
    {
        public static string ToDebugString(this DeckShufflePlan plan, DeckShufflePrintMode mode = DeckShufflePrintMode.StepsOnly)
        {
            if (plan == null) return "<null DeckShufflePlan>";

            var builder = new StringBuilder();
            var displayName = string.IsNullOrEmpty(plan.DisplayName) ? "Unnamed Shuffle" : plan.DisplayName;
            builder.AppendLine($"=== Deck Shuffle Plan - {displayName} ({plan.Steps.Count} steps) ===");

            if (string.IsNullOrEmpty(plan.MethodId) == false)
                builder.AppendLine($"MethodId: {plan.MethodId}");

            for (var i = 0; i < plan.Steps.Count; i++)
            {
                var step = plan.Steps[i];
                builder.Append(i + 1)
                    .Append(". [")
                    .Append(step.StepType)
                    .Append("] ")
                    .AppendLine(step.Description);

                if (mode == DeckShufflePrintMode.StepsOnly) continue;

                var stepDetails = FormatStepDetails(step);
                if (string.IsNullOrEmpty(stepDetails) == false)
                    builder.AppendLine($"   {stepDetails}");
            }

            if (mode == DeckShufflePrintMode.Full && plan.FinalOrder.Count > 0)
                builder.AppendLine($"FinalOrder: {FormatIndexList(plan.FinalOrder)}");

            return builder.ToString().TrimEnd();
        }

        public static void Log(this DeckShufflePlan plan, DeckShufflePrintMode mode = DeckShufflePrintMode.StepsOnly)
        {
            Debug.Log(plan.ToDebugString(mode));
        }

        private static string FormatStepDetails(DeckShuffleStep step)
        {
            var source = step.SourceIndices ?? Array.Empty<int>();
            var result = step.ResultIndices ?? Array.Empty<int>();
            if (source.Count == 0 && result.Count == 0) return string.Empty;

            if (source.Count == result.Count && source.Count > 0)
                return FormatMappings(source, result);

            if (source.Count == 0) return $"result: {FormatIndexList(result)}";
            if (result.Count == 0) return $"source: {FormatIndexList(source)}";
            return $"source: {FormatIndexList(source)} | result: {FormatIndexList(result)}";
        }

        private static string FormatMappings(IReadOnlyList<int> source, IReadOnlyList<int> result)
        {
            var builder = new StringBuilder();
            for (var i = 0; i < source.Count; i++)
            {
                if (i > 0) builder.Append(", ");
                builder.Append(source[i]).Append(" -> ").Append(result[i]);
            }

            return builder.ToString();
        }

        private static string FormatIndexList(IReadOnlyList<int> values)
        {
            var builder = new StringBuilder();
            builder.Append('[');
            for (var i = 0; i < values.Count; i++)
            {
                if (i > 0) builder.Append(", ");
                builder.Append(values[i]);
            }

            builder.Append(']');
            return builder.ToString();
        }
    }
}
