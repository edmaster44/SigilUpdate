
//::///////////////////////////////////////////////
//:: Default On Damaged
//:: NW_C2_DEFAULT6
//:: Copyright © 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If already fighting then ignore, else determine
    combat round
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//:://////////////////////////////////////////////

#include "hench_i0_ai"
#include "ginc_behavior"

string strVarnameBurning = "isburning";

void SpeakDebug(string str);

void DamageReport(int nDmg);

void KillThisCreature(string strDeathMsg);

void TimedDamage(object oTarget, int nCounter);

void ApplySpecialElementalEffects();

void HandleBossEvents(object oSelf);

void main() {

	//Script hook
	string sDamageScript = GetLocalString(OBJECT_SELF, "DamagedScript");
	if (sDamageScript != "")
		ExecuteScript(sDamageScript, OBJECT_SELF);
	HandleBossEvents(OBJECT_SELF);

	//Special elemental effects
	ApplySpecialElementalEffects();

    int iFocused = GetIsFocused();
	
	// I've been damaged so no longer partially focused
	if (iFocused == FOCUSED_PARTIAL) {
	  SetLocalInt(OBJECT_SELF, VAR_FOCUSED, FOCUSED_STANDARD); // no longer focused
	}
    if (iFocused == FOCUSED_FULL) {
        // remain focused
    } else if(GetFleeToExit()) {
        // We're supposed to run away, do nothing
    }
    else if (GetSpawnInCondition(NW_FLAG_SET_WARNINGS)) {
        // don't do anything?
    } else {
        object oDamager = GetLastDamager();
        if (!GetIsObjectValid(oDamager))
        {
        // don't do anything, we don't have a valid damager
        }
        else if (!GetIsFighting(OBJECT_SELF))
        {
            if ((GetLocalInt(OBJECT_SELF, HENCH_HEAL_SELF_STATE) == HENCH_HEAL_SELF_WAIT) &&
                (GetPercentageHPLoss(OBJECT_SELF) < 30))
            {
                // force heal
                HenchDetermineCombatRound(OBJECT_INVALID, TRUE);
            }
            else if (!GetIsObjectValid(GetAttemptedAttackTarget()) && !GetIsObjectValid(GetAttemptedSpellTarget()))
            {
                if (GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
                {
                    HenchDetermineSpecialBehavior(oDamager);
                }
                else
                {
                    HenchDetermineCombatRound(oDamager);
                }
            }
        }
    }
    if(GetSpawnInCondition(NW_FLAG_DAMAGED_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_DAMAGED));
    }
}

void SpeakDebug(string str) {
	SpeakString(str);
	SendMessageToPC(GetFirstPC(), str);
}

void DamageReport(int nDmg) {
	SpeakString("<color=red>" + IntToString(nDmg));
}

void KillThisCreature(string strDeathMsg) {
	effect eDeath = EffectDeath();
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, OBJECT_SELF));
}

void TimedDamage(object oTarget, int nCounter) {

    if (GetIsDead(oTarget) == FALSE) {
  		int nDamage = d4();
  		int nCurrentHp = GetCurrentHitPoints();
  		if (nDamage >= nCurrentHp) {
 			KillThisCreature(GetName(OBJECT_SELF) + " burns to death.");
  		} else {
  			effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
  			ApplyEffectToObject (DURATION_TYPE_INSTANT, eVis, oTarget);
 
        	effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
  			ApplyEffectToObject (DURATION_TYPE_INSTANT, eDam, oTarget);
  			DamageReport(nDamage);
 
  			// do damage in next round
  			if (nCounter > 1)
          		DelayCommand(6.0f,TimedDamage(oTarget, nCounter - 1));
  			else
    			SetLocalInt(OBJECT_SELF, strVarnameBurning, FALSE);
  		}
    }
}

