#include "ps_inc_onhit" 
#include "nw_i0_invocatns" 
void main() {

	int nDC = GetOnHitAbilityDC(OBJECT_SELF);
	int nID = GetOnHitAbilityID(OBJECT_SELF);
	object oCaster = GetOnHitAbilityCaster(OBJECT_SELF);
	string sSpellID = Get2DAString("iprp_onhit_abilities", "SpellID", nID);
	int nSpell = StringToInt(sSpellID);
	
	if (GetHasSpell(839, oCaster) || GetHasSpell(824, oCaster))
		DoAreaOnHitBlast(oCaster, OBJECT_SELF, METAMAGIC_INVOC_FRIGHTFUL_BLAST, nDC, nID);
	else
		SendMessageToPC(oCaster, "You must have eldritch doom or eldritch chain in order to use this ability!");
}