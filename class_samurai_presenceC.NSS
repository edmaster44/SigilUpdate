/*
Heartbeat script for samurai presence. Necessary because if someone is already in range, but not 
yet in party, they won't get the presence effect when joining the party unless the Heartbeat
checks for them. ie, they already triggered on enter but were not in party at that time

*/


#include "class_samurai_presence_inc"


void main(){
	object oCaster = GetAreaOfEffectCreator();
	if (!GetIsObjectValid(oCaster)){
		DestroyObject(OBJECT_SELF);
		return;
	}
	
	object oTarget = GetFirstInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE);;
	
	while(GetIsObjectValid(oTarget)){
		ApplyPresence(oTarget, oCaster);
		oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE);
	}

	
}