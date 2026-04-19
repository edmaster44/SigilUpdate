/*

In order to make dealing with wings and tails less of a pain, all the feats that gave wings
have been made "dummy" feats that do not do anything, and instead possessing these feats
gives you the default nwn2 feat 2120 that I've made persistent and moved all the code from
the other wings here. FlattedFifth, April 18, 2026

Here are the notes for the custom wing feats and the spell ids they used to point to

FEAT		SPELL		TYPE			ADDITIONAL NOTE
288			1391		Half Dragon
2179 		1882		HO celestial 1
2781		1882		HO fiend 1
3008 		1841		Fey Butterfly	This one is still an active feat, it was never a persistent	
3021		1882		HO mezzo
3022		1882		HO erinyes
3023		1882		HO tattered
3024 		1882		HO celestial 2
*/

#include "ps_inc_wingtail"
#include "x2_inc_spellhook"

void SetRacialWingTail(object oPC);
void PS_Ability_DarkFlight(object oPC);
void PS_HD_Dragonflight(object oPC, object oItem);
void PS_FeyWings(object oPC);

void main(){
	object oPC = OBJECT_SELF;
	object oEssence	= GetItemPossessedBy(oPC,"ps_essence");	
	if (GetLocalInt(oEssence, "TempChange")) return;

	if (GetHasFeat(288, oPC, TRUE)) PS_HD_Dragonflight(oPC, oEssence);
	else if (GetHasFeat(2179, oPC, TRUE) || GetHasFeat(3023, oPC, TRUE) ||
		GetHasFeat(3024, oPC, TRUE) || GetHasFeat(2781, oPC, TRUE) || 
		GetHasFeat(3021, oPC, TRUE) || GetHasFeat(022, oPC, TRUE))
			PS_Ability_DarkFlight(oPC);
	else if (GetHasFeat(3008, oPC, TRUE)) PS_FeyWings(oPC);
	else SetRacialWingTail(oPC);
	
	int nWing = PS_GetWingNumber(oPC);
	int nTail = PS_GetTailNumber(oPC);
	if (nWing == 0 && nTail == 0) return;
	
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
	if (nWing != app.WingVariation || nTail != app.TailVariation){
		app.WingVariation = nWing;
		app.TailVariation = nTail;
		PS_SetCreatureCoreAppearance(oPC, app);
		PS_RefreshAppearance(oPC);
	}
	
	/*
	effect eWingTail;
	int bHasEffect = FALSE;

	if (nWing != WING_TYPE_NONE){
		bHasEffect = TRUE;
		eWingTail = EffectLinkEffects(EffectMovementSpeedIncrease(10), eWingTail);
	}
	} if (nTail != 0){
		bHasEffect = TRUE;
		if (GetIsEffectValid(eWingTail))
			eWingTail = EffectLinkEffects(EffectSkillIncrease(SKILL_TUMBLE, 10), eWingTail);
		else eWingTail = EffectSkillIncrease(SKILL_TUMBLE, 10);
	}
	int nId = GetSpellId();
	if (bHasEffect)
		eWingTail = SetEffectSpellId(eWingTail, GetSpellId());
		eWingTail = SupernaturalEffect(eWingTail);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eWingTail, oPC);
	}
	*/
}

void SetRacialWingTail(object oPC){
	if (PS_GetWingNumber(oPC) == 0)
		PS_SetWingNumber(oPC, PS_GetRacialWingType(oPC));
	if (PS_GetTailNumber(oPC) == 0)
		PS_SetTailNumber(oPC, PS_GetRacialTailType(oPC));
}

void PS_FeyWings(object oPC){
	if (GetGender(oPC) == GENDER_MALE) PS_SetWingNumber(oPC, 79);
	else  PS_SetWingNumber(oPC, 78);
	PS_ApplyPCWings(oPC);
}


