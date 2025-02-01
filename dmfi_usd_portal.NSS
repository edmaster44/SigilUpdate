#include "ff_safevar"

//DMFI - USING PORTALS by Qk


void main()
{
	object oMOD = GetModule();
	object oPC = GetLastUsedBy();
	int iDest = PS_GetLocalInt(OBJECT_SELF,"DMFI_DESTINATION");
	object oDest, oIni;
	effect eTel = EffectNWN2SpecialEffectFile("fx_teleport");
	if (iDest == 1)
		{
		  oDest = PS_GetLocalObject(oMOD,"DMFI_PORTAL_B");
		  oIni = PS_GetLocalObject(oMOD,"DMFI_PORTAL_A");
		}
	else
		{
		  oDest = PS_GetLocalObject(oMOD,"DMFI_PORTAL_A");
		  oIni = PS_GetLocalObject(oMOD,"DMFI_PORTAL_B");
		}

	if (GetIsObjectValid(oDest))
		{
		 ApplyEffectAtLocation(0,eTel,GetLocation(oPC));
		 AssignCommand(oPC,JumpToObject(oDest,0));
		 
		}
	else
	   SendMessageToPC(oPC,"Seems this portal is doing nothing");	
}