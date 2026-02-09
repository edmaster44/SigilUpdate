/*This Grants the Knight Saves that applies to his Allies
This is based on the total Knight level, as well as PRC.
*/


#include "scod_f_knightaura_inc"



void main(){
	
	PS_RemoveEffects(GetExitingObject(), SPELLABILITY_KNIGHT_AURA, NULL, GetAreaOfEffectCreator());

}