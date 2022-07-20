// script_name
/*
	Description:
	
*/
// Name_Date
#include "dethia_shop_sys"


void main()
{
    object oStore = GetNearestObject(OBJECT_TYPE_STORE);
	//HSS_FISHMONGER_STORE
	
    if (GetIsObjectValid(oStore)) {
       DS_OpenShop(oStore, GetPCSpeaker());
   } else {
       SpeakString("Sorry, I'm closed right now.");
	}
}