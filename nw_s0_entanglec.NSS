//::///////////////////////////////////////////////
//:: Entangle
//:: NW_S0_EntangleC.NSS
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the AOE the target must make
    a reflex save or be entangled by vegitation
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 30, 2001
//:://////////////////////////////////////////////
//::Updated Aug 14, 2003 Georg: removed some artifacts
//::RPGplayer1 12/20/2008: Use charisma based DC, for racial version (per PnP)

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
	object oCaster = GetAreaOfEffectCreator();
	struct dSpellData data = GetSpellDataForAoE("Entangle", oCaster);
    //Declare major variables
    effect eHold = EffectEntangle();
    effect eEntangle = EffectVisualEffect(VFX_DUR_ENTANGLE);
    //Link Entangle and Hold effects
    effect eLink = EffectLinkEffects(eHold, eEntangle);

    object oTarget = GetFirstInPersistentObject();
    int nDC;

	if (GetTag(OBJECT_SELF) == "AOE_ENTANGLE_RACIAL")
	{
		nDC = 10 + GetSpellLevel(SPELL_ENTANGLE) + GetAbilityModifier(ABILITY_CHARISMA, GetAreaOfEffectCreator());
	} else nDC = data.nDC;

    while(GetIsObjectValid(oTarget))
    {  
       if(GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE)
       {
            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_ENTANGLE));
                if(!GetHasSpellEffect(SPELL_ENTANGLE, oTarget))
                {
                    if(!MyResistSpell(oCaster, oTarget))
                    {
                        //Make reflex save
                        if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC))
                        {
                           //Apply linked effects
                           ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2));
                        }
                    }
                }
            }
        }
        //Get next target in the AOE
        oTarget = GetNextInPersistentObject();
    }
}