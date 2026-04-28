
#include "x2_inc_craft"

const string sDelim = "_";

struct dSequencerData {
	int nMaxSpells;
	int nNumSpells;
	int nSpell1;
	int nSpell2;
	int nSpell3;
	string sTag;
};

/*
void ShowDebugData(object oSequencer, struct dSequencerData data, string sSource, string sAdd = ""){
	object oPC = OBJECT_SELF;
	string sMessage = "From " + sSource +"\nTag: " + GetTag(oSequencer);
	sMessage += "\nMax: " + IntToString(data.nMaxSpells) + "\nNumSpells: ";
	sMessage += IntToString(data.nNumSpells) + "\nSpell1: " + IntToString(data.nSpell1);
	sMessage += "\nSpell2: " + IntToString(data.nSpell2);
	sMessage += "\nSpell3: " + IntToString(data.nSpell3);
	sMessage += "\nTag: " + data.sTag;
	if (sAdd != "") sMessage += "\n" + sAdd;
	SendMessageToPC(OBJECT_SELF, sMessage);
}
*/

int FF_GetIsSeqTag(string sTag){
	return TestStringAgainstPattern("*n_*n_*n", sTag);
}

struct dSequencerData FF_GetSeqDataFromTag(object oSequencer, struct dSequencerData data){
	// if we're looking for the data from the tag then reset all except nMaxSpells
	data.nNumSpells = 0;
	data.nSpell1 = 0;
	data.nSpell2 = 0;
	data.nSpell3 = 0;
	string sTag = GetTag(oSequencer); 
	if (!FF_GetIsSeqTag(sTag)) return data; //if tag isn't just numbers and underscore, no data
	//debug
	//SendMessageToPC(OBJECT_SELF, "Raw tag: " + sTag);
	int nLength = GetStringLength(sTag);
	int i;
	int nDelimCount = 0;
	string s1 = "";
	string s2 = "";
	string s3 = "";
	string c;
	for (i = 0; i < nLength; i++){
		c = GetSubString(sTag, i, 1);
		if (c != sDelim){
			if (nDelimCount == 0) s1 += c;
			else if (nDelimCount == 1) s2 += c;
			else s3 += c;
		} else nDelimCount++;
	}
	data.nSpell1 = (s1 == "" || s1 == "0") ? 0 : StringToInt(s1);
	data.nSpell2 = (s2 == "" || s2 == "0") ? 0 : StringToInt(s2);
	data.nSpell3 = (s3 == "" || s3 == "0") ? 0 : StringToInt(s3);
	if (data.nSpell3 > 0) data.nNumSpells = 3;
	else if (data.nSpell2 > 0) data.nNumSpells = 2;
	else if (data.nSpell1 > 0) data.nNumSpells = 1;
	else data.nNumSpells = 0;
	//DEBUG
	//ShowDebugData(oSequencer, data, "FF_GetSeqDataFromTag");
	return data;
}

struct dSequencerData FF_GetSeqDataFromVars(object oSequencer, struct dSequencerData data){
	data.nNumSpells = GetLocalInt(oSequencer, "X2_L_NUMTRIGGERS");
	data.nSpell1 = GetLocalInt(oSequencer, "X2_L_SPELLTRIGGER1");
	data.nSpell2 = GetLocalInt(oSequencer, "X2_L_SPELLTRIGGER2"); 
	data.nSpell3 = GetLocalInt(oSequencer, "X2_L_SPELLTRIGGER3");
	//ShowDebugData(oSequencer, data, "FF_GetSeqDataFromVars");
	return data;
}

struct dSequencerData FF_GetSeqData(object oSequencer){
	struct dSequencerData data;
	data.nMaxSpells = IPGetItemSequencerProperty(oSequencer);
	if (data.nMaxSpells < 1){
		string sRef = GetStringLowerCase(GetResRef(oSequencer));
		if (TestStringAgainstPattern("ps_potion_greatersequncer**", sRef))
			data.nMaxSpells = 3;
		else if (TestStringAgainstPattern("ps_potion_sequencer**", sRef))
			data.nMaxSpells = 2;
		else if (TestStringAgainstPattern("ps_potion_lessersequencer**", sRef))
			data.nMaxSpells = 1;
	}
	data.sTag = GetTag(oSequencer);
	// if the local integers are intact
	if (GetLocalInt(oSequencer, "X2_L_NUMTRIGGERS") > 0) 
		data = FF_GetSeqDataFromVars(oSequencer, data);
	else if (FF_GetIsSeqTag(data.sTag)){
		data = FF_GetSeqDataFromTag(oSequencer, data);
	} else {
		data.nNumSpells = 0;
		data.nSpell1 = 0;
		data.nSpell2 = 0;
		data.nSpell3 = 0;
	}
	return data;
}

int FF_GetIsNewSequencerPot(object oSequencer){
	string sRef = GetStringLowerCase(GetResRef(oSequencer));
	return TestStringAgainstPattern("ps_potion_**sequ**ncernew", sRef);
}

int FF_GetIsOldSequencerPot(object oSequencer){
	string sRef = GetStringLowerCase(GetResRef(oSequencer));
	return TestStringAgainstPattern("ps_potion_**sequ**ncer", sRef);
}

