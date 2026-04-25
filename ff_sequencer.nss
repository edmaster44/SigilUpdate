// there is a bug in the default sequencer potions we've been using. The sequencer item property
// relies on local integers stored on the item with the property. If you have a stack of such items
// then if you split them what really happens is part of your stack is destroyed and a new copy is
// made for the split-off stack. When this happens, the local integers are NOT copied, so the new
// "child" stack cannot cast spells and reads as empty. Just as bad, if you have one of the original
// sequencer pots with a spell stored you can drop 9 empty ones on top of it (assuming they're all the
// same type, lesser, greater, etc) and the ones you dropped on will inherit the local integers of the
// original. Infinite spell reuse. Forever.

// There's nothing I can do about the bug in old pots where a split stack gets emptied, but I can
// prevent the exploit by renaming them after the spells they get and making both the item editor
// and the dmfi tool unable to target potions. You can't combine stacks when they have different
// names even if they have the same res ref.

//Going forward, we will use the NEW potions I made that store the spell data in a tag (tags are
// copied in a split) and use Unique Power, Self Only, Single Use instead of the sequencer property.
// See x2_inc_spellhook for storing spells on these new sequencers and x2_mod_def_act for casting
// the spell on them.

#include "x2_inc_craft"

const string sDelim = "_";

struct dSequencerData {
	int nMaxSpells;
	int nNumSpells;
	int nSpell1;
	int nSpell2;
	int nSpell3;
};

void ShowDebugData(object oSequencer, struct dSequencerData data, int i){
	object oPC = OBJECT_SELF;
	string sMessage = "Cycle " + IntToString(i) +"\nTag: " + GetTag(oSequencer);
	sMessage += "\nMax: " + IntToString(data.nMaxSpells) + "\nNumSpells: ";
	sMessage += IntToString(data.nNumSpells) + "\nSpell1: " + IntToString(data.nSpell1);
	sMessage += "\nSpell2: " + IntToString(data.nSpell2);
	sMessage += "\nSpell3: " + IntToString(data.nSpell3);
	SendMessageToPC(OBJECT_SELF, sMessage);
}

void RenameOldSequencerPot(object oSequencer, object oCaster = OBJECT_SELF);
int GetStringHasLetters(string sString);
int PS_PayForSequencerPot(object oSequencer, object oCaster = OBJECT_SELF);
int PS_GetQualifiesForSequencer(int nId = -1);
int PS_GetIsOldSequencerPot(object oSequencer);
int PS_GetIsNewSequencerPot(object oSequencer);
struct dSequencerData PS_GetSequencerData(object oSequencer);
void PS_DoSpellCastCheatMode(object oPC, int nId);
string GetSpellName(int nId);
string PS_GetNewSequencerPotName(object oSequencer, struct dSequencerData data);
void PS_ShowSeqRenameMessage(object oCaster);
void PS_CastSpellFromNewSequencer(object oSequencer, object oCaster = OBJECT_SELF);
int PS_GetIsStoreSpellOnNewSquencerPot(object oSequencer, object oCaster = OBJECT_SELF);
void PS_SetOldSeqRecoveryTag(object oSequencer);
void PS_RecoverOldSequencer(object oSequencer);
void RepairAllOldSeq(object oPC);

// main function to "store" spells on new sequencer pots by setting the tag
// to a list of spell ids
int PS_GetIsStoreSpellOnNewSquencerPot(object oSequencer, object oCaster = OBJECT_SELF){
	if (!PS_GetIsNewSequencerPot(oSequencer))
		return FALSE; 
		
	struct dSequencerData data = PS_GetSequencerData(oSequencer);
	ShowDebugData(oSequencer, data, 1);
	if (data.nMaxSpells <= data.nNumSpells){
		FloatingTextStrRefOnCreature(83859, oCaster);
		return TRUE;
	}
		
	if (!PS_GetQualifiesForSequencer())
		return TRUE; 

	if (!PS_PayForSequencerPot(oSequencer, oCaster))
		return TRUE;
	
	// we store the spell ids as 1 higher than they are to avoid negative numbers
	int nId = GetSpellId() + 1;
	if (data.nSpell1 == 0) data.nSpell1 = nId;
	else if (data.nSpell2 == 0) data.nSpell2 = nId;
	else if (data.nSpell3 == 0) data.nSpell3 = nId;
	string sList = IntToString(data.nSpell1) + sDelim + IntToString(data.nSpell2);
	sList += sDelim + IntToString(data.nSpell3);
	// bad things happen if you have an empty tag, but shouldn't be possible here
	if (sList != "") SetTag(oSequencer, sList);
	ShowDebugData(oSequencer, data, 1);
	effect eVisual = EffectVisualEffect(VFX_IMP_BREACH);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oCaster);
    FloatingTextStrRefOnCreature(83884, oCaster);
	string sName = PS_GetNewSequencerPotName(oSequencer, data);
	SetFirstName(oSequencer, "<c=cyan>" + sName + "</c>");
	PS_ShowSeqRenameMessage(oCaster);
	return TRUE;
}


