/*/////////////////////////////////////////////////////////*/
/*
/*	Handles SCOD's animated traps
/*	Mimi Fearthegn 5/31/19
/*
/*/////////////////////////////////////////////////////////*/
#include "ps_inc_training"
#include "x0_i0_transport"

void ResetTrap(object oTrap);

void TriggerTrapOn(object oTrap, object oVic);

void main () {
	
	//The type of the trap trigger
	//1 == the spot trigger
	//2 == the damage trigger
	//3 == the disarm object function
	int nType = GetLocalInt(OBJECT_SELF, "TRAP_TRIGGER_TYPE");
	int nIsRocks = GetLocalInt(OBJECT_SELF, "TRAP_IS_ROCKS"); //handles rocks fall version

	object oPC;
	if (nType == 3) {
		oPC	= GetLastUsedBy();
		if (GetIsDM(oPC)) //don't trigger on DM's, just PCs / NPCs
			return;
	} else {
		oPC	= GetEnteringObject();
		if (GetIsDM(oPC)) //don't trigger on DM's, just PCs / NPCs
			return;
	} 

	string sTrapTag = GetLocalString(OBJECT_SELF, "PLC_TRAP");
	string sDisarmTag = GetLocalString(OBJECT_SELF, "PLC_TRAP_DISARM");
	
	int nDisarmDC = GetLocalInt(OBJECT_SELF, "DC_DISARM_TRAP");
	int nSpotDC = GetLocalInt(OBJECT_SELF, "DC_SPOT_TRAP");
	float fReset = GetLocalFloat(OBJECT_SELF, "TRAP_RESET_TIME");
	float fRadius = GetLocalFloat(OBJECT_SELF, "TRAP_DAMAGE_RADIUS");
	
	object oTrap = GetNearestObjectByTag(sTrapTag);
	object oDisarm = GetNearestObjectByTag(sDisarmTag);
	
	int nInactive = GetLocalInt(oTrap, "TRAP_INACTIVE");
	if (nInactive) 
		return;

	if (nType == 1) {
	
		int nDone = GetLocalInt(oPC, "spot_"+sTrapTag);
		if (nDone)
			return;
			
		if (!GetIsPC(oPC))
			return;
	
		if (GetDetectMode(oPC)) {
			if (GetIsTrainingSkillSuccessful(oPC, SKILL_SEARCH, nSpotDC)) {
				SendMessageToPC(oPC, "You spot an oddity in the corridor ahead; probably a trap. With a bit of searching, you see a disarming mechanism on the wall. . . ");
				SetUseableFlag(oDisarm, TRUE);
				
				SetLocalString(oDisarm, "PLC_TRAP", sTrapTag);
				SetLocalString(oDisarm, "PLC_TRAP_DISARM", sDisarmTag);
				SetLocalInt(oDisarm, "DC_DISARM_TRAP", nDisarmDC);
				SetLocalFloat(oDisarm, "TRAP_RESET_TIME", fReset);
				SetLocalInt(oDisarm, "TRAP_TRIGGER_TYPE", 3);
			}
		} else {
			if (GetIsTrainingSkillSuccessful(oPC, SKILL_SPOT, nSpotDC+5)) {
				SendMessageToPC(oPC, "You spot an oddity in the corridor ahead; probably a trap. With a bit of searching, you see a disarming mechanism on the wall. . . ");
				SetUseableFlag(oDisarm, TRUE);
				
				SetLocalString(oDisarm, "PLC_TRAP", sTrapTag);
				SetLocalString(oDisarm, "PLC_TRAP_DISARM", sDisarmTag);
				SetLocalInt(oDisarm, "DC_DISARM_TRAP", nDisarmDC);
				SetLocalFloat(oDisarm, "TRAP_RESET_TIME", fReset);
				SetLocalInt(oDisarm, "TRAP_TRIGGER_TYPE", 3);
			}
		}
		
		SetLocalInt(oPC, "spot_"+sTrapTag, 1);
		DelayCommand(fReset, DeleteLocalInt(oPC, "spot_"+sTrapTag));
		
	} else if (nType == 2) {
	
		SetLocalInt(oTrap, "TRAP_INACTIVE", 1);
		
		if (!nIsRocks)
			AssignCommand(oTrap, ActionPlayAnimation(ANIMATION_PLACEABLE_OPEN));
	
		float fDelay = 0.1f;
		if (fRadius > 0.0f) {
			object oVic = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oPC), FALSE, OBJECT_TYPE_CREATURE);
			while (GetIsObjectValid(oVic)) {
				DelayCommand(fDelay, TriggerTrapOn(OBJECT_SELF, oVic));
				fDelay += 0.1f;
				oVic = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oPC), FALSE, OBJECT_TYPE_CREATURE);
			}
		} else {
			DelayCommand(fDelay, TriggerTrapOn(OBJECT_SELF, oPC));
		}
		
		if (!nIsRocks)
			DelayCommand(1.0f, AssignCommand(oTrap, ActionPlayAnimation(ANIMATION_PLACEABLE_CLOSE)));
			
		DelayCommand(fReset, ResetTrap(OBJECT_SELF));
		
	} else if (nType == 3) {
		
		if (GetIsTrainingSkillSuccessful(oPC, SKILL_DISABLE_TRAP, nDisarmDC)) {
			SendMessageToPC(oPC, "You successfully disable the trap");
			
			SetLocalInt(oTrap, "TRAP_INACTIVE", 1);
			DelayCommand(fReset, ResetTrap(OBJECT_SELF));
		} else {
			SendMessageToPC(oPC, "You fail to disable the trap. The override mechanism is now broken.");
			SetUseableFlag(oDisarm, FALSE);
		}
	}
}

