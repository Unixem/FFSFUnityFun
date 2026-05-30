using System;
using System.Collections.Generic;
using UnityEngine;

namespace RNGNeeds.Samples.CardBattle
{
    /// <summary>
    /// Main sample asset for the Card Battle demo.
    ///
    /// File guide:
    /// - CardBattleWindowSample.cs: core sample surface and public gameplay entry points
    /// - CardBattleWindowSample.Gameplay.cs: battle flow, combat, win/loss handling
    /// - CardBattleWindowSample.Zones.cs: ProbabilityList zones and Card Deck Extensions usage
    /// - CardBattleWindowSample.StarterDecks.cs: starter deck content and default setup
    /// </summary>
    [CreateAssetMenu(fileName = "Card Battle Window Sample", menuName = "RNGNeeds/Card Battle/Card Battle Window Sample")]
    public partial class CardBattleWindowSample : ScriptableObject
    {
        public enum BattleCardType
        {
            Minion,
            Spell
        }

        [Serializable]
        public class BattleCardInstance
        {
            public string title;
            public string rulesText;
            public string symbol;
            public BattleCardType cardType;
            public Color accentColor;
            public int manaCost;
            public int attack;
            public int maxHealth;
            public int currentHealth;
            public int spellDamage;
            public bool hasAttackedThisTurn;

            public static BattleCardInstance FromCard(BattleCard card, Color ownerTint)
            {
                return new BattleCardInstance
                {
                    title = string.IsNullOrWhiteSpace(card?.title) ? "Untitled Card" : card.title,
                    rulesText = card?.rulesText ?? string.Empty,
                    symbol = string.IsNullOrWhiteSpace(card?.symbol) ? "◆" : card.symbol,
                    cardType = card?.cardType ?? BattleCardType.Minion,
                    accentColor = card != null ? Color.Lerp(card.accentColor, ownerTint, .65f) : ownerTint,
                    manaCost = Mathf.Max(0, card?.manaCost ?? 0),
                    attack = Mathf.Max(0, card?.attack ?? 0),
                    maxHealth = Mathf.Max(1, card?.health ?? 1),
                    currentHealth = Mathf.Max(1, card?.health ?? 1),
                    spellDamage = Mathf.Max(1, card?.spellDamage ?? 1),
                    hasAttackedThisTurn = true
                };
            }
        }

        [Serializable]
        public class PlayRecord
        {
            public int turnNumber;
            public string actor;
            public string action;
            public string symbol;
        }

        [Serializable]
        public class PlayerState
        {
            public string displayName = "Player";
            public Color heroColor = new Color(.35f, .7f, 1f, 1f);
            public int heroHealth;
            public int maxMana;
            public int currentMana;
            public int fatigueCounter;
            [HideInInspector] public ProbabilityList<BattleCardInstance> drawPile = new ProbabilityList<BattleCardInstance>();
            [HideInInspector] public ProbabilityList<BattleCardInstance> hand = new ProbabilityList<BattleCardInstance>();
            [HideInInspector] public ProbabilityList<BattleCardInstance> graveyard = new ProbabilityList<BattleCardInstance>();
            [HideInInspector] public List<BattleCardInstance> board = new List<BattleCardInstance>();
        }

        public string sampleTitle = "Card Battle Window Sample";
        [TextArea(2, 4)] public string sampleSummary = "A two-player Hearthstone-like sample driven by ProbabilityList deck zones and a custom Editor Window.";
        [Min(5)] public int startingHeroHealth = 20;
        [Min(1)] public int openingHandSize = 3;
        [Min(1)] public int boardLimit = 5;
        [Min(1)] public int maxManaCap = 10;
        public bool shuffleDecksOnReset = true;
        [Space]
        public PlayerState playerOne = new PlayerState { displayName = "Captain Azure", heroColor = new Color(.24f, .55f, .95f, 1f) };
        public PlayerState playerTwo = new PlayerState { displayName = "Overseer Ember", heroColor = new Color(.92f, .35f, .28f, 1f) };
        [Space]
        public ProbabilityList<BattleCard> playerOneStartingDeck = new ProbabilityList<BattleCard>();
        public ProbabilityList<BattleCard> playerTwoStartingDeck = new ProbabilityList<BattleCard>();
        [Space]
        public int currentPlayerIndex;
        [Min(1)] public int turnNumber = 1;
        public bool gameOver;
        public string winnerName;
        [TextArea(2, 5)] public string lastAction;
        public List<PlayRecord> history = new List<PlayRecord>();

        public PlayerState GetPlayer(int playerIndex)
        {
            return playerIndex == 0 ? playerOne : playerTwo;
        }

        public PlayerState GetOpponent(int playerIndex)
        {
            return playerIndex == 0 ? playerTwo : playerOne;
        }

        public PlayerState GetCurrentPlayer()
        {
            return GetPlayer(currentPlayerIndex);
        }

        public PlayerState GetWaitingPlayer()
        {
            return GetOpponent(currentPlayerIndex);
        }

