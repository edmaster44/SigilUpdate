//::///////////////////////////////////////////////
//:: Glamer Heartbeat - for Glamer and Mislead spells
//:: [scod_s_glamer_hrt.nss]
//:://////////////////////////////////////////////
//:: Workhorse script for Glamers that active attract attention
//:: Goes on the summon
//:://////////////////////////////////////////////
//:: Mimi Fearthegn
//:: Created: 2-17-2019
//:://////////////////////////////////////////////
#include "ps0_newspells_inc"
#include "ps_inc_time"
#include "x2_inc_spellhook"

void main () {

	//Remove me if there is no caster
	object oCaster = GetLocalObject(OBJECT_SELF, "Caster");
	if (!GetIsObjectValid(oCaster)) {
		DestroyObject(OBJECT_SELF, 0.1f);
	}
	
	//Remove me if the duration has run out
	float fDur = GetLocalFloat(OBJECT_SELF, "Duration");
	if (PS_GetTimestamp_Age_Seconds(OBJECT_SELF, "Glamer_Timestamp") >= FloatToInt(fDur)) {
		DestroyObject(OBJECT_SELF, 0.1f);
	}
	
	string immunityString = GetLocalString(OBJECT_SELF, "Immunity_String");
	int nSaveDC = GetLocalInt(OBJECT_SELF, "SaveDC");
	
	object oDamager = GetLastDamager();
	int nDamage = GetTotalDamageDealt();
	if (nDamage <= 0)
		return;
		
	if (WillSave(oDamager, nSaveDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster)) {
		//Mark that they're immune so they don't get pulled back in
		SetLocalInt(oDamager, immunityString, 1);
		AssignCommand(oDamager, ClearAllActions());
		if (d100() < 50) {
			AssignCommand(oDamager, ActionMoveAwayFromObject(OBJECT_SELF, FALSE, 15.0f));
		} else {
			AssignCommand(oDamager, ActionMoveToObject(oCaster, FALSE, 5.0f));
		}
	}
}