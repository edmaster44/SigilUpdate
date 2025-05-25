

#include "enft_heat_rlf"
#include "enft_cnsts"
#include "nw_i0_spells"
#include "ps_ship_generic_inc"

void main()
{
    int heatDamage;         // Subdual damage from freezing
    int newHeatDamage;      // New subdual damage from freezing
    int pastThrows;         // Number of throws already attempted
    int beforeHP, afterHP;
    effect eff;
	
	int lastRun = GetLocalInt(OBJECT_SELF, "heat_timestamp");
	float diff = IntToFloat(abs(TimeStampT()-lastRun));
	if (diff < heatTime)
		return;
	SetLocalInt(OBJECT_SELF, "heat_timestamp", ShipTimeStamp());
	pastThrows = GetLocalInt(OBJECT_SELF, "HEAT_THROWS");
	
	if(GetLocalInt(GetArea(OBJECT_SELF), "ENV_FATIGUE_AREA") != 2)
    {
        SetLocalInt(OBJECT_SELF, "HEAT_THROWS", 0);
		return;
	}
	
	if (!heatRelief(OBJECT_SELF)) {
		int nDamage = d4();
		if (pastThrows > 5)
			nDamage = d6();
		else if (pastThrows > 10)
			nDamage = d6(2);
		else if (pastThrows > 15)
			nDamage = d6(3);
			
		effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
		ApplyEffectToObject(0, eDam, OBJECT_SELF);	
	} else {
        SetLocalInt(OBJECT_SELF, "HEAT_THROWS", 0);		
	}

    // Increase the number of throws done
    SetLocalInt(OBJECT_SELF, "HEAT_THROWS", pastThrows + 1);

    // Check for heat damage in an hour.
    DelayCommand(heatTime, ExecuteScript("enft_heat_ftg", OBJECT_SELF));
}