#include "ps_inc_faction"

void main () {

	object oPC = GetLastUsedBy();
	
	ToggleFactionSystem(oPC);

}