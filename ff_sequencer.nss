// there is a bug in the default sequencer potions we've been using. The sequencer item property
// relies on local integers stored on the item that has the property. If you have a stack of such items
// then if you split them what really happens is part of your stack is destroyed and a new copy is
// made for the split-off stack. When this happens, the local integers are NOT copied, so the new
// "child" stack cannot cast spells and reads as empty. Just as bad, if you have one of the original
// sequencer pots with a spell stored you can drop 9 empty ones on top of it (assuming they're all the
// same resource reference and name) and the ones you dropped on will inherit the local integers of the
// original. Infinite spell reuse as many times as your pockets are deep. Forever.

// So, I've done 3 things:
// 1, to prevent the exploit, I've made sequencer pots get automatically renamed to the spells upon them
// and made the dmfi and item editor unable to be used on potions. You can't drop a stack of empties on
// one full because their names won't be the same.
// 2, I've created new sequencer pots that store the relevant spell data as a string in the item tag.
// Tags ARE copied during a stack split. The new pots use unique power, self only, single use and code 
// in x2_mod_def_act gets the spell id(s) from the tag and casts them from functions here.
// 3, I've given the old style sequencer potions the same kind of tag and put a function in ps_rest
// that calls upon code here to restore lost local ints on seq pots from their tags.
// -FlattedFifth, june 25, 2026

#include "x2_inc_craft"

const string sDelim = "_";

struct dSequencerData {
	int nMaxSpells;
	int nNumSpells;
	int nSpell1;
	int nSpell2;
	int nSpell3;
};

void FF_RepairAllOldSeq(object oPC);
void FF_ApplySeqVars(object oSequencer, struct dSequencerData data);
void FF_RecoverOldSequencer(object oSequencer);
int FF_GetIsSeqTag(string sTag);
void FF_RenameSeqPotAndSetTag(object oSequencer, struct dSequencerData data);
int FF_GetIsSeqPot(object oSequencer);
int FF_GetIsOldSequencerPot(object oSequencer);
int FF_GetIsNewSequencerPot(object oSequencer);
struct dSequencerData FF_GetSeqData(object oSequencer);
struct dSequencerData FF_GetSeqDataFromTag(object oSequencer, struct dSequencerData data);
struct dSequencerData FF_GetSeqDataFromVars(object oSequencer, struct dSequencerData data);
int FF_GetQualifiesForSequencer(object oSequencer);
void FF_DoSpellCastCheatMode(object oPC, int nId, object oTarget);
void FF_CastSpellFromNewSequencer(object oSequencer, object oCaster = OBJECT_SELF);
int FF_GetIsSeqAndStoreSpell(object oSequencer);
string GetSpellName(int nId);

string GetSpellName(int nId){
	string sNameRef = Get2DAString("spells", "Name", nId);
	return GetStringByStrRef(StringToInt(sNameRef));
}

void ShowDebugData(object oSequencer, struct dSequencerData data, string sSource, string sAdd = ""){
	object oPC = OBJECT_SELF;
	string sMessage = "From " + sSource +"\nTag: " + GetTag(oSequencer);
	sMessage += "\nMax: " + IntToString(data.nMaxSpells) + "\nNumSpells: ";
	sMessage += IntToString(data.nNumSpells) + "\nSpell1: " + IntToString(data.nSpell1);
	sMessage += "\nSpell2: " + IntToString(data.nSpell2);
	sMessage += "\nSpell3: " + IntToString(data.nSpell3);
	if (sAdd != "") sMessage += "\n" + sAdd;
	SendMessageToPC(OBJECT_SELF, sMessage);
}


int FF_GetIsSeqAndStoreSpell(object oSequencer){
	// if it's not a sequncer at all, return false and let them carry on
	if (IPGetItemSequencerProperty(oSequencer) < 1 && 
		FF_GetIsNewSequencerPot(oSequencer) == FALSE) 
			return FALSE;
	
	// a return value of true means only that this was an attempt
	// to store a spell on a sequencer, not that the attempt succeeded
	if (!FF_GetQualifiesForSequencer(oSequencer)) return TRUE;
	
	struct dSequencerData data = FF_GetSeqData(oSequencer);
	int nId = GetSpellId() + 1;
	if (data.nSpell1 == 0) data.nSpell1 = nId;
	else if (data.nSpell2 == 0) data.nSpell2 = nId;
	else if (data.nSpell3 == 0) data.nSpell3 = nId;
	
	if (IPGetItemSequencerProperty(oSequencer) > 0)
		FF_ApplySeqVars(oSequencer, data);
	
	effect eVisual = EffectVisualEffect(VFX_IMP_BREACH);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, OBJECT_SELF);
    FloatingTextStrRefOnCreature(83884, OBJECT_SELF);
	if (FF_GetIsSeqPot(oSequencer)){
		FF_RenameSeqPotAndSetTag(oSequencer, data);
		string sMessage = "<c=cyan>Your Sequencer Potion has been renamed.\nThe new name will ";
		sMessage += "become visible after an area transition or after you move the potion from ";
		sMessage += "one square to another in your inventory.</c>";
		SendMessageToPC(OBJECT_SELF, sMessage);
	}
	return TRUE;
}

