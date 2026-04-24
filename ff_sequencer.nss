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
void PS_CastSpellFromNewSequencer(object oSequencer, object oCaster);
struct dSequencerData PS_GetSequencerData(object oSequencer);
int PS_StoreSpellOnNewSquencerPot(object oSequencer, object oCaster);
int PS_GetIsNewSequencerPot(object oSequencer);
int PS_GetIsOldSequencerPot(object oSequencer);
string PS_GetNameForNewSequencerPot(object oSequencer);
string PS_GetNameForOldSequencerPot(object oSequencer);
void PS_RenameSequencerPot(object oSequencer, object oCaster);
int PS_PayForSequencerPot(object oSequencer, object oCaster);
string GetSpellName(int nId);

void PS_CastSpellFromNewSequencer(object oSequencer, object oCaster){
	struct dSequencerData data = PS_GetSequencerData(oSequencer);
	if (data.nSpell1 != -1) PS_DoSpellCastCheatMode(oCaster, data.nSpell1);
	if (data.nSpell2 != -1) PS_DoSpellCastCheatMode(oCaster, data.nSpell2);
	if (data.nSpell3 != -1) PS_DoSpellCastCheatMode(oCaster, data.nSpell3);
}

void PS_DoSpellCastCheatMode(object oPC, int nId){
	AssignCommand(oPC, ActionCastSpellAtObject(nId, oPC, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
}

int PS_StoreSpellOnNewSquencerPot(object oSequencer, object oCaster){
	if (!PS_GetIsNewSequencerPot(oSequencer))
		return TRUE; // returns true because nothing here is relevant to the 
		// spell being cast
	
	struct dSequencerData data = PS_GetSequencerData(oSequencer);
	if (data.nMaxSpells <= data.nNumSpells){
		FloatingTextStrRefOnCreature(83859, oCaster);
		return FALSE;
	}
	if (StringToInt(Get2DAString("spells", "HostileSetting", GetSpellId()))){
		FloatingTextStrRefOnCreature(83885, oCaster);
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
	if (!PS_PayForSequencerPot(oSequencer, oCaster))
		return FALSE;
	int nId = GetSpellId();
	string sList;
	if (data.nSpell1 == -1) 
		sList = NewListOf(IntToString(nId));
	else if (data.nSpell2 == -1 && data.nMaxSpells > 1)
		sList =  NewListOf(IntToString(data.nSpell1), IntToString(nId));
	else if (data.nSpell3 == -1 && data.nMaxSpells > 2)
		sList =  NewListOf(IntToString(data.nSpell1), IntToString(data.nSpell2), IntToString(nId));
		
	SetTag(oSequencer, sList);
	PS_RenameSequencerPot(oSequencer, oCaster);
	effect eVisual = EffectVisualEffect(VFX_IMP_BREACH);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oCaster);
    FloatingTextStrRefOnCreature(83884, oCaster);
	return TRUE;
}

struct dSequencerData PS_GetSequencerData(object oSequencer){
	string sList = GetTag(oSequencer);
	struct dSequencerData data;
	string sRef = GetResRef(oSequencer);
	if (sRef == "ps_potion_lessersequencernew") 
		data.nMaxSpells = 1;
	else if (sRef == "ps_potion_sequencernew")
		data.nMaxSpells = 2;
	else if (sRef == "ps_potion_greatersequncernew")
		data.nNumSpells = 3;
	else {
		data.nMaxSpells = -1;
		return data;
	}
	data.nNumSpells = GetNumberIndices(sList);
	if (data.nNumSpells == 0){
		data.nSpell1 = -1;
		data.nSpell2 = -1;
		data.nSpell3 = -1;
		return data;
	}
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
	string sNameRef = Get2DAString("spells", "Name", nId);
	return GetStringByStrRef(StringToInt(sNameRef));
}

string PS_GetNameForNewSequencerPot(object oSequencer){
	struct dSequencerData data = PS_GetSequencerData(oSequencer);
	string sName = "<c=cyan>";
	if (data.nMaxSpells == 1) sName += "Lesser ";
	else if (data.nMaxSpells == 3) sName += "Greater ";
	sName += "Sequencer: " + GetSpellName(data.nSpell1);
	if (data.nSpell2 == -1 && data.nSpell3 == -1){
		return sName + "</c>";
	} else if (data.nSpell3 == -1){
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
	int nNumberOfTriggers = GetLocalInt(oSequencer, "X2_L_NUMTRIGGERS");
	int nStack = GetItemStackSize(oSequencer);
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
// the spells added to it for free.
void PS_RenameSequencerPot(object oSequencer, object oCaster){
	string sName;
	if (PS_GetIsOldSequencerPot(oSequencer)) sName = PS_GetNameForOldSequencerPot(oSequencer);
	else if (PS_GetIsNewSequencerPot(oSequencer)) sName = PS_GetNameForNewSequencerPot(oSequencer);
	if (sName == "") return;
	SetFirstName(oSequencer, sName);
	string sMessage = "Your Sequencer Potion has been renamed.\nThe new name will become visible ";
	sMessage += "after an area transition.";
	SendMessageToPC(oCaster, sMessage);
}

int PS_PayForSequencerPot(object oSequencer, object oCaster){
	
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