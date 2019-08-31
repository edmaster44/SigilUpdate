#include "ginc_event_handlers"
#include "ps_inc_time"

void RemoveEffects(object oObj) {

	effect eVFX = GetFirstEffect(oObj);
	while (GetIsEffectValid(eVFX)) {
		RemoveEffect(oObj, eVFX);
		eVFX = GetNextEffect(oObj);
	}
	
    SetEventHandler(oObj, CREATURE_SCRIPT_ON_BLOCKED_BY_DOOR, "nw_c2_defaulte");
    SetEventHandler(oObj, CREATURE_SCRIPT_ON_DAMAGED, "nw_c2_default6");
    SetEventHandler(oObj, CREATURE_SCRIPT_ON_DEATH, "nw_c2_default7");
    SetEventHandler(oObj, CREATURE_SCRIPT_ON_DIALOGUE, "nw_c2_default4");
    SetEventHandler(oObj, CREATURE_SCRIPT_ON_DISTURBED, "nw_c2_default8");
    SetEventHandler(oObj, CREATURE_SCRIPT_ON_END_COMBATROUND, "nw_c2_default3");
    SetEventHandler(oObj, CREATURE_SCRIPT_ON_HEARTBEAT, "nw_c2_default1");
    SetEventHandler(oObj, CREATURE_SCRIPT_ON_MELEE_ATTACKED, "nw_c2_default5");
    SetEventHandler(oObj, CREATURE_SCRIPT_ON_NOTICE, "nw_c2_default2");
    SetEventHandler(oObj, CREATURE_SCRIPT_ON_RESTED, "nw_c2_defaulta");
    SetEventHandler(oObj, CREATURE_SCRIPT_ON_SPAWN_IN, "nw_c2_default9");
    SetEventHandler(oObj, CREATURE_SCRIPT_ON_SPELLCASTAT, "nw_c2_defaultb");
    SetEventHandler(oObj, CREATURE_SCRIPT_ON_USER_DEFINED_EVENT, "nw_c2_defaultd");

}

void CreateAvatar(string sAvatar, location lLoc) {
	object oAvatar = CreateObject(OBJECT_TYPE_CREATURE, sAvatar, lLoc, TRUE);
}

void SummonAvatar(object oPC) {

	object oWP = GetWaypointByTag("wp_minethys_avatar");
	effect eVFX = EffectNWN2SpecialEffectFile("fx_spell_epic_gate01");
	
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVFX, GetLocation(oWP), 8.0f);
	eVFX = EffectNWN2SpecialEffectFile("psi_ectoplasmic_summon");
	DelayCommand(0.75f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVFX, GetLocation(oWP)));
	
	DelayCommand(2.0f, CreateAvatar("ps_minethys_avatar", GetLocation(oWP)));

}

void UnstoneWarriors(object oPC) {

	PlaySound("as_pl_horngood1", TRUE);

	int nUnstoned = GetLocalInt(OBJECT_SELF, "Unstoned");
	if (nUnstoned)
		return;
	SetLocalInt(OBJECT_SELF, "Unstoned", 1);
	
	object oSound = GetNearestObjectByTag("minethys_city_battle");
	SoundObjectPlay(oSound);
	
	FloatingTextStringOnCreature("*the stone statues surrounding you slowly come to life to continue their battle*", oPC);
	
	int nSanity = 0;
	int nCreaturesFound = 0;
	float fDelay = 0.1f;
	object oObj = GetFirstObjectInShape(SHAPE_SPHERE, 50.0f, GetLocation(OBJECT_SELF));
	while (GetIsObjectValid(oObj)) {
	
		if (nSanity > 100)
			return;
			
		effect eVFX = EffectNWN2SpecialEffectFile("fx_wooden_explosion");
		if (GetLocalString(oObj, "SpawnScript") == "statue_from_creature") {
			DelayCommand(fDelay, RemoveEffects(oObj));
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oObj));
			DelayCommand(fDelay, SetPlotFlag(oObj, FALSE));
			nCreaturesFound++;
		}
	
		oObj = GetNextObjectInShape(SHAPE_SPHERE, 50.0f, GetLocation(OBJECT_SELF));
		fDelay += 0.1f;
		nSanity++;
	}
	
	if (nCreaturesFound > 1)
		DelayCommand(3.0f, SummonAvatar(oPC));

	DelayCommand(60.0f, DeleteLocalInt(OBJECT_SELF, "Unstoned"));
	DelayCommand(600.0f, SoundObjectStop(oSound));
}

void LightFires(string sWP) {

	object oWP1 = GetWaypointByTag("wp_"+sWP+"a");
	object oWP2 = GetWaypointByTag("wp_"+sWP+"b");
	object oLight1 = GetNearestObjectByTag("light_"+sWP+"a");
	object oLight2 = GetNearestObjectByTag("light_"+sWP+"b");
	
	effect eVis = EffectNWN2SpecialEffectFile("fx_ashfire_2");
	
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetLocation(oWP1), 600.0f);
	SetLightActive(oLight1, TRUE);
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetLocation(oWP2), 600.0f);
	SetLightActive(oLight2, TRUE);
	
	DelayCommand(600.0f, SetLightActive(oLight1, FALSE));
	DelayCommand(600.0f, SetLightActive(oLight2, FALSE));
	
}

void main() {

 	object oPC = GetEnteringObject();
 
 	if (!GetIsPC(oPC) && !GetIsDM(oPC))
  		return;
	//if (PS_GetTimestamp_Age_Minutes(OBJECT_SELF, "last_unstoned") < 9)
	//	return;
		
	PS_Timestamp_UNIX(OBJECT_SELF, "last_unstoned");
		
	SendMessageToPC(oPC, "Before you is a raging battle, its participants frozen in stone.");
  
 	int nRand = Random(10);
	float fDelay = 10.0f+IntToFloat(nRand);
	
	if (GetLocalInt(OBJECT_SELF, "lightfires") > 0) {
		DelayCommand(6.0f, LightFires("minethysfire_1"));
		DelayCommand(7.0f, LightFires("minethysfire_2"));
		DelayCommand(8.0f, LightFires("minethysfire_3"));
		DelayCommand(9.0f, LightFires("minethysfire_4"));
	}
	
	DelayCommand(fDelay, UnstoneWarriors(oPC));
}