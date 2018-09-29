//::///////////////////////////////////////////////
//:: Hellfire Shield HEARTBEAT
//:: NW_S2_hellfireshield.nss
//:: Copyright (c) 2008 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
    Hellfire Warlock aura. Hits everyone in melee
	range on heartbeat with a Heallfire Blast in
	exchange for 1 Con per hit.  HEARTBEAT SCRIPT
*/
//:://////////////////////////////////////////////
//:: Created By: Justin Reynard (JWR-OEI)
//:: Created On: 06/20/2008
//:://////////////////////////////////////////////

#include "nw_i0_invocatns"
#include "NW_I0_SPELLS"
#include "ps_inc_functions"

void main()
{
		
	object oCaster = GetAreaOfEffectCreator();
	
	// JWR-OEI 10/06/2008
	// Exit out if the player is dying! don't want to be a
	// dead guy killing all the mobs!
	if (GetIsDead(oCaster, FALSE))
	{
		return;
	}
	
	//SpeakString("DEBUG MESSAGE (JWR-OEI 08.22.08): HellfireShield Heartbeat");
	int bIsShieldActive = GetActionMode(oCaster, ACTION_MODE_HELLFIRE_SHIELD);
	if (!bIsShieldActive)
	{
		return;
	}
	
	//SpeakString("DEBUG MESSAGE(JWR-OEI 08.22.08): HellfireShield GOOOOOOOOOOOOOOOOOOOOOOOOOO");
	int nLevels = GetWarlockCasterLevel(oCaster);
	int nChrMod = GetAbilityModifier(ABILITY_CHARISMA, oCaster);
	int nDC = 10 + (nLevels/2) + nChrMod;
	int nTotal = 0; // number of creatures we hit.
	int nDice = GetEldritchBlastLevel(oCaster) + GetHellfireBlastDiceBonus(oCaster); // number of dice to roll
	int nDmg = 0; // amount to damage
	effect eDmg; // damage effect
	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_FIRE); // hit vfx VFX_HIT_SPELL_FIRE
	effect eLink; // linked effect
	
	/*
	// make sure we have valid const to cast this
	int nCurrCon = GetAbilityScore( oCaster, ABILITY_CONSTITUTION );
	if ( nCurrCon < 1 )
	{
		//Display Stopping Text
		FloatingTextStringOnCreature(GetStringByStrRef(STRREF_HELLFIRE_SHIELD_NO_CON), oCaster);
		SetActionMode(oCaster, ACTION_MODE_HELLFIRE_SHIELD, 0); 
		return;	
	}
	*/

	// Due to undead and other races, now scripting the shield to do HP damage instead.
	
	
	object oTarget = GetFirstInPersistentObject();
	
	while(GetIsObjectValid(oTarget))
	 {
 
	 	if (  oTarget != oCaster && GetIsEnemy(oTarget, oCaster)) 
		{
			//if ( !MyResistSpell(oCaster, oTarget) ) hellfire can not be resisted, only dodged
			//{
				nDmg = d6(nDice);
				if (GetHasFeat(FEAT_EPIC_ELDRITCH_MASTER))
					nDmg = FloatToInt(nDmg*1.5);
				
				// Relex Throw chance to halve the damage
				if(MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_NONE))
				{
					nDmg=nDmg/2;
				}
			//}
					
			eDmg = EffectDamage(nDmg, DAMAGE_TYPE_FIRE, DAMAGE_POWER_NORMAL, TRUE);
			eLink = EffectLinkEffects(eHit, eDmg);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
			nTotal++;
			
					
		}
		oTarget = GetNextInPersistentObject();
	 }
	
	// Apply Damage
	if (nTotal > 0)
	{

		int iDmg = nTotal * GetHitDice(oCaster) / 2; // 0.5HP / level is equal to 1 point of CON damage.
		effect eDmg = EffectDamage(iDmg, DAMAGE_TYPE_FIRE, DAMAGE_POWER_NORMAL, TRUE); // hopefully this will bypass resistances.
		DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oCaster));
		
		//HellfireShieldFeedbackMsg(nTotal, STRREF_HELLFIRE_SHIELD_NAME, oCaster);
	} 
}