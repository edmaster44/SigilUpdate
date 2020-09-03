//:://///////////////////////////////////////////////
//:: Warlock Dark Invocation: Word of Changing
//:: nw_s0_iwordchng.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 12/08/05
//::////////////////////////////////////////////////
/*
        Word of Changing    Complete Arcane, pg. 136
        Spell Level:        2
        Class: 	            Misc

        This invocation is the equivalent of the 
        shapechange spell (9th level wizard).

        [Rules Note] In the rules this invocation is 
        the equivalent of the baleful polymorph spell. 
        That spell isn't in NWN2, so shapechange is used 
        instead.
*/


#include "x2_inc_spellhook"
#include "nwn2_inc_metmag"
#include "aaa_changeself_inc"
#include "ps_inc_functions"
#include "ps_inc_advscript"

void AssumeGivenAppearance(object oCaster, struct CreatureCoreAppearance Appearance);

struct CreatureCoreAppearance GetPolymorphAppearance(string sResRef, object oPC = OBJECT_INVALID);

void main()
{


    if (!X2PreSpellCastCode())
    {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }


    //Declare major variables
    int nSpell = GetSpellId();
    object oCaster = OBJECT_SELF;
    effect eVis = EffectVisualEffect(VFX_INVOCATION_WORD_OF_CHANGING);
    effect ePoly;
    int nPoly;
    int nMetaMagic = GetMetaMagicFeat();
    //Enter Metamagic conditions
	float fDuration = TurnsToSeconds( GetCasterLevel(OBJECT_SELF ) );
    fDuration = ApplyMetamagicDurationMods( fDuration );
	
	//No polymorphing while discorporated
	if (GetHasSpellEffect(1375)) {
		SendMessageToPC(oCaster, "You may not use Word of Changing while discorporated.");
		return; 
	}
	
	//843 = Word of changing base spell
	//Remove current spell effects
	if ( GetHasSpellEffect(843) ) {
		effect eEffect = GetFirstEffect( OBJECT_SELF );
		while ( GetIsEffectValid(eEffect) ) {
		
			if ( GetEffectSpellId(eEffect) == 843){
				RemoveEffect( OBJECT_SELF, eEffect );
			}
				
			eEffect = GetNextEffect( OBJECT_SELF );
		}
	}
	
	effect eVFX = EffectNWN2SpecialEffectFile("fx_spirit_gorge_hit");
	if (nSpell == 1721) { //Fiend
	
	} else if (nSpell == 1722) { //Beast
	
	}  else if (nSpell == 1723) { //Ragewalker
	
	}  else if (nSpell == 1724) { //Fey
		struct CreatureCoreAppearance Appearance;
		
		AssumeGivenAppearance(oCaster, Appearance);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oCaster);
		PS_HumForm_DragonUE(oCaster);
		
	}  else if (nSpell == 1725) { //Unshift
		
		PS_RestoreOriginalAppearance(oCaster);
		
		//General useful things for shifting back
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oCaster);
		PS_DragForm_DragonUE(oCaster);
		DelayCommand(1.0f, AssignCommand(oCaster, ActionRest()));
	
	} 
}

void AssumeGivenAppearance(object oCaster, struct CreatureCoreAppearance Appearance) {

	if (!GetIsPC(oCaster)) {
		SendMessageToPC(oCaster, "NPC support not included.");
		return;
	}

	object oEssence = GetItemPossessedBy(oCaster, "ps_essence");
	struct CreatureCoreAppearance Appearance = PS_RetrieveStoredCreatureCoreAppearance(oEssence, "OriginalApp");
	PS_SetCreatureCoreAppearance(oCaster, Appearance);
	PS_RefreshAppearance(oCaster);
	SetLocalInt(oEssence, "TempChange", 1);
}

struct CreatureCoreAppearance GetPolymorphAppearance(string sResRef, object oPC = OBJECT_INVALID) {

 	object oWP = GetWaypointByTag("WP_APPEARANCE_SPAWNER");
	if (GetIsObjectValid(oPC)) {
		SendMessageToPC(oPC, "Found oWP = "+GetFirstName(oWP));
	} else {
		SendMessageToPC(oPC, "Failed to find WP");
	}
	
	object oCreature = CreateObject(OBJECT_TYPE_CREATURE, sResRef, GetLocation(oWP));
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oCreature);
	return app;
}