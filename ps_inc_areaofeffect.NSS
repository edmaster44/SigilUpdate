//:://////////////////////////////////////////////////////////////////////////
//:: AOE Inc
//:: ps_inc_areaofeffect.nss
//:: Created By: Mimi Fearthegn
//:: Created On: 5/29/21
//:://////////////////////////////////////////////////////////////////////////
//:: Various utility functions for areas of effect
//:://////////////////////////////////////////////////////////////////////////

//Re-calibrate the number of AOE active at present
//For instances where we need to limit the number of them hanging around
int CheckNumberOfAOE(object oPC) {
	
	int nNumberCalled = GetLocalInt(oPC, "AOE_CAST");
	int currentNumber = 0;

	SendMessageToPC(oPC, "Currently in Ledger: "+IntToString(nNumberCalled));
	int n;
	for(n = 0; n <= nNumberCalled; n++) {
		object oSummon = GetLocalObject(oPC, "AOE_CAST_"+IntToString(n));
		if (GetIsObjectValid(oSummon) && !GetIsDead(oSummon)) {
			currentNumber++;
		}
	}

	SetLocalInt(oPC, "AOE_CAST", currentNumber);

	int newCount = 0;
	if (currentNumber != nNumberCalled) {
		for(n = 0; n <= nNumberCalled; n++) {
			object oSummon = GetLocalObject(oPC, "AOE_CAST_"+IntToString(n));
			if (GetIsObjectValid(oSummon) && !GetIsDead(oSummon)) {
				SetLocalObject(oPC, "AOE_CAST_"+IntToString(newCount), oSummon);
				newCount++;
			} else {
				DeleteLocalObject(oPC, "AOE_CAST_"+IntToString(n));
			}
		}
	}
	
	nNumberCalled = GetLocalInt(oPC, "AOE_CAST");
	
	return nNumberCalled;

}

//Basic get function; no extra figures
int GetAOESInLedger(object oPC) {
	return GetLocalInt(oPC, "AOE_CAST");
}

//Make note of this AOE so we can keep track of it
void AddAOEToLedger(object oPC, object oAoE) {

	int nNumberCalled = GetAOESInLedger(oPC);
	SetLocalObject(oPC, "WARLOCK_CAST_"+IntToString(nNumberCalled), oAoE);
	SetLocalInt(oPC, "WARLOCK_CAST", nNumberCalled+1);
	
	CheckNumberOfAOE(oPC);

}