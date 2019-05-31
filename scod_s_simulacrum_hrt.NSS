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
	if (PS_GetTimestamp_Age_Seconds(OBJECT_SELF, "Simulacrum_Timestamp") >= FloatToInt(fDur)) {
		RemoveHenchman(oCaster, OBJECT_SELF);
		DestroyObject(OBJECT_SELF, 0.1f);
	}
	
}