#include "ps_inc_training"
#include "ps_inc_functions"
#include "x0_i0_transport"

void main () {

	object oPC = GetLastUsedBy();
	int nDC = PS_GetLocalInt(OBJECT_SELF, "climb_dc");
	string sTarget = PS_GetLocalString(OBJECT_SELF, "climb_target");
	string sSelf = PS_GetLocalString(OBJECT_SELF, "climb_fail_loc"); //the place to fall when you have a minor failure; its down when you're going down
	string sFallback1 = PS_GetLocalString(OBJECT_SELF, "climb_fallback_1");
	string sFallback2 = PS_GetLocalString(OBJECT_SELF, "climb_fallback_2");
	string sFallback3 = PS_GetLocalString(OBJECT_SELF, "climb_fallback_3");
	
	//Because you can increase in skill, we need
	//to determine what difficulty this dc really is
	int nDifficulty = TRAINING_DIFFICULTY_NORMAL;
	int nBonus = 0;
	if (GetHasFeat(2120, oPC)) //WINGS!
		nBonus += 5;
	int nMod = GetAbilityModifier(ABILITY_STRENGTH, oPC)+nBonus;
	int diff = nDC-nMod;
	if (diff <= 0) {
		SendMessageToPC(oPC, "You complete the climb with little difficulty. Your skill far surpasses this challenge.");
		return;
	}
	else if (diff <= 5)
		nDifficulty = TRAINING_DIFFICULTY_VERY_EASY;
	else if (diff <= 10) 
		nDifficulty = TRAINING_DIFFICULTY_EASY;
	else if (diff <= 15)
		nDifficulty = TRAINING_DIFFICULTY_NORMAL;
	else if (diff <= 19)
		nDifficulty = TRAINING_DIFFICULTY_HARD;
	else
		nDifficulty = TRAINING_DIFFICULTY_IMPOSSIBLE;
		
	int nRoll = d20();
	int nTotal = nRoll+nMod+nBonus;
	string sResult = "Failure!";
	string sFlavor = "";
	int nFail = nDC-nTotal;
	int nDamage = d6(nFail);
	
	if (nTotal > nDC) {
		sResult = "Success!";
		int nXP = GetXPForAbilityTrainingQuest(oPC, ABILITY_STRENGTH, nDifficulty);
		
		int nTime = PS_GetLocalInt(OBJECT_SELF, GetName(oPC));
		if (GetTime()-nTime > 10)
			GiveTrainingQuestXP(oPC, nXP);
			
		PS_SetLocalInt(OBJECT_SELF, GetName(oPC), GetTime());
		
		object oWP = GetWaypointByTag(sTarget);
		SendMessageToPC(oPC, sTarget);
  		TransportToWaypoint(oPC, oWP);
	}
	else if (nDC-nTotal <= 3) {
	
  		object oWP = GetWaypointByTag(sSelf);
		SendMessageToPC(oPC, sSelf);
  		TransportToWaypoint(oPC, oWP);
	
		sFlavor = "<i>A helpful looking root pulls away from the rocks beneath your weight. You tumble backwards down the cliff.</i>";
		
		effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL, FALSE);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC);
		
	} else if (nDC-nTotal <= 6) {
		
		object oWP = GetWaypointByTag(sFallback1);
		SendMessageToPC(oPC, sFallback1);
  		TransportToWaypoint(oPC, oWP);
		sFlavor = "<i>The foothold you're standing on crumbles beneath you. You tumble down the cliff face.</i>";
		
		effect eDam = EffectDamage((nDamage/2), DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL, FALSE);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC);
		eDam = EffectDamage((nDamage/2), DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL, TRUE);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC);
		effect eKnock = EffectKnockdown();
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oPC, 1.0f);
		
	} else if (nDC-nTotal <= 9) {
		
		object oWP = GetWaypointByTag(sFallback2);
		SendMessageToPC(oPC, sFallback2);
  		TransportToWaypoint(oPC, oWP);
		sFlavor = "<i>You loose your balance while negotiating a narrow ledge, and down the cliff face. Sharp rocks are waiting for you at the bottom.</i>";
		
		effect eDam = EffectDamage((nDamage/2), DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL, FALSE);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC);
		eDam = EffectDamage((nDamage/2), DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL, TRUE);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC);
		eDam = EffectDamage((nDamage/2), DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL, FALSE);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC);
		effect eKnock = EffectKnockdown();
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oPC, 3.0f);
		
	} else {
		
		object oWP = GetWaypointByTag(sFallback3);
		SendMessageToPC(oPC, sFallback3);
  		TransportToWaypoint(oPC, oWP);
		sFlavor = "<i>You reach an almost sheer portion of the climb, and start sliding. You are unable to find anything to hold onto, and slide down the cliff face. Sharp rocks are waiting for you at the bottom.</i>";
		
		effect eDam = EffectDamage((nDamage/2), DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL, FALSE);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC);
		eDam = EffectDamage((nDamage/2), DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL, TRUE);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC);
		eDam = EffectDamage((nDamage/2), DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL, FALSE);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC);
		eDam = EffectDamage((nDamage/2), DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL, TRUE);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC);
		effect eKnock = EffectKnockdown();
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oPC, 6.0f);
		
	}
	
	SendMessageToPC(oPC, "Strength Roll: "+IntToString(nRoll)+" + "+IntToString(nMod)+" = "+IntToString(nTotal)+", "+sResult);
	if (sFlavor != "")
		SendMessageToPC(oPC, sFlavor);

}