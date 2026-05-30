using System.Collections.Generic;
using UnityEngine;

namespace RNGNeeds.Samples.CardDeck
{
    /// <summary>
    /// Sample for RNGNeeds Card Deck Extensions.
    ///
    /// Shows how to define a card deck recipe in the Inspector using a ProbabilityList,
    /// then build a live deck and manage card flow between zones — draw pile, hand, table, and discard.
    /// Each recipe item's Units value sets how many copies of that card are added to the deck.
    ///
    /// ── Deck Operations Overview ──
    ///
    /// Shuffling and Cutting
    ///   ShuffleDeck()           — Shuffles a deck zone in place.                  → ResetSample, RecycleDiscard
    ///   TryShuffleDeck()        — Tries to shuffle; returns false if too few.     → ShuffleDrawPile
    ///   TryCut(index)           — Cuts the deck at the given position.            → CutDrawPile
    ///
    /// Peeking
    ///   PeekAt(index)           — Looks at a card without removing it.            → PeekTopCards
    ///
    /// Drawing (removing cards from a zone)
    ///   TryDrawTopItem(out)       — Draws the top card from a zone.               → DrawCards, DiscardHand, DiscardTopTableCard, DiscardTable
    ///   TryDrawAtItem(index, out) — Draws a card at a specific position.          → PlayCardFromHand, DiscardHandCard, MoveHandCard
    ///   DrawTopItems(count)       — Draws multiple cards from the top at once.    → RecycleDiscard
    ///
    /// Placing (adding cards to a zone)
    ///   TryPlaceItemOnTop(item)       — Places a card on top of a zone.           → PlayCardFromHand, MoveHandCard
    ///   TryPlaceItemOnBottom(item)    — Places a card on the bottom of a zone.    → DrawCards, DiscardHandCard, DiscardHand, DiscardTopTableCard, DiscardTable
    ///   TryPlaceAtItem(index, item)   — Inserts a card at a specific position.    → used as fallback to return cards on failure
    ///   TryPlaceItemsOnTop(items)     — Places multiple cards on top at once.     → RecycleDiscard (fallback)
    ///   TryPlaceItemsOnBottom(items)  — Places multiple cards on the bottom.      → RecycleDiscard
    /// </summary>
    [CreateAssetMenu(fileName = "Card Deck Extensions Sample", menuName = "RNGNeeds/Card Decks/Card Deck Extensions Sample")]
    public class CardDeckExtensionsSample : ScriptableObject
    {
        [Tooltip("The deck recipe — each item's Units value sets how many copies of that card are added to the draw pile.")]
        public ProbabilityList<Card> startingDeckRecipe = new ProbabilityList<Card>();

        [Space]
        [Min(1)] public int openingHandSize = 5;
        [Min(1)] public int cardsToDraw = 1;
        [Min(1)] public int cardsToPeek = 3;
        [Min(0)] public int selectedHandIndex;
        [Min(1)] public int cutIndex = 1;
        public bool shuffleOnReset = true;
        public bool reshuffleDiscardWhenDrawPileEmpty = true;

        [TextArea(2, 4)] public string lastAction;

        // Runtime deck zones — cards move between these during gameplay.
        [HideInInspector] public ProbabilityList<Card> drawPile = new ProbabilityList<Card>();
        [HideInInspector] public ProbabilityList<Card> hand = new ProbabilityList<Card>();
        [HideInInspector] public ProbabilityList<Card> discardPile = new ProbabilityList<Card>();
        [HideInInspector] public ProbabilityList<Card> tablePile = new ProbabilityList<Card>();

        private void OnEnable()
        {
            EnsureLists();
        }

        private void OnValidate()
        {
            EnsureLists();
        }

        /// <summary>
        /// Builds the draw pile from the deck recipe.
        /// Each recipe item's Units value determines how many copies of that card are created.
        /// Optionally shuffles the draw pile when done.
        /// </summary>
        public void ResetSample()
        {
            EnsureLists();
            ClearZone(drawPile);
            ClearZone(hand);
            ClearZone(discardPile);
            ClearZone(tablePile);

            var addedCards = 0;
            foreach (var recipeItem in EnumerateStartingDeckRecipe())
            {
                if (recipeItem.Value == null) continue;

                var copies = GetRecipeCopies(recipeItem);
                for (var i = 0; i < copies; i++)
                {
                    drawPile.AddItem(new ProbabilityItem<Card>(recipeItem.Value, 1f));
                    addedCards++;
                }
            }

            FinalizeZone(drawPile);
            if (shuffleOnReset) drawPile.ShuffleDeck();

            selectedHandIndex = 0;
            lastAction = addedCards > 0
                ? $"Built a {addedCards}-card draw pile from the authored recipe{(shuffleOnReset ? " and shuffled it." : ".")}"
                : "No cards were added. Add cards to the starting deck recipe first.";
        }

