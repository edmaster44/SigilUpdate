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
// Mymothersmeatloaf 6/21/2020 - Removed SR
#include "X0_I0_SPELLS"
#include "ps_inc_functions"

void main()
{

		
	int nMetaMagic = GetMetaMagicFeat();
	int nDamage;
	int nCL = PS_GetCasterLevel(OBJECT_SELF);
	int nPML = PS_GetPureMageCL(OBJECT_SELF);
	effect eDam;
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ACID);
	effect eSlow = EffectMovementSpeedDecrease(50);
	object oTarget = GetEnteringObject();
	float fDelay = GetRandomDelay(1.0, 2.2);

/* DAE: The SR check was already commented out so didn't seem like we need to this part.
    int nIgnoreSR = FALSE;
    if (GetTag(OBJECT_SELF) == "AOE_ACID_BOMB")
    {
        nIgnoreSR = TRUE;
    }
*/

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_ACID_FOG));
        //Spell resistance check
       // if(nIgnoreSR || !MyResistSpell(GetAreaOfEffectCreator(), oTarget, fDelay))
       // {
            //Roll Damage
            //Enter Metamagic conditions
            
			if (nCL < ITEM_MIN_CL && !GetIsObjectValid(GetSpellCastItem())){
				nDamage = d4(ITEM_MIN_CL/3) + d4(nPML/3);
			}
			else
			{
				nDamage = d4(nCL/3) + d4(nPML/3);
			}

            if (nMetaMagic == METAMAGIC_MAXIMIZE)
            {
                nDamage = nDamage + ((3*nDamage)/4);//Damage is at max
            }
            else if (nMetaMagic == METAMAGIC_EMPOWER)
            {
                nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
            }
            //Make a Fortitude Save to avoid the effects of the movement hit.
            if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_ACID, GetAreaOfEffectCreator(), fDelay))
            {
                //slowing effect
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlow, oTarget);
                // * BK: Removed this because it reduced damage, didn't make sense nDamage = d6();
				
            }
			
			else if (MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_ACID, GetAreaOfEffectCreator(), fDelay))
			{
				nDamage = nDamage/2;
			}
				

            //Set Damage Effect with the modified damage
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
            //Apply damage and visuals
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
       // }
    }
}