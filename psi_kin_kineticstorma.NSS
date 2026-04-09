

//::///////////////////////////////////////////////
//:: Acid Fog: On Enter
//:: NW_S0_AcidFogA.nss
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
#include "psi_inc_manifest"

void main()
{

    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_COM_HIT_ELECTRICAL);
    effect eSlow = EffectMovementSpeedDecrease(50);
    object oTarget = GetEnteringObject();
    float fDelay = GetRandomDelay(1.0, 2.2);
	int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, GetAreaOfEffectCreator());
	int nDC = GetManifesterDC(GetAreaOfEffectCreator());
    if (GetLocalInt(GetAreaOfEffectCreator(), "METAPSI_AUGMENT") == 1)
    {
        nDC = nDC + 2;
    }

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), 14334));
        //Spell resistance check
        if(!MyResistSpell(GetAreaOfEffectCreator(), oTarget, fDelay))
        {
            //Roll Damage
            //Enter Metamagic conditions
            nDamage = d6(4);
            if (GetLocalInt(GetAreaOfEffectCreator(), "METAPSI_MAXIMIZE") == 1)
            {
                nDamage = 24;//Damage is at max
            }
            if (GetLocalInt(GetAreaOfEffectCreator(), "METAPSI_EMPOWER") == 1)
            {
                nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
            }
            //Make a Fortitude Save to avoid the effects of the movement hit.
            

            //Set Damage Effect with the modified damage
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
            //Apply damage and visuals
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
			
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
}