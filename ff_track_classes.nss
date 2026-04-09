 

//This is called on pc load for new characters (and for characters who have not had this done yet), 
// and then at the end of ps_levelup and also in the mimic deleveling scripts. It stores the classes 
// so that we can figure out which class was just leveled in the function below this
void StoreClasses(object oPC){
	object oEss = GetItemPossessedBy(oPC, "ps_essence");
	if (!GetIsObjectValid(oEss)){
		SendMessageToPC(oPC, "Missing Essence! Please contact an administrator immediately on Discord.");
		return;
	}
	
	int i;
	int nClass;
	int nLevel;
	string sVarName = "CLASS_";
	for (i = 1; i <= 4; i++){
        nClass = GetClassByPosition(i, oPC);
        if (nClass == CLASS_TYPE_INVALID) nLevel = 0;
		else nLevel = GetLevelByClass(nClass, oPC);
        SetLocalInt(oEss, sVarName + IntToString(i), nClass);
		SetLocalInt(oEss, sVarName + IntToString(i) + "_LVL", nLevel);
	}
	if (!GetLocalInt(oEss, "TRACKING_CLASSES"))
		SetLocalInt(oEss, "TRACKING_CLASSES", TRUE);
}

//this is called on the level up event only in ff_update_feats before the above function is called.
// this info will be used in the function LevelUpGuiChoices() to determine if we need to launch
// gui_extra_choices and if so with which params. This way we can make 2 improvements:
// 1: We can ditch the "persistent" flag on feats such as half outsider apotheosis that is 
// unnecessarily running on heartbeat just to launch the gui one time
// 2: we can add psi/psy power selection via this feat, allowing us to no longer need separate
// psi/psy power bonus feats. This will not only allow them to get their powers on the right level
// instead of the level after it, but also allow us to expand the possibilities. Psi/psy Eldritch Knight
// Psy/Psi Lich, even? Yeah. Could do it. All by checking here what the last class leveled up was.
int GetLastClassLeveledUp(object oPC){
	object oEss = GetItemPossessedBy(oPC, "ps_essence");
	if (!GetIsObjectValid(oEss)){
		SendMessageToPC(oPC, "Missing Essence! Please contact an administrator immediately on Discord.");
		return -1;
	}
	if (!GetLocalInt(oEss, "TRACKING_CLASSES")) return -2;
	int i;
	int nClass;
	int nLevel;
	int nOldClass;
	int nOldLevel;
	string sVarName = "CLASS_";
	for (i = 1; i <= 4; i++){
        nClass = GetClassByPosition(i, oPC);
		if (nClass == CLASS_TYPE_INVALID) nLevel = 0;
		else nLevel = GetLevelByClass(nClass, oPC);
		nOldClass = GetLocalInt(oEss, sVarName + IntToString(i));
		nOldLevel = GetLocalInt(oEss, sVarName + IntToString(i) + "_LVL");
		if (nClass != nOldClass || nLevel > nOldLevel)
			return nClass;
	}
	return -2;
}