#include "ps_inc_experimentaleffects"

void main () {

	object oPC = GetItemActivator();
	object oItem = GetItemActivated();
	
	SendMessageToPC(oPC, "You drink the questionable potion. . ");
	
	int nLevel = GetLocalInt(oItem, "Item_Level");
	int nHelpful = GetLocalInt(oItem, "Item_Effect_Helpful");
	int nHarmful = GetLocalInt(oItem, "Item_Effect_Harmful");
	
	//If no saved information. . .
	if (nLevel <= 0) nLevel = d3(); //setting to random level
	if (nHelpful <= 0) nHelpful = -1; //setting to random effect
	if (nHarmful <= 0) nHarmful = -1; //setting to random effect 
	
	effect eGood = GetHelpfulEffect(oPC, nLevel, nHelpful);
	effect eBad = GetHarmfulEffect(oPC, nLevel, nHarmful);
	effect eEffect = EffectLinkEffects(eBad, eGood); //a mix of good and bad!
	
	float fDuration = nLevel*1800.0f;
	
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, fDuration);

}