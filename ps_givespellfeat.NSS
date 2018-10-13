#include "aaa_constants"
#include "ps_inc_casterlevel"

int bBardCasting; 			// Boolean, bard casting.
int bWizCasting; 			// Boolean, wizard casting.
int bClerDruCasting; 		// Boolean, cleric and druid casting.
int bSorcFavSpiritCasting; 	// Boolean, sorcerer, favored soul and spirit shaman casting.
int bPalRangCasting; 		// Boolean, paladin and ranger casting.
int bWlkCasting; 			// Boolean, warlock invocations.

void PS_GiveSpellFeat(object oPC);

// Helper function that defines caster type.
void BaseClassCasterType(int classID)
{
	if (classID == CLASS_TYPE_INVALID)
		return;
	else if (classID == CLASS_TYPE_BARD)
		bBardCasting = TRUE;
	if (classID == CLASS_TYPE_WIZARD )
		bWizCasting = TRUE;
	else if (classID == (CLASS_TYPE_CLERIC || CLASS_TYPE_DRUID))
		bClerDruCasting = TRUE;
	else if (classID == (CLASS_TYPE_SORCERER || CLASS_TYPE_SPIRIT_SHAMAN || CLASS_TYPE_FAVORED_SOUL))
		bSorcFavSpiritCasting = TRUE;
	else if (classID == (CLASS_TYPE_PALADIN || CLASS_TYPE_RANGER))
		bPalRangCasting = TRUE;	
	else if (classID == CLASS_TYPE_WARLOCK)
		bWlkCasting = TRUE;
	
	return;
}

