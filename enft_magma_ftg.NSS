#include "ff_safevar"

#include "enft_heat_rlf"
#include "enft_cnsts"
#include "nw_i0_spells"
#include "ps_ship_generic_inc"

int magmaRelief(object oPC) {
	if (GetLevelByClass(63, oPC) > 2)
		return TRUE;
	if (GetSubRace(oPC) == 242)
		return TRUE;
		
	if (GetSubRace(oPC) == RACIAL_SUBTYPE_UNDEAD) //Undead don't breathe
		return TRUE;
	if (GetSubRace(oPC) == RACIAL_SUBTYPE_CONSTRUCT) //Constructs don't breathe
		return TRUE;
	if (GetSubRace(oPC) == RACIAL_SUBTYPE_AIR_GENASI) //Air Genasi don't breathe
		return TRUE;
		
	// Check if Avoid Planar Effects is on the oPC
    if(GetHasSpellEffect(1390, oPC))
    	return TRUE;
		
	return FALSE;
}

//Checks to see if the fire gout should do non-resistable damage
int fireGoutReflexSave(object oPC) {

	if (GetLevelByClass(63, oPC) > 2)
		return TRUE;
	if (GetSubRace(oPC) == 242) //Jann
		return TRUE;
	if (GetSubRace(oPC) == 122) //Efreet
		return TRUE;
	if (GetSubRace(oPC) == 223) //Red Dragon
		return TRUE;
	if (GetSubRace(oPC) == 202) //Fire Giant
		return TRUE;
	if (GetSubRace(oPC) == 120) //Azer
		return TRUE;
		
	// Check if Avoid Planar Effects is on the oPC
    if(GetHasSpellEffect(1390, oPC))
    	return TRUE;
		
	if (ReflexSave(oPC, 20, SAVING_THROW_TYPE_FIRE)) 
		return TRUE;
		
	return FALSE;

}

void main()
{
    int heatDamage;         // Subdual damage from freezing
    int newHeatDamage;      // New subdual damage from freezing
    int pastThrows;         // Number of throws already attempted
    int beforeHP, afterHP;
    effect eff;
	
	int lastRun = PS_GetLocalInt(OBJECT_SELF, "magma_timestamp");
	float diff = IntToFloat(abs(TimeStampT()-lastRun));
	if (diff < heatTime)
		return;
	PS_SetLocalInt(OBJECT_SELF, "magma_timestamp", ShipTimeStamp());
	pastThrows = PS_GetLocalInt(OBJECT_SELF, "MAGMA_THROWS");
	
	if(PS_GetLocalInt(GetArea(OBJECT_SELF), "ENV_FATIGUE_AREA") != 4)
    {
        PS_SetLocalInt(OBJECT_SELF, "MAGMA_THROWS", 0);
		return;
	}
	
	if (!magmaRelief(OBJECT_SELF)) {
		int nDamage = d4();
		if (pastThrows > 5)
			nDamage = d6();
		else if (pastThrows > 10)
			nDamage = d6(2);
		else if (pastThrows > 15)
			nDamage = d6(3);
			
		effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
		ApplyEffectToObject(0, eDam, OBJECT_SELF);	
	} else {
        PS_SetLocalInt(OBJECT_SELF, "MAGMA_THROWS", 0);		
	}
	
	//Random Flame Gout
	if (d100() < 10) { //every PC should encounter a flame gout every 5 minutes
		effect eVis = EffectNWN2SpecialEffectFile("vfx_rds_poipflamejet");
		ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetLocation(OBJECT_SELF), 0.5f);
		
		int nGoutDamage = d6(6);
		if (fireGoutReflexSave(OBJECT_SELF)) {
			effect eDam = EffectDamage(nGoutDamage, DAMAGE_TYPE_FIRE);
			ApplyEffectToObject(0, eDam, OBJECT_SELF);	
		} else {
			effect eDam = EffectDamage(nGoutDamage/2, DAMAGE_TYPE_FIRE);
			ApplyEffectToObject(0, eDam, OBJECT_SELF);
			//half of the damage will punch through resistance here
			eDam = EffectDamage(nGoutDamage/2, DAMAGE_TYPE_FIRE, DAMAGE_POWER_ENERGY, TRUE);
			ApplyEffectToObject(0, eDam, OBJECT_SELF);		
		}
	}

    // Increase the number of throws done
    PS_SetLocalInt(OBJECT_SELF, "MAGMA_THROWS", pastThrows + 1);

    // Check for heat damage in an hour.
    DelayCommand(magmaTime, ExecuteScript("enft_magma_ftg", OBJECT_SELF));
}