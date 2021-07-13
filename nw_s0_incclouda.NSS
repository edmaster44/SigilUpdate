//::///////////////////////////////////////////////
//:: Incendiary Cloud
//:: NW_S0_IncCloud.nss
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
//:: March 2003: Removed movement speed penalty
#include "X0_I0_SPELLS"
#include "ps_inc_functions"

void main()
{

    //Declare major variables
	int nCasterLvl = PS_GetCasterLevel(OBJECT_SELF);

	int nMetaMagic = GetMetaMagicFeat();
	int PML = GetPureMageLevels(OBJECT_SELF);
    int nDamage;
    effect eDam;
    object oTarget;
    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
    float fDelay;
    //Capture the first target object in the shape.
    oTarget = GetEnteringObject();
    //Declare the spell shape, size and the location.
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_INCENDIARY_CLOUD));
        //Make SR check, and appropriate saving throw(s).
       // if(!MyResistSpell(GetAreaOfEffectCreator(), oTarget, fDelay))
      //  {
            fDelay = GetRandomDelay(0.5, 2.0);
            //Roll damage.
            nDamage = d6(nCasterLvl/3) + d6(PML/9);
			if (nCasterLvl < 20 && !GetIsObjectValid(GetSpellCastItem())){
			nDamage = d6(20/3) + d6(PML/9);
			} 
            //Enter Metamagic conditions
                if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {
                   nDamage = nDamage + ((3*nDamage)/4);//Damage is at max
                }
                if (nMetaMagic == METAMAGIC_EMPOWER)
                {
                     nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                }
            //Adjust damage for Reflex Save, Evasion and Improved Evasion
            	if(MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE, GetAreaOfEffectCreator(), fDelay))
         	    {
                 nDamage = nDamage/2;
        	    }
            // Apply effects to the currently selected target.
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
            if(nDamage > 0)
            {
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
       // }
    }
}