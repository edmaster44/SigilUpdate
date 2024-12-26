#include "ps_inc_onhit" 

void main() {

	int aID = GetOnHitAbilityID(OBJECT_SELF)+1751;
	object oCaster = GetOnHitAbilityCaster(OBJECT_SELF);
	string sSpellID = Get2DAString("iprp_onhit_abilities", "SpellID", aID);
	int nSpell = StringToInt(sSpellID);
	
	object oMaster;
	effect eVis = EffectVisualEffect( VFX_HIT_AOE_ABJURATION );
	effect eDeath = EffectDeath(FALSE, TRUE, TRUE); //FIX: should work on death-immune
	effect eLink = EffectLinkEffects(eVis, eDeath);
    int nBaseSpellDC = GetOnHitAbilityDC(oCaster);
	int nCasterLevel = GetCasterLevel ( oCaster );
	int nRacial;
	int nHitDice;
	int nAdjustedSpellDC;
		
	location lTarget = GetLocation(OBJECT_SELF);
	
	if (GetHasSpell(SPELL_BANISHMENT, oCaster)) {
		object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget);
	    int nPool = 2* PS_GetCasterLevel(OBJECT_SELF);
	
	    while(GetIsObjectValid(oTarget))
	    {
	        //does the creature have a master.
	        oMaster = GetMaster(oTarget);
	        if (oMaster == OBJECT_INVALID)
	        {
	            oMaster = OBJECT_SELF;  // TO prevent problems with invalid objects
	                                    // passed into GetAssociate
	        }
			
	        if((GetAssociate(ASSOCIATE_TYPE_SUMMONED, oMaster) == oTarget ||
	          GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oMaster) == oTarget ||
	          GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oMaster) == oTarget ) ||
	          (GetRacialType((oTarget)) == RACIAL_TYPE_OUTSIDER)  &&
	          (nPool > 0))
	        {
	        	// * March 2003. Added a check so that 'friendlies' will not be
	            // * unsummoned.
	            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
	            {
	             	SignalEvent(oTarget, EventSpellCastAt(oCaster, 430));
	                //Determine correct save
	                // * Must be enough points in the pool to destroy target
	                if (nPool >= GetHitDice(oTarget))
	                // * Make SR and will save checks
	                if (!OnHitResistSpell(oCaster, oTarget) && !MySavingThrow(SAVING_THROW_WILL, oTarget, nBaseSpellDC))
	                {
	                	//Apply the VFX and delay the destruction of the summoned monster so
	                    //that the script and VFX can play.
	
	                    nPool = nPool - GetHitDice(oTarget);
	                    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
	                    if (CanCreatureBeDestroyed(oTarget) == TRUE)
	                    {
	                    	//bugfix: Simply destroying the object won't fire it's OnDeath script.
	                        //Which is bad when you have plot-specific things being done in that
	                        //OnDeath script... so lets kill it.
	                        effect eKill = EffectDamage(GetCurrentHitPoints(oTarget));
	                        //just to be extra-sure... :)
	                        effect eDeath = EffectDeath(FALSE, FALSE);
	                        DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget));
	                        DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
							string report = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> kills "+GetName(oTarget)+"</color>";
							DelayCommand(0.25, SendMessageToPC(oCaster, report));
	                    }
	                } // rep check
	            }
	        }
	        //Get next creature in the shape.
	        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget);
	    }
	}
	else if (GetHasSpell(SPELL_DISMISSAL, oCaster)) {
		
		nBaseSpellDC += nCasterLevel;
	    //Get the first object in the are of effect
	    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget );
		
	    while(GetIsObjectValid(oTarget))
	    { 	
	        //does the creature have a master.
	        oMaster = GetMaster(oTarget);
			nHitDice = GetHitDice ( oTarget );
			nAdjustedSpellDC = nBaseSpellDC - nHitDice;
			nRacial = GetRacialType(oTarget);
			
	        //Is that master valid and is he an enemy
	        if ( (GetIsObjectValid(oMaster) && spellsIsTarget(oMaster,SPELL_TARGET_STANDARDHOSTILE, oCaster) ) ||
				 spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster) )
	        {
			
	            if ( GetAssociate(ASSOCIATE_TYPE_SUMMONED, oMaster) == oTarget ||
	            	GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oMaster) == oTarget ||
	            	GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oMaster) == oTarget ||
					nRacial == RACIAL_TYPE_OUTSIDER ||
					nRacial == RACIAL_TYPE_ELEMENTAL )
	            {
	                SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_DISMISSAL));
	                //Determine correct save
	               
	                //Make SR and will save checks
	                if (!OnHitResistSpell(oCaster, oTarget) && !MySavingThrow(SAVING_THROW_WILL, oTarget, nAdjustedSpellDC))
	                {
	                     //Apply the VFX and delay the destruction of the summoned monster so
	                     //that the script and VFX can play.
	                     ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
						 string report = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> kills "+GetName(oTarget)+"</color>";
						 SendMessageToPC(oCaster, report);
	                }
	            }
	        }
	        //Get next creature in the shape.
	        oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget );	
		}
		
	}
}