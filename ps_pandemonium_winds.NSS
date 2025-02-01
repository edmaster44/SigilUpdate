#include "ff_safevar"

#include "ps_inc_training"
#include "ps_inc_achievements"

void DecreaseSavingThrow(object oPC, int nStage) {

	if (nStage < 3)
		return;
	
	int nDecrease = 0;
	if (nStage < 6) {
		nDecrease = 2;
		SendMessageToPC(oPC, "<i>The harsh conditions of Pandemonium wear on you. . .</i>");
	} else if (nStage < 9) {
		nDecrease = 4;
		SendMessageToPC(oPC, "<i>The screaming winds of Pandemonium weaken you further. . .</i>");
	}  else if (nStage < 12) {
		nDecrease = 6;
		SendMessageToPC(oPC, "<i>The harsh conditions of Pandemonium have taken their toll on you.</i>");
	} else if (nStage < 15) {
		nDecrease = 8;
		SendMessageToPC(oPC, "<i>The screaming wind is less noticeable as you spend more time in Pandemonium. You are learning to tune it out.</i>");
	} else {
		nDecrease = 10;
		SendMessageToPC(oPC, "<i>You barely hear the wind or dripping water any more. This place finally makes sense.</i>");
	}
	
	effect eEffect = GetFirstEffect(oPC);
	while (GetIsEffectValid(eEffect)) {
	
		if (GetEffectType(eEffect) == EFFECT_TYPE_SAVING_THROW_DECREASE && GetEffectCreator(eEffect) == OBJECT_SELF) {
			RemoveEffect(oPC, eEffect);
		}
			
		eEffect = GetNextEffect(oPC);
		
	}
	
	effect eSave = EffectSavingThrowDecrease(SAVING_THROW_ALL, nDecrease);
	eSave = ExtraordinaryEffect(eSave);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSave, oPC);
	
}

//Sonic damage effect
//DC Fort 25
void DoSonicDamage(object oPC) {

	int nDam = d6(15);
	if (FortitudeSave(oPC, 25, SAVING_THROW_TYPE_SONIC, OBJECT_SELF)) {
		nDam = nDam/2;
	}
	
	effect eDam = EffectDamage(nDam, DAMAGE_TYPE_SONIC);
	ApplyEffectToObject(0, eDam, oPC);
	
	int nTimes = PS_GetLocalInt(oPC, "pandemonium_time");
	DecreaseSavingThrow(oPC, nTimes);
	PS_SetLocalInt(oPC, "pandemonium_time", nTimes+1);
	
}

//Wind damage effect
//DC Reflex 30
void DoWindEffect(object oPC) {

	int nDam = d6(8);
	if (ReflexSave(oPC, 30, SAVING_THROW_TYPE_ALL, OBJECT_SELF)) {
		nDam = nDam/2;
	}
	
	SendMessageToPC(oPC, "<i>The winds suddenly pick you up and dash you against the wall.</i>");
	effect eDam = EffectDamage(nDam, DAMAGE_TYPE_BLUDGEONING);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC);
	effect eKnock = EffectKnockdown();
	eKnock = ExtraordinaryEffect(eKnock);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oPC, 1.0f);
	
	int nTimes = PS_GetLocalInt(oPC, "pandemonium_time");
	DecreaseSavingThrow(oPC, nTimes);
	PS_SetLocalInt(oPC, "pandemonium_time", nTimes+1);
	
}

//Confusion effect
//DC Will 30
void DoConfusionEffect(object oPC) {

	int nTimes = PS_GetLocalInt(oPC, "pandemonium_time");
	if (nTimes < 3) {
		DoWindEffect(oPC);
		return;
	} else if (nTimes < 6) {
		DoSonicDamage(oPC);
		return;
	}

	int nExp = PS_GetLocalInt(oPC, "pandemonium_exp");
	if (nExp > 0) {
		if (WillSave(oPC, 30, SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF)) {
			SendMessageToPC(oPC, "<i>You think you see something in the shadows, beckoning to you, crying out. . . but you resist the siren call of the winds.</i>");
			return;
		}
	} else {
		if (GetIsTrainingSavingThrowSuccessful(oPC, SAVING_THROW_WILL, 30, SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF)) {
			PS_SetLocalInt(oPC, "pandemonium_exp", 1);
			SendMessageToPC(oPC, "<i>You think you see something in the shadows, beckoning to you, crying out. . . but you resist the siren call of the winds.</i>");
			return;
		}
	}
	
	SendMessageToPC(oPC, "<i>You see something in the shadows, beckoning to you. . it whispers secrets on the screaming winds. Suddenly, it all makes sense!</i>");		
	AddAchievement(oPC, 18);
	
	effect eConfus = EffectConfused();
	eConfus = ExtraordinaryEffect(eConfus);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConfus, oPC, 6.0f);
	
	DecreaseSavingThrow(oPC, nTimes);
	PS_SetLocalInt(oPC, "pandemonium_time", nTimes+1);
	
}

void main () {

	int nRun = PS_GetLocalInt(OBJECT_SELF, "winds_run");
	if (nRun > 5) {
		DestroyObject(OBJECT_SELF, 0.2f);
		return;
	}

	int nRand = Random(3)+1;
	object oPC = GetFirstObjectInShape(SHAPE_SPHERE, 5.0f, GetLocation(OBJECT_SELF));
	while (GetIsObjectValid(oPC)) {
	
		switch(nRand) {
			case 1:DoSonicDamage(oPC);
			case 2:DoWindEffect(oPC);
			case 3:DoConfusionEffect(oPC);
			default:DoWindEffect(oPC);
		}
		oPC = GetNextObjectInShape(SHAPE_SPHERE, 5.0f, GetLocation(OBJECT_SELF));
	}
	
	PS_SetLocalInt(OBJECT_SELF, "winds_run", nRun+1);

}