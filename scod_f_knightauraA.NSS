/*This Grants the Knight Saves that applies to his Allies
This is based on the total Knight level, as well as PRC.
*/


#include "scod_f_knightaura_inc"


void main(){
	object oCaster = GetAreaOfEffectCreator();
	if (!GetIsObjectValid(oCaster)) DestroyObject(OBJECT_SELF);
	
	object oTarget = GetEnteringObject();
	
	ApplyAura(oTarget, oCaster);
	
}