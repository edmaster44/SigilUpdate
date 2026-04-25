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

//NOTE: TODO, if using the tag to re-up local ints fixes the bug with old sequencers, then redo
// new ones to be "spell bombs" that are not self-only. If so, then make their tags
// be same format as old sequence, ie, [number of spells stored, spell 1, spell 2, spell 3]
#include "x2_inc_craft"
#include "ff_arrays"


struct dSequencerData {
	int nMaxSpells;
	int nNumSpells;
	int nSpell1;
	int nSpell2;
	int nSpell3;
};

void PS_DoSpellCastCheatMode(object oPC, int nID);
void PS_CastSpellFromNewSequencer(object oSequencer, object oCaster = OBJECT_SELF);
struct dSequencerData PS_GetSequencerData(object oSequencer);
int PS_GetIsStoreSpellOnNewSquencerPot(object oSequencer, object oCaster = OBJECT_SELF);
int PS_GetIsNewSequencerPot(object oSequencer);
int PS_GetIsOldSequencerPot(object oSequencer);
string PS_GetNameForNewSequencerPot(object oSequencer);
string PS_GetNameForOldSequencerPot(object oSequencer);
void PS_RenameSequencerPot(object oSequencer, object oCaster = OBJECT_SELF);
int PS_PayForSequencerPot(object oSequencer, object oCaster = OBJECT_SELF);
string GetSpellName(int nId);
int PS_GetQualifiesForSequencer(int nId = -1);
int GetStringHasLetters(string sString);

// main function to "store" spells on new sequencer pots by setting the tag
// to a list of spell ids
int PS_GetIsStoreSpellOnNewSquencerPot(object oSequencer, object oCaster = OBJECT_SELF){
	if (!PS_GetIsNewSequencerPot(oSequencer))
		return FALSE; 
	
	struct dSequencerData data = PS_GetSequencerData(oSequencer);
	if (data.nMaxSpells <= data.nNumSpells){
		FloatingTextStrRefOnCreature(83859, oCaster);
		return TRUE;
	}
		
	if (!PS_GetQualifiesForSequencer())
		return TRUE; 

	if (!PS_PayForSequencerPot(oSequencer, oCaster))
		return TRUE;
		
	int nId = GetSpellId();
	string sList;
	if (data.nSpell1 == -1) 
		sList = NewListOf(IntToString(nId));
	else if (data.nSpell2 == -1 && data.nMaxSpells > 1)
		sList =  NewListOf(IntToString(data.nSpell1), IntToString(nId));
	else if (data.nSpell3 == -1 && data.nMaxSpells > 2)
		sList =  NewListOf(IntToString(data.nSpell1), IntToString(data.nSpell2), IntToString(nId));
	if (sList != "") SetTag(oSequencer, sList); // bad things happen if you have an empty tag
	PS_RenameSequencerPot(oSequencer, oCaster);
	effect eVisual = EffectVisualEffect(VFX_IMP_BREACH);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oCaster);
    FloatingTextStrRefOnCreature(83884, oCaster);
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
	if (data.nSpell1 != -1) PS_DoSpellCastCheatMode(oCaster, data.nSpell1);
	if (data.nSpell2 != -1) PS_DoSpellCastCheatMode(oCaster, data.nSpell2);
	if (data.nSpell3 != -1) PS_DoSpellCastCheatMode(oCaster, data.nSpell3);
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

