#include "hss_fishing_inc"


void main()
{
     object oItem =  GetItemActivated();
     object oPC = GetItemActivator();
     object oTarget = GetItemActivatedTarget();
     string sTag = GetTag(oItem);

	 HSS_DoFishingLineUse(oPC, oTarget);
		
}