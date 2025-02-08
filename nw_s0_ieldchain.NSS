//::///////////////////////////////////////////////
//:: Invocation: Eldritch Chain (Warlock Spelllike effect)
//:: NW_S0_IEldChain.nss
//:://////////////////////////////////////////////
/*
    Does 1d6 Dmg per "ranking" of Eldritch Blast.
    Chains from Target to secondary targets,
    similar to Chain Lightning.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: August 22, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001


#include "nw_i0_invocatns"
#include "x2_inc_spellhook" 

void DoChainEffectWrapper(int nID, object oTarget, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE);
int DoChainEffect(int nID, object oTarget, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE);

void main() {

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
	
	int nID = GetSpellId();
	if (nID == 824) {
    	DoShapeEldritchChain();
		return;
	}

    //Declare major variables
    int nCasterLvl = GetWarlockCasterLevel(OBJECT_SELF);
    if (nCasterLvl > 20) { nCasterLvl = 20; } //max CL 20?
	
	
    int nNumAffected = 0;
    int nMetaMagic = GetMetaMagicFeat();
	
	int nChain1VFX = VFX_INVOCATION_ELDRITCH_CHAIN;	// default Chain1 is Eldritch
	int nChain2VFX = VFX_INVOCATION_ELDRITCH_CHAIN2;	// default Chain2 is Eldritch
	int nHitVFX = VFX_INVOCATION_ELDRITCH_HIT;	// default nHitVFX is Eldritch

	// adjust the VFX according to the essence
    if ( (nMetaMagic & METAMAGIC_INVOC_DRAINING_BLAST) ||  nID == 2233 )         
	{ 
		nChain1VFX = VFX_INVOCATION_DRAINING_CHAIN; 
		nChain2VFX = VFX_INVOCATION_DRAINING_CHAIN2;
		nHitVFX = VFX_INVOCATION_DRAINING_HIT;
	}
    else if ( (nMetaMagic & METAMAGIC_INVOC_FRIGHTFUL_BLAST) ||  nID == 2234 )   
	{ 
		nChain1VFX = VFX_INVOCATION_FRIGHTFUL_CHAIN; 
		nChain2VFX = VFX_INVOCATION_FRIGHTFUL_CHAIN2; 
		nHitVFX = VFX_INVOCATION_FRIGHTFUL_HIT;
	}
    else if ( (nMetaMagic & METAMAGIC_INVOC_BESHADOWED_BLAST) ||  nID == 2235 )  
	{ 
		nChain1VFX = VFX_INVOCATION_BESHADOWED_CHAIN; 
		nChain2VFX = VFX_INVOCATION_BESHADOWED_CHAIN2; 
		nHitVFX = VFX_INVOCATION_BESHADOWED_HIT;
	}
    else if ( (nMetaMagic & METAMAGIC_INVOC_BRIMSTONE_BLAST) ||  nID == 2236 )   
	{ 
		nChain1VFX = VFX_INVOCATION_BRIMSTONE_CHAIN; 
		nChain2VFX = VFX_INVOCATION_BRIMSTONE_CHAIN2; 
		nHitVFX = VFX_INVOCATION_BRIMSTONE_HIT;
	}
    else if ( (nMetaMagic & METAMAGIC_INVOC_HELLRIME_BLAST) ||  nID == 2237 )    
	{ 
		nChain1VFX = VFX_INVOCATION_HELLRIME_CHAIN; 
		nChain2VFX = VFX_INVOCATION_HELLRIME_CHAIN2; 
		nHitVFX = VFX_INVOCATION_HELLRIME_HIT;
	}
    else if ( (nMetaMagic & METAMAGIC_INVOC_BEWITCHING_BLAST) ||  nID == 2238 )  
	{ 
		nChain1VFX = VFX_INVOCATION_BEWITCHING_CHAIN; 
		nChain2VFX = VFX_INVOCATION_BEWITCHING_CHAIN2; 
		nHitVFX = VFX_INVOCATION_BEWITCHING_HIT;
	}
    else if ( (nMetaMagic & METAMAGIC_INVOC_NOXIOUS_BLAST) ||  nID == 2239 )     
	{ 
		nChain1VFX = VFX_INVOCATION_NOXIOUS_CHAIN; 
		nChain2VFX = VFX_INVOCATION_NOXIOUS_CHAIN2; 
		nHitVFX = VFX_INVOCATION_NOXIOUS_HIT;
	}
    else if ( (nMetaMagic & METAMAGIC_INVOC_VITRIOLIC_BLAST) ||  nID == 2240 )   
	{ 
		nChain1VFX = VFX_INVOCATION_VITRIOLIC_CHAIN; 
		nChain2VFX = VFX_INVOCATION_VITRIOLIC_CHAIN2; 
		nHitVFX = VFX_INVOCATION_VITRIOLIC_HIT;
	}
    else if ( (nMetaMagic & METAMAGIC_INVOC_UTTERDARK_BLAST) ||  nID == 2241 )   
	{ 
		nChain1VFX = VFX_INVOCATION_UTTERDARK_CHAIN; 
		nChain2VFX = VFX_INVOCATION_UTTERDARK_CHAIN2; 
		nHitVFX = VFX_INVOCATION_UTTERDARK_HIT;
	}
    else if ( (nMetaMagic & METAMAGIC_INVOC_HINDERING_BLAST) ||  nID == 2242 )   
	{ 
		nChain1VFX = VFX_INVOCATION_HINDERING_CHAIN; 
		nChain2VFX = VFX_INVOCATION_HINDERING_CHAIN2; 
		nHitVFX = VFX_INVOCATION_HINDERING_HIT;
	}
    else if ( (nMetaMagic & METAMAGIC_INVOC_BINDING_BLAST) ||  nID == 2243 )   
	{ 
		nChain1VFX = VFX_INVOCATION_BINDING_CHAIN; 
		nChain2VFX = VFX_INVOCATION_BINDING_CHAIN2; 
		nHitVFX = VFX_INVOCATION_BINDING_HIT;
	}
	
	if (IsHellfireBlastActive())
	{
		nChain1VFX = VFX_INVOCATION_BRIMSTONE_CHAIN; 
		nChain2VFX = VFX_INVOCATION_BRIMSTONE_CHAIN2; 
		nHitVFX = VFX_INVOCATION_BRIMSTONE_HIT;
	}
	
    //Declare lightning effect connected the casters hands
    effect eLightning = EffectBeam( nChain1VFX, OBJECT_SELF, BODY_NODE_HAND );
    effect eVis  = EffectVisualEffect( nHitVFX );
    object oFirstTarget = GetSpellTargetObject();
    object oHolder;
    object oTarget;
    location lSpellLocation;

    //setting this to non-zero will trigger collecting touch attack success info from DoEldritchCombinedEffects
    PS_SetLocalInt(OBJECT_SELF, "NW_EB_TOUCH_RESULT", 1);

    //Apply effect to the first target and the VFX impact.
    if(DoChainEffect(nID, oFirstTarget))
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oFirstTarget);
    }
	
    //Apply the lightning stream effect to the first target, connecting it with the caster
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oFirstTarget,0.5);

    //Reinitialize the lightning effect so that it travels from the first target to the next target
    eLightning = EffectBeam(nChain2VFX, oFirstTarget, BODY_NODE_CHEST);

    float fDelay = 0.2;
    int nCnt = 0;
    // Warlock Counts
    int nMaxCnt;
    if ( nCasterLvl >= 20 )      { nMaxCnt = 4; }
    else if ( nCasterLvl >= 15 ) { nMaxCnt = 3; }
    else if ( nCasterLvl >= 10 ) { nMaxCnt = 2; }
    else                         { nMaxCnt = 1; }

    // *
    // * Secondary Targets
    // *
    int nBonus = 0;
    if (GetHasFeat(FEAT_EPIC_ELDRITCH_MASTER, OBJECT_SELF))
    {
        nBonus = 2;
    }   
    
    //Get the first target in the spell shape
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oFirstTarget), TRUE, OBJECT_TYPE_CREATURE );

    int nTouch = PS_GetLocalInt(OBJECT_SELF, "NW_EB_TOUCH_RESULT");
    PS_DeleteLocalInt(OBJECT_SELF, "NW_EB_TOUCH_RESULT");
    if ( nTouch == TOUCH_ATTACK_RESULT_MISS )
    {
	    // Failed
		return;
	}
	
    while (GetIsObjectValid(oTarget) && nCnt < nMaxCnt)
    {
		//SpeakString("DoShapeEldritchChain(): Chain target while loop iteration.");	// DEBUG!

        //Make sure the caster's faction is not hit and the first target is not hit
        if (oTarget != oFirstTarget && spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        {
		    nTouch = TouchAttackRanged( oTarget, TRUE, nBonus );
		    if ( nTouch == TOUCH_ATTACK_RESULT_MISS ) {
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oTarget,0.5));
    			return;
    		}
            //Connect the new lightning stream to the older target and the new target
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oTarget,0.5));
            {
                if ( nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT) )
                {
                    DelayCommand(fDelay, DoChainEffectWrapper(nID, oTarget, FALSE));
                }
                else
                {
                    DelayCommand(fDelay, DoChainEffectWrapper(nID, oTarget,FALSE,TRUE));
                }
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
            }
            oHolder = oTarget;

            //change the currect holder of the lightning stream to the current target
            if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
            {
                eLightning = EffectBeam( nChain2VFX, oHolder, BODY_NODE_CHEST );
            }
            else
            {
                // * April 2003 trying to make sure beams originate correctly
                effect eNewLightning = EffectBeam( nChain2VFX, oHolder, BODY_NODE_CHEST );
                if(GetIsEffectValid(eNewLightning))
                {
                    eLightning =  eNewLightning;
                }
            }

            fDelay = fDelay + 0.1f;
	        //Count the number of targets that have been hit.
	        if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE && !GetIsDead(oTarget))	// added the GetIsDead check to keep from cheating the player when corpses are hit, which were counting against the max count
	        {
	            nCnt++;
	        }
        }
		
        //Get the next target in the shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oFirstTarget), TRUE, OBJECT_TYPE_CREATURE);
    }
	
	if (IsHellfireBlastActive() && nHellfireConDmg > 0)
	{
		HellfireShieldFeedbackMsg(nHellfireConDmg, STRREF_HELLFIRE_BLAST_NAME, OBJECT_SELF);
		nHellfireConDmg = 0;
	}
	
	DoHellfireDamage();	
	
}

void DoChainEffectWrapper(int nID, object oTarget, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE) {
	DoChainEffect(nID, oTarget, nAllowReflexSave, nHalfDmg);
}

int DoChainEffect(int nID, object oTarget, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE) {
	switch (nID) {
		case 2233: return DoEssenceDrainingBlast( OBJECT_SELF, oTarget, TRUE, FALSE, nAllowReflexSave, nHalfDmg ); //draining spear
		case 2234: return DoEssenceFrightfulBlast( OBJECT_SELF, oTarget, TRUE, FALSE, nAllowReflexSave, nHalfDmg ); //frightful spear
		case 2235: return DoEssenceBeshadowedBlast( OBJECT_SELF, oTarget, TRUE, FALSE, nAllowReflexSave, nHalfDmg ); //beshadowed spear
		case 2236: return DoEssenceBrimstoneBlast( OBJECT_SELF, oTarget, TRUE, FALSE, nAllowReflexSave, nHalfDmg ); //brimstone spear
		case 2237: return DoEssenceHellrimeBlast( OBJECT_SELF, oTarget, TRUE, FALSE, nAllowReflexSave, nHalfDmg ); //hellrime spear
		case 2238: return DoEssenceBewitchingBlast( OBJECT_SELF, oTarget, TRUE, FALSE, nAllowReflexSave, nHalfDmg ); //bewitching spear
		case 2239: return DoEssenceNoxiousBlast( OBJECT_SELF, oTarget, TRUE, FALSE, nAllowReflexSave, nHalfDmg ); //noxious spear
		case 2240: return DoEssenceVitriolicBlast( OBJECT_SELF, oTarget, TRUE, FALSE, nAllowReflexSave, nHalfDmg ); //vitriolic spear
		case 2241: return DoEssenceUtterdarkBlast( OBJECT_SELF, oTarget, TRUE, FALSE, nAllowReflexSave, nHalfDmg ); //utterdark spear
		case 2242: return DoEssenceHinderingBlast( OBJECT_SELF, oTarget, TRUE, FALSE, nAllowReflexSave, nHalfDmg ); //hindering spear
		case 2243: return DoEssenceBindingBlast( OBJECT_SELF, oTarget, TRUE, FALSE, nAllowReflexSave, nHalfDmg ); //binding spear
	}
	
	return FALSE;
}