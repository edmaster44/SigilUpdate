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
#include "nwn2_inc_metmag"
#include "aaa_halfoutsider_inc"

void AssumeGivenAppearance(object oCaster, struct CreatureCoreAppearance Appearance);

struct CreatureCoreAppearance GetPolymorphAppearance(string sResRef, object oPC = OBJECT_INVALID);

void AddPolymorphBoni(object oCaster, string sVFX = "", int bVFXonly = FALSE);

void main() {

    if (!X2PreSpellCastCode())
    {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	object oCaster = OBJECT_SELF;
	object oEss = PS_GetEssence(oCaster);
	int nSpell = GetSpellId();
	PS_RemoveAllShapeChange(oCaster); // remove all fiendform, word of changing, lycan, and polymorph
	
	effect eVFX = EffectNWN2SpecialEffectFile("fx_spirit_gorge_hit");
	if (nSpell == 1725){ //unshift
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oCaster);
		return;
	}

    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_INVOCATION_WORD_OF_CHANGING);
    effect ePoly;
    int nPoly;
    int nMetaMagic = GetMetaMagicFeat();
    //Enter Metamagic conditions
	float fDuration = TurnsToSeconds( GetCasterLevel(OBJECT_SELF ) );
    fDuration = ApplyMetamagicDurationMods( fDuration );
	
	SetLocalInt(oEss, "FiendformSource", WORD_OF_CHANGE_ID);
	SetLocalInt(oEss, "TempChange", TRUE);
	
	int nGender = GetGender(oCaster);
	if (nSpell == 1721) { //Demon
		if (GetLocalInt(PS_GetEssence(oCaster), "VFX_FIENDFORM")){
			PS_RestoreOriginalAppearance(oCaster);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oCaster);
			AddPolymorphBoni(oCaster, "fx_f_beetle_eyes", TRUE);
			return;
		}
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
		//PS_HumForm_DragonUE(oCaster);
	
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
		//PS_HumForm_DragonUE(oCaster);
	
	}  else if (nSpell == 1723) { //Abomination
	
		AddPolymorphBoni(oCaster);
		struct CreatureCoreAppearance Appearance = GetPolymorphAppearance("ps_polymorph_warlockeldritch", oCaster);
		
		AssumeGivenAppearance(oCaster, Appearance);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oCaster);
		//PS_HumForm_DragonUE(oCaster);
	
	}  else if (nSpell == 1724) { //Fey
	
		struct CreatureCoreAppearance Appearance = GetPolymorphAppearance("ps_polymorph_warlockfey", oCaster);
		Appearance.Gender = nGender;
		if (nGender == GENDER_FEMALE){
			Appearance.HairVariation = 158; //Different hair
			Appearance.HeadVariation = 11; //Different head
			AddPolymorphBoni(oCaster, "fx_green_eyes_leaves");
		} else {
			AddPolymorphBoni(oCaster, "fx_green_eyes");
		}
		
		AssumeGivenAppearance(oCaster, Appearance);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oCaster);
		//PS_HumForm_DragonUE(oCaster);
		
	}
}

void AddPolymorphBoni(object oCaster, string sVFX = "", int bVFXonly = FALSE){
	effect eBoost = EffectAbilityIncrease(ABILITY_STRENGTH, 8);
	eBoost = EffectLinkEffects(eBoost, EffectAbilityIncrease(ABILITY_DEXTERITY, 8));
	eBoost = EffectLinkEffects(eBoost, EffectAbilityIncrease(ABILITY_CONSTITUTION, 8));
	eBoost = EffectLinkEffects(eBoost, EffectRegenerate(3, 6.0f));
		
	int nSR = GetSpellResistance(oCaster);
	int nBoost = 26 - nSR;
	if (nBoost > 0) {
		eBoost = EffectLinkEffects(eBoost, EffectSpellResistanceIncrease(nBoost));
	}
	
	if (sVFX != "") {
		eBoost = EffectLinkEffects(eBoost, EffectNWN2SpecialEffectFile(sVFX));
	}
	
	if (bVFXonly){
		string sVFXmessage = "Fiendish power surges through your body, but you manage to ";
		sVFXmessage += " channel the strength without changing form.";
		SendMessageToPC(oCaster, sVFXmessage);
		eBoost = EffectLinkEffects(EffectNWN2SpecialEffectFile("FX_SE_RAVENOUS"), eBoost);
		eBoost = EffectLinkEffects(EffectNWN2SpecialEffectFile("FX_A_SPIRIT_EMERGE_LOOP"), eBoost);
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