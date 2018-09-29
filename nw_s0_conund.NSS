//::///////////////////////////////////////////////
//:: [Control Undead]
//:: [NW_S0_ConUnd.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
    A single undead with up to 3 HD per caster level
    can be dominated.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 2, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk
//:: Last Updated On: April 6, 2001

#include "x0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;

    //Declare major variables
	object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
	if (GetIsOwnedByPlayer(oTarget) == TRUE)
	{
		FloatingTextStringOnCreature("Control Undead does not affect player characters.", oPC, FALSE);
		return;
		//Does not work against other players.
	}
	
	// Maximum 5 undead from Control Undead at a time.
	int undeadCount = 0;
	object area = GetArea(oPC);
	
	object oCreature = GetFirstObjectInArea(area);
	while (GetIsObjectValid(oCreature))
	{
	if(GetObjectType(oCreature) == OBJECT_TYPE_CREATURE && GetControlledCharacter(oCreature) == oPC && GetHasSpellEffect(SPELL_CONTROL_UNDEAD, oCreature))
		++undeadCount;
	
	oCreature = GetNextObjectInArea(area);
	}
	
	if (undeadCount >= 5)
	{
		SendMessageToPC(oPC, "You have too many undead under your control and cannot dominate more for now.");
		return;
	}
	
    effect eControl = EffectCutsceneDominated();
    //effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);	// NWN1 VFX
    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_CONTROL_UNDEAD);	// NWN2 VFX
	eControl = EffectLinkEffects(eControl, eVis);
	
	//Make meta magic
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = GetCasterLevel(oPC);
    int nDuration = nCasterLevel;
    int nHD = nCasterLevel * 2;
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nCasterLevel * 2;
	
	//The actual spell
    if ((GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)&&(GetHitDice(oTarget) <= nHD))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))
        {
           //Fire cast spell at event for the specified target
           SignalEvent(oTarget, EventSpellCastAt(oPC, SPELL_CONTROL_UNDEAD));
           if (!MyResistSpell(oPC, oTarget))
           {
                //Make a Will save
                if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, oPC, 1.0))
                {
                    //Apply VFX impact and Link effect
                    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	// NWN1 VFX
                    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eControl, oTarget, HoursToSeconds(nDuration)));
                    //Increment HD affected count
                }
            }
        }
    }
}