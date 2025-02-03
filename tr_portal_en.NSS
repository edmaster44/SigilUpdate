#include "ps_inc_achievements"

void main()
{
	//SendMessageToPC(GetFirstPC(),"enter");
	
	string sKeyTag;
	string sWPTag;
	string sFXTag;
	string sPortalTag;
	
	int iPrevCounter;
	int iSpawnCounter;
	
	sKeyTag = GetLocalString(OBJECT_SELF, "KeyTag");
	sWPTag = GetLocalString(OBJECT_SELF, "WPTag");
	iPrevCounter = GetLocalInt(OBJECT_SELF, "Counter");
	
	sFXTag = GetLocalString(OBJECT_SELF, "FXTag");
	sPortalTag = GetLocalString(OBJECT_SELF, "PortalTag");
	
	//Determine how many pcs with key are in the trigger at the present time
	iSpawnCounter=0;
	object oCreature=GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oCreature)) {
	
		if (GetIsPC(oCreature) && !GetIsPossessedFamiliar(oCreature)) {
		
			if(GetHasFeat(2380, oCreature, FALSE) == TRUE) {
			
				AddAchievement(oCreature, 7);
				iSpawnCounter = iSpawnCounter + 1;
				
			} else if(GetHasFeat(3216, oCreature, FALSE) == TRUE) {
			
				if(sPortalTag == "ps_plac_port_fire01" || 
				sPortalTag == "ps_plac_port_earth01" || 
				sPortalTag == "ps_plac_port_planeofair01" || 
				sPortalTag == "ps_plac_port_planeofair02" || 
				sPortalTag == "ps_plac_port_earth02" || 
				sPortalTag == "ps_plac_port_fire02" ||
				sPortalTag == "ps_plac_port_ice01" ||
				sPortalTag == "ps_plac_port_ice02")
				{
					AddAchievement(oCreature, 7);
					iSpawnCounter = iSpawnCounter + 1;
				}
				
			} else if(GetItemPossessedBy(oCreature, sKeyTag) != OBJECT_INVALID) {
			
				AddAchievement(oCreature, 7);
				iSpawnCounter = iSpawnCounter + 1;
				
			}
		
		}
		
		oCreature = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
		
	}
	if (iSpawnCounter > 0 && iPrevCounter==0)
	{
		//portal needs to spawn and counter to be updated
		location lPortal = GetLocation(GetObjectByTag(sWPTag));
		CreateObject(OBJECT_TYPE_PLACED_EFFECT, sFXTag, lPortal);
		CreateObject(OBJECT_TYPE_PLACEABLE, sPortalTag, lPortal);
		SetLocalInt(OBJECT_SELF, "Counter", iSpawnCounter);
	}
	else if (iSpawnCounter==0 && iPrevCounter>0)
	{
		//for some reason the counter didn't get updated in time. Despawn the portal and update the counter
		object oPortal = GetObjectByTag(sPortalTag);
		SetPlotFlag(oPortal, FALSE);
		
		int iLoop=1;
		object oPortalEffect=GetNearestObjectByTag(sFXTag, GetObjectByTag(sWPTag), iLoop);
		while (oPortalEffect!=OBJECT_INVALID)
		{
			if (GetArea(oPortalEffect) == GetArea(GetObjectByTag(sFXTag)))
			{
				DelayCommand(20.0f, AssignCommand(OBJECT_SELF, DestroyObject(oPortalEffect,10.0f)));
			}
			iLoop = iLoop + 1;
			oPortalEffect=GetNearestObjectByTag(sFXTag, GetObjectByTag(sWPTag), iLoop);
		}
		DestroyObject(oPortal,30.0f);
		SetLocalInt(OBJECT_SELF, "Counter", 0);
	}
}