void PS_HD_Dragonflight(object oPC, object oItem){
	int iCheck		= GetLocalInt(oItem, "DragonFlight");
	int iTemp		= GetLocalInt(oItem, "TempChange");
	if (iTemp == 1) return;
	int iWing, iWingF, iWingM;
	int iRace		= GetLocalInt(oItem, "OldRace");
	int iSub		= GetLocalInt(oItem, "OldSubrace");
	
	if (iRace == RACIAL_TYPE_INVALID)
	{	SendMessageToPC(oPC, "Debug: Error, no racial type found."); return;	}
	
	switch (iRace)
	{
		case 0: iWingF = 44; iWingM = 43; break; // Dwarf
		case 1: iWingF = 56; iWingM = 55; break; // Elf
		case 2: iWingF = 46; iWingM = 45; break; // Gnome
		case 3: iWingF = 56; iWingM = 55; break; // Halfling
		case 4: iWingF = 56; iWingM = 55; break; // Half-elf
		case 5: iWingF = 48; iWingM = 47; break; // Half-orc
		case 6: iWingF = 56; iWingM = 55; break; // Human
		case 10: if (iSub == 61) iWingF= 56; iWingM = 55; break; //Khaasta
		case 14: iWingF = 48; iWingM = 47; break; // Orc
		case 15: iWingF = 55; iWingM = 55; break; // rept humanoid
		case 21: iWingF = 56; iWingM = 55; break; // Planetouched
		case 31: if (iSub == 47) iWingF = 56; iWingM = 55; break; //Yuan-ti Pureblood
		case 32: iWingF = 48; iWingM = 47; break; // Grey Orc
		case 33: iWingF = 56; iWingM = 55; break; // Native Outsider
		case 251: iWingF =56; iWingM = 55; break; //Dragonborn

	}
	if (GetGender(oPC) == GENDER_FEMALE) iWing = iWingF;
	else iWing = iWingM;
	PS_SetWingNumber(oPC, iWing);
	//FeatAdd(oPC, 2120, FALSE);
	PS_RestoreOriginalAppearance(oPC);
		
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
		app.WingVariation = iWing;
	PS_SetCreatureCoreAppearance(oPC, app);
	PS_RefreshAppearance(oPC);
	SetLocalInt(oItem, "DragonFlight", 1);
	DelayCommand(0.1f, PS_TintFixer(oPC));
	DelayCommand(0.2f, PS_RefreshAppearance(oPC));
	DelayCommand(0.3f, PS_SaveOriginalAppearance(oPC));
}

void PS_Ability_DarkFlight(object oPC){
	object oItem	= GetItemPossessedBy(oPC,"ps_essence");	
	//int iCheck		= GetLocalInt(oItem, "DarkFlight"); // not used in this function
	if (GetLocalInt(oItem, "TempChange") == 1)	return;
	
	int iWing;
	int iWingRace;
	{	if (GetLevelByClass(CLASS_TYPE_BRACHINA, oPC) != 0)
		{	if (GetGender(oPC) == GENDER_FEMALE)
			{	iWing = WING_TYPE_RAVEN_F;		}
			else
			{	iWing = WING_TYPE_RAVEN_M;		}	}
		else if (GetLevelByClass(CLASS_TYPE_ERINYES, oPC) != 0)
		{	if (GetGender(oPC) == GENDER_FEMALE)
			{	iWing = WING_TYPE_ERINYES_F;	}
			else
			{	iWing = WING_TYPE_ERINYES_M;	}	}
		else if (GetLevelByClass(CLASS_TYPE_SUCCUBUS_INCUBUS, oPC) != 0)
		{	if (GetGender(oPC) == GENDER_FEMALE)
			{	iWing = WING_TYPE_BAT_F;	}
			else
			{	iWing = WING_TYPE_BAT_M;	}	}
		else if (GetLevelByClass(CLASS_TYPE_TRUMPET_ARCHON_PRC, oPC) != 0)
		{	if (GetGender(oPC) == GENDER_FEMALE)
			{	iWing = WING_TYPE_HEZEBEL_F;	}
			else
			{	iWing = WING_TYPE_HEZEBEL_M;	}	}
		else if (GetLevelByClass(CLASS_TYPE_WORD_ARCHON_PRC, oPC) != 0)
		{	if (GetGender(oPC) == GENDER_FEMALE)
			{	iWing = WING_TYPE_HEZEBEL_F;	}
			else
			{	iWing = WING_TYPE_HEZEBEL_M;	}	}
		else if (GetLevelByClass(CLASS_TYPE_HALFOUTSIDER_PRC, oPC) != 0)
		{	iWingRace = PS_Get_WingRace(oPC);
			if (GetHasFeat(2537))
			{	iWing = PS_GetWing_Fiend(oPC);	}
			if (GetHasFeat(2538) || GetHasFeat(3024))
			{	iWing = PS_GetWing_Celestial(oPC);	}
		}
		
		else //You have no class!
		{	return;		}
		PS_RestoreOriginalAppearance(oPC);
		PS_SetWingNumber(oPC, iWing);
		struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
			app.WingVariation = iWing;
		PS_SetCreatureCoreAppearance(oPC, app);
		PS_RefreshAppearance(oPC);
		SetLocalInt(oItem, "DarkFlight", 1);
		DelayCommand(0.1f, PS_TintFixer(oPC));
		DelayCommand(0.2f, PS_RefreshAppearance(oPC));
		DelayCommand(0.3f, PS_SaveOriginalAppearance(oPC));	}
}
