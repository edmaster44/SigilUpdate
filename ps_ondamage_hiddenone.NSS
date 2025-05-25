

#include "hench_i0_ai"
#include "ginc_behavior"
void main()
{
	int iFocused = GetIsFocused();
	object oDamager = GetLastDamager();
	int nDamage = GetTotalDamageDealt();
	int nMax = GetMaxHitPoints();
	int nPreviousDamage = GetLocalInt(OBJECT_SELF, "damageTaken");
	
	object oWeapon = GetItemInSlot(4, oDamager);
	if (GetTag(oWeapon) == "ps_sword_godkiller")
		SetLocalInt(OBJECT_SELF, "damageTaken", nPreviousDamage+nDamage);
	
	if (nPreviousDamage > nMax)
		SetImmortal(OBJECT_SELF, FALSE);
	
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
}