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
	
	ClearAllActions();
	PlayCustomAnimation(OBJECT_SELF, "taunt", FALSE);
	DelayCommand(3.0f, AssignCommand(OBJECT_SELF, ActionRandomWalk()));
	string immunityString = GetLocalString(OBJECT_SELF, "Immunity_String");
	int nSpellID = GetLocalInt(OBJECT_SELF, "Spell_ID");
	SpeakString(immunityString+", "+IntToString(nSpellID), TALKVOLUME_SHOUT);
	
	GetAttentionOfHostiles(OBJECT_SELF, RADIUS_SIZE_COLOSSAL, nSpellID, immunityString);
}