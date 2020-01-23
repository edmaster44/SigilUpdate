/*******************************************************/
// A copy of ga_open_store
// that populates the gemstone store with common
// enchanting components every 60 minutes
// And handles markup / markdown as normal
/*******************************************************/

#include "ginc_param_const"
#include "ginc_item"
#include "ps_inc_time"
#include "ps_inc_gemstones"

const int MAX_MARKUP = 30;
const int MIN_MARKUP = 1;
const int MAX_MARKDOWN = -30;
const int MIN_MARKDOWN = -1;
// How much effect on the markup/markdown does each point of Appraise have?
const int APPRAISE_DIVISOR = 2;
const int CLEAN_TIME = 3600; //60 minute delay

object GetStoreFromStoreArea(string sTag)
{
	int iStoreArea = GetGlobalInt("STORE_AREA");
	object oStoreArea = IntToObject(iStoreArea);
	
	object oStore = GetFirstObjectInArea(oStoreArea);
	
	while (GetTag(oStore) != sTag && oStore != OBJECT_INVALID) {
		oStore = GetNextObjectInArea(oStoreArea);
	}
	
	// just in case someone drops a store outside the store area, it will still work.
	if (oStore == OBJECT_INVALID) {	oStore = GetTarget(sTag); }
	
	return oStore;
}

void ClearStore(object oStore) {

	object oItem = GetFirstItemInInventory(OBJECT_SELF);
	while (GetIsObjectValid(oItem)) {
		DestroyObject(oItem);
	}
	
}

void PopulateStore(object oStore) {

	CreateGemstoneOfType("gemstone_jasmal", 0, 0, oStore);
	CreateGemstoneOfType("gemstone_jasmal", 0, 0, oStore);
	CreateGemstoneOfType("gemstone_jasmal", 0, 0, oStore);
	CreateGemstoneOfType("gemstone_diamond_white", 0, 0, oStore);
	CreateGemstoneOfType("gemstone_diamond_white", 0, 0, oStore);
	CreateGemstoneOfType("gemstone_diamond_white", 0, 0, oStore);
	CreateGemstoneOfType("gemstone_diamond_black", 0, 0, oStore);
	
	int gemCount = 0;
	while (gemCount < 10) {
	
		int nRand = Random(12)+1;
		switch(nRand) {
			case 1: CreateGemstoneOfType("gemstone_tourmaline_red", 0, 0, oStore); break;
			case 2: CreateGemstoneOfType("gemstone_tourmaline_white", 0, 0, oStore); break;
			case 3: CreateGemstoneOfType("gemstone_tourmaline_black", 0, 0, oStore); break;
			case 4: CreateGemstoneOfType("gemstone_tourmaline_green", 0, 0, oStore); break;
			case 5: CreateGemstoneOfType("gemstone_tourmaline_blue", 0, 0, oStore); break;
			case 6: CreateGemstoneOfType("gemstone_zircon_white", 0, 0, oStore); break;
			case 7: CreateGemstoneOfType("gemstone_zircon_red", 0, 0, oStore); break;
			case 8: CreateGemstoneOfType("gemstone_zircon_blue", 0, 0, oStore); break;
			case 9: CreateGemstoneOfType("gemstone_zircon_green", 0, 0, oStore); break;
			case 10: CreateGemstoneOfType("gemstone_jasmal", 0, 0, oStore); break;
			case 11: CreateGemstoneOfType("gemstone_diamond_white", 0, 0, oStore); break;
			case 12: CreateGemstoneOfType("gemstone_diamond_black", 0, 0, oStore); break;
		}
	
		gemCount++;
	}

}

void main(int nMarkUp, int nMarkDown)
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	object oStore = GetStoreFromStoreArea("ps_store_zharak_gemstones");
	
	int nCurrentTime = PS_GetTime();
	int nTimestamp = GetLocalInt(oStore, "LastPopulated");
	
	if (nTimestamp > 0 && nCurrentTime-nTimestamp > CLEAN_TIME) {
		ClearStore(oStore);
	} else {
		PopulateStore(oStore);
		SetLocalInt(oStore, "LastPopulated", nCurrentTime);
	}
	
	int iPCAppraise = FloatToInt(IntToFloat(GetSkillRank(SKILL_APPRAISE, oPC)) / APPRAISE_DIVISOR);
    //int iNPCAppraise = GetSkillRank(SKILL_APPRAISE, OBJECT_SELF);
	//int iAppraiseDiff = iPCAppraise - iNPCAppraise;

	nMarkUp = MAX_MARKUP - iPCAppraise;
	if (nMarkUp < MIN_MARKUP) nMarkUp = MIN_MARKUP;
	
	nMarkDown = MAX_MARKDOWN + iPCAppraise;
	if (nMarkDown > MIN_MARKDOWN) nMarkDown = MIN_MARKDOWN;
	
	//SendMessageToPC(oPC, "Markup value = " + IntToString(nMarkUp) + ". Markdown value = " + IntToString(nMarkDown) + ".");
	
	OpenStore(oStore, oPC, nMarkUp, nMarkDown);
}