int FF_GetIsSeqPot(object oSequencer){
	string sRef = GetStringLowerCase(GetResRef(oSequencer));
	return TestStringAgainstPattern("ps_potion_**sequ**ncer**", sRef);;
}

int FF_GetQualifiesForSequencer(object oPC, object oSequencer, struct dSequencerData data){
	
	if (data.nNumSpells >= data.nMaxSpells){
		FloatingTextStrRefOnCreature(83859, oPC, FALSE);
		return FALSE;
	}
	int nId = GetSpellId();
	if (StringToInt(Get2DAString("spells", "Innate", nId)) >= 10){
		FloatingTextStringOnCreature("You cannot store epic spells", oPC, FALSE);
		return FALSE;
	}
	if (StringToInt(Get2DAString("spells", "HostileSetting", nId))){
		FloatingTextStrRefOnCreature(83885, oPC, FALSE);
		return FALSE;
	}
	object oItem = GetSpellCastItem();
	if (GetIsObjectValid(oItem)){
        // we allow scrolls
        int nItem = GetBaseItemType(oItem);
        if (nItem !=BASE_ITEM_SPELLSCROLL && nItem != 105){
            FloatingTextStrRefOnCreature(83373, oPC, FALSE);
            return FALSE;
        }
    }
	// seq pots require gold because the old way was for seq pots to cost
	// a fortune to make and then it didn't make a difference whether you put
	// level 4 or level 9 spells on. Should we make all sequencers cost money
	// to store? Probably. But for now we'll just look at sequencer robes and
	// things like that as being very powerful magic that bypasses the sacrifice
	// Returns true if we cannot pay. Doesn't return if we pay, it just continues
	if (FF_GetIsSeqPot(oSequencer)){
		//debug
		//SendMessageToPC(oPC, "Pay recognizes oPC");
		//ShowDebugData(oSequencer, data, "Pay");
		
		int nLevel = StringToInt(Get2DAString("spells", "Innate", nId));
		int nGold = CIGetCraftGPCost(oPC, nLevel, X2_CI_SEQUENCER_COSTMODIFIER);
		nGold *= GetItemStackSize(oSequencer);

		if (GetGold(oPC) < nGold){
			FloatingTextStrRefOnCreature(STR_REF_IC_INSUFFICIENT_GOLD, oPC, FALSE); // not enough gold!
			return FALSE;
		}
		//ShowDebugData(oSequencer, data, "Pay", IntToString(nGold));
		PS_TakeGoldFromCreature(nGold, oPC);
		return TRUE;
	}
	return TRUE;
}

string GetSpellName(int nId){
	string sNameRef = Get2DAString("spells", "Name", nId);
	return GetStringByStrRef(StringToInt(sNameRef));
}


void FF_SetSeqTag(object oSequencer, struct dSequencerData data){
	string sTag = IntToString(data.nSpell1) + sDelim + IntToString(data.nSpell2);
	sTag += sDelim + IntToString(data.nSpell3);
	SetTag(oSequencer, sTag);
}

void FF_RenameSeqPotAndSetTag(object oSequencer, struct dSequencerData data){
	string sName = "";
	if (data.nNumSpells < 1){
		if (data.nMaxSpells == 3) sName = "Greater ";
		else if (data.nMaxSpells == 1) sName = "Lesser ";
		sName += "Sequencer Potion";
	} else {
		sName = "<c=cyan>";
		if (data.nMaxSpells == 1) sName += "Lesser ";
		else if (data.nMaxSpells == 3) sName += "Greater ";
		sName += "Sequencer: " + GetSpellName(data.nSpell1 - 1); 
		if (data.nSpell2 > 0){
			if (data.nSpell3 > 0)
				sName += ", " + GetSpellName(data.nSpell2 - 1) + ", and " + GetSpellName(data.nSpell3 - 1);
			else sName += " and " + GetSpellName(data.nSpell2 - 1);
		}
		sName += "</c>";
	}
	SetFirstName(oSequencer, sName);
	FF_SetSeqTag(oSequencer, data);
}

void FF_ApplySeqVars(object oSequencer, struct dSequencerData data){
	SetLocalInt(oSequencer, "X2_L_NUMTRIGGERS", data.nNumSpells);
	SetLocalInt(oSequencer, "X2_L_SPELLTRIGGER1", data.nSpell1);
	SetLocalInt(oSequencer, "X2_L_SPELLTRIGGER2", data.nSpell2);
	SetLocalInt(oSequencer, "X2_L_SPELLTRIGGER3", data.nSpell3);
}

void FF_RecoverOldSequencer(object oSequencer){
	if (!FF_GetIsOldSequencerPot(oSequencer)) return;
	struct dSequencerData data = FF_GetSeqData(oSequencer);
	FF_RenameSeqPotAndSetTag(oSequencer, data);
	FF_ApplySeqVars(oSequencer, data);
}

void FF_DoSpellCastCheatMode(object oPC, int nId, object oTarget){
	// to avoid converting negative numbers to and from strings we've stored the 
	// spell ids as 1 higher than they really are, so we cast them as one lower
	AssignCommand(oPC, ActionCastSpellAtObject(nId, oTarget, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
}
