

//::///////////////////////////////////////////////
//:: Dying Script
//:: NW_O0_DEATH.NSS
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This script handles the default behavior
    that occurs when a player is dying.
    DEFAULT CAMPAIGN: player dies automatically
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: November 6, 2001
//:://////////////////////////////////////////////


void main()
{
// Contingency heal at 0 hit points by Ceremorph 11/7/16
object oDying  	= GetLastPlayerDying();
object oItem  = GetItemPossessedBy(oDying,"ps_essence");
int nContingency	= GetLocalInt(oDying, "Contingency");
int nHPHeal  	= GetMaxHitPoints(oDying);
effect eRestore, eSafety, eHeal, eVis1, eVis2;


if (nContingency == 1)
{	eRestore  = EffectResurrection();
 eSafety = EffectEthereal();
 eHeal = EffectHeal(nHPHeal);
 eVis1 = EffectNWN2SpecialEffectFile("fx_teleport_new.sef", oDying);
 eVis2 = EffectNWN2SpecialEffectFile("fx_telthor_m.sef", oDying);
 	DelayCommand(12.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eRestore, oDying));
	DelayCommand(12.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis1, oDying));
	DelayCommand(12.5f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oDying));
	DelayCommand(12.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSafety, oDying, 6.0f));
	DelayCommand(12.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis2, oDying, 6.0f));
 	SetLocalInt(oDying, "Contingency", 0);
 	return;  }


// * April 14 2002: Hiding the death part from player
  effect eDeath = EffectDeath(FALSE, FALSE);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, GetLastPlayerDying());
}