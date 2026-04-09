//::///////////////////////////////////////////////
//:: Lightning Bolt
//:: NW_S0_LightnBolt
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does 1d6 per level in a 5ft tube for 30m
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On:  March 8, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: May 2, 2001
//:: Mymothersmeatloaf 6/20/2020: Upped scaling to 20'th level and changed damage dice to d10

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 
#include "ginc_debug"
#include "ps_inc_functions"

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    int nCasterLevel = PS_GetCasterLevel(OBJECT_SELF);
    //Limit caster level
	int PML = GetPureMageLevels(OBJECT_SELF);
    int nDamage;
    int nMetaMagic = GetMetaMagicFeat();
    //Set the lightning stream to start at the caster's hands
    effect eLightning = EffectBeam(VFX_BEAM_LIGHTNING, OBJECT_SELF, BODY_NODE_HAND);
    effect eVis  = EffectVisualEffect(VFX_HIT_SPELL_LIGHTNING);
    effect eDamage;
    object oTarget = GetSpellTargetObject();
    location lTarget = GetLocation(oTarget);
	location lTarget2 = GetSpellTargetLocation();
	
	//string sTarget2 = "wp_lbolttrgt2";
    object oNextTarget, oTarget2;
    float fDelay;
    int nCnt = 1;
	
	// If you target a location, this will spawn in an invisible creature to act as the endpoint on the beam, then delete itself
	object oPoint = CreateObject(OBJECT_TYPE_CREATURE, "c_attachspellnode" , lTarget2);
	SetScriptHidden(oPoint, TRUE);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLightning, oPoint, 1.0);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPoint);
	DestroyObject(oPoint, 2.0);
	
	//CreateObject(OBJECT_TYPE_WAYPOINT, sTarget2, lTarget2);
	//object oPoint = GetObjectByTag(sTarget2);
	//ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLightning, oPoint, 1.0);
	//PrettyDebug("Lightning bolt!  Woo Hoo!");
    oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
    while(GetIsObjectValid(oTarget2) && GetDistanceToObject(oTarget2) <= 30.0)
    {
        //Get first target in the lightning area by passing in the location of first target and the casters vector (position)
        oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, 30.0, lTarget2, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
		//PrettyDebug("investigating target " + GetName(oTarget));
         while (GetIsObjectValid(oTarget))
        {
           //Exclude the caster from the damage effects
           if (oTarget != OBJECT_SELF && oTarget2 == oTarget)
           {
                if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
            	{
                   //Fire cast spell at event for the specified target
					//PrettyDebug("Signaling Lightning Bolt on " + GetName(oTarget));
                   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LIGHTNING_BOLT));
                   //Make an SR check
                   if (!MyResistSpell(OBJECT_SELF, oTarget))
        	       {
                        //Roll damage
                        nDamage =  d4(nCasterLevel) +  d4(PML/3) ;
						if (nCasterLevel < 20 && !GetIsObjectValid(GetSpellCastItem())){
						nDamage = d4(20) + d4(PML/3);
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
                        //Adjust damage based on Reflex Save, Evasion and Improved Evasion
                        nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(),SAVING_THROW_TYPE_ELECTRICITY);
                        //Set damage effect
                        eDamage = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
                        if(nDamage > 0)
                        {
                            fDelay = GetSpellEffectDelay(GetLocation(oTarget), oTarget);
                            //Apply VFX impcat, damage effect and lightning effect
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget));
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
                        }
                    }
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oTarget,1.0);
                    //Set the currect target as the holder of the lightning effect
                    oNextTarget = oTarget;
                    eLightning = EffectBeam(VFX_BEAM_LIGHTNING, oNextTarget, BODY_NODE_CHEST);
                }
           }
           //Get the next object in the lightning cylinder
           oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, 30.0, lTarget2, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
        }
        nCnt++;
        oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
    }
}