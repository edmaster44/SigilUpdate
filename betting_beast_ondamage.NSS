//::///////////////////////////////////////////////
//:: Default On Damaged
//:: NW_C2_DEFAULT6
//:: Copyright (c) 2001 Bioware Corp.
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

void EndFight(object oKiller);

void main()
{
    int iFocused = GetIsFocused();
	
	// I've been damaged so no longer partially focused
	if (iFocused == FOCUSED_PARTIAL)
	{
		SetLocalInt(OBJECT_SELF, VAR_FOCUSED, FOCUSED_STANDARD); // no longer focused
	}
    if (iFocused == FOCUSED_FULL)
	{
        // remain focused
    }
	else if(GetFleeToExit())
	{
        // We're supposed to run away, do nothing
    }
    else if (GetSpawnInCondition(NW_FLAG_SET_WARNINGS))
    {
        // don't do anything?
    }
    else
    {
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
//    Jug_Debug(GetName(OBJECT_SELF) + " responding to damage");
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
	
	//***********************************************************
	//Beast Special
	//***********************************************************
	object controller = GetObjectByTag("ps_fw_beastmaster");
	/*if (GetLocalInt(controller,"FIGHTING") == 0) {
		return;
	}*/

	int nDamage = GetLocalInt(OBJECT_SELF, "total_damage");
	int damageDealt = GetTotalDamageDealt();
	object oMonster1 = GetObjectByTag("ps_fw_monster1");
	object oMonster2 = GetObjectByTag("ps_fw_monster2");
	object oDamager = GetLastDamager();
	if (GetIsObjectValid(oMonster1) == FALSE ||
		GetIsObjectValid(oMonster2) == FALSE)
		EndFight(OBJECT_INVALID);
	//No one but the fighters can damage the fighters
	if (oDamager != oMonster1 &&
		oDamager != oMonster2)
		return;
	
	nDamage = nDamage+damageDealt;
	//The winner is actually determined by the script, not real combat!
	if (nDamage > GetMaxHitPoints() && GetLocalInt(oDamager, "Winner")) {
		EndFight(oDamager);
		
		SetImmortal(OBJECT_SELF, FALSE);
		effect eDeath = EffectDeath();
		effect eDamage = EffectDamage(nDamage+1);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, OBJECT_SELF);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, OBJECT_SELF);
		SpawnBloodHit(OBJECT_SELF, TRUE, GetLastDamager());
	}
	SetLocalInt(OBJECT_SELF, "total_damage", nDamage);
}

void EndFight(object oKiller) {
	object oMonster1 = GetObjectByTag("ps_fw_monster1");
	object oMonster2 = GetObjectByTag("ps_fw_monster2");
	object controller = GetObjectByTag("ps_fw_beastmaster");
	SetLocalString(controller, "Winner", GetLocalString(controller, "POTENTIAL_WINNER"));
		
	if (GetIsObjectValid(oMonster1))
		DestroyObject(oMonster1, 2.0f);
	if (GetIsObjectValid(oMonster2))
		DestroyObject(oMonster2, 2.0f);
		
    DeleteLocalInt(controller,"FIGHTING");
}