void PS_CastSpellFromNewSequencer(object oSequencer, object oCaster = OBJECT_SELF){
	if (!PS_GetIsNewSequencerPot(oSequencer)) return;
	struct dSequencerData data = PS_GetSequencerData(oSequencer);
	// if the tag was set up correctly it should contain ONLY numbers and whatever
	// we're currently using as a delimiter in ff_arrays. Therefore there shouldn't
	// be any letters.
	if (data.nNumSpells == 0 || GetStringHasLetters(GetTag(oSequencer))){
		FloatingTextStringOnCreature("No spells stored!", oCaster);
		return;
	}
	if (data.nSpell1 != 0) PS_DoSpellCastCheatMode(oCaster, data.nSpell1 -1);
	if (data.nSpell2 != 0) PS_DoSpellCastCheatMode(oCaster, data.nSpell2 -1);
	if (data.nSpell3 != 0) PS_DoSpellCastCheatMode(oCaster, data.nSpell3 -1);
}


void PS_ShowSeqRenameMessage(object oCaster){
	string sMessage = "<c=cyan>Your Sequencer Potion has been renamed.\nThe new name will become ";
	sMessage += "visible after an area transition or after you move the potion from one square to ";
	sMessage += "another in your inventory.</c>";
	SendMessageToPC(oCaster, sMessage);
}


string PS_GetNewSequencerPotName(object oSequencer, struct dSequencerData data){
	string sName = "";
	if (data.nMaxSpells == 3) sName += "Greater ";
	else if (data.nMaxSpells == 1) sName += "Lesser ";
	sName += "Sequencer: ";
	if (data.nSpell1 == 0) return sName;
	if (data.nSpell1 != 0) 
		sName += GetSpellName(data.nSpell1 - 1);
	if (data.nSpell2 == 0) return sName;
	if (data.nSpell2 != 0 && data.nSpell3 == 0)
		return sName + " and " + GetSpellName(data.nSpell2 - 1);
	if (data.nSpell3 != 0){
		sName += ", " + GetSpellName(data.nSpell2 - 1) + ", and ";
		sName += GetSpellName(data.nSpell3 - 1);
	}
	return sName;
}


string GetSpellName(int nId){
	int nNameRef = StringToInt(Get2DAString("spells", "Name", nId));
	return GetStringByStrRef(nNameRef);
}


