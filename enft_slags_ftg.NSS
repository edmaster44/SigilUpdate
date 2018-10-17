#include "enft_heat_rlf"
#include "enft_cnsts"
#include "nw_i0_spells"
#include "x0_i0_transport"
#include "ps_inc_spawns"
#include "ps_inc_faction"

//Random warning message
string KadyxMessage() {
	int nRandom = Random(8);
	switch(nRandom) {
		case 0: return "<C=Gray>You catch a wiff of cinnamon on the breeze.";
		case 1: return "<C=Gray>A strong sulphur smell assaults your senses.";
		case 2: return "<C=Gray>You spot some movement in the gravely soil, as if a large snake-like creature were slithering beneath";
		case 3: return "<C=Gray>You catch sight of some movement out of the corner of your eye.";
		case 4: return "<C=Gray>Something is watching you.";
		case 5: return "<C=Gray>The spicy scent of cinnamon fills the air.";
		case 6: return "<C=Gray>You spot a dull black scale on the ground.";
		case 7: return "<C=Gray>You could have sworn you saw a large reptilian tail slink farther into the shadows of that ruin. . .";
	}
	return "<C=Gray>You catch a wiff of cinnamon on the breeze.";
}

//Kadyx Warning Message
void KadyxApproachMessage(object oPC, int nKadyx) {
	string sMessage = KadyxMessage();
	object oPlayer = GetFirstFactionMember(oPC, TRUE);
	while (GetIsObjectValid(oPlayer)) {
		if (GetLocalInt(GetArea(oPlayer), "ENV_FATIGUE_AREA") == 5) { //Is in the slags
			SendMessageToPC(oPlayer, sMessage);
			int pcKadyx = GetLocalInt(oPlayer, "KadyxCount");
			if (pcKadyx < nKadyx)
				SetLocalInt(oPlayer, "KadyxCount", nKadyx);
		}
		oPlayer = GetNextFactionMember(oPC, TRUE);
	}
}

//Kadyx eating effect
void KadyxEats(object oPC) {

	object oWP = GetWaypointByTag("ps_death_respawn_wp");
	effect eKnock = EffectKnockdown();
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oPC, 2.0f);
	int nDam = FloatToInt(IntToFloat(GetCurrentHitPoints(oPC))*0.8f);
	effect eDam = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL, TRUE);
	
	object obj = CreateObject(OBJECT_TYPE_PLACEABLE, "ps_slags_kadyxstain", GetLocation(oPC));
	SetFirstName(obj, "Pool of "+GetName(oPC)+"'s Blood");
	
	DelayCommand(0.6f, SendMessageToPC(oPC, "<C=Gray>Your senses are suddenly overwhelmed with the scent of cinnamon and sulphur. Then you feel a sharp pain as something attacks you from behind. . ."));
	DelayCommand(0.8f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC));
	DelayCommand(1.0f, SendMessageToPC(oPC, "<C=Gray>You wake up in the Mortuary, with grevious wounds."));
	DelayCommand(1.1f, TransportToWaypoint(oPC, oWP));
}

//The Kadyx is here. You are being eaten.
void KadyxArrives(object oPC) {
	location lLoc = GetLocation(oPC);
	object oPlayer = GetFirstObjectInShape(SHAPE_SPHERE, 20.0f, lLoc, TRUE);
	while(GetIsObjectValid(oPlayer)) {
		if (GetIsPC(oPlayer)) {
			if (GetLocalInt(GetArea(oPlayer), "ENV_FATIGUE_AREA") == 5) //Only happens in the Slags
				KadyxEats(oPlayer);
		}
		oPlayer = GetNextObjectInShape(SHAPE_SPHERE, 20.0f, lLoc, TRUE);
	}
}

