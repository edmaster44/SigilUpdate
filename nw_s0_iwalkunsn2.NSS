// Draco Rayne: Changed Walk Unseen script for use with Warlock Buddy
#include "nwn2_inc_spells"
#include "nw_i0_spells"
#include "x2_inc_spellhook" 

void OnDispellCallback( object oCaster, int nSaveDC, float fDuration )
{
	//SpawnScriptDebugger();

	if ( !GetIsObjectValid( oCaster ) )
		return;
 
	location lTarget = GetLocation( oCaster );

	// Do a quick explosion effect
	effect eExplode = EffectVisualEffect( VFX_INVOCATION_ELDRITCH_AOE );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);


	int nDamageType  	= DAMAGE_TYPE_SONIC;
	int nDamagePower 	= DAMAGE_POWER_NORMAL;
	int nSaveType		= SAVING_THROW_TYPE_NONE;
	float fDistToDelay 	= 0.25f; 

	
	int nDamageAmt;
	float fDelay;
	effect eDmg;
	effect eStun;
	effect eDur;
	effect eDur2;


    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE );
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster) && oTarget != oCaster)
    	{
			nDamageAmt = d6(4);
			nDamageAmt	= ApplyMetamagicVariableMods( nDamageAmt, 4 * 6 );

			int nSaveResult = FortitudeSave( oTarget, nSaveDC, nSaveType, oCaster );
            if ( nSaveResult == SAVING_THROW_CHECK_FAILED ) // saving throw failed
            {
				eDmg = EffectDamage( nDamageAmt, nDamageType, nDamagePower );  // create the effects
				eStun = EffectStunned();
                eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
				eDur2 = EffectVisualEffect( VFX_DUR_STUN );
                effect eLink = EffectLinkEffects(eStun, eDur);
				eLink = EffectLinkEffects(eLink, eDur2);

                // Apply effects to the currently selected target.
				fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget)) * fDistToDelay ;
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget));
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
            }
			else if ( nSaveResult == SAVING_THROW_CHECK_SUCCEEDED )	// Saving throw successful
			{
				nDamageAmt = nDamageAmt / 2; // halve the damage

				eDmg = EffectDamage( nDamageAmt, nDamageType, nDamagePower ); // create the effect
			
                // Apply effects to the currently selected target.
				fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget)) * fDistToDelay ;
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget));
			}
            
		}

		//Select the next target within the spell shape.
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE );
	}

}


void RetribInvis(object oPC)
{
	//Added actual invisibility effect - cryptc
	RemoveEffectsFromSpell(oPC, SPELL_I_RETRIBUTIVE_INVISIBILITY);

	int nSaveDC = 18 + GetAbilityModifier(ABILITY_CHARISMA);
    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_IMPROVED);
    effect eDur     = EffectVisualEffect( VFX_DUR_INVISIBILITY );
    effect eCover = EffectConcealment(50);
    effect eOnDispell = EffectOnDispel( 0.5f, OnDispellCallback( oPC, nSaveDC, RoundsToSeconds(1) ) );
    effect eInvisLink = EffectLinkEffects(eInvis, eOnDispell);
	effect eLink = EffectLinkEffects(eCover, eInvisLink);
	effect eLink2 = EffectLinkEffects(eLink, eDur);
	eLink2 = SetEffectSpellId(eLink2, SPELL_I_RETRIBUTIVE_INVISIBILITY);

    SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_GREATER_INVISIBILITY, FALSE));

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oPC, RoundsToSeconds(3));
}


void WalkUnseen(object oTarget)
{
	//Declare major variables
//	object oTarget = OBJECT_SELF;
    effect eInvis   = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
    effect eDur     = EffectVisualEffect( VFX_DUR_INVISIBILITY );
    effect eLink = EffectLinkEffects(eInvis, eDur);
	eLink = SetEffectSpellId(eLink, SPELL_I_WALK_UNSEEN);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_INVISIBILITY, FALSE));

    float fDuration = HoursToSeconds(24); // Hours

    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    RemoveEffectsFromSpell(oTarget, SPELL_I_WALK_UNSEEN);

	//Apply the VFX impact and effects
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
}

void StayUnseen(object oPC)
{
	if (GetLocalInt(oPC,"Invisibility")==FALSE) return;
	
	if (GetHasSpell(SPELL_I_WALK_UNSEEN,oPC))    
		if (!GetHasSpellEffect(SPELL_I_WALK_UNSEEN,oPC))	
			if (!GetIsInCombat(oPC)) 
				WalkUnseen(oPC);
			
	if (GetHasSpell(SPELL_I_RETRIBUTIVE_INVISIBILITY,oPC)) 
		if (!GetIsInCombat(oPC)) 
			RetribInvis(oPC);	
				
	DelayCommand(6.0, StayUnseen(oPC));
}

void main()
{
	object oPC = OBJECT_SELF;

	StayUnseen(oPC);
}