void FF_CastSpellFromNewSequencer(object oSequencer, object oCaster = OBJECT_SELF){
	if (!FF_GetIsNewSequencerPot(oSequencer)) return;
	struct dSequencerData data = FF_GetSeqData(oSequencer);
	// if the tag was set up correctly it should contain ONLY numbers and whatever
	// we're currently using as a delimiter in ff_arrays. Therefore there shouldn't
	// be any letters.
	if (data.nNumSpells == 0 || !FF_GetIsSeqTag(GetTag(oSequencer))){
		FloatingTextStringOnCreature("No spells stored!", oCaster);
		return;
	}
	if (data.nSpell1 != 0) FF_DoSpellCastCheatMode(oCaster, data.nSpell1 -1, oCaster);
	if (data.nSpell2 != 0) FF_DoSpellCastCheatMode(oCaster, data.nSpell2 -1, oCaster);
	if (data.nSpell3 != 0) FF_DoSpellCastCheatMode(oCaster, data.nSpell3 -1, oCaster);
}

void FF_DoSpellCastCheatMode(object oPC, int nId, object oTarget){
	// to avoid converting negative numbers to and from strings we've stored the 
	// spell ids as 1 higher than they really are, so we cast them as one lower
	AssignCommand(oPC, ActionCastSpellAtObject(nId -1, oTarget, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
}

int FF_GetQualifiesForSequencer(object oSequencer){
	struct dSequencerData data = FF_GetSeqData(oSequencer);
	if (data.nNumSpells >= data.nMaxSpells){
		FloatingTextStrRefOnCreature(83859, OBJECT_SELF);
		return FALSE;
	}
	int nId = GetSpellId();
	if (StringToInt(Get2DAString("spells", "Innate", nId)) >= 10){
		FloatingTextStringOnCreature("You cannot store epic spells", OBJECT_SELF);
		return FALSE;
	}
	if (StringToInt(Get2DAString("spells", "HostileSetting", nId))){
		FloatingTextStrRefOnCreature(83885, OBJECT_SELF);
		return FALSE;
	}
	object oItem = GetSpellCastItem();
	if (GetIsObjectValid(oItem)){
        // we allow scrolls
        int nItem = GetBaseItemType(oItem);
        if (nItem !=BASE_ITEM_SPELLSCROLL && nItem != 105){
            FloatingTextStrRefOnCreature(83373, OBJECT_SELF);
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
		SendMessageToPC(OBJECT_SELF, "Pay recognizes OBJECT_SELF");
		ShowDebugData(oSequencer, data, "Pay");
		
		int nLevel = StringToInt(Get2DAString("spells", "Innate", nId));
		int nGold = CIGetCraftGPCost(OBJECT_SELF, nLevel, X2_CI_SEQUENCER_COSTMODIFIER);
		nGold *= GetItemStackSize(oSequencer);

		if (GetGold(OBJECT_SELF) < nGold){
			FloatingTextStrRefOnCreature(STR_REF_IC_INSUFFICIENT_GOLD, OBJECT_SELF); // not enough gold!
			return FALSE;
		}
		ShowDebugData(oSequencer, data, "Pay", IntToString(nGold));
		PS_TakeGoldFromCreature(nGold, OBJECT_SELF);
		return TRUE;
	}
	return TRUE;
}

struct dSequencerData FF_GetSeqDataFromVars(object oSequencer, struct dSequencerData data){
	data.nNumSpells = GetLocalInt(oSequencer, "X2_L_NUMTRIGGERS");
	data.nSpell1 = GetLocalInt(oSequencer, "X2_L_SPELLTRIGGER1");
	data.nSpell2 = GetLocalInt(oSequencer, "X2_L_SPELLTRIGGER2"); 
	data.nSpell3 = GetLocalInt(oSequencer, "X2_L_SPELLTRIGGER3");
	ShowDebugData(oSequencer, data, "FF_GetSeqDataFromVars");
	return data;
}

struct dSequencerData FF_GetSeqDataFromTag(object oSequencer, struct dSequencerData data){
	// if we're looking for the data from the tag then reset all except nMaxSpells
	data.nNumSpells = 0;
	data.nSpell1 = 0;
	data.nSpell2 = 0;
	data.nSpell3 = 0;
	string sTag = GetTag(oSequencer); 
	if (!FF_GetIsSeqTag(sTag)) return data; //if tag isn't just numbers and underscore, no data
	
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
	data.nSpell1 = StringToInt(s1);
	if (data.nSpell1 > 0) data.nNumSpells = 1;
	data.nSpell2 = StringToInt(s2);
	if (data.nSpell2 > 0) data.nNumSpells = 2;
	data.nSpell3 = StringToInt(s3);
	if (data.nSpell3 > 0) data.nNumSpells = 3;
	//DEBUG
	ShowDebugData(oSequencer, data, "FF_GetSeqDataFromTag");
	return data;
}

struct dSequencerData FF_GetSeqData(object oSequencer){
	struct dSequencerData data;
	data.nMaxSpells = IPGetItemSequencerProperty(oSequencer);
	if (data.nMaxSpells < 1){
		string sRef = GetStringLowerCase(GetResRef(oSequencer));
		if (TestStringAgainstPattern("ps_**_greatersequncer**", sRef))
			data.nMaxSpells = 3;
		else if (TestStringAgainstPattern("ps_**_sequencer**", sRef))
			data.nMaxSpells = 2;
		else data.nMaxSpells = 1;
	}
	// if the tag is correct format..
	if (FF_GetIsSeqTag(GetTag(oSequencer))){
		data = FF_GetSeqDataFromTag(oSequencer, data);
	} else data = FF_GetSeqDataFromVars(oSequencer, data);
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

void FF_RenameSeqPotAndSetTag(object oSequencer, struct dSequencerData data){
	string sName = "<c=cyan>";
	if (data.nMaxSpells == 1) sName += "Lesser ";
	else if (data.nMaxSpells == 3) sName += "Greater ";
	sName += "Sequencer: " + GetSpellName(data.nSpell1 - 1); 
	if (data.nSpell2 > 0){
		if (data.nSpell3 > 0)
			sName += ", " + GetSpellName(data.nSpell2 - 1) + ", and " + GetSpellName(data.nSpell3 - 1);
		else sName += " and " + GetSpellName(data.nSpell2 - 1);
	}
	sName += "</c>";
	SetFirstName(oSequencer, sName);
	string sTag = IntToString(data.nSpell1) + sDelim + IntToString(data.nSpell2);
	sTag += sDelim + IntToString(data.nSpell3);
	SetTag(oSequencer, sTag);
}

int FF_GetIsSeqTag(string sTag){
	return TestStringAgainstPattern("*n_*n_*n", sTag);
}

void FF_RecoverOldSequencer(object oSequencer){
	if (!FF_GetIsSeqTag(GetTag(oSequencer))) return;
	struct dSequencerData data;
	data.nMaxSpells = IPGetItemSequencerProperty(oSequencer);
	if (data.nMaxSpells < 1) return;
	data = FF_GetSeqDataFromTag(oSequencer, data);
	FF_ApplySeqVars(oSequencer, data);
}

void FF_ApplySeqVars(object oSequencer, struct dSequencerData data){
	SetLocalInt(oSequencer, "X2_L_NUMTRIGGERS", data.nNumSpells);
	SetLocalInt(oSequencer, "X2_L_SPELLTRIGGER1", data.nSpell1);
	SetLocalInt(oSequencer, "X2_L_SPELLTRIGGER2", data.nSpell2);
	SetLocalInt(oSequencer, "X2_L_SPELLTRIGGER3", data.nSpell3);
}

void FF_RepairAllOldSeq(object oPC){
	int i = 0;
	object oSequencer = GetFirstItemInInventory(oPC);
	//27072 = num of items a pc could have if inv full of full bags, including the bags
    while (GetIsObjectValid(oSequencer) && i <= 27072){
		i++;
		FF_RecoverOldSequencer(oSequencer);
        oSequencer = GetNextItemInInventory(oPC);
    }
}