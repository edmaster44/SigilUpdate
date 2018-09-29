// Myconid spore ability, created by Agony_Aunt for SCoD.

#include "nw_i0_spells"

void UnsummonSpawn(object oPC, object oTarget)
{
	SendMessageToPC(oPC, "Your spawn has decayed.");
	effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	DestroyObject(oTarget, 0.1);
}

void CreateMyconid(object oPC, object oTarget, int iDC, int iSpellID)
{
	int iLevel = GetHitDice(oTarget);
	location lLoc = GetLocation(oTarget);
	int iFeat;
	//if (GetHasSpellEffect(iSpellID, oTarget)) // if target gets a remove disease or otherwise cured, then no further effect.
	//{ 
		// second custom fort save chance 
		if (GetFortitudeSavingThrow(oTarget) + d20(1) <= iDC)
		{
			SendMessageToPC(oPC, GetName(oTarget) + " has been taken over by your spores.");
			effect eDeath = EffectDeath(TRUE, FALSE, TRUE, TRUE);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
			object oNew = CreateObject(OBJECT_TYPE_CREATURE, "ps_srr_myspore" + IntToString(Random(3)+1), lLoc); // 3 different coloured spawns possible with different packages
			
			float fScale = 0.5 + (IntToFloat(iLevel) / 10.0);
			SetScale(oNew, fScale, fScale, fScale);
			 
			effect eDom = EffectCutsceneDominated();
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDom, oNew);
			
			if (iLevel > 20) iFeat = 2261 + 20; // natural AC increase feats
			else iFeat = 2261 + iLevel;
			FeatAdd(oNew, iFeat, FALSE, FALSE, FALSE);
			
			int iLoop;
			if (iLevel > 1)
			{
				for (iLoop = 1; iLoop < iLevel; iLoop++)
				{
					LevelUpHenchman(oNew, CLASS_TYPE_INVALID, TRUE, PACKAGE_INVALID);
				}
			}
			
			DelayCommand(1.0, AssignCommand(oNew, ForceRest(oNew)));
			
			DelayCommand(iLevel * 60.0, UnsummonSpawn(oPC, oNew));
		}
		else
		{
			SendMessageToPC(oPC, GetName(oTarget) + " has fought off the spores.");
		}
	//}
}

void main()
{
	object oPC = OBJECT_SELF;
	location lTarget = GetLocation(oPC);
	int iDC = 10 + GetTotalLevels(oPC, TRUE)/2 + GetAbilityModifier(ABILITY_CHARISMA, oPC);
	effect eVis;
	effect eDisease;
	
	// make VFX
	effect eAOE = EffectAreaOfEffect(AOE_PER_FOGMIND);
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, 6.0);
	
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    
    while (GetIsObjectValid(oTarget))
    {
		if (GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT && GetSubRace(oTarget) != 165 && GetSubRace(oTarget) != 234) // constructs and myconids are immune
		{
			SignalEvent(oTarget, EventSpellCastAt(oPC, GetSpellId()));
			// need to do a custom fort check to avoid immunity
			if (GetFortitudeSavingThrow(oTarget) + d20(1) > iDC)
			{
				SendMessageToPC(oPC, "Your spores fail to infect " + GetName(oTarget));
			}
			else
			{
				eVis = EffectVisualEffect(VFX_IMP_DISEASE_S);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				
				// now to determine what actual effect takes place
				eDisease = EffectDisease(DISEASE_DREAD_BLISTERS);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDisease, oTarget, 66.0);
				SendMessageToPC(oPC, GetName(oTarget) + " is infected with spores.");
				DelayCommand(50.0 + Random(10), CreateMyconid(oPC, oTarget, iDC, GetSpellId()));
			}
		}
		
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
}