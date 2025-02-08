#include "ff_safevar"

#include "enft_cnsts"

void startEngine(object oEnterer)
{
	if(GetArea(OBJECT_SELF) == OBJECT_INVALID)
		SendMessageToPC(oEnterer, "OBJECT_INVALID");

    // Check for environmental damage
	int nEnvironType = PS_GetLocalInt(GetArea(OBJECT_SELF), "ENV_FATIGUE_AREA");
    if(nEnvironType > 0)
    {
		switch(nEnvironType) {
			case 1:  DelayCommand(freezeTime, ExecuteScript("enft_freeze_ftg", oEnterer)); break;
			case 2:  DelayCommand(heatTime, ExecuteScript("enft_heat_ftg", oEnterer)); break;
			case 3:  DelayCommand(heatTime, ExecuteScript("enft_salt_ftg", oEnterer)); break;
			case 4:  DelayCommand(magmaTime, ExecuteScript("enft_magma_ftg", oEnterer)); break;
			case 5:  DelayCommand(slagsTime, ExecuteScript("enft_slags_ftg", oEnterer)); break;
			default: break;
		}
    } else {
		SendMessageToPC(oEnterer, "You are safe now.");
	}
}