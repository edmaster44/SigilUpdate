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

int FF_GetIsSeqAndStoreSpell(object oSequencer);
void FF_CastSpellFromNewSequencer(object oSequencer, object oCaster = OBJECT_SELF);
struct dSequencerData FF_GetSeqData(object oSequencer);
struct dSequencerData FF_GetSeqDataFromVars(object oSequencer, struct dSequencerData data);
struct dSequencerData FF_GetSeqDataFromTag(object oSequencer, struct dSequencerData data);
void FF_RepairAllOldSeq(object oPC);
void FF_RecoverOldSequencer(object oSequencer);
int FF_GetStringHasLetters(string sString);
string GetSpellName(int nId);
int FF_PayForSequencerPot(object oSequencer);
int FF_GetQualifiesForSequencer(object oSequencer);
int FF_GetIsSeqPot(object oSequencer);
int FF_GetIsSeq(object oSequencer);
int FF_GetIsOldSequencerPot(object oSequencer);
int FF_GetIsNewSequencerPot(object oSequencer);
void FF_RenameSeqPot(object oSequencer, struct dSequencerData data);
void FF_DoSpellCastCheatMode(object oPC, int nId, object oTarget);
void FF_CastSpellFromNewSequencer(object oSequencer, object oCaster = OBJECT_SELF);


