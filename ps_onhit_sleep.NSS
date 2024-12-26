#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 
#include "ps_inc_onhit" 

void main() {

	int aID = GetOnHitAbilityID(OBJECT_SELF)+1751;
	object oCaster = GetOnHitAbilityCaster(OBJECT_SELF);
	string sSpellID = Get2DAString("iprp_onhit_abilities", "SpellID", aID);
	int nSpell = StringToInt(sSpellID);
	int nDC = GetOnHitAbilityDC(OBJECT_SELF);
	int nID = GetOnHitAbilityID(OBJECT_SELF);
	int nHD = 0;
	int nMax;
	
	if (GetHasSpell(SPELL_HISS_OF_SLEEP, oCaster)) {
		nHD = 2000; //arbitrarily large number!
		nMax = 2000;
	}
	else if (GetHasSpell(SPELL_DEEP_SLUMBER, oCaster)) {
		nHD = 10+d10();
		nMax = 10;
	}
	else if (GetHasSpell(SPELL_SLEEP, oCaster)) {
		nHD = 4+d4();
		nMax = 5;
	}
		
	//Declare major variables
    object oTarget;
    object oLowest;
    effect eSleep =  EffectSleep();
	effect eDur = EffectVisualEffect( VFX_DUR_SLEEP );
	effect eLink = EffectLinkEffects( eSleep, eDur);
	
     // * Moved the linking for the ZZZZs into the later code
     // * so that they won't appear if creature immune

    int bContinueLoop;
    int nMetaMagic = GetMetaMagicFeat();
    int nCurrentHD;
    int bAlreadyAffected;
    int nLow;
    int nDuration = PS_GetCasterLevel(oCaster);
    nDuration = 3 + GetScaledDuration(nDuration, oTarget);

    string sSpellLocal = "BIOWARE_SPELL_LOCAL_SLEEP_" + ObjectToString(OBJECT_SELF);
	
    //nDuration += 2;
    //Get the first target in the spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(OBJECT_SELF));
    //If no valid targets exists ignore the loop
    if (GetIsObjectValid(oTarget))
    {
        bContinueLoop = TRUE;
    }
    // The above checks to see if there is at least one valid target.
    while ((nHD > 0) && (bContinueLoop))
    {
        nLow = nMax;
        bContinueLoop = FALSE;
        //Get the first creature in the spell area
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(OBJECT_SELF));
        while (GetIsObjectValid(oTarget))
        {
            //Make faction check to ignore allies
        	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)
                && GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT && GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
        	{
                //Get the local variable off the target and determined if the spell has already checked them.
                bAlreadyAffected = GetLocalInt(oTarget, sSpellLocal);
                if (!bAlreadyAffected)
                {
                     //Get the current HD of the target creature
                     nCurrentHD = GetHitDice(oTarget);
                     //Check to see if the HD are lower than the current Lowest HD stored and that the
                     //HD of the monster are lower than the number of HD left to use up.
                     if(nCurrentHD < nLow && nCurrentHD <= nHD && nCurrentHD < nMax)
                     {
                         nLow = nCurrentHD;
                         oLowest = oTarget;
                         bContinueLoop = TRUE;
                     }
                }
            }
            //Get the next target in the shape
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetSpellTargetLocation());
        }
        //Check to see if oLowest returned a valid object
        if(oLowest != OBJECT_INVALID)
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oLowest, EventSpellCastAt(oCaster, nID)); //FIX: signal goes to oLowest, not oTarget, which is invalid
            //Make SR check
            if (!OnHitResistSpell(oCaster, oLowest))
            {
                //Make Fort save
                if(!MySavingThrow(SAVING_THROW_WILL, oLowest, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oLowest);
                    if (GetIsImmune(oLowest, IMMUNITY_TYPE_SLEEP) == FALSE)
                    {
                        //effect eLink2 = EffectLinkEffects(eLink, eVis);
                        //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oLowest, RoundsToSeconds(nDuration));
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oLowest, RoundsToSeconds(nDuration));
                    }
                    else
                    // * even though I am immune apply just the sleep effect for the immunity message
                    {
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSleep, oLowest, RoundsToSeconds(nDuration));
                    }

                }
            }
        }
        //Set a local int to make sure the creature is not used twice in the pass.  Destroy that variable in
        //.3 seconds to remove it from the creature
        SetLocalInt(oLowest, sSpellLocal, TRUE);
        DelayCommand(0.5, SetLocalInt(oLowest, sSpellLocal, FALSE));
        DelayCommand(0.5, DeleteLocalInt(oLowest, sSpellLocal));
        //Remove the HD of the creature from the total
        nHD = nHD - GetHitDice(oLowest);
        oLowest = OBJECT_INVALID;
    }
}