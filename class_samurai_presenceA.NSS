


#include "class_samurai_presence_inc"


void main(){
	object oCaster = GetAreaOfEffectCreator();
	if (!GetIsObjectValid(oCaster)){
		DestroyObject(OBJECT_SELF);
		return;
	}
	
	object oTarget = GetEnteringObject();
	
	ApplyPresence(oTarget, oCaster);
	
	
	
}