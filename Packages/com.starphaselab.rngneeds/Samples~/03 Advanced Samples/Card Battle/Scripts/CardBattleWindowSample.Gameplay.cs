using System.Collections.Generic;
using UnityEngine;

namespace RNGNeeds.Samples.CardBattle
{
    /// <summary>
    /// Battle rules and gameplay flow for the Card Battle sample.
    /// This layer sits above the RNGNeeds-powered zone helpers.
    /// </summary>
    public partial class CardBattleWindowSample
    {
        public bool CanAttackWithBoardCard(int boardIndex)
        {
            var player = GetCurrentPlayer();
            if (player.board == null || boardIndex < 0 || boardIndex >= player.board.Count) return false;
            var card = player.board[boardIndex];
            return card != null && card.attack > 0 && card.hasAttackedThisTurn == false;
        }

        private void ReadyBoard(PlayerState player, bool readyToAttack)
        {
            if (player?.board == null) return;
            foreach (var card in player.board)
            {
                if (card == null) continue;
                card.hasAttackedThisTurn = readyToAttack == false;
            }
        }

        private bool TryGetBoardCard(PlayerState player, int boardIndex, out BattleCardInstance card)
        {
            card = null;
            if (player?.board == null || boardIndex < 0 || boardIndex >= player.board.Count)
            {
                lastAction = $"There is no minion at board index {boardIndex}.";
                return false;
            }

            card = player.board[boardIndex];
            if (card != null) return true;

            lastAction = "The selected board slot is empty.";
            return false;
        }

        private void ResolveBoardDeaths(PlayerState owner)
        {
            if (owner?.board == null) return;
            for (var i = owner.board.Count - 1; i >= 0; i--)
            {
                var card = owner.board[i];
                if (card == null || card.currentHealth > 0) continue;
                owner.board.RemoveAt(i);
                MoveCardToGraveyard(owner, card);
                AddHistory("✖", owner.displayName, $"lost {card.title}.");
            }
        }

        private void CheckForWinner()
        {
            if (gameOver) return;

            if (playerOne.heroHealth <= 0 && playerTwo.heroHealth <= 0)
            {
                gameOver = true;
                winnerName = "Draw";
                lastAction = "Both heroes fell. The duel ends in a draw.";
                AddHistory("◎", "Duel", "ended in a draw.");
                return;
            }

            if (playerOne.heroHealth <= 0)
            {
                gameOver = true;
                winnerName = playerTwo.displayName;
                lastAction = $"{playerTwo.displayName} wins the duel.";
                AddHistory("★", playerTwo.displayName, "won the duel.");
                return;
            }

            if (playerTwo.heroHealth <= 0)
            {
                gameOver = true;
                winnerName = playerOne.displayName;
                lastAction = $"{playerOne.displayName} wins the duel.";
                AddHistory("★", playerOne.displayName, "won the duel.");
            }
        }

        private void AddHistory(string symbol, string actor, string action)
        {
            history ??= new List<PlayRecord>();
            history.Insert(0, new PlayRecord
            {
                turnNumber = turnNumber,
                symbol = symbol,
                actor = actor,
                action = action
            });

            if (history.Count > 40) history.RemoveRange(40, history.Count - 40);
        }
    }
}
