#include "ff_safevar"

#include "NW_I0_TOOL"

void main()
{
	//SendMessageToPC(GetFirstPC(),"exit");
	
	string sKeyTag;
	string sWPTag;
	string sFXTag;
	string sPortalTag;
	
	int iPrevCounter;
	int iSpawnCounter;
	
	object oExiting = GetExitingObject();
	
	sKeyTag = PS_GetLocalString(OBJECT_SELF, "KeyTag");
	sWPTag = PS_GetLocalString(OBJECT_SELF, "WPTag");
	iPrevCounter = PS_GetLocalInt(OBJECT_SELF, "Counter");
	//if the counter is already at 0, no need to do further operations
	if (iPrevCounter > 0)
	{
		iSpawnCounter = iPrevCounter;
		//Check wether the exiting pc should decrease the counter or not
		if (GetIsPC(oExiting) && !GetIsPossessedFamiliar(oExiting))
		{
			if(GetHasFeat(2380, oExiting, FALSE) == TRUE)
			{
				iSpawnCounter = iSpawnCounter - 1;
			}
			else if(GetItemPossessedBy(oExiting, sKeyTag) != OBJECT_INVALID)
			{
				iSpawnCounter = iSpawnCounter - 1;
			}
		
		}
		
		//now save the new counter state and despawn the portal if it's zero
		PS_SetLocalInt(OBJECT_SELF, "Counter", iSpawnCounter);
		if (iSpawnCounter == 0)
		{
			sFXTag = PS_GetLocalString(OBJECT_SELF, "FXTag");
			sPortalTag = PS_GetLocalString(OBJECT_SELF, "PortalTag");
			object oPortal = GetObjectByTag(sPortalTag);
			SetPlotFlag(oPortal, FALSE);
			
			int iLoop=1;
			object oPortalEffect=GetNearestObjectByTag(sFXTag, GetObjectByTag(sWPTag), iLoop);
			while (oPortalEffect!=OBJECT_INVALID)
			{
				if (GetArea(oPortalEffect) == GetArea(GetNearestObjectByTag(sFXTag)))
				{
					DelayCommand(20.0f, AssignCommand(OBJECT_SELF, DestroyObject(oPortalEffect,10.0f)));
				}
				iLoop = iLoop + 1;
				oPortalEffect=GetNearestObjectByTag(sFXTag, GetObjectByTag(sWPTag), iLoop);
			}
			DestroyObject(oPortal,30.0f);
		}
	}
}