#include "ps_astral_inc"


// should pass payment method 3 PAYMENT_METHOD_BANKRUPT and destination the tag of dead god area
// if player can't pay proper fee.
void main(string sAreaTag, int iPaymentMethod)
{
	object oPC = GetPCSpeaker();
	object oArea = GetAstralAreaObjectFromTag(sAreaTag);
	
	//int iPaid = AstralMakeTravelPayment(oPC, iPaymentMethod);

	AssignCommand(GetArea(oPC), AstralShipDestinationRequest(oArea, oPC, REQUEST_SOURCE_LOCATION_DECK));
}