//::///////////////////////////////////////////////
//:: Delayed Blast Fireball: On Enter
//:: NW_S0_DelFireA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The caster creates a trapped area which detects
    the entrance of enemy creatures into 3 m area
    around the spell location.  When tripped it
    causes a fiery explosion that does 1d6 per
    caster level up to a max of 20d6 damage.
*/
//:://////////////////////////////////////////////
//:: Georg: Removed Spellhook, fixed damage cap
//:: Created By: Preston Watamaniuk
//:: Created On: July 27, 2001
//:://////////////////////////////////////////////
//:: RPGplayer1 04/09/2008: Only enemies will trigger explosion
//:: Mymothersmeatloaf: 6/21/2020 - uncapped the spells damage.
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
//#include "ps_inc_functions" inherited from spellhook via class_mageslayer_utils

void main()
{

    //Declare major variables
    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator();
    location lTarget = GetLocation(OBJECT_SELF);
    int nDamage;
	int PML = GetPureMageLevels(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = PS_GetCasterLevel(oCaster);

	
    int nFire = PS_GetLocalInt(OBJECT_SELF, "NW_SPELL_DELAY_BLAST_FIREBALL");
    /*Limit caster level
    if (nCasterLevel > 20)
    {
        nCasterLevel = 20;
    }*/
    effect eDam;
    effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL);
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    //Check the faction of the entering object to make sure the entering object is not in the casters faction
    if(nFire == 0)
    {
        //if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster))
        {
            PS_SetLocalInt(OBJECT_SELF, "NW_SPELL_DELAY_BLAST_FIREBALL",TRUE);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
            //Cycle through the targets in the explosion area
            oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            while(GetIsObjectValid(oTarget))
            {
                if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
                {
                    //Fire cast spell at event for the specified target
                    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_DELAYED_BLAST_FIREBALL));
                    //Make SR check
                    if (!MyResistSpell(oCaster, oTarget))
                    {
                        nDamage = d3(nCasterLevel*2) + d3((2*PML)/3);
						if (nCasterLevel < 20 && !GetIsObjectValid(GetSpellCastItem())){
						nDamage = d3(40) + d3((2*PML)/3);
						} 
                        //Enter Metamagic conditions
                        if (nMetaMagic == METAMAGIC_MAXIMIZE)
                        {
                            nDamage = nDamage + ((3*nDamage)/4);//Damage is at max
                        }
                        else if (nMetaMagic == METAMAGIC_EMPOWER)
                        {
                            nDamage = nDamage + (nDamage/2);//Damage/Healing is +50%
                        }
                        //Change damage according to Reflex, Evasion and Improved Evasion
                        nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE, GetAreaOfEffectCreator());
                        //Set up the damage effect
                        eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                        if(nDamage > 0)
                        {
                            //Apply VFX impact and damage effect
                            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                            DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                        }
                    }
                }
                //Get next target in the sequence
                oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            }
            DestroyObject(OBJECT_SELF, 1.0);
        }
    }
}