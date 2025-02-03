#include "enft_heat_rlf"
#include "enft_cnsts"
#include "nw_i0_spells"
#include "ps_ship_generic_inc"

int carceriRelief(object oPC) {
		
	// Check if Avoid Planar Effects is on the oPC
    if(GetHasSpellEffect(1390, oPC))
    	return TRUE;
		
	return FALSE;
}

void main() {

	int nAcidThrows = GetLocalInt(OBJECT_SELF, "CarceriAcid");
	float carceriTime = 60.0f;
	
	int lastRun = GetLocalInt(OBJECT_SELF, "porphatys_timestamp");
	float diff = IntToFloat(abs(TimeStampT()-lastRun));
	if (diff < carceriTime)
		return;
		
	SetLocalInt(OBJECT_SELF, "porphatys_timestamp", ShipTimeStamp());
	
	if(GetLocalInt(GetArea(OBJECT_SELF), "ENV_FATIGUE_AREA") != 6) {
		DeleteLocalInt(OBJECT_SELF, "CarceriAcid");
		return;
	}
	
	if (!carceriRelief(OBJECT_SELF)) {
		int nDamage = d6(6);
			
		SendMessageToPC(OBJECT_SELF, "<i>The acid snow of Carceri burns your skin.");
		effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
		ApplyEffectToObject(0, eDam, OBJECT_SELF);	
		if (nAcidThrows > 10) {
			SendMessageToPC(OBJECT_SELF, "<i>The acid snow of Carceri eats through your resistances.");
			eDam = EffectDamage(nDamage/2, DAMAGE_TYPE_ACID, DAMAGE_POWER_NORMAL, TRUE);
			ApplyEffectToObject(0, eDam, OBJECT_SELF);	
		} else if (nAcidThrows > 5) {
			SendMessageToPC(OBJECT_SELF, "<i>The acid snow of Carceri starts to eat through your resistances.");
			eDam = EffectDamage(nDamage/3, DAMAGE_TYPE_ACID, DAMAGE_POWER_NORMAL, TRUE);
			ApplyEffectToObject(0, eDam, OBJECT_SELF);	
		}
		
		nAcidThrows++;
		SetLocalInt(OBJECT_SELF, "CarceriAcid", nAcidThrows);
	} else {
		DeleteLocalInt(OBJECT_SELF, "CarceriAcid");
	}

    // Check for heat damage in an hour.
    DelayCommand(carceriTime, ExecuteScript("enft_porphatys_ftg", OBJECT_SELF));
}