        public List<Card> PeekTopCards()
        {
            return PeekTopCards(cardsToPeek);
        }

        /// <summary>
        /// Returns a list of cards from the top of the draw pile without removing them.
        /// </summary>
        public List<Card> PeekTopCards(int count)
        {
            EnsureLists();
            var peekedCards = new List<Card>();
            if (count < 1)
            {
                lastAction = "Peek count must be at least 1.";
                return peekedCards;
            }

            var peekCount = Mathf.Min(count, drawPile.ItemCount);
            for (var i = 0; i < peekCount; i++)
            {
                var card = drawPile.PeekAt(i);
                if (card != null) peekedCards.Add(card);
            }

            lastAction = peekedCards.Count > 0
                ? $"Peeked top {peekedCards.Count}: {JoinCardNames(peekedCards)}"
                : "The draw pile is empty.";
            return peekedCards;
        }

        /// <summary>
        /// Shuffles the draw pile.
        /// </summary>
        public bool ShuffleDrawPile()
        {
            EnsureLists();
            if (drawPile.TryShuffleDeck() == false)
            {
                lastAction = drawPile.ItemCount < 2
                    ? "Need at least 2 cards in the draw pile to shuffle."
                    : "Unable to shuffle the draw pile.";
                return false;
            }

            lastAction = $"Shuffled the draw pile ({drawPile.ItemCount} cards).";
            return true;
        }

        /// <summary>
        /// Cuts the draw pile at the specified index, moving everything above it to the bottom.
        /// </summary>
        public bool CutDrawPile()
        {
            EnsureLists();
            if (drawPile.TryCut(cutIndex) == false)
            {
                lastAction = "Cut index must be between the top and bottom of the draw pile.";
                return false;
            }

            lastAction = $"Cut the draw pile at index {cutIndex}.";
            return true;
        }

        public bool DrawOpeningHand()
        {
            return DrawCards(openingHandSize);
        }

        public bool DrawCards()
        {
            return DrawCards(cardsToDraw);
        }

        /// <summary>
        /// Draws cards from the top of the draw pile into the hand.
        /// If the draw pile runs out and reshuffling is enabled, the discard pile is recycled automatically.
        /// </summary>
        public bool DrawCards(int count)
        {
            EnsureLists();
            if (count < 1)
            {
                lastAction = "Draw count must be at least 1.";
                return false;
            }

            var drawnCards = new List<Card>();
            for (var i = 0; i < count; i++)
            {
                if (drawPile.ItemCount < 1 && TryRecycleDiscardIntoDrawPileInternal(false) == false) break;
                if (drawPile.TryDrawTopItem(out var drawnItem) == false) break;
                if (hand.TryPlaceItemOnBottom(drawnItem) == false)
                {
                    drawPile.TryPlaceItemOnTop(drawnItem);
                    break;
                }

                if (drawnItem.Value != null) drawnCards.Add(drawnItem.Value);
            }

            if (drawnCards.Count < 1)
            {
                lastAction = "No cards were drawn.";
                return false;
            }

            lastAction = $"Drew {drawnCards.Count} card{(drawnCards.Count == 1 ? string.Empty : "s")}: {JoinCardNames(drawnCards)}";
            return true;
        }

        public bool PlaySelectedCard()
        {
            return PlayCardFromHand(selectedHandIndex);
        }

        /// <summary>
        /// Moves a card from the hand onto the top of the table pile.
        /// </summary>
        public bool PlayCardFromHand(int handIndex)
        {
            EnsureLists();
            if (hand.TryDrawAtItem(handIndex, out var playedItem) == false)
            {
                lastAction = $"There is no card at hand index {handIndex}.";
                return false;
            }

            if (tablePile.TryPlaceItemOnTop(playedItem) == false)
            {
                hand.TryPlaceAtItem(Mathf.Clamp(handIndex, 0, hand.ItemCount), playedItem);
                lastAction = "Could not move the played card onto the table.";
                return false;
            }

            selectedHandIndex = Mathf.Clamp(selectedHandIndex, 0, Mathf.Max(0, hand.ItemCount - 1));
            lastAction = playedItem.Value == null
                ? "Played a card to the top of the table."
                : $"Played {playedItem.Value.name} to the top of the table.";
            return true;
        }

