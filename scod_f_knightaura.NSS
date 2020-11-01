/*This Grants the Knight Saves that applies to his Allies
This is based on the total Knight level, as well as PRC.
*/


#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "ps_inc_functions"


void main()
{
object oPC = OBJECT_SELF;
	int cScale = PS_GetCasterLevel(oPC)/6 ;



	object oTarget = GetEnteringObject();
	object oCaster = GetAreaOfEffectCreator();
	
	effect eSaves  = EffectSavingThrowDecrease(SAVING_THROW_ALL, cScale);
	effect eAB =	EffectAttackIncrease(cScale,ATTACK_BONUS_MISC);
	
effect	eBuffs = EffectLinkEffects(eSaves,eAB);






	// Doesn't work on self
	if (oTarget != oCaster)
	{
		//SpeakString("nw_s2_auradespairA.nss: On Enter: target is not the same as the creator");

		SignalEvent (oTarget, EventSpellCastAt(oCaster, SPELLABLILITY_AURA_OF_DESPAIR, FALSE));		

	    //Faction Check
		if (!GetIsDead(oTarget) && GetIsEnemy(oTarget, oCaster)) {
		
	        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBuffs, oTarget);			
		}
	}
}