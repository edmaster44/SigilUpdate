/*This Grants the Knight Saves that applies to his Allies
This is based on the total Knight level, as well as PRC.
*/


#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "ps_inc_functions"


void main(){
	
	PS_RemoveEffects(GetExitingObject(), SPELLABILITY_KNIGHT_AURA, NULL, GetAreaOfEffectCreator());

}