void ApplySpecialElementalEffects() {

	object oDamager = GetLastDamager();
	// SpeakDebug(GetName(OBJECT_SELF) + " damaged by " + GetName(oDamager));

	int nTotalDmg = GetTotalDamageDealt();
	// elemental
	int nAcidDmg = GetDamageDealtByType(DAMAGE_TYPE_ACID);
	int nColdDmg = GetDamageDealtByType(DAMAGE_TYPE_COLD);
	int nElectricalDmg = GetDamageDealtByType(DAMAGE_TYPE_ELECTRICAL);
	int nFireDmg = GetDamageDealtByType(DAMAGE_TYPE_FIRE);
	int nSonicDmg = GetDamageDealtByType(DAMAGE_TYPE_SONIC);

	// ACID
	if (nAcidDmg > 4 && nAcidDmg > (GetMaxHitPoints(OBJECT_SELF) / 4)) {
	
  		// minimum 5 damage for acid fumes to daze enemies
  		int nSaveDC = 10 + nAcidDmg / 5; //10 + nAcidDmg / 3;
  		if (GetIsImmune(OBJECT_SELF, IMMUNITY_TYPE_DAZED) == FALSE && FortitudeSave(OBJECT_SELF, nSaveDC, SAVING_THROW_TYPE_ACID) == 0) {
  			// save failed
  			float fDazeRounds = IntToFloat(nAcidDmg / 10 + 1) * 6.0;
  			effect eVis1 = EffectVisualEffect(VFX_DUR_SPELL_DAZE);
  			effect eVis2 = EffectVisualEffect(VFX_DUR_STUN);
  			eVis1 = EffectLinkEffects(eVis2, eVis1);
  			effect eEffect = EffectDazed();
  			eVis1 = EffectLinkEffects(eEffect, eVis1);
  			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis1, OBJECT_SELF, fDazeRounds);
  		}
	}

	// COLD
	if (nColdDmg > 4 && nColdDmg > (GetMaxHitPoints(OBJECT_SELF) / 4)) {
  		// minimum x damage for cold to slow enemies
  		int nSaveDC = 10 + nColdDmg / 4; //10 + nColdDmg / 3;
  		if (GetIsImmune(OBJECT_SELF, IMMUNITY_TYPE_SLOW) == FALSE && FortitudeSave(OBJECT_SELF, nSaveDC, SAVING_THROW_TYPE_COLD) == 0) {
  			// save failed
 	 		float fRounds = IntToFloat(nColdDmg / 10 + 1) * 6.0;
  			effect eVis1 = EffectVisualEffect(VFX_DUR_SPELL_CREEPING_COLD);
  			effect eVis2 = EffectVisualEffect(VFX_DUR_SPELL_SLOW);
  			eVis1 = EffectLinkEffects(eVis2, eVis1);
  			effect eEffect = EffectSlow();
  			eVis1 = EffectLinkEffects(eEffect, eVis1);
  			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis1, OBJECT_SELF, fRounds);
  		}
	}

	// ELECTRICAL
	if (nElectricalDmg > 4 && nElectricalDmg > (GetMaxHitPoints(OBJECT_SELF) / 4)) {
		// minimum x damage for electricity to paralyze and possibly kill enemies
	  	int nStunSaveDC = 10 + nElectricalDmg / 5; //10 + nElectricalDmg / 3;
	 	// && GetIsImmune(OBJECT_SELF, IMMUNITY_TYPE_STUN) == FALSE
	  	if (GetIsImmune(OBJECT_SELF, IMMUNITY_TYPE_MIND_SPELLS) == FALSE && FortitudeSave(OBJECT_SELF, nStunSaveDC, SAVING_THROW_TYPE_ELECTRICITY) == 0) {
	  		// save failed
	  		float fRounds = IntToFloat(nElectricalDmg / 10 + 1) * 6.0;
	 
	  		effect eEffect1 = EffectKnockdown();
	  		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect1, OBJECT_SELF, 6.0);
	
	  		//
	  		effect eEffect2 = EffectStunned();
	  		DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect2, OBJECT_SELF, fRounds));
	
	 		effect eVis1 = EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION);
	  		DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis1, OBJECT_SELF, fRounds));
	 
	  		effect eEffect3 = EffectVisualEffect(VFX_DUR_PARALYZED);
	  		DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect3, OBJECT_SELF, fRounds));
	  	}
	 
	  	// "living" creature? possibly kill it
	  	int nKillSaveDC = nStunSaveDC / 2;
	  	if (GetIsImmune(OBJECT_SELF, IMMUNITY_TYPE_CRITICAL_HIT) == FALSE && FortitudeSave(OBJECT_SELF, nKillSaveDC, SAVING_THROW_TYPE_ELECTRICITY) == 0) {
	  		// save failed
	  		KillThisCreature(GetName(OBJECT_SELF) + " dies from electrical shock.");
	  	}
	}

	// FIRE
	if (nFireDmg > 4 && nFireDmg > (GetMaxHitPoints(OBJECT_SELF) / 4)) {
	
	  // minimum 5 damage to cause burning and fear
	  // (INFINITE LOOP with timeddamage possible otherwise)
		if (GetLocalInt(OBJECT_SELF, strVarnameBurning) == FALSE) {
	  
			// does not have burning effect yet
		  	int nDmgRange = nFireDmg / 10;
		  	int nBurnRounds = nDmgRange + 1;
		  	float fBurnRounds = IntToFloat(nBurnRounds) * 6.0;
		 
		  	// burning visual effect for nFireDmg / factor rounds
		  	effect eVis = EffectVisualEffect(VFX_DUR_FIRE);
		 
		  	// fear effect: apply if either of will or fortitude fail
		  	int nSaveDC = 10 + nFireDmg / 5; //10 + nFireDmg / 3;
		  	//  5 dmg: DC 11
		  	// 30 dmg: DC 20
		  	// 60 dmg: DC 30
		 
	  	  	if (GetIsImmune(OBJECT_SELF, IMMUNITY_TYPE_FEAR) == TRUE 
			|| WillSave(OBJECT_SELF, nSaveDC, SAVING_THROW_TYPE_FIRE) == 1
	    	|| FortitudeSave(OBJECT_SELF, nSaveDC, SAVING_THROW_TYPE_FIRE) == 1) {
	    		// immune to fear or at least one save succeded then no fear, only burning visual
	    		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, OBJECT_SELF, fBurnRounds);
	  	  	} else {
	    		// apply fear as well
	    		effect eFear = EffectFrightened();
	    		eVis = EffectLinkEffects(eFear,eVis);
	    		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, OBJECT_SELF, fBurnRounds);
	  	  	}
	 
	  		// delayed smoke effect
	  		effect eSmoke = EffectVisualEffect(868);
	  		DelayCommand(fBurnRounds + 0.0 * 6.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSmoke, OBJECT_SELF, 6.0));
	 
	  		// mark this creature as burning already, dont burn again while this runs
	  		SetLocalInt(OBJECT_SELF, strVarnameBurning, TRUE);
	 
	  		// damage over time
	  		//TimedDamage(OBJECT_SELF, nBurnRounds);
	  	}
	}
}

