//::///////////////////////////////////////////////
//:: Wall of Fire: Heartbeat
//:: NW_S0_WallFireA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Person within the AoE take 4d6 fire damage
    per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

// (Update JLR - OEI 07/19/05) -- Changed Dmg to 2d6 + lvl (max 20), double dmg to Undead


#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{

    //Declare major variables
	object oPC = GetAreaOfEffectCreator(OBJECT_SELF);
    int nCasterLvl = GetTotalLevels(oPC, TRUE);
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    effect eDam;
    object oTarget;
    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
    //Capture the first target object in the shape.

    //--------------------------------------------------------------------------
    // GZ 2003-Oct-15
    // When the caster is no longer there, all functions calling
    // GetAreaOfEffectCreator will fail. Its better to remove the barrier then
    //--------------------------------------------------------------------------
    if (!GetIsObjectValid(oPC))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    oTarget = GetFirstInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Declare the spell shape, size and the location.
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oPC, SPELL_WALL_OF_FIRE));
            //Make SR check, and appropriate saving throw(s).
            if(!MyResistSpell(oPC, oTarget))
            {
                //Roll damage.
				int nDice = GetTotalLevels(oPC, TRUE) / 2;
				if (nDice < 2) nDice = 2;
                nDamage = d6(nDice);  // JLR - OEI 07/19/05

                nDamage += nCasterLvl;  // JLR - OEI 07/19/05
                if ( GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD )
                {
                    nDamage *= 2;
                }

                nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE);
                if(nDamage > 0)
                {
                    // Apply effects to the currently selected target.
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}