//HSS on activate item event script

#include "hss_fishing_inc"


void main()
{
     object oItem =  GetItemActivated();
     object oPC = GetItemActivator();
     object oTarget = GetItemActivatedTarget();
     string sTag = GetTag(oItem);


     if (sTag == "HSS_FISH_ROD")
        {
        HSS_DoCast(oPC, oItem);
        }
		
	 if (sTag == "HSS_FISH_LINE_HOOK_001")
	    {
		HSS_DoFishingLineUse(oPC, oTarget);
		}	
}