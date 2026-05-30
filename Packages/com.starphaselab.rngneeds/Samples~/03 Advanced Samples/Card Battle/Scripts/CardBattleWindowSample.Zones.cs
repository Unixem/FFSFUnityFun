using System.Collections.Generic;
using UnityEngine;

namespace RNGNeeds.Samples.CardBattle
{
    /// <summary>
    /// RNGNeeds-facing deck and zone helpers for the Card Battle sample.
    /// Start here to see how ProbabilityList and Card Deck Extensions power
    /// draw piles, hands, graveyards, and identity-preserving card movement.
    /// Board state is kept separate on purpose because it is not a deck-like zone.
    /// </summary>
    public partial class CardBattleWindowSample
    {
        private void InitializePlayer(PlayerState player, ProbabilityList<BattleCard> deckEntries, string deckName)
        {
            player.heroHealth = Mathf.Max(1, startingHeroHealth);
            player.maxMana = 0;
            player.currentMana = 0;
            player.fatigueCounter = 0;
            EnsurePlayerZones(player, deckName);
            ResetZone(player.drawPile);
            ResetZone(player.hand);
            ResetZone(player.graveyard);
            player.board.Clear();

            foreach (var entry in deckEntries)
            {
                var card = entry?.Value;
                if (card == null) continue;

                var copies = Mathf.Max(0, entry.Units);
                for (var i = 0; i < copies; i++)
                {
                    var instance = BattleCardInstance.FromCard(card, player.heroColor);
                    player.drawPile.AddItem(new ProbabilityItem<BattleCardInstance>(instance, 1f));
                }
            }

            FinalizeDeckZone(player.drawPile);
            if (shuffleDecksOnReset && player.drawPile.ItemCount > 1) player.drawPile.ShuffleDeck();
        }

        private void EnsurePlayers()
        {
            playerOne ??= new PlayerState { displayName = "Captain Azure", heroColor = new Color(.24f, .55f, .95f, 1f) };
            playerTwo ??= new PlayerState { displayName = "Overseer Ember", heroColor = new Color(.92f, .35f, .28f, 1f) };
            EnsurePlayerZones(playerOne, "Player One Deck");
            EnsurePlayerZones(playerTwo, "Player Two Deck");
        }

        private static void EnsurePlayerZones(PlayerState player, string drawPileName)
        {
            if (player.drawPile == null) player.drawPile = new ProbabilityList<BattleCardInstance>();
            if (player.hand == null) player.hand = new ProbabilityList<BattleCardInstance>();
            if (player.graveyard == null) player.graveyard = new ProbabilityList<BattleCardInstance>();
            if (player.board == null) player.board = new List<BattleCardInstance>();

            player.drawPile.ListName = drawPileName;
            player.hand.ListName = $"{player.displayName} Hand";
            player.graveyard.ListName = $"{player.displayName} Graveyard";
        }

        private void DrawCardsFromDeckToHand(int playerIndex, int count, bool markHistory)
        {
            var player = GetPlayer(playerIndex);
            var drawnTitles = new List<string>();
            for (var i = 0; i < count; i++)
            {
                if (player.drawPile.TryDrawTopItem(out var drawnItem) == false)
                {
                    ApplyFatigue(playerIndex);
                    continue;
                }

                if (player.hand.TryPlaceItemOnBottom(drawnItem) == false)
                {
                    player.drawPile.TryPlaceItemOnTop(drawnItem);
                    break;
                }

                if (drawnItem.Value != null) drawnTitles.Add(drawnItem.Value.title);
            }

            if (markHistory && drawnTitles.Count > 0)
            {
                AddHistory("✚", player.displayName, $"drew {string.Join(", ", drawnTitles)}.");
            }
        }

        private void ApplyFatigue(int playerIndex)
        {
            var player = GetPlayer(playerIndex);
            player.fatigueCounter++;
            player.heroHealth -= player.fatigueCounter;
            AddHistory("☠", player.displayName, $"took {player.fatigueCounter} fatigue damage.");
            lastAction = $"{player.displayName} tried to draw from an empty deck and took {player.fatigueCounter} fatigue damage.";
            CheckForWinner();
        }

        private static void MoveCardToGraveyard(PlayerState owner, BattleCardInstance card)
        {
            if (owner?.graveyard == null || card == null) return;
            owner.graveyard.TryPlaceItemOnBottom(new ProbabilityItem<BattleCardInstance>(card, 1f));
        }

        private static void ResetZone(ProbabilityList<BattleCardInstance> list)
        {
            if (list == null) return;
            list.ClearList();
            list.ClearHistory();
        }

        private static void FinalizeDeckZone(ProbabilityList<BattleCardInstance> list)
        {
            if (list == null) return;
            list.NormalizeProbabilities();
            list.RecalibrateWeights();
            if (list.WeightsPriority) list.CalculatePercentageFromWeights();
            list.ClearHistory();
        }
    }
}