        public void ResetSample()
        {
            EnsureDefaultDecks();
            EnsurePlayers();
            history ??= new List<PlayRecord>();
            history.Clear();
            gameOver = false;
            winnerName = string.Empty;
            turnNumber = 1;
            currentPlayerIndex = 0;

            InitializePlayer(playerOne, playerOneStartingDeck, "Player One Deck");
            InitializePlayer(playerTwo, playerTwoStartingDeck, "Player Two Deck");

            DrawCardsFromDeckToHand(0, openingHandSize, false);
            DrawCardsFromDeckToHand(1, openingHandSize, false);

            playerOne.maxMana = 1;
            playerOne.currentMana = 1;
            playerTwo.maxMana = 0;
            playerTwo.currentMana = 0;
            ReadyBoard(playerOne, true);
            ReadyBoard(playerTwo, false);

            lastAction = $"{playerOne.displayName} starts the duel with {openingHandSize} cards and 1 mana.";
            AddHistory("▶", playerOne.displayName, "begins the duel.");
        }

        public bool EndTurn()
        {
            if (gameOver)
            {
                lastAction = "The duel is over. Reset the sample to start again.";
                return false;
            }

            var endingPlayer = GetCurrentPlayer();
            currentPlayerIndex = 1 - currentPlayerIndex;
            turnNumber++;

            var currentPlayer = GetCurrentPlayer();
            currentPlayer.maxMana = Mathf.Min(maxManaCap, currentPlayer.maxMana + 1);
            currentPlayer.currentMana = currentPlayer.maxMana;
            ReadyBoard(currentPlayer, true);
            DrawCardsFromDeckToHand(currentPlayerIndex, 1, true);

            lastAction = $"{endingPlayer.displayName} ended the turn. {currentPlayer.displayName} is now up with {currentPlayer.currentMana} mana.";
            AddHistory("⏭", endingPlayer.displayName, $"ended the turn. {currentPlayer.displayName} is now active.");
            return true;
        }
        
        public bool PlayCardFromHand(int handIndex)
        {
            if (gameOver)
            {
                lastAction = "The duel is over. Reset the sample to play again.";
                return false;
            }

            var player = GetCurrentPlayer();
            var opponent = GetWaitingPlayer();
            if (player.hand.TryDrawAtItem(handIndex, out var cardItem) == false)
            {
                lastAction = $"There is no card at hand index {handIndex}.";
                return false;
            }

            var card = cardItem.Value;
            if (card == null)
            {
                lastAction = "The selected hand card is missing.";
                return false;
            }

            if (player.currentMana < card.manaCost)
            {
                player.hand.TryPlaceAtItem(Mathf.Clamp(handIndex, 0, player.hand.ItemCount), cardItem);
                lastAction = $"{player.displayName} needs {card.manaCost} mana to play {card.title}.";
                return false;
            }

            if (card.cardType == BattleCardType.Minion && player.board.Count >= boardLimit)
            {
                player.hand.TryPlaceAtItem(Mathf.Clamp(handIndex, 0, player.hand.ItemCount), cardItem);
                lastAction = $"{player.displayName}'s board is full.";
                return false;
            }

            player.currentMana -= card.manaCost;

            if (card.cardType == BattleCardType.Minion)
            {
                card.hasAttackedThisTurn = true;
                player.board.Add(card);
                lastAction = $"{player.displayName} played {card.title} to the board.";
                AddHistory(card.symbol, player.displayName, $"played {card.title} ({card.attack}/{card.currentHealth}).");
                return true;
            }

            opponent.heroHealth -= card.spellDamage;
            MoveCardToGraveyard(player, card);
            lastAction = $"{player.displayName} cast {card.title} for {card.spellDamage} damage to {opponent.displayName}.";
            AddHistory(card.symbol, player.displayName, $"cast {card.title} for {card.spellDamage} damage.");
            CheckForWinner();
            return true;
        }

        public bool AttackEnemyHero(int attackerBoardIndex)
        {
            if (gameOver)
            {
                lastAction = "The duel is over. Reset the sample to play again.";
                return false;
            }

            var player = GetCurrentPlayer();
            var opponent = GetWaitingPlayer();
            if (TryGetBoardCard(player, attackerBoardIndex, out var attacker) == false) return false;
            if (attacker.hasAttackedThisTurn)
            {
                lastAction = $"{attacker.title} has already attacked this turn.";
                return false;
            }

            opponent.heroHealth -= attacker.attack;
            attacker.hasAttackedThisTurn = true;
            lastAction = $"{player.displayName}'s {attacker.title} attacked {opponent.displayName} for {attacker.attack}.";
            AddHistory("⚔", player.displayName, $"sent {attacker.title} at the enemy hero for {attacker.attack}.");
            CheckForWinner();
            return true;
        }

        public bool AttackEnemyMinion(int attackerBoardIndex, int defenderBoardIndex)
        {
            if (gameOver)
            {
                lastAction = "The duel is over. Reset the sample to play again.";
                return false;
            }

            var player = GetCurrentPlayer();
            var opponent = GetWaitingPlayer();
            if (TryGetBoardCard(player, attackerBoardIndex, out var attacker) == false) return false;
            if (TryGetBoardCard(opponent, defenderBoardIndex, out var defender) == false)
            {
                lastAction = $"There is no enemy minion at board index {defenderBoardIndex}.";
                return false;
            }

            if (attacker.hasAttackedThisTurn)
            {
                lastAction = $"{attacker.title} has already attacked this turn.";
                return false;
            }

            attacker.currentHealth -= defender.attack;
            defender.currentHealth -= attacker.attack;
            attacker.hasAttackedThisTurn = true;

            lastAction = $"{attacker.title} traded with {defender.title}.";
            AddHistory("⚔", player.displayName, $"attacked {defender.title} with {attacker.title}.");
            ResolveBoardDeaths(player);
            ResolveBoardDeaths(opponent);
            CheckForWinner();
            return true;
        }
    }
}
