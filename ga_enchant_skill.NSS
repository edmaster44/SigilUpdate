/*ga_enchant_skill
by Dedic8ed 5/8/11 for Sigil: City of Doors PW
Skill enchantment action pulled from a conversation

	nSlot: The inventory slot to be affected by the AC bonus. Note that different item types handle AC bonuses
		in different ways, such as amulets having natural AC, bracers having armor AC, and boots having dodge AC.
		The slots are as follows:
			0.	Head						10.	Belt
			1.	Chest						11.	Arrows
			2.	Boots						12.	Bullets
			3.	Arms (glove)				13.	Bolts
			4.	Right Hand					14.	Creature Weapon Left
			5.	Left Hand					15.	Creature Weapon Right
			6.	Cloak						16.	Creature Bite
			7.	Left Ring					17.	Creature Armor
			8.	Right Ring
			9.	Neck
	nSkill: The skill to be increased as per the following:
			1.	Concentration				15.	Set Trap
			2.	Disable Device				16.	Spellcraft
			4.	Heal						17.	Spot
			5.	Hide						18.	Taunt
			6.	Listen						20.	Appraise
			7.	Lore						22.	Craft Trap
			8.	Move Silently				23.	Bluff		
			9.	Open Lock					24.	Intimidate
			10.	Parry						25.	Craft Armor
			11.	Perform						26.	Craft Weapon
			12.	Diplomacy					27.	Craft Alchemy						
			13.	Sleight of Hand				29.	Survival	
			14.	Search				
	nBonus: The numeric AC bonus to be given, i.e. 1 for +1, 2 for +2, etc.
*/

#include "ginc_param_const"
#include "x2_inc_itemprop"
#include "ginc_crafting"

void main(int nSlot, int nSkill, int nBonus)

{
object oPC = GetPCSpeaker();

object oTarget;
object oItem;
oTarget = oPC;

oItem = GetItemInSlot(nSlot, oTarget);

if (GetIsObjectValid(oItem) == TRUE)

	{
	itemproperty ipAdd;
	ipAdd = ItemPropertySkillBonus(nSkill, nBonus);

IPSafeAddItemProperty(oItem, ipAdd);
ActionUnequipItem(oItem);
ActionEquipItem(oItem, nSlot);
}
}