        public bool PutSelectedHandCardOnTopOfDrawPile()
        {
            return PutHandCardOnTopOfDrawPile(selectedHandIndex);
        }

        public bool PutSelectedHandCardOnBottomOfDrawPile()
        {
            return PutHandCardOnBottomOfDrawPile(selectedHandIndex);
        }

        public bool PutHandCardOnTopOfDrawPile(int handIndex)
        {
            return MoveHandCard(handIndex, drawPile, true, "top of the draw pile");
        }

        public bool PutHandCardOnBottomOfDrawPile(int handIndex)
        {
            return MoveHandCard(handIndex, drawPile, false, "bottom of the draw pile");
        }

        public bool DiscardSelectedHandCard()
        {
            return DiscardHandCard(selectedHandIndex);
        }

        /// <summary>
        /// Moves a card from the hand to the bottom of the discard pile.
        /// </summary>
        public bool DiscardHandCard(int handIndex)
        {
            EnsureLists();
            if (hand.TryDrawAtItem(handIndex, out var discardedItem) == false)
            {
                lastAction = $"There is no card at hand index {handIndex}.";
                return false;
            }

            if (discardPile.TryPlaceItemOnBottom(discardedItem) == false)
            {
                hand.TryPlaceAtItem(Mathf.Clamp(handIndex, 0, hand.ItemCount), discardedItem);
                lastAction = "Could not discard the selected hand card.";
                return false;
            }

            selectedHandIndex = Mathf.Clamp(selectedHandIndex, 0, Mathf.Max(0, hand.ItemCount - 1));
            lastAction = discardedItem.Value == null
                ? "Discarded the selected hand card."
                : $"Discarded {discardedItem.Value.name} from hand.";
            return true;
        }

        /// <summary>
        /// Discards the entire hand to the discard pile.
        /// </summary>
        public bool DiscardHand()
        {
            EnsureLists();
            if (hand.ItemCount < 1)
            {
                lastAction = "The hand is already empty.";
                return false;
            }

            var discardedCards = new List<Card>();
            while (hand.TryDrawTopItem(out var cardItem))
            {
                if (discardPile.TryPlaceItemOnBottom(cardItem) == false)
                {
                    hand.TryPlaceItemOnTop(cardItem);
                    break;
                }

                if (cardItem.Value != null) discardedCards.Add(cardItem.Value);
            }

            selectedHandIndex = 0;
            lastAction = discardedCards.Count > 0
                ? $"Discarded {discardedCards.Count} card{(discardedCards.Count == 1 ? string.Empty : "s")}: {JoinCardNames(discardedCards)}"
                : "No cards were discarded.";
            return discardedCards.Count > 0;
        }

        /// <summary>
        /// Discards the top card from the table pile.
        /// </summary>
        public bool DiscardTopTableCard()
        {
            EnsureLists();
            if (tablePile.TryDrawTopItem(out var tableItem) == false)
            {
                lastAction = "The table is empty.";
                return false;
            }

            if (discardPile.TryPlaceItemOnBottom(tableItem) == false)
            {
                tablePile.TryPlaceItemOnTop(tableItem);
                lastAction = "Could not discard the top table card.";
                return false;
            }

            lastAction = tableItem.Value == null
                ? "Discarded the top table card."
                : $"Discarded {tableItem.Value.name} from the top of the table.";
            return true;
        }

        /// <summary>
        /// Moves all cards from the table to the discard pile.
        /// </summary>
        public bool DiscardTable()
        {
            EnsureLists();
            if (tablePile.ItemCount < 1)
            {
                lastAction = "The table is already empty.";
                return false;
            }

            var tableCards = new List<Card>();
            while (tablePile.TryDrawTopItem(out var cardItem))
            {
                if (discardPile.TryPlaceItemOnBottom(cardItem) == false)
                {
                    tablePile.TryPlaceItemOnTop(cardItem);
                    break;
                }

                if (cardItem.Value != null) tableCards.Add(cardItem.Value);
            }

            lastAction = tableCards.Count > 0
                ? $"Moved {tableCards.Count} card{(tableCards.Count == 1 ? string.Empty : "s")} from the table to discard: {JoinCardNames(tableCards)}"
                : "No table cards were discarded.";
            return tableCards.Count > 0;
        }

