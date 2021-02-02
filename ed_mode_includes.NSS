#include "x0_i0_spells"


void ResetStealth (object oPC)
{
	SetActionMode(oPC, ACTION_MODE_STEALTH, TRUE);
	DelayCommand(0.05f, SetActionMode(oPC, ACTION_MODE_STEALTH, FALSE));
	DeleteLocalInt(oPC,"HIPSTIMER");
	DeleteLocalInt(oPC,"NOSTEALTHLOOP");
	return;
}

void RemoveStealth(object oCaster, int id)
{
	if(GetLocalInt(oCaster,"STEALTH-ID") == id) SetActionMode(oCaster, ACTION_MODE_STEALTH, FALSE);
}

void StealthTimer(object oCaster, int dur)
{
	int timer;	

	if(dur == 1) timer = 60;
	else if(dur == 2) timer = 30;
	else if(dur == 3) timer = 15;

	int id = Random(5000);
	SetLocalInt(oCaster,"STEALTH-ID",id);
	
	DelayCommand(IntToFloat(timer),RemoveStealth(oCaster, id));
	

}
void CheckStealthMode(object oPC, float count)
{
	int stealthmode = GetStealthMode(oPC);
	int hipstimer = GetLocalInt(oPC,"HIPSTIMER");
	
	if(stealthmode == STEALTH_MODE_ACTIVATED && hipstimer == 0)
	{
		SetLocalInt(oPC,"HIPSTIMER", 1);
		SetLocalInt(oPC,"NOSTEALTHLOOP", 1);
	
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY,SetEffectSpellId(ExtraordinaryEffect(EffectNWN2SpecialEffectFile("fx_invisibility")),3213),oPC, HoursToSeconds(1));
	
		int sTSetting = GetLocalInt(GetArea(oPC),"STEALTHSETTING");
		if(sTSetting > 0) StealthTimer(oPC, sTSetting);
		if(GetHasFeat(1465, oPC, TRUE))
			{
				SendMessageToPC(oPC,"Applying Swift & Silent bonus.");
				if (GetHasFeat(1772, oPC, TRUE) && !GetIsAreaInterior(GetArea(oPC))) return;
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SetEffectSpellId(EffectMovementSpeedIncrease(45), -4533), oPC, HoursToSeconds(1));
			}
	else if(GetHasFeat(1500, oPC, TRUE))
			{
				SendMessageToPC(oPC,"Applying Swift & Silent bonus.");
				if (GetHasFeat(1772, oPC, TRUE) && !GetIsAreaInterior(GetArea(oPC))) return;
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SetEffectSpellId(EffectMovementSpeedIncrease(99), -4532), oPC, HoursToSeconds(1));
			}		
	}
	}
void DervishParry(object oPC, float count)
{
	int combexp = GetActionMode(oPC,ACTION_MODE_COMBAT_EXPERTISE);
	int impcombexp = GetActionMode(oPC,ACTION_MODE_IMPROVED_COMBAT_EXPERTISE);
	int enabled = GetLocalInt(oPC,"NODERVISHPARRY");
		
	if(combexp == 1 && enabled == 0 && !GetHasSpellEffect(1929,oPC) || impcombexp == 1 && enabled == 0 && !GetHasSpellEffect(-1929,oPC)) //Activated
	{
		SetLocalInt(oPC,"NODERVISHPARRY", 1);
		RemoveAnySpellEffects(3214,oPC);
		
		int iBonus =4;

		
		
		DelayCommand(1.0f,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,SetEffectSpellId(ExtraordinaryEffect(EffectACIncrease(iBonus)),1929),oPC, HoursToSeconds(1)));
	}
	
	if(combexp == 0 && impcombexp == 0)
	{
		DeleteLocalInt(oPC,"NODERVISHPARRY");
		RemoveAnySpellEffects(1929, oPC);
	}
	
	if(GetLocalInt(oPC, "NODERVISHPARRY") == 0) return;
	
	DelayCommand(1.0f, DervishParry(oPC, 6.0f));
}
	
void main()
{
object oPC = OBJECT_SELF; 
if(GetHasFeat(433, oPC, TRUE) && GetLocalInt(oPC,"NOSTEALTHLOOP") == 0) CheckStealthMode(oPC, 6.0f); // Stealth Mode
if(GetHasFeat(3002, oPC,TRUE) && GetLocalInt(oPC,"NODERVISHPARRY") == 0) DervishParry(oPC, 6.0f); //Dervish Parry 

}