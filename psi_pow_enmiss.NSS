//::///////////////////////////////////////////////
//:: Magic Missile
//:: NW_S0_MagMiss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// A missile of magical energy darts forth from your
// fingertip and unerringly strikes its target. The
// missile deals 1d4+1 points of damage.
//
// For every two extra levels of experience past 1st, you
// gain an additional missile.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 10, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: May 8, 2001

// (Updated JLR - OEI 08/02/05 NWN2 3.5 -- Metamagic cleanup)


// JLR - OEI 08/23/05 -- Metamagic changes
#include "nwn2_inc_spells"
#include "psi_inc_manifest"
#include "psi_inc_metapsi"
#include "psi_inc_fillin"
#include "psi_spellhook"
#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/
   if (!PsiPrePowerCastCode())
   {
   // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
       return;
   }

// End of Spell Cast Hook

   object oManifester = OBJECT_SELF;
   object oTarget     = GetSpellTargetObject();
   struct manifestation manif =
       EvaluateManifestationNew(oManifester, oTarget,
                             GetSpellId(),
                             METAPSIONIC_EMPOWER | METAPSIONIC_AUGMENT | METAPSIONIC_MAXIMIZE); //sending metapsionic options


	if(manif.bCanManifest)
	{

    //Declare major variables
    
	    int nCasterLvl = manif.nManifesterLevel;
	    int nMissiles = (nCasterLvl + 1)/2;
	    //effect eMissile = EffectVisualEffect(VFX_IMP_MIRV);	// handled by SpawnSpellProjectile()
	    effect eVis;
	    float fDelay, fTime, fTime2;
		int nSpell = GetSpellId();
		int nPathType = PROJECTILE_PATH_TYPE_DEFAULT;
		location lSourceLoc = GetLocation( OBJECT_SELF );
		location lTarget = GetLocation( oTarget );
	    int nCnt;
		float fTravelTime;
		int nAugment = GetLocalInt(OBJECT_SELF, "METAPSI_AUGMENT");
		int nLimit = 5;
		
		if (GetLocalInt(OBJECT_SELF, "METAPSI_AUGMENT") == 1)
		{
			nLimit = 7;
		}
		
	    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	    {
	        //Fire cast spell at event for the specified target
	        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 14332));
	        
			//Limit missiles to five
	        if (nMissiles > nLimit)
	        {
	            nMissiles = nLimit;
	        }
	
		effect eMantle = GetFirstEffect(oTarget);
		while (GetIsEffectValid(eMantle) &&
			(GetEffectSpellId(eMantle) != SPELL_LEAST_SPELL_MANTLE) &&
			(GetEffectSpellId(eMantle) != SPELL_LESSER_SPELL_MANTLE) &&
			(GetEffectSpellId(eMantle) != SPELL_SPELL_MANTLE) &&
			(GetEffectSpellId(eMantle) != SPELL_GREATER_SPELL_MANTLE))
		{
			eMantle = GetNextEffect(oTarget);
		}
		if (GetIsEffectValid(eMantle)) 
		{
			MyResistSpell(OBJECT_SELF, oTarget, fDelay);
			for (nCnt = 1; nCnt <= nMissiles; nCnt++)
			{
				fDelay = GetRandomDelay( 0.1f, 0.2f ) + (0.2f * IntToFloat(nCnt));
				DelayCommand( fDelay, SpawnSpellProjectile(OBJECT_SELF, oTarget, lSourceLoc, lTarget, nSpell, nPathType) );
			}
		}
		else
		{
			//Apply a single damage hit for each missile instead of as a single mass
			for (nCnt = 1; nCnt <= nMissiles; nCnt++)
			{
				fTravelTime = GetProjectileTravelTime( lSourceLoc, lTarget, nPathType );
				if ( nCnt == 0 )	fDelay = 0.0f;
				else				fDelay = GetRandomDelay( 0.1f, 0.2f ) + (0.2f * IntToFloat(nCnt));
				
				/*
				fTime = fDelay + ((nCnt - 1) * 0.25);
				fTime2 = ((nCnt - 1) * 0.25);
				*/			        
				
				//Make SR Check
		        if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
			  	{
	                //Roll damage
	                int nDam = d6(1);
	     	          //Enter Metamagic conditions
	                if (GetLocalInt(OBJECT_SELF, "METAPSI_EMPOWER") == 1)
					{
						nDam = d6(1) + 1;
						if (GetLocalInt(OBJECT_SELF, "METAPSI_MAXIMIZE") == 1)
						{
							nDam = 7;
						}
					}
					
					if (GetLocalInt(OBJECT_SELF, "METAPSI_MAXIMIZE") == 1)
					{
						nDam = 6;
					}
	
	                //Set damage effect
					int nDamageType;
					if (nSpell == 14453)
					{
						nDamageType = DAMAGE_TYPE_COLD;
						eVis = EffectVisualEffect(VFX_HIT_SPELL_ICE);
					}
					else if (nSpell == 14454)
					{
						nDamageType = DAMAGE_TYPE_ELECTRICAL;
						eVis = EffectVisualEffect(VFX_HIT_SPELL_LIGHTNING);
					}
					else if (nSpell == 14455)
					{
						nDamageType = DAMAGE_TYPE_FIRE;
						eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
					}
					else
					{
						nDamageType = DAMAGE_TYPE_SONIC;
						eVis = EffectVisualEffect(VFX_HIT_SPELL_SONIC);
					}
					
	                effect eDam = EffectDamage(nDam, nDamageType);
					
					
	                //Apply the MIRV and damage effect
	                DelayCommand(fDelay + fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
	                DelayCommand(fDelay + fTravelTime, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
				}
				DelayCommand( fDelay, SpawnSpellProjectile(OBJECT_SELF, oTarget, lSourceLoc, lTarget, nSpell, nPathType) );
	       	}
		}
		}
	}
}