/*
Chain of Defensive Posture (Ex)
At 2nd level, a war mind learns the second principle of warfare for the individual combatant: 
the ability to avoid the enemy’s counterattacks if that enemy is not immediately overwhelmed. 
Calling upon inner reserves of knowledge and dedication, 
a war mind can provide himself with a +2 insight bonus to Dodge for up to 1 minute. A war mind can use this power three times per day.
 Activating this power is a free action. At 8th level, the insight bonus to dodge improves to +5.
*/






#include "ps_inc_melee"
#include "x2_inc_itemprop"
#include "x2_inc_spellhook"
#include "aaa_constants"
#include "nwn2_inc_spells"


void main()
{
object oPC = OBJECT_SELF;
int nSpell = GetSpellId();
int nArmor = 2;
if (GetLevelByClass(CLASS_TYPE_WARMIND,oPC)>7) {nArmor =5;}
effect eArmour = EffectACIncrease(nArmor,AC_DODGE_BONUS,AC_VS_DAMAGE_TYPE_ALL,FALSE);
if (GetHasSpellEffect(nSpell, oPC)) RemoveEffectsFromSpell(oPC, nSpell);
ApplyEffectToObject(DURATION_TYPE_INSTANT,eArmour,oPC,60.0f);


}