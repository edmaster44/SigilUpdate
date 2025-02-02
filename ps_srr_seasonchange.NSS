#include "ff_safevar"

#include "ps_inc_advscript"

const int FEAT_AURA_DESPAIR = 1832;
const int SEASON_SUMMER = 0;
const int SEASON_FALL = 1;
const int SEASON_WINTER = 2;
const int SEASON_SPRING = 3;
const int WINTER1 = -256;
const int WINTER2 = -256;
const int FALL1 = 504037376;
const int FALL2 = -937885696;
const int SUMMER1 = 504037376;
const int SUMMER2 = 1967400448;
const int SPRING1 = 69731328;
const int SPRING2 = 1501898496;


void removeCurrentEffects(object oPC)
{
	effect currentEffect = GetFirstEffect(oPC);
	while (GetIsEffectValid(currentEffect))
	{
		if (GetEffectSpellId(currentEffect) == GetSpellId())
		{
			RemoveEffect(oPC, currentEffect);
		}
		currentEffect = GetNextEffect(oPC);
	}
	
	if (GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC) < 3)
	{
		FeatRemove(oPC, FEAT_AURA_DESPAIR);
	}
	
	if (GetLevelByClass(CLASS_TYPE_PALADIN, oPC) < 3)
	{
		FeatRemove(oPC, FEAT_AURA_OF_COURAGE);
	}
}

void addEffects(object oPC, int currentSeason)
{
	if (currentSeason == SEASON_SUMMER)
	{
		effect summer = SupernaturalEffect(EffectAttackIncrease(1));
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, summer, oPC, 0.0f);
	}
	else if (currentSeason == SEASON_FALL)
	{
		FeatAdd(oPC, FEAT_AURA_DESPAIR, FALSE);
	}
	else if (currentSeason == SEASON_WINTER)
	{
		effect winter = SupernaturalEffect(EffectACIncrease(1));
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, winter, oPC, 0.0f);
	}
	else if (currentSeason == SEASON_SPRING)
	{
		FeatAdd(oPC, FEAT_AURA_OF_COURAGE, FALSE);
	}
}

void changeHairColor(object oPC, int currentSeason)
{
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);

	if (currentSeason == SEASON_SUMMER)
	{
		app.HairTint_Color1 = SUMMER1;
		app.HairTint_Color2 = SUMMER2;
		app.HairTint_Mask = PS_CCA_TINT_COLOR1 | PS_CCA_TINT_COLOR2;
		app.HeadTint_Color2 = SUMMER1;
		app.HeadTint_Mask = PS_CCA_TINT_COLOR2;
	}
	else if (currentSeason == SEASON_FALL)
	{
		app.HairTint_Color1 = FALL1;
		app.HairTint_Color2 = FALL2;
		app.HairTint_Mask = PS_CCA_TINT_COLOR1 | PS_CCA_TINT_COLOR2;
		app.HeadTint_Color2 = FALL1;
		app.HeadTint_Mask = PS_CCA_TINT_COLOR2;
	}
	else if (currentSeason == SEASON_WINTER)
	{
		app.HairTint_Color1 = WINTER1;
		app.HairTint_Color2 = WINTER2;
		app.HairTint_Mask = PS_CCA_TINT_COLOR1 | PS_CCA_TINT_COLOR2;
		app.HeadTint_Color2 = WINTER1;
		app.HeadTint_Mask = PS_CCA_TINT_COLOR2;
	}
	else if (currentSeason == SEASON_SPRING)
	{
		app.HairTint_Color1 = SPRING1;
		app.HairTint_Color2 = SPRING2;
		app.HairTint_Mask = PS_CCA_TINT_COLOR1 | PS_CCA_TINT_COLOR2;
		app.HeadTint_Color2 = SPRING1;
		app.HeadTint_Mask = PS_CCA_TINT_COLOR2;
	}
	
	PS_SetCreatureCoreAppearance(oPC, app);
	
	// Refresh appearance
	object gloves = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
	if (!GetIsObjectValid(gloves))
	{
		object newGloves = CreateItemOnObject("ps_srlg_gloves", oPC);
		ActionEquipItem(newGloves, INVENTORY_SLOT_ARMS);
		DelayCommand(1.0f, DestroyObject(newGloves));
	}
	else
	{
		ActionUnequipItem(gloves);
		DelayCommand(1.0f, ActionEquipItem(gloves, INVENTORY_SLOT_ARMS));
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	int currentSeason = PS_GetLocalInt(oPC, "currentSeason") + 1;
	if (currentSeason == 4) currentSeason = 0;
	PS_SetLocalInt(oPC, "currentSeason", currentSeason);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_ENTANGLE), oPC, 1.0f);
	
	//temporary
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
	
	SendMessageToPC(oPC,"Hair color 0 " + IntToString(app.HairTint_Color0));
	SendMessageToPC(oPC,"Hair color 1 " + IntToString(app.HairTint_Color1));
	SendMessageToPC(oPC,"Hair color 2 " + IntToString(app.HairTint_Color2));
	SendMessageToPC(oPC,"Head color 0 " + IntToString(app.HeadTint_Color0));
	SendMessageToPC(oPC,"Head color 1 " + IntToString(app.HeadTint_Color1));
	SendMessageToPC(oPC,"Head color 2 " + IntToString(app.HeadTint_Color2));
	SendMessageToPC(oPC,"Tattoo color 1 " + IntToString(app.TattooColor1));
	SendMessageToPC(oPC,"Tattoo color 2 " + IntToString(app.TattooColor1));
	SendMessageToPC(oPC,"Tint color 0 " + IntToString(app.Tint_Color0));
	SendMessageToPC(oPC,"Tint color 1 " + IntToString(app.Tint_Color1));
	SendMessageToPC(oPC,"Tint color 2 " + IntToString(app.Tint_Color2));

	// end temp
	
	removeCurrentEffects(oPC);
	addEffects(oPC, currentSeason);
	changeHairColor(oPC, currentSeason);
}