int FF_GetIsSeqAndStoreSpell(object oSequencer){
	// if it's not a sequncer at all, return false and let them carry on
	if (!FF_GetIsSeq(oSequencer)) return FALSE;
	
	// a return value of true means only that this was an attempt
	// to store a spell on a sequencer, not that the attempt succeeded
	if (!FF_GetQualifiesForSequencer(oSequencer)) return TRUE;
	
	int nId = GetSpellId() + 1;
	// the new seq pots dont use the sequencer item property
	if (FF_GetIsSeqPot(oSequencer)){
		struct dSequencerData data = FF_GetSeqData(oSequencer);
		if (data.nSpell1 == 0) data.nSpell1 = nId;
		else if (data.nSpell2 == 0) data.nSpell2 = nId;
		else if (data.nSpell3 == 0) data.nSpell3 = nId;
		FF_RenameSeqPot(oSequencer, data);
	}
	if (!FF_GetIsNewSequencerPot(oSequencer)){
		int nNumSpells = GetLocalInt(oSequencer, "X2_L_NUMTRIGGERS");
		nNumSpells++;
		SetLocalInt(oSequencer, "X2_L_NUMTRIGGERS", nNumSpells);
		SetLocalInt(oSequencer, "X2_L_SPELLTRIGGER" + IntToString(nNumSpells), nId);
	}
	effect eVisual = EffectVisualEffect(VFX_IMP_BREACH);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, OBJECT_SELF);
    FloatingTextStrRefOnCreature(83884, OBJECT_SELF);
	if (FF_GetIsSeqPot(oSequencer)){
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
	if (data.nNumSpells == 0 || FF_GetStringHasLetters(GetTag(oSequencer))){
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

void FF_RenameSeqPot(object oSequencer, struct dSequencerData data){
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

int FF_GetIsNewSequencerPot(object oSequencer){
	string sRef = GetResRef(oSequencer);
	//check to make sure this is a sequencer pot
	if (sRef == "ps_potion_lessersequencernew" || sRef == "ps_potion_sequencernew" ||
		sRef == "ps_potion_greatersequncernew"){
			return TRUE;
	}	
	return FALSE;
}

int FF_GetIsOldSequencerPot(object oSequencer){
	string sRef = GetResRef(oSequencer);
	//check to make sure this is a sequencer pot
	if (sRef == "ps_potion_lessersequencer" || sRef == "ps_potion_sequencer" ||
		sRef == "ps_potion_greatersequncer"){
			return TRUE;
	}	
	return FALSE;
}

int FF_GetIsSeq(object oSequencer){
	if (IPGetItemSequencerProperty(oSequencer) > 0) return TRUE;
	if (FF_GetIsNewSequencerPot(oSequencer)) return TRUE;
	return FALSE;
}

int FF_GetIsSeqPot(object oSequencer){
	if (FF_GetIsNewSequencerPot(oSequencer)) return TRUE;
	if (FF_GetIsOldSequencerPot(oSequencer)) return TRUE;
	return FALSE;
}

int FF_GetQualifiesForSequencer(object oSequencer){
	int bHasRoom = TRUE;
	if (!FF_GetIsSeqPot(oSequencer)){
		int nMaxSpells = IPGetItemSequencerProperty(oSequencer);
		int nNumSpells = GetLocalInt(oSequencer, "X2_L_NUMTRIGGERS");
		if (nNumSpells >= nMaxSpells) bHasRoom = FALSE;
	} else {
		struct dSequencerData data = FF_GetSeqData(oSequencer);
		if (data.nNumSpells >= data.nMaxSpells) bHasRoom = FALSE;
	}
	if (!bHasRoom){
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
	object oSequencer = GetSpellCastItem();
	if (GetIsObjectValid(oSequencer)){
        // we allow scrolls
        int nItem = GetBaseItemType(oSequencer);
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
		SendMessageToPC(OBJECT_SELF, "RECOGNIZED AS SEQ POT IN GET QUALIFIES");
		if (!FF_PayForSequencerPot(oSequencer)) return FALSE;
	}
	return TRUE;
}

int FF_PayForSequencerPot(object oSequencer){
	object oCaster = OBJECT_SELF;
	SendMessageToPC(oCaster, "CHECKING GOLD");
	int nId = GetSpellId();
	int nLevel = StringToInt(Get2DAString("spells", "Innate", nId));
	int nGold = CIGetCraftGPCost(oCaster, nLevel, X2_CI_SEQUENCER_COSTMODIFIER);
	nGold *= GetItemStackSize(oSequencer);

	if (GetGold(oCaster) < nGold){
		FloatingTextStrRefOnCreature(STR_REF_IC_INSUFFICIENT_GOLD, oCaster); // not enough gold!
        return FALSE;
	}
	PS_TakeGoldFromCreature(nGold, oCaster);
	return TRUE;
}

string GetSpellName(int nId){
	int nNameRef = StringToInt(Get2DAString("spells", "Name", nId));
	return GetStringByStrRef(nNameRef);
}


int FF_GetStringHasLetters(string sString){
	sString = GetStringLowerCase(sString);
	string sLetters = "abcdefghijklmnopqrstuvwxyz";
	int nLength = GetStringLength(sString);
	int i;
	string c;
	for (i = 0; i < nLength; i++){
		c = GetSubString(sString, i, 1);
		if (FindSubString(sLetters, c) != -1)
			return TRUE;
	}
	return FALSE;
}

void FF_RecoverOldSequencer(object oSequencer){
	// only needed on old seq pots
	if (!FF_GetIsOldSequencerPot(oSequencer))
		return;
	string sTag = GetTag(oSequencer);
	//if tag has letters its not a tag set by above function
	// as that tag would be numbers and underscore only
	if (FF_GetStringHasLetters(sTag))
		return;
	// if the numbertriggers local int is intact then prob we don't need
	// to repair it and would screw it up if we tried
	if (GetLocalInt(oSequencer, "X2_L_NUMTRIGGERS") > 1)
		return;
		
	string s1 = "";
	string s2 = "";
	string s3 = "";
	int i;
	string c;
	int nDelimCount = 0;
	int nLength = GetStringLength(sTag);
	for (i = 0; i < nLength; i++){
		c = GetSubString(sTag, i, 1);
		if (c != sDelim){
			if (nDelimCount == 0) s1 += c;
			else if (nDelimCount == 1) s2 += c;
			else if (nDelimCount == 2) s3 += c;
		} else nDelimCount++;
	}
	int nNumSpells = 0;
	if (s1 != ""){
		SetLocalInt(oSequencer, "X2_L_SPELLTRIGGER1", StringToInt(s1));
		nNumSpells++;
	}
	if (s2 != ""){
		SetLocalInt(oSequencer, "X2_L_SPELLTRIGGER2", StringToInt(s2));
		nNumSpells++;
	}
	if (s3 != ""){
		SetLocalInt(oSequencer, "X2_L_SPELLTRIGGER3", StringToInt(s3));
		nNumSpells++;
	}
	SetLocalInt(oSequencer, "X2_L_NUMTRIGGERS", nNumSpells); 
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

struct dSequencerData FF_GetSeqDataFromVars(object oSequencer, struct dSequencerData data){
	data.nNumSpells = GetLocalInt(oSequencer, "X2_L_NUMTRIGGERS");
	data.nSpell1 = GetLocalInt(oSequencer, "X2_L_SPELLTRIGGER1");
	data.nSpell2 = GetLocalInt(oSequencer, "X2_L_SPELLTRIGGER2"); 
	data.nSpell3 = GetLocalInt(oSequencer, "X2_L_SPELLTRIGGER3");
	return data;
}

struct dSequencerData FF_GetSeqDataFromTag(object oSequencer, struct dSequencerData data){
	// if we're looking for the data from the tag then reset all except nMaxSpells
	data.nNumSpells = 0;
	data.nSpell1 = 0;
	data.nSpell2 = 0;
	data.nSpell3 = 0;
	string sTag = GetTag(oSequencer); 
	if (sTag ==  GetResRef(oSequencer)) return data; // if the tag and ref are same, no data
	if (FF_GetStringHasLetters(sTag)) return data; //if tag isn't just numbers and underscore, no data
	
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
	//todo: I'm nearly 100% sure that converting an empty string to in makes 0 so I could simplify
	// this by removing the if and else, but not entirely sure so I should test at some point
	if (s1 != ""){
		data.nSpell1 = StringToInt(s1);
		if (data.nSpell1 > 0) data.nNumSpells++;
	} else data.nSpell1 = 0;
	if (s2 != ""){
		data.nSpell2 = StringToInt(s2);
		if (data.nSpell1 > 0) data.nNumSpells++;
	} else data.nSpell2 = 0;
	if (s3 != ""){
		data.nSpell3 = StringToInt(s3);
		if (data.nSpell1 > 0) data.nNumSpells++;
	} else data.nSpell3 = 0;
	return data;
}

struct dSequencerData FF_GetSeqData(object oSequencer){
	struct dSequencerData data;
	string sRef = GetResRef(oSequencer);
	if (sRef == "ps_potion_greatersequncer" || sRef == "ps_potion_greatersequncernew")
		data.nMaxSpells = 3;
	else if (sRef == "ps_potion_sequencer" || sRef == "ps_potion_sequencernew")
		data.nMaxSpells = 2;
	else data.nMaxSpells = 1;
	
	// if it still has the number of triggers local int set in spellhook then
	// we can probably get all we need from local ints. Otherwise the hard way
	if (GetLocalInt(oSequencer, "X2_L_NUMTRIGGERS") > 0)
		data = FF_GetSeqDataFromVars(oSequencer, data);
	else data = FF_GetSeqDataFromTag(oSequencer, data);
	return data;
}