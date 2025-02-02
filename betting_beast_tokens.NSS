#include "ff_safevar"

void main () {

	string sFighter1 = PS_GetLocalString(OBJECT_SELF, "MONSTER1");
	string sFighter2 = PS_GetLocalString(OBJECT_SELF, "MONSTER2");
	string sWinner = PS_GetLocalString(OBJECT_SELF, "POTENTIAL_WINNER");
	
	SetCustomToken(33331, sFighter1);
	SetCustomToken(33332, sFighter2);
	SetCustomToken(33333, sWinner);

}