#include "x2_inc_craft"


int SequencerFullMessage(object oCaster){
	FloatingTextStringOnCreature("Sequencer already full!", oCaster); 
	return FALSE;
}

int StoreSpellOnSequencerPot(object oSequencer, object oCaster){
	
	int nId = GetSpellId();
	int nLevel = CIGetSpellInnateLevel(nId, FALSE);
	int nGold = CIGetCraftGPCost(oCaster, nLevel, X2_CI_BREWPOTION_COSTMODIFIER);
	int nStack = GetItemStackSize(oSequencer);
	nGold *= nStack;
	
	if (GetGold(oCaster) < nGold){
		FloatingTextStrRefOnCreature(STR_REF_IC_INSUFFICIENT_GOLD, oCaster); // not enough gold!
        return FALSE;
	} else {
		PS_TakeGoldFromCreature(nGold, oCaster, TRUE);
		string sNameRef = Get2DAString("spells", "Name", nId);
		string sName = GetStringByStrRef(StringToInt(sNameRef));
		string sRef = GetResRef(oSequencer);
		string sCL = IntToString(PS_GetCasterLevel());
		//LESSER SEQUENCER 1 SPELL
		if (sRef == "ps_potion_lessersequencer"){
			if (GetLocalString(oSequencer, "Spell1") != ""){
				return SequencerFullMessage(oCaster);
			}
			SetItemStackSize(oSequencer, 1);
			SetFirstName(oSequencer, "Lesser Sequencer: " + sName);
			SetDescription(oSequencer, "This potions contains:\n " + sName + " CL " + sCL);
			SetItemStackSize(oSequencer, nStack);
			SetLocalString(oSequencer, "Spell1", sName);
			return TRUE;
		//SEQUENCER 2 SPELLS
		} else if (sRef == "ps_potion_sequencer"){
			if (GetLocalString(oSequencer, "Spell1") != "" && GetLocalString(oSequencer, "Spell2") != ""){
				return SequencerFullMessage(oCaster);
			}
			SetItemStackSize(oSequencer, 1);
			if (GetLocalString(oSequencer, "Spell1") == ""){
				SetFirstName(oSequencer, "Sequencer: " + sName);
				SetDescription(oSequencer, "This potions contains:\n" + sName + " CL " + sCL);
				SetItemStackSize(oSequencer, nStack);
				SetLocalString(oSequencer, "Spell1", sName);
				return TRUE;
			} else if (GetLocalString(oSequencer, "Spell2") == ""){
				SetFirstName(oSequencer, GetFirstName(oSequencer) + " and " + sName);
				SetDescription(oSequencer, GetDescription(oSequencer) + "\n" + sName + " CL " + sCL);
				SetItemStackSize(oSequencer, nStack);
				SetLocalString(oSequencer, "Spell2", sName);
				return TRUE;
			}
		//GREATER SEQUENCER 3 SPELLS
		} else if (sRef == "ps_potion_greatersequencer"){
			if (GetLocalString(oSequencer, "Spell1") != "" && GetLocalString(oSequencer, "Spell2") != ""
				&& GetLocalString(oSequencer, "Spell3") != ""){
					return SequencerFullMessage(oCaster);
			}
			SetItemStackSize(oSequencer, 1);
			if (GetLocalString(oSequencer, "Spell1") == ""){
				SetFirstName(oSequencer, "Greater Sequencer: " + sName);
				SetDescription(oSequencer, "This potions contains:\n" + sName + " CL " + sCL);
				SetItemStackSize(oSequencer, nStack);
				SetLocalString(oSequencer, "Spell1", sName);
				SetLocalString(oSequencer, "Spell1CL", sCL);
				return TRUE;
			} else if (GetLocalString(oSequencer, "Spell2") == ""){
				SetFirstName(oSequencer, GetFirstName(oSequencer) + " and " + sName);
				SetDescription(oSequencer, GetDescription(oSequencer) + "\n" + sName + " CL " + sCL);
				SetItemStackSize(oSequencer, nStack);
				SetLocalString(oSequencer, "Spell2", sName);
				SetLocalString(oSequencer, "Spell2CL", sCL);
				return TRUE;
			} else if (GetLocalString(oSequencer, "Spell3") == ""){
				string sName1 = GetLocalString(oSequencer, "Spell1");
				string sName2 = GetLocalString(oSequencer, "Spell2");
				string sGrName = "Greater Sequencer: " + sName1 + ", " + sName2 + ", and " + sName;
				SetFirstName(oSequencer, sGrName);
				string sDesc = "This potion contains:\n";
				sDesc += sName1 + " CL " + GetLocalString(oSequencer, "Spell1CL") + "\n";
				sDesc += sName2 + " CL " + GetLocalString(oSequencer, "Spell2CL") + "\n";
				sDesc += sName + " CL " + sCL;
				SetDescription(oSequencer, sDesc);
				SetItemStackSize(oSequencer, nStack);
				SetLocalString(oSequencer, "Spell3", sName);
				return TRUE;
			}
		}
	}
	FloatingTextStringOnCreature("Unknown Sequencer", oCaster); 
	return FALSE;
}