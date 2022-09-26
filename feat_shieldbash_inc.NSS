#include "x2_inc_spellhook"
#include "X0_I0_SPELLS"
#include "ps_inc_functions"
#include "ps_inc_equipment"
#include "ps_inc_advscript"
#include "nw_i0_spells"
#include "x0_i0_match"
#include "ps_inc_melee"
#include "x2_inc_itemprop"


int CancelIfNotInMeleeRange(object oCaller, object oTarget, int nFeatID)
{
	if (GetDistanceBetween(oCaller, oTarget) > 4.5f) // Melee range seems to be around a little less then 3.0f, so picked a number
	{                                                // a little higher to give some loose.
		SendMessageToPC(oCaller, "Target out of range.");
		ResetFeatUses(oCaller, nFeatID, FALSE, TRUE);
		return FALSE;
	}	
	return TRUE;
}


void Shield_Bash(object oPC, object oTarget, int nSpell )
{
int nDam;
object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
	
	if(GetWeaponRanged(oShield) || !GetIsObjectValid(oShield))
	{
		SendMessageToPC(oPC,"You require a Shield to use this");
		return;
	}
int shield = GetBaseItemType(oShield);
if(shield = 56) nDam = d6(1);
else if (shield = 57)
nDam = d8(1);
else if (shield = 14)
nDam = d4(1);

int iHit = AttemptMeleeAttackMainHand(oPC, oTarget,"Shield Bash",1, "*shieldbash", 0, nSpell);
if(iHit >0)
{

}
}


void Shield_Throw(object oPC, object oTarget, int nSpell )
{


}

void Agile_Strike(object oPC, object oTarget, int nSpell )
{


}

void Arcane_Bash(object oPC, int nSpell)
{


}