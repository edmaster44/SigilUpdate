

//*********************************************************************
//ga_store_openplanar
//MimiFearthegn 3-22-20
//Opens one of the randomized planar stores and populates it
//*********************************************************************
#include "ps_inc_stores"

void main(string sStoreTag) {

	object oPC = GetPCSpeaker();
	object oMerchant = OBJECT_SELF;
	
	object oStore = GetStoreFromStoreArea(sStoreTag);
	
	int nCurrentTime = PS_GetTime();
	int nTimestamp = GetLocalInt(oStore, "LastPopulated");
	
	if (nTimestamp > 0 && nCurrentTime-nTimestamp > CLEAN_TIME) {
		ClearStore(oStore);
		SetLocalInt(oStore, "Initialized", 0);
	} else if (GetLocalInt(oStore, "Initialized") <= 0) {
	
		AddMustHaveItems(oStore);
		
		float fDelay = 0.01f;
		
		int n = 0;
		int nItemNum = Random(10)+20;
		while (n < nItemNum) {
			DelayCommand(fDelay, CreateItemForStore(oStore));
			fDelay += 0.01f;
			n++;
		}
		
		SetLocalInt(oStore, "LastPopulated", nCurrentTime);
		SetLocalInt(oStore, "Initialized", 1);
	}
	
	int iPCAppraise = FloatToInt(IntToFloat(GetSkillRank(SKILL_APPRAISE, oPC)) / APPRAISE_DIVISOR);

	int nMarkUp = MAX_MARKUP - iPCAppraise;
	if (nMarkUp < MIN_MARKUP) nMarkUp = MIN_MARKUP;
	
	int nMarkDown = MAX_MARKDOWN + iPCAppraise;
	if (nMarkDown > MIN_MARKDOWN) nMarkDown = MIN_MARKDOWN;
	
	DelayCommand(0.5f, DS_OpenShop(oStore, oPC, nMarkUp, nMarkDown));
	
}