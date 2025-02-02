// This script controls the effects of the Keeper sword
// For SCOD.
// by Michel Remillard/Electrohydra
// michel.remillard1@gmail.com
// Last Edit 02/07/2017

const string KILL_COUNT = "Kill Count";

void DisplayString(string sString, object oSpeaker)
{
	SetCommandable(TRUE, oSpeaker);
	AssignCommand(oSpeaker, ClearAllActions());
	AssignCommand(oSpeaker, ActionSpeakString(sString));
}

string GenerateName()
{
	string name = "";
	
	switch (d4(1))
	{
		case 1 :
			name += "Archfiend of ";
			break;
		case 2 :
			name += "Greater Demon of ";
			break;
		case 3 :
			name += "Abyssal Vizier of ";
			break;
		case 4 :
			name += "Unholy Beast of ";
			break;
	}
	
	switch (d10(1))
	{
		case 1 :
			name += "Carnage";
			break;
		case 2 :
			name += "Unbridled Depravity";
			break;
		case 3 :
			name += "Endless Gore";
			break;
		case 4 :
			name += "Reckless Corruption";
			break;
		case 5 :
			name += "Bloody Slaughters";
			break;
		case 6 :
			name += "Massacres";
			break;
		case 7 :
			name += "the Deeper Darkness";
			break;
		case 8 :
			name += "the Apocalypse";
			break;
		case 9 :
			name += "Boiling Rage";
			break;
		case 10 :
			name += "Annihilation";
			break;
	}
	
	return name;
}

void GiveDagger(object oPC)
{
	CreateItemOnObject("ps_dagger_sacrifice", oPC, 1, "", TRUE);
}

void SummonDemon(object oPC)
{
	object oDemon = CreateObject(OBJECT_TYPE_CREATURE, "keeperdemon", GetLocation(oPC));
	
	SetFirstName(oDemon, GenerateName());
	ChangeToStandardFaction(oDemon, STANDARD_FACTION_COMMONER);
	
	DelayCommand(1.0f, DisplayString("<b>FINALLY, AFTER ALL THESE YEARS. I AM FREE!</b>", oDemon));
	DelayCommand(6.0f, DisplayString("The Heavens will pay for what they did. Mortal worlds will bleed!", oDemon));
	
	AdjustAlignment(oPC, ALIGNMENT_EVIL, 10);
	
	int PCAlign = GetAlignmentGoodEvil(oPC);
	
	if (PCAlign == ALIGNMENT_EVIL)
	{
		DelayCommand(12.0f, DisplayString("For freeing me, I give you this token of my gratitude. Go forth and spread carnage! Let the rivers flow with blood!", oDemon));
		DelayCommand(12.0f, GiveDagger(oPC));
	}
	else
	{
		DelayCommand(12.0f, DisplayString("You should run now, greedy, worthless little insect, before I make you my first victim.", oDemon));
		DelayCommand(24.0f, DisplayString("<b>YOUR TIME HAS COME! YOURS WILL BE THE FIRST DROP IN A RIVER OF DEATH.", oDemon));
		DelayCommand(30.0f, ChangeToStandardFaction(oDemon, STANDARD_FACTION_HOSTILE));
	}
}

void DestroySword(object oPC, object oSword)
{
	if(GetIsObjectValid(oSword))
	{
		DestroyObject(oSword);
		SummonDemon(oPC);
	}
}

void main()
{
	object oTarget = GetSpellTargetObject();
	
	if (GetObjectType(oTarget) != OBJECT_TYPE_CREATURE)
		return;
	
	if (!GetIsDead(oTarget, FALSE))
		return;
		
	object oSword = GetSpellCastItem();	
	object oPC = GetItemPossessor(oSword);	
	int kills = GetLocalInt(oSword, KILL_COUNT) + 1;
	
	if (GetTag(oTarget) == "keeperdemon")
	{
		DisplayString("<b>NO! I WON'T GO BACK. NOOOOOOOO!", oTarget);
		AdjustAlignment(oPC, ALIGNMENT_GOOD, 10);
		DelayCommand(6.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(FALSE, FALSE, TRUE, TRUE), oTarget, 0.0f));
	}	
	
	
	SetLocalInt(oSword, KILL_COUNT, kills);
	
	if (kills == 1)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyKeen(), oSword, 0.0f);
	if (kills == 10)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(5), oSword, 0.0f);
	if (kills == 50)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonus(7), oSword, 0.0f);
	if (kills == 100)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_2d12), oSword, 0.0f);
	if (kills == 250)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVampiricRegeneration(2), oSword, 0.0f);
	if (kills == 500)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_NEGATIVE, IP_CONST_DAMAGEBONUS_1d6), oSword, 0.0f);
	if (kills == 900)
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_2d6), oSword, 0.0f);
	if (kills == 995)
	{
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_BRIGHT, IP_CONST_LIGHTCOLOR_RED), oSword, 0.0f);
		SetDescription(oSword, "This once holy looking sword is barely recognisable. The whole weapon reaks of an unholy aura, pulsing with dark, hungry power. The once-clear celestial runes are now illegible, looking more like cracks in the fragile-looking weapon then writing.");
		FloatingTextStringOnCreature("*<b>Your sword is practically bursting with unholy energy.*</b>", oPC, FALSE);
	}
	if (kills >= 1001)
	{
		FloatingTextStringOnCreature("*<b>Your sword starts shattering in your hands!*</b>", oPC, FALSE);
		DelayCommand(30.0f, DestroySword(oPC, oSword));
	}
}
