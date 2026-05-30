using UnityEngine;

namespace RNGNeeds.Samples.CardBattle
{
    [CreateAssetMenu(fileName = "Battle Card", menuName = "RNGNeeds/Card Battle/Battle Card")]
    public class BattleCard : ScriptableObject, IProbabilityItemColorProvider, IProbabilityItemInfoProvider
    {
        public string title;
        [TextArea(2, 4)] public string rulesText;
        public string symbol = "◆";
        public CardBattleWindowSample.BattleCardType cardType;
        public Color accentColor = new Color(.35f, .7f, 1f, 1f);
        [Min(0)] public int manaCost = 1;
        [Min(0)] public int attack = 1;
        [Min(1)] public int health = 1;
        [Min(1)] public int spellDamage = 2;

        public Color ItemColor => accentColor;
        public string ItemInfo => cardType == CardBattleWindowSample.BattleCardType.Minion
            ? $"{manaCost} mana • {attack}/{health}"
            : $"{manaCost} mana • {spellDamage} damage";
    }
}