void PS_DoSpellCastCheatMode(object oPC, int nId){
	AssignCommand(oPC, ActionCastSpellAtObject(nId, oPC, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
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
	else {
		data.nMaxSpells = 0;
		return data;
	}
	string sList = GetTag(oSequencer);
	// if it still has the original tag, it hasnt had any spells stored.
	if (sList == sRef) data.nNumSpells = 0;
	// if it has any letters in the tag, then it's not a tag full of only 
	// spell ids and delimiters, so it's "empty"
	else if (GetStringHasLetters(sList)) data.nNumSpells = 0;
	else data.nNumSpells = GetNumberIndices(sList);
	if (data.nNumSpells == 0 ){
		data.nSpell1 = -1;
		data.nSpell2 = -1;
		data.nSpell3 = -1;
		return data;
	}
	// if we got here then the new seq pot is not empty
	data.nSpell1 = StringToInt(GetValueAtIndex(sList, 0));
	if (data.nNumSpells >= 2){
		data.nSpell2 = StringToInt(GetValueAtIndex(sList, 1));
		if (data.nNumSpells == 3)
			data.nSpell3 = StringToInt(GetValueAtIndex(sList, 2));
		else data.nSpell3 = -1;
	} else {
		data.nSpell3 = -1;
		data.nSpell2 = -1;
	}
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

string GetSpellName(int nId){
	int nNameRef = StringToInt(Get2DAString("spells", "Name", nId));
	return GetStringByStrRef(nNameRef);
}

string PS_GetNameForNewSequencerPot(object oSequencer){
	struct dSequencerData data = PS_GetSequencerData(oSequencer);
	string sName = "<c=cyan>";
	if (data.nMaxSpells == 1) sName += "Lesser ";
	else if (data.nMaxSpells == 3) sName += "Greater ";
	sName += "Sequencer: " + GetSpellName(data.nSpell1);
	if (data.nSpell2 == -1 && data.nSpell3 == -1){
		return sName + "</c>";
	} else if (data.nSpell2 != -1 && data.nSpell3 == -1){
		sName += " and " + GetSpellName(data.nSpell2);
		return sName + "</c>";
	} else {
		sName += ", " + GetSpellName(data.nSpell2) + ", and ";
		sName += GetSpellName(data.nSpell3)  + "</c>";
	}
	return sName;
}

string PS_GetNameForOldSequencerPot(object oSequencer){
	int nSpell1 = GetLocalInt(oSequencer, "X2_L_SPELLTRIGGER1"); 
	int nSpell2 = GetLocalInt(oSequencer, "X2_L_SPELLTRIGGER2"); 
	int nSpell3 = GetLocalInt(oSequencer, "X2_L_SPELLTRIGGER3");
	// if no spells stored something has gone wrong
	if (nSpell1 + nSpell2 + nSpell3 < 1) return "";
	int nNumTriggers = GetLocalInt(oSequencer, "X2_L_NUMTRIGGERS");
	string sSpell1 = GetSpellName(nSpell1 - 1);
	string sSpell2, sSpell3;
	if (nSpell2 > 0) sSpell2 = GetSpellName(nSpell2 - 1);
	if (nSpell3 > 0) sSpell3 = GetSpellName(nSpell3 - 1);
	
	string sName = "<c=cyan>";
	string sRef = GetResRef(oSequencer);
	if (sRef == "ps_potion_lessersequencer") sName += "Lesser ";
	else if (sRef == "ps_potion_greatersequncer") sName += "Greater ";
	sName += "Sequencer: ";
	
	if (nSpell2 == 0 && nSpell3 == 0){
		sName += sSpell1;
	} else if (nSpell3 == 0){
		sName += sSpell1 + " and " + sSpell2;
	} else {
		sName += sSpell1 + ", " + sSpell2 + ", and " + sSpell3;
	}
	sName += "</c>";
	return sName;
}
// used sequencer pots MUST be given specific names to prevent an exploit
// wherein an empty sequencer pot is dropped onto a full one to get all
// the spells added to it for free forever.
void PS_RenameSequencerPot(object oSequencer, object oCaster = OBJECT_SELF){
	string sName;
	if (PS_GetIsOldSequencerPot(oSequencer)) sName = PS_GetNameForOldSequencerPot(oSequencer);
	else if (PS_GetIsNewSequencerPot(oSequencer)) sName = PS_GetNameForNewSequencerPot(oSequencer);
	
	if (sName == "") return;
	SetFirstName(oSequencer, sName);
	string sMessage = "<c=cyan>Your Sequencer Potion has been renamed.\nThe new name will become ";
	sMessage += "visible after an area transition or after you move the potion from one square to ";
	sMessage += "another in your inventory.</c>";
	SendMessageToPC(oCaster, sMessage);
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