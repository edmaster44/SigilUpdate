#include "ff_safevar"

void main() {

	object oPC = GetEnteringObject();

	int iLock = PS_GetGlobalInt("undersigilRatsLock");
	if ( iLock == 0 ) {
		PS_SetGlobalInt("undersigilRatsLock", 1); // Only allows one clean up at a time.
		
   		if(GetObjectByTag("ps_us_ratrepresentative") == OBJECT_INVALID) {
  			CreateObject(OBJECT_TYPE_CREATURE, "ps_us_ratrepresentative", GetLocation(GetWaypointByTag("wp_us_ratrepresentative")));
		}
		
		PS_SetGlobalInt("undersigilRatsLock", 0);
 	}
	
}