#include "ff_safevar"

////////////////////////////////////////////////////////////////////////////////
// shinn_sava_hub
// Original Scripter:  Shinn      Design: Shinn
// Last modified : 20/06/2012 by Shinn
//------------------------------------------------------------------------------
// Sava chess minigame game hub object script
////////////////////////////////////////////////////////////////////////////////

#include "shinn_sava_inc"

void main()
{

	object oHub = OBJECT_SELF;

	object oPlayer1 = PS_GetLocalObject(oHub,"PLR_1");
	object oPlayer2 = PS_GetLocalObject(oHub,"PLR_2");
	int iReseted = PS_GetLocalInt(oHub,"Reseted");

	int i;

	if(GetIsObjectValid(oPlayer1) != TRUE && GetIsObjectValid(oPlayer2) != TRUE && iReseted == FALSE) {

		for(i=11 ; i <= 88 ; i++) {
			PS_DeleteLocalInt(oHub,"FIELD_"+IntToString(i)+"_VT");
			PS_DeleteLocalInt(oHub, "FIELD_"+IntToString(i)+"_Piece");
			PS_DeleteLocalInt(oHub, "FIELD_"+IntToString(i)+"_Owner");
		}
			
		PS_DeleteLocalObject(oHub,"PLR_1");
		PS_DeleteLocalObject(oHub,"PLR_2");
		
		SetUseableFlag(GetNearestObjectByTag("sava_ctrl_1"),TRUE);
		SetUseableFlag(GetNearestObjectByTag("sava_ctrl_2"),TRUE);	
		PS_SetLocalInt(oHub,"GAME_IN_PROGERSS", FALSE);
		
		PS_SetLocalInt(oHub,"Kill_Count_1",0);
		PS_SetLocalInt(oHub,"Kill_Count_2",0);

		PS_SetLocalInt(oHub,"Reseted", TRUE);
		
	//	ClearSpecFields(oHub);
		
	}


}