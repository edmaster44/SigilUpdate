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

void AddPolymorphBoni(object oCaster, string sVFX = "");

void main() {

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
	if ( GetHasSpellEffect(843, oCaster) ) {
		effect eEffect = GetFirstEffect( oCaster );
		while ( GetIsEffectValid(eEffect) ) {
		
			if ( GetEffectSpellId(eEffect) == 843){
				RemoveEffect( oCaster, eEffect );
			}
				
			eEffect = GetNextEffect( oCaster );
		}
	}
	
	int nGender = GetGender(oCaster);
	
	effect eVFX = EffectNWN2SpecialEffectFile("fx_spirit_gorge_hit");
	if (nSpell == 1721) { //Demon
	
		AddPolymorphBoni(oCaster, "fx_f_beetle_eyes");
		struct CreatureCoreAppearance Appearance = GetPolymorphAppearance("ps_polymorph_warlockdemon", oCaster);
		
		Appearance.Gender = nGender;
		if (nGender == GENDER_FEMALE){
			Appearance.HairVariation = 100; //Different hair
			Appearance.HeadVariation = 11;
			Appearance.WingVariation = 42; //bat wings!
			Appearance.TailVariation = 9; //Tail switch
		}
		
		AssumeGivenAppearance(oCaster, Appearance);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oCaster);
		PS_HumForm_DragonUE(oCaster);
	
	} else if (nSpell == 1722) { //Devil
	
		AddPolymorphBoni(oCaster, "fx_f_beetle_eyes");
		struct CreatureCoreAppearance Appearance = GetPolymorphAppearance("ps_polymorph_warlockdevil", oCaster);
		Appearance.Gender = nGender;
		if (nGender == GENDER_FEMALE){
			Appearance.HairVariation = 157; //Different hair
			Appearance.HeadVariation = 24; //Different head
			Appearance.WingVariation = 66; //raven wings!
		}
		
		AssumeGivenAppearance(oCaster, Appearance);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oCaster);
		PS_HumForm_DragonUE(oCaster);
	
	}  else if (nSpell == 1723) { //Abomination
	
		AddPolymorphBoni(oCaster);
		struct CreatureCoreAppearance Appearance = GetPolymorphAppearance("ps_polymorph_warlockeldritch", oCaster);
		
		AssumeGivenAppearance(oCaster, Appearance);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oCaster);
		PS_HumForm_DragonUE(oCaster);
	
	}  else if (nSpell == 1724) { //Fey
	
		AddPolymorphBoni(oCaster);
		struct CreatureCoreAppearance Appearance = GetPolymorphAppearance("ps_polymorph_warlockbear", oCaster);
		
		AssumeGivenAppearance(oCaster, Appearance);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oCaster);
		PS_HumForm_DragonUE(oCaster);
		
	}  else if (nSpell == 1725) { //Unshift
		
		PS_RestoreOriginalAppearance(oCaster);
		
		//General useful things for shifting back
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oCaster);
		PS_DragForm_DragonUE(oCaster);
	
	} 
	
}

void AddPolymorphBoni(object oCaster, string sVFX = "") {
	effect eBoost = EffectAbilityIncrease(ABILITY_STRENGTH, 8);
	eBoost = EffectLinkEffects(eBoost, EffectAbilityIncrease(ABILITY_DEXTERITY, 8));
	eBoost = EffectLinkEffects(eBoost, EffectAbilityIncrease(ABILITY_CONSTITUTION, 8));
	eBoost = EffectLinkEffects(eBoost, EffectRegenerate(5, 6.0f));
		
	int nSR = GetSpellResistance(oCaster);
	int nBoost = 26-nSR;
	if (nBoost > 0) {
		eBoost = EffectLinkEffects(eBoost, EffectSpellResistanceIncrease(nBoost));
	}
	
	if (sVFX != "") {
		eBoost = EffectLinkEffects(eBoost, EffectNWN2SpecialEffectFile(sVFX));
	}
		
	eBoost = SetEffectSpellId(eBoost, 843);
	eBoost = SupernaturalEffect(eBoost);
		
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBoost, oCaster);
}

void AssumeGivenAppearance(object oCaster, struct CreatureCoreAppearance Appearance) {

	if (!GetIsPC(oCaster)) {
		SendMessageToPC(oCaster, "NPC support not included.");
		return;
	}

	object oEssence = GetItemPossessedBy(oCaster, "ps_essence");
	struct CreatureCoreAppearance originalApp = PS_RetrieveStoredCreatureCoreAppearance(oEssence, "OriginalApp");
	SendMessageToPC(oCaster, "Original Appearance type: "+IntToString(originalApp.AppearanceType)); //checking what we even have saved here
	
	Appearance.Tint_Mask = PS_CCA_TINT_ALL;
	Appearance.HeadTint_Mask = PS_CCA_TINT_ALL;
	Appearance.HairTint_Mask = PS_CCA_TINT_ALL;
	
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
	//SendMessageToPC(oPC, "Creature: "+GetName(oCreature));
	
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oCreature);
	//SendMessageToPC(oPC, "New head: "+IntToString(app.HeadVariation));
	
	DestroyObject(oCreature, 1.0f);
	return app;
}