void HandleBossEvents(object oSelf) {

	string sEvent1 		= GetLocalString(oSelf, "BossEvent_1");
	int nEventDone1		= GetLocalInt(oSelf, "BossEvent_1Done");
	string sEvent2 		= GetLocalString(oSelf, "BossEvent_2");
	int nEventDone2		= GetLocalInt(oSelf, "BossEvent_2Done");
	string sEvent3 		= GetLocalString(oSelf, "BossEvent_3");
	int nEventDone3		= GetLocalInt(oSelf, "BossEvent_3Done");
	string sEvent4 		= GetLocalString(oSelf, "BossEvent_4");
	int nEventDone4		= GetLocalInt(oSelf, "BossEvent_4Done");
	string sEvent5 		= GetLocalString(oSelf, "BossEvent_5");
	int nEventDone5		= GetLocalInt(oSelf, "BossEvent_5Done");
	
	float hpPercentage = IntToFloat(GetCurrentHitPoints(oSelf))/IntToFloat(GetMaxHitPoints(oSelf));
	
	if (hpPercentage <= 0.95f && sEvent1 != "" && !nEventDone1) {
		SpeakString("Event 1", TALKVOLUME_SHOUT);
		ExecuteScript(sEvent1, oSelf);
		SetLocalInt(oSelf, "BossEvent_1Done", 1);
	} else if (hpPercentage <= 0.75f && sEvent2 != "" && !nEventDone2) {
		SpeakString("Event 2", TALKVOLUME_SHOUT);
		ExecuteScript(sEvent2, oSelf);
		SetLocalInt(oSelf, "BossEvent_2Done", 1);
	} else if (hpPercentage <= 0.55f && sEvent3 != "" && !nEventDone3) {
		SpeakString("Event 3", TALKVOLUME_SHOUT);
		ExecuteScript(sEvent3, oSelf);
		SetLocalInt(oSelf, "BossEvent_3Done", 1);
	} else if (hpPercentage <= 0.35f && sEvent4 != "" && !nEventDone4) {
		SpeakString("Event 4", TALKVOLUME_SHOUT);
		ExecuteScript(sEvent4, oSelf);
		SetLocalInt(oSelf, "BossEvent_4Done", 1);
	} else if (hpPercentage <= 0.15f && sEvent5 != "" && !nEventDone5) {
		SpeakString("Event 5", TALKVOLUME_SHOUT);
		ExecuteScript(sEvent5, oSelf);
		SetLocalInt(oSelf, "BossEvent_5Done", 1);
	} 

}
