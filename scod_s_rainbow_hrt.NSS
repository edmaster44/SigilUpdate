//::///////////////////////////////////////////////
//:: Rainbow Dweomer Heartbeat - for Rainbow Dweomer Spell
//:: [scod_s_rainbow_hrt.nss]
//:://////////////////////////////////////////////
//:: Workhorse script of Rainbow Dweomer. Goes on summon.
//:://////////////////////////////////////////////
//:: Mimi Fearthegn
//:: Created: 2-10-2019
//:://////////////////////////////////////////////
#include "ps0_newspells_inc"
#include "ps_inc_time"
#include "x2_inc_spellhook"
#include "x0_i0_position"

const float dweomer_closeness = 5.0f;

//The victims should move to stay in the radius
void MoveTargetToSpell(object oTarget, location lLocation) {
	AssignCommand(oTarget, ActionSpeakString("moving to the dweomer", TALKVOLUME_SHOUT));
	location lLoc = CalcSafeLocation(oTarget, lLocation, dweomer_closeness, TRUE, TRUE);
	AssignCommand(oTarget, ActionMoveToLocation(lLoc, FALSE));
}

//Get the firework effect!
string GetRandomFireworkEffect() {
	int nRandom = d12();
	switch (nRandom) {
		case 1: return "ror_firework_blue";
		case 2: return "ror_firework_blueyellow";
		case 3: return "ror_firework_green";
		case 4: return "ror_firework_grnblue";
		case 5: return "ror_firework_grnyell";
		case 6: return "ror_firework_lavendar";
		case 7: return "ror_firework_red";
		case 8: return "ror_firework_yellow";
		default: return "ror_firework_rainbow";
	}
	
	return "ror_firework_rainbow";
}

//raises the firework location into the air slightly
location GetFireworkLocation(location lLoc) {
	object oArea = GetAreaFromLocation(lLoc);
	float fOrientation = GetFacingFromLocation(lLoc);
	vector pos = GetPositionFromLocation(lLoc);
	
	pos.x += Random(3);
	pos.y += Random(3);
	pos.z += d4();
	
	return Location(oArea, pos, fOrientation);
}

void main () {

	//Remove me if there is no caster
	object oCaster = GetLocalObject(OBJECT_SELF, "Caster");
	if (!GetIsObjectValid(oCaster)) {
		DestroyObject(OBJECT_SELF, 0.1f);
	}
	
	//Remove me if the duration has run out
	int nDuration = GetLocalInt(OBJECT_SELF, "Duration");
	float fDur = RoundsToSeconds(nDuration);
	/*if (PS_GetTimestamp_Age_Seconds(OBJECT_SELF, "Rainbow_Timestamp") >= FloatToInt(fDur)) {
		DestroyObject(OBJECT_SELF, 0.1f);
	}*/
	
	//Set DC
	int nSaveDC = GetLocalInt(OBJECT_SELF, "SaveDC");
	
	//Target location
	location lTarget = GetLocation(OBJECT_SELF);
	
	//let's see a firework!
	string sEffect = GetRandomFireworkEffect();
	location lVis = GetFireworkLocation(lTarget);
	effect eVis = EffectNWN2SpecialEffectFile(sEffect);
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lVis);

	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget)) {
	
		if (GetHasSpellEffect(SPELL_RAINBOW_DWEOMER, oTarget)) {
		
			if (GetDistanceBetween(OBJECT_SELF, oTarget) > dweomer_closeness)
				MoveTargetToSpell(oTarget, lTarget);
		
		} else if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)) {
		
	        //Fire cast spell at event for the specified target
	        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_RAINBOW_DWEOMER));
	
			//You need a mind to be effected
	        if (GetIsBlind(oTarget) == FALSE) {
			
	            if (!MyResistSpell(oCaster, oTarget) && !MySavingThrow(SAVING_THROW_WILL, oTarget, nSaveDC, SAVING_THROW_TYPE_MIND_SPELLS)) {
				
	                if (!GetIsImmune(oTarget,IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF )) {
						
						effect eFasc = EffectFascinate();
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFasc, oTarget, fDur);
						SetEffectSpellId(eFasc, SPELL_RAINBOW_DWEOMER);
						
						if (GetDistanceBetween(OBJECT_SELF, oTarget) > dweomer_closeness)
							MoveTargetToSpell(oTarget, lTarget);
					
						//Make sure being damaged breaks the spell
						SetLocalString(oTarget, "DamagedScript", "scod_s_creature_distracted");
					
	                }
	            }
	        }
	    }
		
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
}