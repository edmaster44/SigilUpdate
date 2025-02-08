#include "ff_safevar"

#include "aaa_constants"
#include "nw_i0_spells"



effect BossFX(int nBHP)
{
	effect eFX = EffectBonusHitpoints(nBHP);
	eFX = EffectLinkEffects(eFX, EffectRegenerate(10, 1.0));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_BLINDNESS));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_CHARM));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_CONFUSED));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_DAZED));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_DEAFNESS));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_DEATH));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_DOMINATE));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_ENTANGLE));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_FEAR));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_PARALYSIS));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_SILENCE));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_SLEEP));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_STUN));
	eFX = SupernaturalEffect(eFX);
	eFX = SetEffectSpellId(eFX, BOSS_EFFECTS);
	return eFX;
}

void RespawnBoss(object oBOSS)
{
	object oAREA = GetArea(oBOSS);
	object oCENTER = GetObjectByTag("wp_herald_center");
	object oWAY = GetObjectByTag("wp_herald_annhi_entrance");
	object oPC = GetFirstObjectInArea(oAREA);
	while (oPC != OBJECT_INVALID)
	{
		if (GetIsOwnedByPlayer(oPC) == TRUE)
		{
			if (GetIsDead(oPC) == TRUE)	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
			AssignCommand(oPC, JumpToObject(oWAY));
		}
		oPC = GetNextObjectInArea(oAREA);
	}
	AssignCommand(oBOSS, JumpToObject(oCENTER));
	SetFirstName(oBOSS, "Herald of Annihilation");
	if (GetHasSpellEffect(BOSS_EFFECTS, oBOSS) == FALSE)
	{
		int nBHP = 12000;
		effect eFX = BossFX(nBHP);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oBOSS);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nBHP), oBOSS);
	}
	PS_DeleteLocalInt(oBOSS, "BOSS_DEFEATED");
	object oPLAYER = GetFirstPC();
	while (oPLAYER != OBJECT_INVALID)
	{
		SendChatMessage(oBOSS, oPLAYER, CHAT_MODE_SERVER, "The Herald of Annihilation has respawned.");
		oPLAYER = GetNextPC();
	}
}

void main()
{
	object oBOSS = OBJECT_SELF;
	if (GetCurrentHitPoints(oBOSS) > 1) return;
	if (PS_GetLocalInt(oBOSS, "BOSS_DEFEATED") == 1) return; //To avoid multiple.
	PS_SetLocalInt(oBOSS, "BOSS_DEFEATED", 1);
	RemoveEffectsFromSpell(oBOSS, BOSS_EFFECTS);
	ChangeToStandardFaction(oBOSS, STANDARD_FACTION_COMMONER);
	ClearAllActions(TRUE);
	SpeakString("It's when we face defeat... that we learn the most precious lesson...");	
	SetFirstName(oBOSS, GetName(oBOSS) + " (Defeated)");
	string sADD;
	object oITEM;
	location lBOSS = GetLocation(oBOSS);
	object oPC = GetFirstObjectInShape(SHAPE_SPHERE, 100.0, lBOSS, TRUE);
	while (oPC != OBJECT_INVALID)
	{
		sADD = GetTag(oPC);
		if ((sADD == "heraldannhi_add") || (sADD == "heraldannhi_font")) DestroyObject(oPC);
		else if (GetIsOwnedByPlayer(oPC) == TRUE)
		{
			if (GetIsDead(oPC) == TRUE) ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
			ForceRest(oPC);
			DisplayMessageBox(oPC, 0, "Congratulations on defeating the Herald of Annihilation! You have received a token for you deeds. If your inventory was full, the token should be at your feet.");
			oITEM = CreateItemOnObject("heraldannhi_token", oPC);
			if (oITEM == OBJECT_INVALID) CreateObject(OBJECT_TYPE_ITEM, "heraldannhi_token", GetLocation(oPC));
		}
		oPC = GetNextObjectInShape(SHAPE_SPHERE, 100.0, lBOSS, TRUE);
	}
	float fDELAY = 60.0;
	effect eDEAD = ExtraordinaryEffect(EffectKnockdown());
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDEAD, oBOSS, fDELAY - 1.0));
	DelayCommand(fDELAY, RespawnBoss(oBOSS));
}