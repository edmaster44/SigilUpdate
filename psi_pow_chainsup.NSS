#include "ps_inc_melee"
#include "x2_inc_itemprop"
#include "x2_inc_spellhook"
#include "aaa_constants"
#include "nwn2_inc_spells"
#include "ps_enchant_lib"

/*

Chain of Personal Superiority (Ex)
At 1st level, a war mind learns the first principle of warfare for the individual combatant:
 the ability to both deal punishment and take it. Calling upon inner reserves of knowledge and dedication,
  a war mind can provide himself with a +2 insight bonus to Strength and Constitution for up to 1 minute.
   A war mind can use this power three times per day. Activating this power is a free action. At 7th level, the insight bonus to Strength and Constitution improves to +4.



*/

void main()
{
object oPC = OBJECT_SELF;
int nStrength = ABILITY_CONSTITUTION;
int nCon = ABILITY_STRENGTH;
object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF);
int nLevel = 4;
if (GetLevelByClass(CLASS_TYPE_WARMIND,oPC) >6) nLevel = 6;


effect eStr =EffectAbilityIncrease(nStrength,nLevel);
effect eCon=EffectAbilityIncrease(nCon,nLevel);
effect eLink = EffectLinkEffects(eStr,eCon);

ApplyEffectToObject(DURATION_TYPE_INSTANT,eLink,oPC,60.0f);

/*EnchantItem(oArmor,ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON, nLevel), 0);
EnchantItem(oArmor,ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR, nLevel), 0); Disabled for now */

}