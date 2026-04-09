//:://////////////////////////////////////////////
#include "x2_inc_switches"
#include "x2_inc_intweapon" // contains a helper function: RemoveSpellEffects

//------------------------------------------------
const int SR_FIX = -4000;

//------------------------------------------------
void DelayedSRFixApplication(object oPC, effect eEffect)
{
if (GetHasSpellEffect(SR_FIX,oPC))
{
 RemoveSpellEffects(SR_FIX, oPC, oPC);
}
ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oPC);
}

//------------------------------------------------
int GetSRValueBy2DAValue(int nItemPropertyCostTableValueIndex)
{
int nSR = 10;

switch (nItemPropertyCostTableValueIndex)
{
 case 0: nSR = 10;
  break;
 case 1: nSR = 12;
  break;
 case 2: nSR = 14;
  break;
 case 3: nSR = 16;
  break;
 case 4: nSR = 18;
  break;
 case 5: nSR = 20;
  break;
 case 6: nSR = 22;
  break;
 case 7: nSR = 24;
  break;
 case 8: nSR = 26;
  break;
 case 9: nSR = 28;
  break;
 case 10: nSR = 30;
  break;
 case 11: nSR = 32;
  break;
 case 12: nSR = 34;
  break;
 case 13: nSR = 36;
  break;
 case 14: nSR = 38;
  break;
 case 15: nSR = 40;
  break;
 case 16: nSR = 19;
  break;                                      
 default: nSR = 10;
  break;        
}

return nSR;
}


void ApplySRFix(object oPC)
{
	if (GetHasSpellEffect(SR_FIX,oPC))
	{
 		RemoveSpellEffects(SR_FIX, oPC, oPC);
	}

   	object oItem;
   	int nSRMax=0;
   	int nSRCurrent=0;

   	int nCostTableResRef;
   	int nValue;

	int nSlotNum;
   	for(nSlotNum = 0; nSlotNum < NUM_INVENTORY_SLOTS; nSlotNum++)
   	{
       oItem = GetItemInSlot(nSlotNum, oPC);
       if(GetIsObjectValid(oItem))
       {
        itemproperty iProp = GetFirstItemProperty(oItem);
        while (GetIsItemPropertyValid(iProp))
        {
            nCostTableResRef = GetItemPropertyCostTable(iProp);
            if (nCostTableResRef == 11) //iprp_srcost
            {
    			nValue = GetItemPropertyCostTableValue(iProp);
                //string nSRValue = Get2DAString("iprp_srcost", "Value", nValue);
                //nSRCurrent = StringToInt(nSRValue);
			    nSRCurrent = GetSRValueBy2DAValue(nValue);
            	if (nSRMax < nSRCurrent)
             	{
                	nSRMax = nSRCurrent;
             	}    
            }
            iProp = GetNextItemProperty(oItem);
		}
	}
   }

	if (nSRMax > 0)
	{
		effect eSR = EffectSpellResistanceIncrease(nSRMax);
		eSR = SetEffectSpellId(eSR, SR_FIX);
		eSR = SupernaturalEffect(eSR);
		DelayCommand(0.3f, DelayedSRFixApplication(oPC, eSR));
	}
}