//sp_earthquake might be needed
void Earthquake(object oPC) {
	location lLoc = GetLocation(oPC);
	effect eVFX = EffectVisualEffect(VFX_SPELL_HIT_EARTHQUAKE);
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVFX, lLoc, 1.0f);
	
	object oCreature = GetFirstObjectInShape(SHAPE_SPHERE, 10.0f, lLoc, TRUE);
	while(GetIsObjectValid(oCreature)) {
		SendMessageToPC(oCreature, "<C=Gray>The ground beneath your feet gives way as a mini-earthquake hits your vicinity.");
		effect eDam = EffectDamage(d4(2), DAMAGE_TYPE_BLUDGEONING);
		if (!ReflexSave(oCreature, 15, SAVING_THROW_TYPE_TRAP)) {
			effect eKnock = EffectKnockdown();
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oPC, 1.0f);
		}
		oCreature = GetNextObjectInShape(SHAPE_SPHERE, 10.0f, lLoc, TRUE);
	}
}

void VargouilleSwarm(object oPC) {
	float fLow = 6.0f;
	float fHigh = 10.0f;

  	float avg = PS_GetAvgPartylevel(oPC,PS_GetMaxPartylevel(oPC));
	int iDiff = PS_GetDifficulty(oPC);
	
	location lLoc = FindHenchSpawnPoint(oPC);
	effect eVFX = EffectNWN2SpecialEffectFile("fx_wooden_explosion_big");
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVFX, lLoc, 0.5f);
		
	string mod = "";
	if(fLow==0.0f || fHigh==0.0f || iDiff == DIFFLOW)
		mod="";
	else if(avg>fLow && avg<fHigh && iDiff == DIFFNORM)
		mod="2";
	else if(avg>=fHigh || iDiff == DIFFHIGH || iDiff == DIFFVERY)
		mod="3";
		   
	int iEliteChance = 97;
	if (iDiff == DIFFHIGH)
		iEliteChance = 95;
	else if (iDiff == DIFFVERY)
		iEliteChance = 90;
		
	int num = PS_GetNumPC(oPC);
		   
	SpawnMonsterAtLocation(OBJECT_SELF, "ps_slags_vargouille", lLoc, avg, iEliteChance, mod);
	if (num >= 2)
		SpawnMonsterAtLocation(OBJECT_SELF, "ps_slags_vargouille", lLoc, avg, iEliteChance, mod);
	if (num >= 3)
		SpawnMonsterAtLocation(OBJECT_SELF, "ps_slags_vargouille", lLoc, avg, iEliteChance, mod);
	if (d100() < 50)
		SpawnMonsterAtLocation(OBJECT_SELF, "ps_slags_vargouille", lLoc, avg, iEliteChance, mod);
}

void main () {

	if (!CanRunEnvironmentLoop("slags_timestamp", slagsTime))
		return;
	
	if(GetLocalInt(GetArea(OBJECT_SELF), "ENV_FATIGUE_AREA") != 5) {
        SetLocalInt(OBJECT_SELF, "KadyxCount", 0);
		return;
	}
	
	int nKadyx = GetLocalInt(OBJECT_SELF, "KadyxCount");
	int nKadyxComes = GetLocalInt(OBJECT_SELF, "KadyxComing");
	if (nKadyx == nKadyxComes) {
		KadyxArrives(OBJECT_SELF);
	} else if (nKadyx == (nKadyxComes-1) || nKadyx == (nKadyxComes-3) || nKadyx == (nKadyxComes-5)) {
		KadyxApproachMessage(OBJECT_SELF, nKadyx);
	} else { 
		//No Kadyx, let's do other things!
		int nRand = d100();
		if (nRand < 50) {
			Earthquake(OBJECT_SELF);
		} else {
			VargouilleSwarm(OBJECT_SELF);
		}
	}
	

	SetLocalInt(OBJECT_SELF, "KadyxCount", nKadyx+1);
    DelayCommand(slagsTime, ExecuteScript("enft_slags_ftg", OBJECT_SELF));

}