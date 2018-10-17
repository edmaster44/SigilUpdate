#include "enft_cnsts"

void startEngine(object oEnterer)
{
	if(GetArea(OBJECT_SELF) == OBJECT_INVALID)
		SendMessageToPC(oEnterer, "OBJECT_INVALID");

    // Check for environmental damage
    if(GetLocalInt(GetArea(OBJECT_SELF), "ENV_FATIGUE_AREA") != 0)
    {
        if(GetLocalInt(GetArea(OBJECT_SELF), "ENV_FATIGUE_AREA") == 1)
        {
            DelayCommand(freezeTime, ExecuteScript("enft_freeze_ftg", oEnterer));
        }
        if(GetLocalInt(GetArea(OBJECT_SELF), "ENV_FATIGUE_AREA") == 2)
        {
            DelayCommand(heatTime, ExecuteScript("enft_heat_ftg", oEnterer));
        }
		if(GetLocalInt(GetArea(OBJECT_SELF), "ENV_FATIGUE_AREA") == 3)
        {
            DelayCommand(heatTime, ExecuteScript("enft_salt_ftg", oEnterer));
        }
		if(GetLocalInt(GetArea(OBJECT_SELF), "ENV_FATIGUE_AREA") == 4)
        {
            DelayCommand(magmaTime, ExecuteScript("enft_magma_ftg", oEnterer));
        }
		if(GetLocalInt(GetArea(OBJECT_SELF), "ENV_FATIGUE_AREA") == 5)
        {
            DelayCommand(magmaTime, ExecuteScript("enft_slags_ftg", oEnterer));
        }
    }
}