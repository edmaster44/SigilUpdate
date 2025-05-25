/***********************************************************/
// Tracks how much treasure has been taken, so that the cieling
// can start collapsing theatrically
// Mimi Feartheg - 6/30/19
/***********************************************************/
#include "ps_inc_functions"
#include "x0_i0_position"

const int MAX_STAGES = 3;

void CreateExplosion(object oPC) {

	string sVFX = "fx_rockslide";
	effect eVFX = EffectNWN2SpecialEffectFile(sVFX);
	
	location lLoc = GetRandomLocation(GetArea(oPC), oPC, RADIUS_SIZE_MEDIUM);
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVFX, lLoc);
	
	object oObj = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLoc);
	while (GetIsObjectValid(oObj)) {
		
		int nDamage = d6(12);
		if (ReflexSave(oObj, 30, SAVING_THROW_TYPE_TRAP)) {
			nDamage /= 2;
		}
		
		effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oObj);
		
		oObj = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lLoc);
	}
	
}

void CreateFinalExplosion(object oPC) {

	string sVFX = "fx_rock_collapse";
	effect eVFX = EffectNWN2SpecialEffectFile(sVFX);
	
	location lLoc = GetRandomLocation(GetArea(oPC), oPC, RADIUS_SIZE_MEDIUM);
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVFX, lLoc);
	
	object oPartyMember = GetFirstFactionMember(oPC, TRUE);
    while(GetIsObjectValid(oPartyMember) == TRUE && GetArea(oPC) == GetArea(oPartyMember)) {	
	
        int nDamage = d6(24);
		if (ReflexSave(oPartyMember, 30, SAVING_THROW_TYPE_TRAP)) {
			nDamage /= 2;
		}
		
		effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPartyMember);
		
		SendMessageToPC(oPC, "You flee out of the treasure room. . ");
		//Teleport here!
	
		oPartyMember = GetNextFactionMember(oPC, TRUE);	    
		
	}
	
}

//Start collapsing the treasure room on everyone's heads!
void CollapseRoom(object oHolder, object oPC) {

	int nStage = GetLocalInt(oHolder, "CollapseStage");
	
	if (nStage == 0) {
		SendMessageToPC(oPC, "The room shakes as you lift an item from the pile of treasure, as if in warning.");
	} else if (nStage > 0 && nStage < MAX_STAGES) {
		SendMessageToPC(oPC, "The quakes become more violent. The room is clearly unstable.");
		DelayCommand(1.0f, CreateExplosion(oPC));
	} else {
		SpeakString("*the ceiling begins to collapse around you, and you are forced to run for the stairs*");
		CreateFinalExplosion(oPC);
	}
	
	int nMax = GetLocalInt(oHolder, "MaxTreasure");
	if (nMax < MAX_STAGES) { 
		//progress 2x as fast if the party size is significantly smaller
		nStage += 1;
	}
	SetLocalInt(oHolder, "CollapseStage", nStage+1);
	
}

void main () {

	int nType = GetInventoryDisturbType();
	if (nType <= 0)
		return;
		
	object oPC = GetLastDisturbed();
	object oHolder = GetNearestObjectByTag("minethys_treasure_holder");
	object oItem = GetInventoryDisturbItem();
	
	//Get / set the max treasure threshold for this party
	//parties cannot be bigger than 6 people - sanity check
	int nMax = PS_GetNumPC(oPC);
	if (nMax > 6)
		nMax = 6;
	
	if (GetLocalInt(oHolder, "MaxTreasure") <= 0)
		SetLocalInt(oHolder, "MaxTreasure", nMax);
	nMax = GetLocalInt(oHolder, "MaxTreasure");
	
	//Get / set the current number of pieces of treasure taken
	int nCurrent = GetLocalInt(oHolder, "TreasureTaken");
	SetLocalInt(oHolder, "TreasureTaken", nCurrent+1);
	nCurrent = GetLocalInt(oHolder, "TreasureTaken");
	
	//Get / set the current number of pieces this PC has taken
	int nTaken = GetLocalInt(oPC, "TreasureTaken");
	SetLocalInt(oPC, "TreasureTaken", nTaken+1);
	nTaken = GetLocalInt(oPC, "TreasureTaken");
	
	if (nTaken > 1 || nCurrent >= nMax) {
		DestroyObject(oItem, 0.8f);
		SetLocalInt(oHolder, "CollapseStage", MAX_STAGES);
	}
	
	if (nCurrent > 0) {
		DelayCommand(1.0f, CollapseRoom(oHolder, oPC));
	}
	
	DelayCommand(900.0f, DeleteLocalInt(oHolder, "MaxTreasure"));
	DelayCommand(900.0f, DeleteLocalInt(oHolder, "TreasureTaken"));
	DelayCommand(900.0f, DeleteLocalInt(oHolder, "CollapseStage"));
	DelayCommand(900.0f, DeleteLocalInt(oPC, "TreasureTaken"));

}