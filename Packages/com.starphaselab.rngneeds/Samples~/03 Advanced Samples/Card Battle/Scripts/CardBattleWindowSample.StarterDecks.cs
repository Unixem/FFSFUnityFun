using UnityEngine;

namespace RNGNeeds.Samples.CardBattle
{
    /// <summary>
    /// Starter deck content and default setup helpers for the Card Battle sample.
    /// This keeps sample content separate from the core RNGNeeds-powered zone logic.
    /// </summary>
    public partial class CardBattleWindowSample
    {
        public void EnsureDefaultDecks()
        {
            playerOneStartingDeck ??= new ProbabilityList<BattleCard>();
            playerTwoStartingDeck ??= new ProbabilityList<BattleCard>();
            ConfigureStarterDeckList(playerOneStartingDeck, "Captain Azure Starter Deck");
            ConfigureStarterDeckList(playerTwoStartingDeck, "Overseer Ember Starter Deck");

            if (playerOneStartingDeck.ItemCount < 1)
            {
                playerOneStartingDeck = CreateStarterDeck(
                    "Captain Azure Starter Deck",
                    LoadCard("Scout Drone"), 2,
                    LoadCard("Shield Bot"), 2,
                    LoadCard("Blade Runner"), 2,
                    LoadCard("Meteor Ping"), 2,
                    LoadCard("Titan Walker"), 1);
            }

            if (playerTwoStartingDeck.ItemCount < 1)
            {
                playerTwoStartingDeck = CreateStarterDeck(
                    "Overseer Ember Starter Deck",
                    LoadCard("Scout Drone"), 2,
                    LoadCard("Shield Bot"), 2,
                    LoadCard("Blade Runner"), 2,
                    LoadCard("Meteor Ping"), 2,
                    LoadCard("Titan Walker"), 1);
            }
        }

        private static void ConfigureStarterDeckList(ProbabilityList<BattleCard> list, string listName)
        {
            if (list == null) return;
            list.ListName = listName;
            list.IsDepletable = true;
        }

        private static ProbabilityList<BattleCard> CreateStarterDeck(string listName, params object[] entries)
        {
            var deck = new ProbabilityList<BattleCard>
            {
                ListName = listName,
                IsDepletable = true
            };

            for (var i = 0; i < entries.Length - 1; i += 2)
            {
                var card = entries[i] as BattleCard;
                var units = entries[i + 1] is int copies ? Mathf.Max(0, copies) : 0;
                if (card == null) continue;

                var item = new ProbabilityItem<BattleCard>(card, 1f);
                item.SetDepletable(true, units, units);
                deck.AddItem(item);
            }

            FinalizeStarterDeck(deck);
            return deck;
        }

        private static void FinalizeStarterDeck(ProbabilityList<BattleCard> deck)
        {
            if (deck == null) return;
            deck.NormalizeProbabilities();
            deck.RecalibrateWeights();
            if (deck.WeightsPriority) deck.CalculatePercentageFromWeights();
            deck.ClearHistory();
        }

        private static BattleCard LoadCard(string cardName)
        {
#if UNITY_EDITOR
            var search = UnityEditor.AssetDatabase.FindAssets($"{cardName} t:BattleCard");
            if (search != null && search.Length > 0)
            {
                var path = UnityEditor.AssetDatabase.GUIDToAssetPath(search[0]);
                return UnityEditor.AssetDatabase.LoadAssetAtPath<BattleCard>(path);
            }
#endif
            return null;
        }
    }
}
