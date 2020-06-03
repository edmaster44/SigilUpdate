#include "x0_i0_position"
#include "aaa_constants"
#include "ps_inc_advscript"
#include "x0_i0_match"
#include "x0_i0_petrify"
#include "x2_inc_itemprop"

void PS_CalculateECL(object oPC);
int PS_CalculateRacialECL(object oPC);
int PS_CalculateOriginalECL(object oPC, object oEssence);
int PS_CalculateTemplateECL(object oPC);
void PS_EnforceMaxLevel(object oPC);

// Calculates the character's complete ECL including racial and class-given, and writes it to the essence
void PS_CalculateECL(object oPC)
{
	object oEssence		= GetItemPossessedBy(oPC, "ps_essence");
	int nRacialECL		= PS_CalculateRacialECL(oPC);				// Current Racial LA
	int nOriginalECL	= PS_CalculateOriginalECL(oPC, oEssence);	// Original Racial LA
	int nTemplateECL	= PS_CalculateTemplateECL(oPC);				// Template LA
	string sManualECL	= GetLocalString(oEssence, "ECL_Manual");
	int nManualECL		= StringToInt(sManualECL);
	int nECL			= 0;
	
	// Debug messages
	SendMessageToPC(oPC, "Racial adjustment: LA +" + IntToString(nRacialECL));
	SendMessageToPC(oPC, "Original racial adjustment: LA +" + IntToString(nOriginalECL));
	SendMessageToPC(oPC, "Total template class adjustment: LA +" + IntToString(nTemplateECL));
	
	if (nOriginalECL == nRacialECL)
	{	nECL = nECL + nRacialECL + nTemplateECL;
		SendMessageToPC(oPC, "Level adjusmtent calculated using current racial type: +" + IntToString(nECL));	}
	else
	{	nECL = nECL + nOriginalECL + nTemplateECL;
		SendMessageToPC(oPC, "Level adjusmtent calculated using original racial type: +" + IntToString(nECL));	}

	string sECL = IntToString(nECL);
			
	if (nManualECL > 0)
	{	SetLocalString(oEssence, "ECL", sManualECL);
		SetLocalString(oPC, "ECL", sManualECL);
		SendMessageToPC(oPC, "Level adjustment of +" + sManualECL + " stored on Essence; this was manually edited.");
	}
	else
	{	SetLocalString(oEssence, "ECL", sECL);
		SetLocalString(oPC, "ECL", sECL);
		SendMessageToPC(oPC, "Level adjustment of +" + sECL + " stored on Essence");
	}
}

// Helper function to pull the ECL adjustment from racialsubtype.2da
int PS_CalculateRacialECL(object oPC)
{
	int nSubrace		= GetSubRace(oPC);
	string s2da			= "racialsubtypes";
	string sColumn		= "LA";
	
	string sAdjustment	= Get2DAString(s2da, sColumn, nSubrace);
	int nAdjustment		= StringToInt(sAdjustment);
	
	return nAdjustment;	
}

// Helper function to pull the ECL adjustment from the character's original racial type if race
// is changed via polymorph, wildshape, or through taking a template class.
int PS_CalculateOriginalECL(object oPC, object oEssence)
{
	int nOldSub			= GetLocalInt(oEssence, "OldSubrace");
	string s2da			= "racialsubtypes";
	string sColumn		= "LA";
	
	string sAdjustment	= Get2DAString(s2da, sColumn, nOldSub);
	int nAdjustment		= StringToInt(sAdjustment);

	if (GetLocalInt(oEssence, "SPECIAL_ECL") == 1)
 	{	string sECL 	= GetLocalString(oEssence, "ECL"); //For old Special Characters
 		//SendMessageToPC(oPC, "This is an old special character.");
		nAdjustment = StringToInt(sECL);	}
			
	return nAdjustment;
}

