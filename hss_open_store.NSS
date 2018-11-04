// script_name
/*
	Description:
	
*/
// Name_Date


void main()
{
    object oStore = GetNearestObject(OBJECT_TYPE_STORE);
	//HSS_FISHMONGER_STORE
	
    if (GetIsObjectValid(oStore)) {
       OpenStore(oStore, GetPCSpeaker());
   } else {
       SpeakString("Sorry, I'm closed right now.");
	}
}