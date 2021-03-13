#include "ps_inc_cards"

void main(int index) {

	object oPC = GetPCSpeaker();
	
	object oCard = CardsCreateCard(oPC, index);

}