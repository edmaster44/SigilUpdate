#include "ginc_misc"
#include "kinc_silver_sword"

void PlayCustomLoopingAnimation(object oObject, string sAnimationName, float fSpeed);
void PlayCustomOneShotAnimation(object oObject, string sAnimationName, float fSpeed);
void Meditate(object oPC, object oItem);
void Meditate2(object oPC, object oItem);
void Meditate3(object oPC, object oItem);
void Meditate4(object oPC, object oItem);
void Meditate5(object oPC, object oItem);
void Meditate6(object oPC, object oItem);
void Meditate7(object oPC, object oItem);
void Meditate8(object oPC, object oItem);
void RestoreCharges(object oPC, object oItem);

void main()
{
	object oPC = OBJECT_SELF;
	object oItem = GetSilverSwordOwnedByPC(oPC);
	object oPartyMember;
	
	AssignCommand(oPC, ClearAllActions());
	
	int n = 1;
	
	oPartyMember = GetFirstFactionMember(oPC, FALSE);
	
	while (GetIsObjectValid(oPartyMember) == TRUE)
	{
		if (GetIsInCombat(oPartyMember) == TRUE)
		{
			PrettyDebug("You are in combat.");
			SendMessageToPCByStrRef(oPC, 184624);
			return;
		}
		
		oPartyMember = GetNextFactionMember(oPC, FALSE);
	}			
	
	object oCreature = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oPC,
		n, CREATURE_TYPE_IS_ALIVE, TRUE);
		
	while (GetIsObjectValid(oCreature) == TRUE)
	{
		n = n + 1;
		
		if (GetScriptHidden(oCreature) == FALSE)
		{
			oPartyMember = GetFirstFactionMember(oPC, FALSE);
			
			while (GetIsObjectValid(oPartyMember) == TRUE)
			{
				if (GetDistanceBetween(oPartyMember, oCreature) <= 30.0f)
				{
					PrettyDebug("Enemies are nearby.");
					SendMessageToPCByStrRef(oPC, 66234);
					return;
				}
				
				oPartyMember = GetNextFactionMember(oPC, FALSE);
			}
		}
		
		oCreature = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oPC,
			n, CREATURE_TYPE_IS_ALIVE, TRUE);
	}
			
	Meditate(oPC, oItem);
}

void Meditate(object oPC, object oItem)
{
	PrettyDebug("Current action is " + IntToString(GetCurrentAction(oPC)));
	if (GetCurrentAction(oPC) != ACTION_ITEMCASTSPELL)
	{	
		PrettyDebug("actions present in queue, ending.");
		SendMessageToPCByStrRef(oPC, 184625);
		return;
	}

	effect eEffect = EffectNWN2SpecialEffectFile("fx_shard_rip.sef");
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 4.0f);
	PlayCustomLoopingAnimation(oPC, "%", 1.0f);
	PlayCustomOneShotAnimation(oPC, "kneeldown", 1.0f);
	DelayCommand(0.8f, PlayCustomLoopingAnimation(oPC, "kneelbow", 0.5f));
	DelayCommand(1.0f, AssignCommand(oPC, Meditate2(oPC, oItem)));
}

void Meditate2(object oPC, object oItem)
{
	if (GetCurrentAction(oPC) != ACTION_INVALID)
	{
		SendMessageToPCByStrRef(oPC, 184625);
		return;
	}
	
	DelayCommand(1.0f, AssignCommand(oPC, Meditate3(oPC, oItem)));
}

void Meditate3(object oPC, object oItem)
{
	if (GetCurrentAction(oPC) != ACTION_INVALID)
	{
		SendMessageToPCByStrRef(oPC, 184625);
		return;
	}
	
	DelayCommand(1.0f, AssignCommand(oPC, Meditate4(oPC, oItem)));
}

void Meditate4(object oPC, object oItem)
{
	if (GetCurrentAction(oPC) != ACTION_INVALID)
	{
		SendMessageToPCByStrRef(oPC, 184625);
		return;
	}
	
	DelayCommand(1.0f, AssignCommand(oPC, Meditate5(oPC, oItem)));
}

void Meditate5(object oPC, object oItem)
{
	if (GetCurrentAction(oPC) != ACTION_INVALID)
	{
		SendMessageToPCByStrRef(oPC, 184625);
		return;
	}
		
	effect eEffect = EffectNWN2SpecialEffectFile("fx_shard_rip.sef");
	effect eEffect2 = EffectNWN2SpecialEffectFile("sp_divination_cast.sef");
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 4.0f);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect2, oPC);
	DelayCommand(2.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect2, oPC));
	DelayCommand(1.0f, AssignCommand(oPC, Meditate6(oPC, oItem)));
}

void Meditate6(object oPC, object oItem)
{
	if (GetCurrentAction(oPC) != ACTION_INVALID)
	{
		SendMessageToPCByStrRef(oPC, 184625);
		return;
	}
	
	DelayCommand(1.0f, AssignCommand(oPC, Meditate7(oPC, oItem)));
}

void Meditate7(object oPC, object oItem)
{
	effect eEffect2 = EffectNWN2SpecialEffectFile("sp_divination_cast.sef");
	
	if (GetCurrentAction(oPC) != ACTION_INVALID)
	{
		SendMessageToPCByStrRef(oPC, 184625);
		return;
	}
	
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect2, oPC);
		
	DelayCommand(1.0f, AssignCommand(oPC, Meditate8(oPC, oItem)));
}

void Meditate8(object oPC, object oItem)
{	
	if (GetCurrentAction(oPC) != ACTION_INVALID)
	{
		SendMessageToPCByStrRef(oPC, 184625);
		return;
	}

	DelayCommand(1.0f, AssignCommand(oPC, RestoreCharges(oPC, oItem)));
}

void RestoreCharges(object oPC, object oItem)
{
	int n;
	int nCharges = GetItemCharges(oItem);

	if (GetCurrentAction(oPC) != ACTION_INVALID)
	{
		SendMessageToPCByStrRef(oPC, 184625);
		return;
	}
	
	effect eVis = EffectNWN2SpecialEffectFile("fx_shard_attack_reform.sef");
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
	PlayCustomLoopingAnimation(oPC, "%", 1.0f);
	PlayCustomOneShotAnimation(oPC, "kneelup", 1.0f);
	
	n = 1;
	
	object oCreature = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oPC,
		n, CREATURE_TYPE_IS_ALIVE, TRUE);
		
	while (GetIsObjectValid(oCreature) == TRUE)
	{
		n = n + 1;
		
		if (GetScriptHidden(oCreature) == FALSE)
		{
			if (GetDistanceBetween(oPC, oCreature) <= 60.0f)
			{
				if (nCharges < 3)
				{
					SendMessageToPCByStrRef(oPC, 184622);
					SetItemCharges(oItem, nCharges + 1);
				}
				
				return;
			}
		}

		oCreature = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oPC,
			n, CREATURE_TYPE_IS_ALIVE, TRUE);
	}
	
	SendMessageToPCByStrRef(oPC, 184623);
	SetItemCharges(oItem, 3);
}
	
void PlayCustomLoopingAnimation(object oObject, string sAnimationName, float fSpeed)
{
	PlayCustomAnimation(oObject, sAnimationName, 1, fSpeed);
}

void PlayCustomOneShotAnimation(object oObject, string sAnimationName, float fSpeed)
{
	PlayCustomAnimation(oObject, sAnimationName, 0, fSpeed);
}