void ResetTrap(object oTrap) {

	string sTrapTag = GetLocalString(OBJECT_SELF, "PLC_TRAP");
	object oTrap = GetNearestObjectByTag(sTrapTag);
	
	string sDisarmTag = GetLocalString(OBJECT_SELF, "PLC_TRAP_DISARM");
	object oDisarm = GetNearestObjectByTag(sDisarmTag);
	
	DeleteLocalInt(oTrap, "TRAP_INACTIVE");
	AssignCommand(oTrap, ActionPlayAnimation(ANIMATION_PLACEABLE_CLOSE));
	SetUseableFlag(oDisarm, FALSE);
	
}

void TriggerTrapOn(object oTrap, object oVic) {

	int nDC = GetLocalInt(oTrap, "DC_REFLEX_TRAP");
	int nDice = GetLocalInt(oTrap, "TRAP_DAMAGE_d6");
	int nDamType = GetLocalInt(oTrap, "TRAP_DAMAGE_TYPE");
	float fDelay = 0.0f;
	
	int nIsRocks = GetLocalInt(OBJECT_SELF, "TRAP_IS_ROCKS"); //handles rocks fall version
	if (nIsRocks) {
		string sTrapTag = GetLocalString(OBJECT_SELF, "PLC_TRAP");
		object oRockCaster = GetObjectByTag(sTrapTag);
		if (GetIsObjectValid(oRockCaster)) {
			effect eImpact	 = EffectNWN2SpecialEffectFile("fx_wooden_explosion_big");
			fDelay 	= GetProjectileTravelTime(GetLocation(oRockCaster), GetLocation(oVic), PROJECTILE_PATH_TYPE_BALLISTIC_THROWN);
			AssignCommand(oRockCaster, ActionCastFakeSpellAtLocation(9300, GetLocation(oVic), PROJECTILE_PATH_TYPE_DEFAULT));
			DelayCommand(fDelay, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetLocation(oVic)));
		} else {
			return;
		}
	}
	
	int nDamage = d6(nDice);
	
	if (ReflexSave(oVic, nDC, SAVING_THROW_TYPE_TRAP, oTrap)) {
		effect eDam = EffectDamage(nDamage/2, nDamType);
		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oVic));
		//TransportToWaypoint(oVic, oEscape);
	} else {
		effect eDam = EffectDamage(nDamage, nDamType);
		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oVic));
	}
}