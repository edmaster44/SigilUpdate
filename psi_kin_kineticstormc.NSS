//::///////////////////////////////////////////////
//:: Acid Fog: Heartbeat
//:: NW_S0_AcidFogC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures within the AoE take 2d6 acid damage
    per round and upon entering if they fail a Fort Save
    their movement is halved.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: RPGplayer1 08/29/2008: Will ignore SR check, in case of Acid Bomb (won't work otherwise)

#include "X0_I0_SPELLS"
#include "psi_inc_psifunc"
#include "psi_inc_manifest"
#include "psi_inc_metapsi"
#include "psi_inc_fillin"
#include "psi_spellhook"

void main()
{

    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage = d6(2);
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_COM_HIT_ELECTRICAL);
    object oTarget;
    float fDelay;
	int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, GetAreaOfEffectCreator());
	int nDC = GetManifesterDC(GetAreaOfEffectCreator());
	if (GetLocalInt(GetAreaOfEffectCreator(), "METAPSI_AUGMENT") == 1)
    {
        nDC = nDC + 2;
    }

   //--------------------------------------------------------------------------
    // GZ 2003-Oct-15
    // When the caster is no longer there, all functions calling
    // GetAreaOfEffectCreator will fail. Its better to remove the barrier then
    //--------------------------------------------------------------------------
    if (!GetIsObjectValid(GetAreaOfEffectCreator()))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }


    //Start cycling through the AOE Object for viable targets including doors and placable objects.
    oTarget = GetFirstInPersistentObject(OBJECT_SELF);
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
        {
            /*if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_ACID, GetAreaOfEffectCreator(), fDelay))
            {
                 nDamage = d6();
            }*/

            nDamage = d6(2);

        //Enter Metamagic conditions
        if (GetLocalInt(GetAreaOfEffectCreator(), "METAPSI_MAXIMIZE") == 1)
        {
            nDamage = 12;//Damage is at max
        }
        if (GetLocalInt(GetAreaOfEffectCreator(), "METAPSI_EMPOWER") == 1)
        {
            nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
        }

        //Set the damage effect
        eDam = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
		eDam = EffectLinkEffects(eVis, eDam);

            fDelay = GetRandomDelay(0.4, 1.2);
            //Fire cast spell at event for the affected target
            SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), 14334));
            //Spell resistance check
            if(!MyResistSpell(GetAreaOfEffectCreator(), oTarget, fDelay))
            {
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				if(nDamage > 0 && !MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_SPELL, GetAreaOfEffectCreator(), fDelay))
            	{
                //slowing effect
					effect eParalyze = EffectParalyze(nDC, SAVING_THROW_FORT, TRUE);
					int nDurationP = d4(1);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParalyze, oTarget, RoundsToSeconds(nDurationP));
               
                // * BK: Removed this because it reduced damage, didn't make sense nDamage = d6();
            	}
            }
        }
        //Get next target.
        oTarget = GetNextInPersistentObject(OBJECT_SELF);
    }
}