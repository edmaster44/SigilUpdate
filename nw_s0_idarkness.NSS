//::///////////////////////////////////////////////
//:: Invocation: Darkness
//:: NW_S0_IDarkness.nss
//:://////////////////////////////////////////////
/*
    Summons a series of creatures to help the caster fight enemies
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: June 19, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Mimi Fearthegn 7/26/20 - Turned this into Call of the Beast

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook" 
#include "ps_inc_onhit"
//const string abilityCaster = "abilityCaster";

//picks out the right creature resref for area / hd
string GetCreatureResref(object oPC, int nHD);

//Spawns in the actual creature and assigns variables
void SpawnInSummon(object oPC, string sResRef);

//Defines the summon appearance (randomizes animal type + gives vfx)
void SetSummonAppearance(object oPC, object oSummon);

//Remember how many creatures we have around! And renumber if necessary
void CheckNumberOfBeasts(object oPC);

//Pull all beasts to the caster
void PullBeastsToMe(object oPC);

void main() {

	/* 
	  Spellcast Hook Code 
	  Added 2003-06-23 by GeorgZ
	  If you want to make changes to all spells,
	  check x2_inc_spellhook.nss to find out more
	*/
    if (!X2PreSpellCastCode()) {
		// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	
    //Declare major variables
	object oCaster = OBJECT_SELF;
	int nCasterLevel = GetWarlockCasterLevel(oCaster);
	
	int nCreatures = 1+(nCasterLevel/5);
	int nHD = 1+(nCasterLevel/2);
	
	//SendMessageToPC(oCaster, "Summoning "+IntToString(nCreatures)+" creatures of "+IntToString(nHD)+" HD");
	
	WriteTimestampedLogEntry(GetName(oCaster)+" is casting Call of the Beast.");
	
	string sCreature = GetCreatureResref(oCaster, nHD);
	//SendMessageToPC(oCaster, "Chosen creature: "+sCreature);

	//Sanity checker
	CheckNumberOfBeasts(oCaster);

	int nNumberCalled = GetLocalInt(oCaster, "WARLOCK_ANIMALS_CALLED");
	
	if (nNumberCalled > 0) {
		PullBeastsToMe(oCaster);
	}
	
	if (nNumberCalled >= nCreatures) {
		SendMessageToPC(oCaster, "You have already called "+IntToString(nNumberCalled)+" beasts. You will receive no more aid at this time.");
		return;
	} else {
		nCreatures -= nNumberCalled;
	}
	
	float fDelay = 0.0f;
	int nSpawned = 0;
	
	for (nSpawned = 0; nSpawned < nCreatures; nSpawned++) {
		DelayCommand(fDelay, SpawnInSummon(oCaster, sCreature));
		fDelay += 0.5f;
	}
	
}

void PullBeastsToMe(object oPC) {

	int n;
	int nNumberCalled = GetLocalInt(oPC, "WARLOCK_ANIMALS_CALLED");
	for(n = 0; n <= nNumberCalled; n++) {
		object oSummon = GetLocalObject(oPC, "WARLOCK_ANIMAL_"+IntToString(n));
		if (GetIsObjectValid(oSummon) && !GetIsDead(oSummon)) {
			//SendMessageToPC(oPC, "Snagging beast "+GetFirstName(oSummon));
		    AssignCommand(oSummon, ClearAllActions());
		    AssignCommand(oSummon, JumpToLocation(GetLocation(oPC)));
		}
	}
	
}

void CheckNumberOfBeasts(object oPC) {
	
	int nNumberCalled = GetLocalInt(oPC, "WARLOCK_ANIMALS_CALLED");
	int currentNumber = 0;

	int n;
	for(n = 0; n <= nNumberCalled; n++) {
		object oSummon = GetLocalObject(oPC, "WARLOCK_ANIMAL_"+IntToString(n));
		if (GetIsObjectValid(oSummon) && !GetIsDead(oSummon)) {
			currentNumber++;
		}
	}

	SetLocalInt(oPC, "WARLOCK_ANIMALS_CALLED", currentNumber);

	int newCount = 0;
	if (currentNumber != nNumberCalled) {
		for(n = 0; n <= nNumberCalled; n++) {
			object oSummon = GetLocalObject(oPC, "WARLOCK_ANIMAL_"+IntToString(n));
			if (GetIsObjectValid(oSummon) && !GetIsDead(oSummon)) {
				SetLocalObject(oPC, "WARLOCK_ANIMAL_"+IntToString(newCount), oSummon);
				newCount++;
			} else {
				DeleteLocalObject(oPC, "WARLOCK_ANIMAL_"+IntToString(n));
			}
		}
	}

}

