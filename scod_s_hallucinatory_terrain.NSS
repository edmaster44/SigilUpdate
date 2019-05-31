//::///////////////////////////////////////////////
//:: Hallucinatory Terrain
//:: [scod_s_hallucinatory_terrain.nss]
//:://////////////////////////////////////////////
//:: Creates an area of effect which imposes movement speed penalties on 
//:: hostiles, and provides cover to your friends
//:://////////////////////////////////////////////
//:: Mimi Fearthegn
//:: Created: 2-17-2019
//:://////////////////////////////////////////////
#include "ps0_newspells_inc"
#include "ps_inc_time"
#include "x0_i0_position"

void main() {

	//Spellhook script
    if (!X2PreSpellCastCode()) {
        return;
    }

	//debug code to make sure we got here
	object oCaster = OBJECT_SELF;
	
	//Checking that we don't have one already
	if (GetLocalString(oCaster, "HallucinatoryTerrainTag") != "") {
		string sTag = GetLocalString(oCaster, "HallucinatoryTerrainTag");
		if (GetIsObjectValid(GetNearestObjectByTag(sTag))) {
			SendMessageToPC(oCaster, "You may not have more than one Hallucinatory Terrain active at a time!");
			return;
		}
	}
	string sHallucinatoryTag = "AOE_"+IntToString(Random(10000));
	SetLocalString(oCaster, "HallucinatoryTerrainTag", sHallucinatoryTag);
	
    //Declare major variables
    location lTarget = GetSpellTargetLocation();
    int nCasterLvl = GetCasterLevel(oCaster);

	//Extend Metamagic
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = nCasterLvl;
    //check meta magic for extend
    if (nMetaMagic == METAMAGIC_EXTEND) {
        nDuration *= 2;
    }
	float fDur = HoursToSeconds(nDuration);
	
	effect eVFX = EffectNWN2SpecialEffectFile("fx_okku_den_fog");
	
	effect eAOE = EffectAreaOfEffect(VFX_PER_HALLUCINATORY_TERRAIN, "scod_s_hallucinatory_one", "", "scod_s_hallucinatory_onex", sHallucinatoryTag);
	eAOE = EffectLinkEffects(eVFX, eAOE);
	
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDur);
	
	//Scatter phantom trees!
	int n = 0;
	for (n = 0; n < 6; n++) {
		int rand = d4();
		string sFX = "";
		switch (rand) {
			case 1: sFX = "fx_hallucinatory_tree1"; break;
			case 2: sFX = "fx_hallucinatory_tree2"; break; 
			case 3: sFX = "fx_hallucinatory_tree3"; break; 
			case 4: sFX = "fx_hallucinatory_tree4"; break; 
			default: sFX = "fx_hallucinatory_tree1"; break;
		}
		
		eVFX = EffectNWN2SpecialEffectFile(sFX);
		SetEffectSpellId(eVFX, SPELL_HALLUCINATORY_TERRAIN);
		float fDis = IntToFloat(Random(7))+3.0f;
		location lRand = GetRandomLocation(GetArea(oCaster), oCaster, fDis);
		ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVFX, lRand, fDur);
	}
	
	DelayCommand(RoundsToSeconds(nDuration), DeleteLocalInt(oCaster, "HallucinatoryActive"));
}