// Gives SpellLevel dummy feats.
void PS_GiveSpellFeat(object oPC)
{
	int nCasterLevel = GetRealCasterLevel(oPC);
	int nMaxClassSlot = 4;
	int pcClassSlot;
	int pcClass1;
	int pcClass2;
	int pcClass3;
	int pcClass4;	
	int bIsCaster;
	
	// Iterate through classes, and set caster type.
	for(pcClassSlot = 1; pcClassSlot < nMaxClassSlot; pcClassSlot++)
	{
		if (pcClassSlot == 1)
		{
			pcClass1 = GetClassByPosition(pcClassSlot, oPC);
			if (pcClass1 == CLASS_TYPE_INVALID)
				bIsCaster = StringToInt(Get2DAString("classes", "SpellCaster", pcClass1));
			if (bIsCaster)
				BaseClassCasterType(pcClass1);
		}
		else if (pcClassSlot == 2)
		{
			pcClass2 = GetClassByPosition(pcClassSlot, oPC);
			if (pcClass2 == CLASS_TYPE_INVALID)
				bIsCaster = StringToInt(Get2DAString("classes", "SpellCaster", pcClass2));
			if (bIsCaster)
				BaseClassCasterType(pcClass2);
		}
		else if (pcClassSlot == 3)
		{
			pcClass3 = GetClassByPosition(pcClassSlot, oPC);
			if (pcClass3 == CLASS_TYPE_INVALID)
				bIsCaster = StringToInt(Get2DAString("classes", "SpellCaster", pcClass3));
			if (bIsCaster)
				BaseClassCasterType(pcClass3);
		}
		else if (pcClassSlot == 4)
		{
			pcClass4 = GetClassByPosition(pcClassSlot, oPC);
			if (pcClass4 == CLASS_TYPE_INVALID)
				bIsCaster = StringToInt(Get2DAString("classes", "SpellCaster", pcClass4));
			if (bIsCaster)
				BaseClassCasterType(pcClass4);
		}
	}

	// Add feats for 4th level spells.
	if (bWizCasting
			&& nCasterLevel >= 7
			&& !GetHasFeat(FEAT_SPELL_WIZARD_IV, oPC))
		FeatAdd(oPC, FEAT_SPELL_WIZARD_IV, FALSE, TRUE, FALSE);
	else if (bClerDruCasting		
			&& nCasterLevel >= 8
			&& !GetHasFeat(FEAT_SPELL_CLERDRU_IV, oPC))
		FeatAdd(oPC, FEAT_SPELL_CLERDRU_IV, FALSE, TRUE, FALSE);
	else if (bSorcFavSpiritCasting
			&& nCasterLevel >= 8
			&& !GetHasFeat(FEAT_SPELL_SORCFAVSHAMAN_IV, oPC))
		FeatAdd(oPC, FEAT_SPELL_SORCFAVSHAMAN_IV, FALSE, TRUE, FALSE);
	else if (bBardCasting
			&& nCasterLevel >= 10
			&& !GetHasFeat(FEAT_SPELL_BARD_IV, oPC))
		FeatAdd(oPC, FEAT_SPELL_BARD_IV, FALSE, TRUE, FALSE);
	else if (bPalRangCasting
			&& nCasterLevel >= 13
			&& !GetHasFeat(FEAT_SPELL_PALRANG_IV, oPC))
		FeatAdd(oPC, FEAT_SPELL_PALRANG_IV, FALSE, TRUE, FALSE);
	
	// Add feats for 3rd level spells.
	if (bWizCasting
			&& nCasterLevel >= 5
			&& !GetHasFeat(FEAT_SPELL_WIZARD_III, oPC))
		FeatAdd(oPC, FEAT_SPELL_WIZARD_III, FALSE, TRUE, FALSE);
	else if (bClerDruCasting
			&& nCasterLevel >= 5
			&& !GetHasFeat(FEAT_SPELL_CLERDRU_III, oPC))
		FeatAdd(oPC, FEAT_SPELL_CLERDRU_III, FALSE, TRUE, FALSE);
	else if (bSorcFavSpiritCasting
			&& nCasterLevel >= 6
			&& !GetHasFeat(FEAT_SPELL_SORCFAVSHAMAN_III, oPC))
		FeatAdd(oPC, FEAT_SPELL_SORCFAVSHAMAN_III, FALSE, TRUE, FALSE);
	else if (bBardCasting
			&& nCasterLevel >= 7
			&& !GetHasFeat(FEAT_SPELL_BARD_III, oPC))
		FeatAdd(oPC, FEAT_SPELL_BARD_III, FALSE, TRUE, FALSE);
	else if (bPalRangCasting
			&& nCasterLevel >= 9
			&& !GetHasFeat(FEAT_SPELL_PALRANG_III, oPC))
		FeatAdd(oPC, FEAT_SPELL_PALRANG_III, FALSE, TRUE, FALSE);
		
	// Add feats for 2nd level spells.
	if (bWizCasting
			&& nCasterLevel >= 3
			&& !GetHasFeat(FEAT_SPELL_WIZARD_II, oPC))
		FeatAdd(oPC, FEAT_SPELL_WIZARD_II, FALSE, TRUE, FALSE);
	else if (bClerDruCasting
			&& nCasterLevel >= 3
			&& !GetHasFeat(FEAT_SPELL_CLERDRU_II, oPC))
		FeatAdd(oPC, FEAT_SPELL_CLERDRU_II, FALSE, TRUE, FALSE);
	else if (bSorcFavSpiritCasting
			&& nCasterLevel >= 4
			&& !GetHasFeat(FEAT_SPELL_SORCFAVSHAMAN_II, oPC))
		FeatAdd(oPC, FEAT_SPELL_SORCFAVSHAMAN_II, FALSE, TRUE, FALSE);
	else if (bBardCasting
			&& nCasterLevel >= 4
			&& !GetHasFeat(FEAT_SPELL_BARD_II, oPC))
		FeatAdd(oPC, FEAT_SPELL_BARD_II, FALSE, TRUE, FALSE);
	else if (bPalRangCasting
			&& nCasterLevel >= 5
			&& !GetHasFeat(FEAT_SPELL_PALRANG_II, oPC))
		FeatAdd(oPC, FEAT_SPELL_PALRANG_II, FALSE, TRUE, FALSE);
		
	// Add feats for 1st level spells.
	if (nCasterLevel >= 1)
	{
		if (bWizCasting
				&& !GetHasFeat(FEAT_SPELL_WIZARD_I, oPC))
			FeatAdd(oPC, FEAT_SPELL_WIZARD_I, FALSE, TRUE, FALSE);
		else if (bClerDruCasting
				&& !GetHasFeat(FEAT_SPELL_CLERDRU_I, oPC))
			FeatAdd(oPC, FEAT_SPELL_CLERDRU_I, FALSE, TRUE, FALSE);
		else if (bSorcFavSpiritCasting
				&& !GetHasFeat(FEAT_SPELL_SORCFAVSHAMAN_I, oPC))
			FeatAdd(oPC, FEAT_SPELL_SORCFAVSHAMAN_I, FALSE, TRUE, FALSE);		
		else if (bPalRangCasting
				&& !GetHasFeat(FEAT_SPELL_PALRANG_I, oPC))
			FeatAdd(oPC, FEAT_SPELL_PALRANG_I, FALSE, TRUE, FALSE);
		else if (bBardCasting
				&& nCasterLevel >= 2
				&& !GetHasFeat(FEAT_SPELL_BARD_I, oPC))
			FeatAdd(oPC, FEAT_SPELL_BARD_I, FALSE, TRUE, FALSE);
	}
	
	// Add feats for warlock invocations.
	if (bWlkCasting 
		&& GetLevelByClass(CLASS_TYPE_WARLOCK, oPC) >= 6)
		FeatAdd(oPC, FEAT_INVOCATIONS_WARLOCK_II, FALSE, TRUE, FALSE);
	if (bWlkCasting 
		&& GetLevelByClass(CLASS_TYPE_WARLOCK, oPC) >= 3)
		FeatAdd(oPC, FEAT_INVOCATIONS_WARLOCK_I, FALSE, TRUE, FALSE);
	
	return;
}