void SpawnInSummon(object oPC, string sResRef) {

	//SendMessageToPC(oPC, "Creating "+sResRef);

	location lTarget = CalcSafeLocation(oPC, GetLocation(oPC), 8.0f, TRUE, FALSE);
	if (!GetIsLocationValid(lTarget)) {
		SendMessageToPC(oPC, "Nearby location not found to spawn one of the beasts. Cast the spell in a more open location.");
		return;
	}
	
	effect eVFX = EffectNWN2SpecialEffectFile("fx_teleport_new");
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVFX, lTarget);
	
	object oCreature = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lTarget);
	SetLocalObject(oCreature, abilityCaster, oPC);
	SetLocalObject(oCreature, "FOLLOW_MASTER", oPC);
	SetLocalInt(oCreature, "IS_SUMMONED", 1);
	SetSummonAppearance(oPC, oCreature);

	int nNumberCalled = GetLocalInt(oPC, "WARLOCK_ANIMALS_CALLED");
	SetLocalObject(oPC, "WARLOCK_ANIMAL_"+IntToString(nNumberCalled), oCreature);
	SetLocalInt(oPC, "WARLOCK_ANIMALS_CALLED", nNumberCalled+1);
}

void SetSummonAppearance(object oPC, object oSummon) {
	
	string sTemplate = "Fiendish ";
	effect eVFX;
	if (GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL || GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL) {		
		eVFX = EffectNWN2SpecialEffectFile("fx_animus");
		sTemplate = "Fiendish ";
	} else {
		eVFX = EffectNWN2SpecialEffectFile("fx_telthor_s");
		sTemplate = "Fey ";
	}
		
	int nAppearance = APPEARANCE_TYPE_BADGER;
	
	if (GetHitDice(oSummon) < 3) {
		//small critter set
		int nRand = Random(8)+1;
		switch(nRand) {
			case 1: nAppearance = APPEARANCE_TYPE_BADGER; SetFirstName(oSummon, sTemplate+"Badger"); break;
			case 2: nAppearance = APPEARANCE_TYPE_BAT; SetFirstName(oSummon, sTemplate+"Bat");  break;
			case 3: nAppearance = APPEARANCE_TYPE_DEER; SetFirstName(oSummon, sTemplate+"Deer");  break;
			case 4: nAppearance = APPEARANCE_TYPE_RAT_DIRE; SetFirstName(oSummon, sTemplate+"Rat");  break;
			case 5: nAppearance = 2307; SetFirstName(oSummon, sTemplate+"Badger");  break;
			case 6: nAppearance = 1502; SetFirstName(oSummon, sTemplate+"Snake");  break;
			case 7: nAppearance = 1504; SetFirstName(oSummon, sTemplate+"Stirge");  break;
		}
	} else {
		//large critter set
		int nRand = Random(9)+1;
		switch(nRand) {
			case 1: nAppearance = APPEARANCE_TYPE_BEAR_BROWN; SetFirstName(oSummon, sTemplate+"Bear"); break;
			case 2: nAppearance = APPEARANCE_TYPE_BOAR; SetFirstName(oSummon, sTemplate+"Boar"); break;
			case 3: nAppearance = APPEARANCE_TYPE_BEETLE_STAG; SetFirstName(oSummon, sTemplate+"Beetle"); break;
			case 4: nAppearance = APPEARANCE_TYPE_DOG_WOLF; SetFirstName(oSummon, sTemplate+"Wolf"); break;
			case 5: nAppearance = 2322; SetFirstName(oSummon, sTemplate+"Dinosaur"); break;
			case 6: nAppearance = 2324; SetFirstName(oSummon, sTemplate+"Tiger"); break;
			case 7: nAppearance = 2325; SetFirstName(oSummon, sTemplate+"Lion"); break;
			case 8: nAppearance = 2326; SetFirstName(oSummon, sTemplate+"Lion"); break;
			case 9: nAppearance = 2327; SetFirstName(oSummon, sTemplate+"Manticore"); break;
		}
	}
	
	WriteTimestampedLogEntry("Call of the beast appearance set to "+IntToString(nAppearance));
		
	SetCreatureAppearanceType(oSummon, nAppearance);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX, oSummon);
}

string GetCreatureResref(object oPC, int nHD) {
	
	if (nHD <= 2)
		nHD = 1;
	else if (nHD <= 5)
		nHD = 2;
	else if (nHD <= 8)
		nHD = 3;
	else if (nHD <= 11)
		nHD = 4;
	else
		nHD = 5;
	
	if (GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL || GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
		return "ps_summon_warlockfiend_"+IntToString(nHD);
	else
		return "ps_summon_warlockfey_"+IntToString(nHD);

}