void PS_DoSpellCastCheatMode(object oPC, int nId){
	// to avoid converting negative numbers to and from strings we've stored the 
	// spell ids as 1 higher than they really are, so we cast them as one lower
	AssignCommand(oPC, ActionCastSpellAtObject(nId -1, oPC, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
}


struct dSequencerData PS_GetSequencerData(object oSequencer){
	struct dSequencerData data;
	string sRef = GetResRef(oSequencer);
	if (sRef == "ps_potion_lessersequencernew") 
		data.nMaxSpells = 1;
	else if (sRef == "ps_potion_sequencernew")
		data.nMaxSpells = 2;
	else if (sRef == "ps_potion_greatersequncernew")
		data.nMaxSpells = 3;
	
	string sList = GetTag(oSequencer);
	// if it still has the original tag, it hasnt had any spells stored.
	if (sList == sRef) data.nNumSpells = 0;
	// if it has any letters in the tag, then it's not a tag full of only 
	// spell ids and delimiters, so it's "empty"
	else if (GetStringHasLetters(sList)) data.nNumSpells = 0;
	if (data.nNumSpells == 0 ){
		data.nSpell1 = 0;
		data.nSpell2 = 0;
		data.nSpell3 = 0;
		return data;
	}
	int nLength = GetStringLength(sList);
	int i;
	int nDelimCount = 0;
	string sSpell1 = "";
	string sSpell2 = "";
	string sSpell3 = "";
	string c;
	for (i = 0; i < nLength; i++){
		c = GetSubString(sList, i, 1);
		if (c != sDelim){
			if (nDelimCount == 0) sSpell1 += c;
			else if (nDelimCount == 1) sSpell2 += c;
			else sSpell3 += c;
		} else {
			nDelimCount++;
		}
	}
	data.nNumSpells = 0;
	int nTempId = StringToInt(sSpell1);
	data.nSpell1 = nTempId;
	if (nTempId > 0) data.nNumSpells++;
	nTempId = StringToInt(sSpell2);
	data.nSpell2 = nTempId;
	if (nTempId > 0) data.nNumSpells++;
	nTempId = StringToInt(sSpell3);
	data.nSpell3 = nTempId;
	if (nTempId > 0) data.nNumSpells++;
	return data;
}


int PS_GetIsNewSequencerPot(object oSequencer){
	string sRef = GetResRef(oSequencer);
	//check to make sure this is a sequencer pot
	if (sRef == "ps_potion_lessersequencernew" || sRef == "ps_potion_sequencernew" ||
		sRef == "ps_potion_greatersequncernew"){
			return TRUE;
	}	
	return FALSE;
}


int PS_GetIsOldSequencerPot(object oSequencer){
	string sRef = GetResRef(oSequencer);
	//check to make sure this is a sequencer pot
	if (sRef == "ps_potion_lessersequencer" || sRef == "ps_potion_sequencer" ||
		sRef == "ps_potion_greatersequncer"){
			return TRUE;
	}	
	return FALSE;
}


int PS_GetQualifiesForSequencer(int nId = -1){
	if (nId == -1) nId = GetSpellId();
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
	return TRUE;
}


//making sequencers have a cost based on the power of the spells stored instead of
//costing a fortume to make and then being free to store.
// this is the same for both old and new
int PS_PayForSequencerPot(object oSequencer, object oCaster = OBJECT_SELF){
	
	int nId = GetSpellId();
	int nLevel = CIGetSpellInnateLevel(nId, FALSE);
	int nGold = CIGetCraftGPCost(oCaster, nLevel, X2_CI_SEQUENCER_COSTMODIFIER);
	nGold *= GetItemStackSize(oSequencer);

	if (GetGold(oCaster) < nGold){
		FloatingTextStrRefOnCreature(STR_REF_IC_INSUFFICIENT_GOLD, oCaster); // not enough gold!
        return FALSE;
	}
	PS_TakeGoldFromCreature(nGold, oCaster);
	return TRUE;
}


int GetStringHasLetters(string sString){
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


void RenameOldSequencerPot(object oSequencer, object oCaster = OBJECT_SELF){
	int nSpell1 = GetLocalInt(oSequencer, "X2_L_SPELLTRIGGER1"); 
	int nSpell2 = GetLocalInt(oSequencer, "X2_L_SPELLTRIGGER2"); 
	int nSpell3 = GetLocalInt(oSequencer, "X2_L_SPELLTRIGGER3");
	int nNumTriggers = GetLocalInt(oSequencer, "X2_L_NUMTRIGGERS");
	string sSpell1 = GetSpellName(nSpell1 - 1);
	string sSpell2, sSpell3;
	if (nSpell2 > 0) sSpell2 = GetSpellName(nSpell2 - 1);
	if (nSpell3 > 0) sSpell3 = GetSpellName(nSpell3 - 1);
	
	string sName;
	string sRef = GetResRef(oSequencer);
	if (sRef == "ps_potion_lessersequencer") sName = "Lesser Sequencer: ";
	else if (sRef == "ps_potion_greatersequncer") sName = "Greater Sequencer: ";
	else sName = "Sequencer: ";
	
	if (nSpell2 == 0 && nSpell3 == 0){
		sName += sSpell1;
	} else if (nSpell3 == 0){
		sName += sSpell1 + " and " + sSpell2;
	} else {
		sName += sSpell1 + ", " + sSpell2 + ", and " + sSpell3;
	}
	sName += "</c>";
	SetFirstName(oSequencer, sName);
	PS_ShowSeqRenameMessage(oCaster);
	PS_SetOldSeqRecoveryTag(oSequencer);
}

// since tags are preserved when a stack is split but local variables are NOT
// copy the data from a seq pot's local ints to the tag as a string delimited by 
// underscore.
void PS_SetOldSeqRecoveryTag(object oSequencer){
	// in order to get here there must be at least 1 spell stored
	string sTag = IntToString(GetLocalInt(oSequencer, "X2_L_SPELLTRIGGER1"));
	int nSp = GetLocalInt(oSequencer, "X2_L_SPELLTRIGGER2");
	if (nSp > 0) sTag += sDelim + IntToString(nSp);
	nSp = GetLocalInt(oSequencer, "X2_L_SPELLTRIGGER3");
	if (nSp > 0) sTag += sDelim + IntToString(nSp);
	if (sTag != "") SetTag(oSequencer, sTag);
}

//retrieve the local int date from the tag
void PS_RecoverOldSequencer(object oSequencer){
	// only needed on old seq pots
	if (!PS_GetIsOldSequencerPot(oSequencer))
		return;
	string sTag = GetTag(oSequencer);
	//if tag has letters its not a tag set by above function
	// as that tag would be numbers and underscore only
	if (GetStringHasLetters(sTag))
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
	SetLocalInt(oSequencer, "X2_L_NUMTRIGGERS", nDelimCount + 1); 
	if (s1 != "") SetLocalInt(oSequencer, "X2_L_SPELLTRIGGER1", StringToInt(s1));
	if (s2 != "") SetLocalInt(oSequencer, "X2_L_SPELLTRIGGER2", StringToInt(s2));
	if (s3 != "") SetLocalInt(oSequencer, "X2_L_SPELLTRIGGER3", StringToInt(s3));
}

void RepairAllOldSeq(object oPC){
	int i = 0;
	object oItem = GetFirstItemInInventory(oPC);
	//27072 = num of items a pc could have if inv full of full bags, including the bags
    while (GetIsObjectValid(oItem) && i <= 27072){
		i++;
		PS_RecoverOldSequencer(oItem);
        oItem = GetNextItemInInventory(oPC);
    }
}