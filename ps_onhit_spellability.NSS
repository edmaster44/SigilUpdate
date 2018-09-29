//:://////////////////////////////////////////////
//:: Created By: Miriam Rauschert
//:: Created On: April 27th, 2015
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 
#include "ps_inc_onhit" 

void main()
{
    if (!X2PreSpellCastCode())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
	object oCaster = OBJECT_SELF;
	
	object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCaster);
	if (!GetIsObjectValid(oItem)) //reject if we don't have a weapon equipped
		oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCaster);
	if (!GetIsObjectValid(oItem)) {
		SendMessageToPC(oCaster, "You must have a weapon equipped to use this ability.");
		return;
	}
	
    int nCasterLvl = GetCasterLevel(oCaster);
	int nID = GetSpellId();
	int nDC = GetSpellSaveDC();

	//SpeakString("spell_id: "+IntToString(nID)+", DC: "+IntToString(nDC), TALKVOLUME_SHOUT);
		
	int itemType = GetBaseItemType(oItem);
	if (itemType != BASE_ITEM_HEAVYCROSSBOW && //reject for not being a ranged weapon
		itemType != BASE_ITEM_LIGHTCROSSBOW &&
		itemType != BASE_ITEM_SLING &&
		itemType != BASE_ITEM_LONGBOW  &&
		itemType != BASE_ITEM_SHORTBOW) {
		SendMessageToPC(oCaster, "You must have a ranged weapon equipped to use this ability.");
		return;
	}
	
	if (itemType == BASE_ITEM_HEAVYCROSSBOW || itemType == BASE_ITEM_LIGHTCROSSBOW)
		oItem = GetItemInSlot(INVENTORY_SLOT_BOLTS, oCaster);
	else if (itemType == BASE_ITEM_LONGBOW || itemType == BASE_ITEM_SHORTBOW)
		oItem = GetItemInSlot(INVENTORY_SLOT_ARROWS, oCaster);
	else if (itemType == BASE_ITEM_SLING)
		oItem = GetItemInSlot(INVENTORY_SLOT_BULLETS, oCaster);
		
	if (!GetIsObjectValid(oItem)) {
		SendMessageToPC(oCaster, "You must have ammunition equipped to use this ability.");
		return;
	}
	
	int aID = nID-1751;
	string sSpellID = Get2DAString("iprp_onhit_abilities", "SpellID", aID); //get the id of the "real" spell this one is attached to
	int nSpell = StringToInt(sSpellID);
	//nSpell = GetBestSpellID(nSpell, oCaster);
	if (GetHasSpell(nSpell, oCaster) <= 0) { //reject because we don't know or haven't memorized the spell
		SendMessageToPC(oCaster, "You must know or have the spell you wish to put on your arrow memorized.");
		return;
	}
	
	DecrementRemainingSpellUses(oCaster, nSpell);
	
	string sVFX = Get2DAString("iprp_onhit_abilities", "WeaponEffect", aID);
	effect eVis = EffectNWN2SpecialEffectFile(sVFX);
	SetEffectSpellId(eVis, nID);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oCaster, 60.0f);
		
	SetTempOnHitProperty(oItem, OBJECT_SELF, aID, nDC, 60.0f);
	
}