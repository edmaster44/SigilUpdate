/*This Grants the Knight Saves that applies to his Allies
This is based on the total Knight level, as well as PRC.
*/


#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "ps_inc_functions"


void main(){

	object oCaster = OBJECT_SELF;
	
	effect eAOE = EffectAreaOfEffect(VFX_SENTINEL_KNIGHT_AURA);
	eAOE = SupernaturalEffect(eAOE);
 
	
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, oCaster);

}