        /// <summary>
        /// Moves all discarded cards back into the draw pile and shuffles.
        /// </summary>
        public bool RecycleDiscardIntoDrawPile()
        {
            return TryRecycleDiscardIntoDrawPileInternal(true);
        }

        /// <summary>
        /// Moves a card from the hand to the specified target pile.
        /// </summary>
        private bool MoveHandCard(int handIndex, ProbabilityList<Card> targetPile, bool placeOnTop, string destinationLabel)
        {
            EnsureLists();
            if (hand.TryDrawAtItem(handIndex, out var movedItem) == false)
            {
                lastAction = $"There is no card at hand index {handIndex}.";
                return false;
            }

            var placed = placeOnTop ? targetPile.TryPlaceItemOnTop(movedItem) : targetPile.TryPlaceItemOnBottom(movedItem);
            if (placed == false)
            {
                hand.TryPlaceAtItem(Mathf.Clamp(handIndex, 0, hand.ItemCount), movedItem);
                lastAction = "Could not move the selected hand card.";
                return false;
            }

            selectedHandIndex = Mathf.Clamp(selectedHandIndex, 0, Mathf.Max(0, hand.ItemCount - 1));
            lastAction = movedItem.Value == null
                ? $"Moved a hand card to the {destinationLabel}."
                : $"Moved {movedItem.Value.name} to the {destinationLabel}.";
            return true;
        }

        private bool TryRecycleDiscardIntoDrawPileInternal(bool manualRequest)
        {
            EnsureLists();
            if (discardPile.ItemCount < 1)
            {
                if (manualRequest) lastAction = "The discard pile is empty.";
                return false;
            }

            if (manualRequest == false && reshuffleDiscardWhenDrawPileEmpty == false)
            {
                return false;
            }

            var recycledItems = discardPile.DrawTopItems(discardPile.ItemCount);
            if (drawPile.TryPlaceItemsOnBottom(recycledItems) == false)
            {
                discardPile.TryPlaceItemsOnTop(recycledItems);
                if (manualRequest) lastAction = "Could not move the discard pile back into the draw pile.";
                return false;
            }

            drawPile.ShuffleDeck();
            lastAction = $"Moved {recycledItems.Count} discarded card{(recycledItems.Count == 1 ? string.Empty : "s")} back into the draw pile and shuffled.";
            return true;
        }

        private void EnsureLists()
        {
            if (startingDeckRecipe == null) startingDeckRecipe = new ProbabilityList<Card>();
            if (drawPile == null) drawPile = new ProbabilityList<Card>();
            if (hand == null) hand = new ProbabilityList<Card>();
            if (discardPile == null) discardPile = new ProbabilityList<Card>();
            if (tablePile == null) tablePile = new ProbabilityList<Card>();
        }

        private IEnumerable<ProbabilityItem<Card>> EnumerateStartingDeckRecipe()
        {
            if (startingDeckRecipe == null) yield break;

            for (var i = 0; i < startingDeckRecipe.ItemCount; i++)
            {
                if (startingDeckRecipe.TryGetProbabilityItem(i, out var item) == false) continue;
                yield return item;
            }
        }

        // Units value is the copy count. Non-depletable items default to one copy.
        private static int GetRecipeCopies(ProbabilityItem<Card> recipeItem)
        {
            if (recipeItem == null) return 0;
            return recipeItem.IsDepletable ? Mathf.Max(0, recipeItem.Units) : 1;
        }

        private static void ClearZone(ProbabilityList<Card> list)
        {
            if (list == null) return;
            list.ClearList();
            list.ClearHistory();
        }

        private static void FinalizeZone(ProbabilityList<Card> list)
        {
            if (list == null) return;
            list.NormalizeProbabilities();
            list.RecalibrateWeights();
            if (list.WeightsPriority) list.CalculatePercentageFromWeights();
            list.ClearHistory();
        }

        private static string JoinCardNames(List<Card> cards)
        {
            if (cards == null || cards.Count < 1) return "No cards";

            var cardNames = new List<string>(cards.Count);
            foreach (var card in cards)
            {
                if (card == null) continue;
                cardNames.Add(card.name);
            }

            return cardNames.Count > 0 ? string.Join(", ", cardNames) : "No cards";
        }
    }
}
