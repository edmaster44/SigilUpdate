/*******************************************************/
// A copy of ga_open_store
// that populates the gemstone store with common
// enchanting components every 60 minutes
// And handles markup / markdown as normal
/*******************************************************/

#include "ps_inc_time"
#include "ps_inc_stores"

void main(int nMarkUp, int nMarkDown)
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	object oStore = GetStoreFromStoreArea("store_cards");
	
	if (!GetIsObjectValid(oStore)) {
		SendMessageToPC(oPC, "Debug: Store not found");
	}
	
	int nCurrentTime = PS_GetTime();
	int nTimestamp = GetLocalInt(oStore, "LastPopulated");
	
	if (nTimestamp > 0 && nCurrentTime-nTimestamp > CLEAN_TIME) {
		ClearStore(oStore);
	} else {
		PopulateCardStore(oStore, oPC);
		SetLocalInt(oStore, "LastPopulated", nCurrentTime);
	}
	
	int iPCAppraise = FloatToInt(IntToFloat(GetSkillRank(SKILL_APPRAISE, oPC)) / APPRAISE_DIVISOR);

	nMarkUp = MAX_MARKUP - iPCAppraise;
	if (nMarkUp < MIN_MARKUP) nMarkUp = MIN_MARKUP;
	
	nMarkDown = MAX_MARKDOWN + iPCAppraise;
	if (nMarkDown > MIN_MARKDOWN) nMarkDown = MIN_MARKDOWN;
	
	OpenStore(oStore, oPC, nMarkUp, nMarkDown);
}