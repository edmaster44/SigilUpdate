//::///////////////////////////////////////////////
//:: Invocation: Hideous Blow
//:: NW_S0_IHideousB.nss
//:://////////////////////////////////////////////
/*
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: August 26, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001


// JLR - OEI 08/24/05 -- Metamagic changes
#include "nwn2_inc_spells"
#include "nw_i0_spells"
#include "x2_inc_spellhook"   

const float HIDEOUS_DELAY = 6.0f;
const float THIRSTING_DELAY = 3.0f;                                          

void DoHideousBlow(object oPC)
{
	if (GetLocalInt(oPC,"HideousBlow")==FALSE) return;
	
	//Declare major variables
	int nMetaMagic = GetLocalInt(oPC,"HideousMeta");
	//SendMessageToPC(oPC, "Executing hideous blow: "+IntToString(nMetaMagic));
	
	int nDurVFX = VFX_INVOCATION_HIDEOUS_BLOW;

	//Remove previous versions of this spell
	effect eEffect = GetFirstEffect( oPC );
	while ( GetIsEffectValid(eEffect) ) {
		
		//SendMessageToPC(oPC, "Shield: "+IntToString(GetEffectSpellId(eEffect)));
			
		if (GetEffectSpellId(eEffect) == 816 ||
			GetEffectSpellId(eEffect) == 2211 ||
			GetEffectSpellId(eEffect) == 2212 ||
			GetEffectSpellId(eEffect) == 2213 ||
			GetEffectSpellId(eEffect) == 2214 ||
			GetEffectSpellId(eEffect) == 2215 ||
			GetEffectSpellId(eEffect) == 2216 ||
			GetEffectSpellId(eEffect) == 2217 ||
			GetEffectSpellId(eEffect) == 2218 ||
			GetEffectSpellId(eEffect) == 2219 ||
			GetEffectSpellId(eEffect) == 2220 ||
			GetEffectSpellId(eEffect) == 2221) {
				RemoveEffect( oPC, eEffect );
			}
				
		eEffect = GetNextEffect( oPC );
	}
	
    effect eHidBlow = EffectHideousBlow( nMetaMagic );
	
	if ( nMetaMagic == METAMAGIC_INVOC_DRAINING_BLAST )         { nDurVFX = VFX_INVOCATION_DRAINING_BLOW; }
    else if ( nMetaMagic == METAMAGIC_INVOC_FRIGHTFUL_BLAST )   { nDurVFX = VFX_INVOCATION_FRIGHTFUL_BLOW; }
    else if ( nMetaMagic == METAMAGIC_INVOC_BESHADOWED_BLAST )  { nDurVFX = VFX_INVOCATION_BESHADOWED_BLOW; }
    else if ( nMetaMagic == METAMAGIC_INVOC_BRIMSTONE_BLAST )   { nDurVFX = VFX_INVOCATION_BRIMSTONE_BLOW; }
    else if ( nMetaMagic ==  METAMAGIC_INVOC_HELLRIME_BLAST )    { nDurVFX = VFX_INVOCATION_HELLRIME_BLOW; }
    else if ( nMetaMagic == METAMAGIC_INVOC_BEWITCHING_BLAST )  { nDurVFX = VFX_INVOCATION_BEWITCHING_BLOW; }
    else if ( nMetaMagic == METAMAGIC_INVOC_NOXIOUS_BLAST )     { nDurVFX = VFX_INVOCATION_NOXIOUS_BLOW; }
    else if ( nMetaMagic == METAMAGIC_INVOC_VITRIOLIC_BLAST )   { nDurVFX = VFX_INVOCATION_VITRIOLIC_BLOW; }
    else if ( nMetaMagic == METAMAGIC_INVOC_UTTERDARK_BLAST )   { nDurVFX = VFX_INVOCATION_UTTERDARK_BLOW; }
	else if ( nMetaMagic == METAMAGIC_INVOC_BINDING_BLAST )     { nDurVFX = VFX_INVOCATION_BINDING_BLOW; }
	else if ( nMetaMagic == METAMAGIC_INVOC_HINDERING_BLAST )   { nDurVFX = VFX_INVOCATION_HINDERING_BLOW; }

    effect eDur = EffectVisualEffect( nDurVFX );
    effect eLink = EffectLinkEffects(eHidBlow, eDur);
	eLink = SetEffectSpellId(eLink, SPELL_I_HIDEOUS_BLOW);
	
	RemoveEffectsFromSpell(oPC, SPELL_I_HIDEOUS_BLOW);
    //Fire cast spell at event for the specified target
    //SignalEvent(oPC, EventSpellCastAt(oPC, GetSpellId(), FALSE));

    //Apply the VFX impact and effects
	if (GetHasFeat(FEAT_FELLBLADE_THIRSTING_BLADE, oPC, TRUE)) {
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, THIRSTING_DELAY+0.1f); // Added 0.1 seconds so that the effect can be checked for later -Electrohydra
	} else {
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, HIDEOUS_DELAY+0.1f);
	}
}

void RedoHideousBlow(object oPC)
{
	if (GetLocalInt(oPC,"HideousBlow")==FALSE) return;
	if (GetLocalInt(oPC,"AllreadyRunning")==TRUE) return;
	else SetLocalInt(oPC,"AllreadyRunning",TRUE);
	
	DoHideousBlow(oPC);
	
	if (GetHasFeat(FEAT_FELLBLADE_THIRSTING_BLADE, oPC, TRUE)) {
		DelayCommand(THIRSTING_DELAY-0.1f, SetLocalInt(oPC,"AllreadyRunning",FALSE));
		DelayCommand(THIRSTING_DELAY, RedoHideousBlow(oPC));
	} else {
		DelayCommand(HIDEOUS_DELAY-0.1f, SetLocalInt(oPC,"AllreadyRunning",FALSE));
		DelayCommand(HIDEOUS_DELAY, RedoHideousBlow(oPC));
	}
}

void main()
{
	object oPC = OBJECT_SELF;
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
	if (!GetIsInCombat(oPC)) DoHideousBlow(oPC);
	else if (GetHasSpellEffect(SPELL_I_HIDEOUS_BLOW)) DoHideousBlow(oPC);
	if (GetLocalInt(oPC,"AllreadyRunning")==FALSE) RedoHideousBlow(oPC);
}