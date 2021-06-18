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
#include "ps_inc_functions"

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

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = PS_GetCasterLevel(OBJECT_SELF);
    int nMissiles = (nCasterLvl);
	int nMetaMagic = GetMetaMagicFeat();
    //effect eMissile = EffectVisualEffect(VFX_IMP_MIRV);	// handled by SpawnSpellProjectile()
    effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);
    float fDelay, fTime, fTime2;
	int nSpell = GetSpellId();
	int nPathType = PROJECTILE_PATH_TYPE_DEFAULT;
	location lSourceLoc = GetLocation( OBJECT_SELF );
	location lTarget = GetLocation( oTarget );
    int nCnt;
	float fTravelTime;
	
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MAGIC_MISSILE));
        
		//Limit missiles to 12
        if (nMissiles > 12)
        {
            nMissiles = 12;
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
			fDelay = GetRandomDelay( 0.1f, 0.1f ) + (0.1f * IntToFloat(nCnt));
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
			else				fDelay = GetRandomDelay( 0.1f, 0.1f ) + (0.1f * IntToFloat(nCnt));
			
			/*
			fTime = fDelay + ((nCnt - 1) * 0.25);
			fTime2 = ((nCnt - 1) * 0.25);
			*/			        
			
			//Make SR Check
	        if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
		  	{
                //Roll damage
                int nDam = d3(1) + 1;
     	     //Resolve metamagic
				if (nMetaMagic == METAMAGIC_MAXIMIZE)
				{
				nDam = (nDam*2);
				}
				else if (nMetaMagic == METAMAGIC_EMPOWER)
				{
				nDam = nDam + nDam / 2;
				}

                //Set damage effect
                effect eDam = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL);
                //Apply the MIRV and damage effect
                DelayCommand(fDelay + fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(fDelay + fTravelTime, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
			}
			DelayCommand( fDelay, SpawnSpellProjectile(OBJECT_SELF, oTarget, lSourceLoc, lTarget, nSpell, nPathType) );
       	}
	}
	}
}