#include "nw_i0_spells"

const int SR_FIX = -4000;

int GetSRValueBy2DAValue(int nVALUE)
{
	int nSR = 10;
	switch (nVALUE)
	{
		case 0: nSR = 10; break;
		case 1: nSR = 12; break;
		case 2: nSR = 14; break;
		case 3: nSR = 16; break;
		case 4: nSR = 18; break;
		case 5: nSR = 20; break;
		case 6: nSR = 22; break;
		case 7: nSR = 24; break;
		case 8: nSR = 26; break;
		case 9: nSR = 28; break;
		case 10: nSR = 30; break;
		case 11: nSR = 32; break;
		case 12: nSR = 34; break;
		case 13: nSR = 36; break;
		case 14: nSR = 38; break;
		case 15: nSR = 40; break;
		case 16: nSR = 19; break;
	}
	return nSR;
}

void DelayedSRFixApplication(object oPC, int nSR)
{
	effect eSR = EffectSpellResistanceIncrease(nSR);
	eSR = SupernaturalEffect(eSR);
	eSR = SetEffectSpellId(eSR, SR_FIX);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSR, oPC);
}

void ApplySRFix(object oPC)
{
	RemoveEffectsFromSpell(oPC, SR_FIX);	
	int nSRMax;
	int nSRCurrent;
	int nTABLE;
	int nVALUE;
	object oHIDE = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
	if(oHIDE != OBJECT_INVALID)
	{
		itemproperty iPROP = GetFirstItemProperty(oHIDE);
		while (GetIsItemPropertyValid(iPROP))
		{
			nTABLE = GetItemPropertyCostTable(iPROP);
			if (nTABLE == 11) //iprp_srcost
			{
				nVALUE = GetItemPropertyCostTableValue(iPROP);
				nSRCurrent = GetSRValueBy2DAValue(nVALUE);
				if (nSRMax < nSRCurrent) nSRMax = nSRCurrent;
			}
			iPROP = GetNextItemProperty(oHIDE);
		}
	}
	if (nSRMax > 0) DelayCommand(0.0f, DelayedSRFixApplication(oPC, nSRMax));
}