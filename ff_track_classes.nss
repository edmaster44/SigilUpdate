 

//This is called on pc load for new characters (and for characters who have not had this done yet), 
// and then at the end of ps_levelup and also in the mimic deleveling scripts. It stores the classes 
// so that we can figure out which class was just leveled in the function below this. How this works:
// At character creation and at end of every level up it stores 2 local integers on essence for each class.
// one for the class and one for the level, by it's position. For example, if you create a cleric at character
// creation then your position 1 class is cleric (classes.2da row 2) and you have one level in it. So this will
// store on the essence the local integer "CLASS_1" with a value of 2 and the local integer "CLASS_1_LVL" with a 
// value of 1. Then if at lvl 2 you add a lvl of barb then it will add "CLASS_2" with a value of 0 and "CLASS_2_LVL"
// with a value of 1. Then at lvl 3 if you add another cleric lvl then "CLASS_1_LVL" value will change to 2.
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
// this info will be used in the function FF_AdjustClasses() in the file ff_adjust_classes to determine if we need to launch
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