// Helper function to calculate ECL adjustments due to template classes
int PS_CalculateTemplateECL(object oPC)
{
	int nValue		= 0;
	
	if (GetLevelByClass(CLASS_TYPE_LICH_D_PRC, oPC) >= 1)				// Divine Lich
	{	SendMessageToPC(oPC, "Lich (divine) template class: LA +3");
		nValue = nValue +2;		}
	if (GetLevelByClass(CLASS_TYPE_LICH_PRC, oPC) >= 1)					// Arcane Lich
	{	SendMessageToPC(oPC, "Lich (arcane) template class: LA +3");
		nValue = nValue +2;		}
	if (GetLevelByClass(CLASS_TYPE_LICH_W_PRC, oPC) >= 1)				// Warlock Lich
	{	SendMessageToPC(oPC, "Lich (warlock) template class: LA +3");
		nValue = nValue +2;		}
	if (GetLevelByClass(CLASS_TYPE_DEATH_KNIGHT_PRC, oPC) >= 1)			// Death Knight
	{	SendMessageToPC(oPC, "Death Knight template class: LA +3");
		nValue = nValue +3;		}
	if (GetLevelByClass(CLASS_TYPE_VAMPIRE_LUP_PRC, oPC) >= 1)			// Vampire Lupus
	{	SendMessageToPC(oPC, "Vampire (Lupus) template class: LA +3");
		nValue = nValue +3;		}
	if (GetLevelByClass(CLASS_TYPE_VAMPIRE_DRA_PRC, oPC) >= 1)			// Vampire Draco
	{	SendMessageToPC(oPC, "Vampire (Draco) template class: LA +3");
		nValue = nValue +3; 	}
	if (GetLevelByClass(CLASS_TYPE_VAMPIRE_MAL_PRC, oPC) >= 1)			// Vampire Maleficus
	{	SendMessageToPC(oPC, "Vampire (Maleficus) template class: LA +3");
		nValue = nValue +3;		}
	if (GetLevelByClass(CLASS_TYPE_LYCAN_PRC, oPC) >= 1)
	{	SendMessageToPC(oPC, "Lycanthrope template class: LA +1");
		nValue = nValue +1;		}
	if (GetLevelByClass(CLASS_TYPE_HALFDRAGON_PRC, oPC) >= 1)			// Half-Dragon
	{	if (GetLevelByClass(CLASS_TYPE_HALFDRAGON_PRC, oPC) >= 5)
		{	SendMessageToPC(oPC, "Half-Dragon template class (tier 2): LA +2");
			nValue = nValue +2;		}
		else
		{	SendMessageToPC(oPC, "Half-Dragon template class (tier 1): LA +1");
			nValue = nValue +1;		}	}
	if (GetLevelByClass(CLASS_TYPE_HALFOUTSIDER_PRC, oPC) >= 1)			// Half-Outsider
	{	SendMessageToPC(oPC, "Half-Outsider template class: LA +2");
		nValue = nValue +2;		}
	
		return nValue;
}

// If a character's total levels including LA are greater than 30, remove any levels beyond this point.
void PS_EnforceMaxLevel(object oPC)
{
	object oEssence		= GetItemPossessedBy(oPC, "ps_essence");
	string sECL			= GetLocalString(oEssence, "ECL");
	int nECL			= StringToInt(sECL);
	int nLevels			= GetHitDice(oPC);
	int nTotal			= nLevels + nECL;
	
	if (nTotal > 30 )
	{	int nextlvl = 1000;
		int totalxp = 0;
		int whatlevel = GetHitDice(oPC) - 1; // decrease level by 1
		// set your level
		int i=0;
		for (i = 1; i < whatlevel; i++) 
		{	totalxp += nextlvl;
			nextlvl += 1000;	}
		SetXP(oPC, totalxp + nextlvl - 1);
		SendMessageToPC(oPC, "Your total levels including LA are over 30. Your level is being adjusted.");
	}
}