

// Rod of Seven Parts activation script
// Merges two different parts of the rod together
// By Electrohydra / Mick64
// michel.remillard1@gmail.com
// Last edit : 22/01/2017

void main()
{
    object oPC      = GetItemActivator();
    object oItem1    = GetItemActivated();
    object oItem2  = GetItemActivatedTarget();
	
	if (oItem1 == oItem2 && GetLocalInt(oItem1, "staffcomplete") == TRUE)
	{
		object area = GetArea(oPC);
		float fDur = RoundsToSeconds(d4() + 1);
		effect eTimeStop = EffectCutsceneParalyze();
	
		object oTarget = GetFirstObjectInArea(area);
		while (GetIsObjectValid(oTarget))
		{
			if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE && oTarget != oPC)
			{
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eTimeStop, oTarget, fDur);
			}
			
			oTarget = GetNextObjectInArea(area);
		}
		
		DestroyObject(oItem1, 0.0f);
	}
	else if (oItem1 == oItem2)
	{
		SendMessageToPC(oPC, "You feel like you could unleash great power like this, but only if the Rod is fully assembled.");
		return;		
	}

 	if (GetObjectType(oItem2) != OBJECT_TYPE_ITEM)
	{
		SendMessageToPC(oPC, "Use this ability on another rod piece to join it to this piece.");
		return;
	}

	if (GetTag(oItem2) != "rodofseven")
	{
		SendMessageToPC(oPC, "This ability can only be used on another piece of the Rod of Seven Parts.");
		return;
	}
	
	int numberOfParts = 0;
	
	itemproperty prop = GetFirstItemProperty(oItem1);
	while (GetIsItemPropertyValid(prop))
	{
		if (GetItemPropertyType(prop) == ITEM_PROPERTY_CAST_SPELL && GetItemPropertySubType(prop) == IP_CONST_CASTSPELL_CURE_SERIOUS_WOUNDS_10)
		{
			++numberOfParts;
		}
		
		if (GetItemPropertyType(prop) == ITEM_PROPERTY_CAST_SPELL && GetItemPropertySubType(prop) == IP_CONST_CASTSPELL_SLOW_5)
		{
			++numberOfParts;
		}
		
		if (GetItemPropertyType(prop) == ITEM_PROPERTY_CAST_SPELL && GetItemPropertySubType(prop) == IP_CONST_CASTSPELL_HASTE_10)
		{
			++numberOfParts;
		}
		
		if (GetItemPropertyType(prop) == ITEM_PROPERTY_CAST_SPELL && GetItemPropertySubType(prop) == IP_CONST_CASTSPELL_GUST_OF_WIND_10)
		{
			++numberOfParts;
		}
		
		if (GetItemPropertyType(prop) == ITEM_PROPERTY_CAST_SPELL && GetItemPropertySubType(prop) == IP_CONST_CASTSPELL_TRUE_SEEING_9)
		{
			++numberOfParts;
		}
		
		if (GetItemPropertyType(prop) == ITEM_PROPERTY_CAST_SPELL && GetItemPropertySubType(prop) == IP_CONST_CASTSPELL_HOLD_MONSTER_7)
		{
			++numberOfParts;
		}
		
		if (GetItemPropertyType(prop) == ITEM_PROPERTY_CAST_SPELL && GetItemPropertySubType(prop) == IP_CONST_CASTSPELL_HEAL_11)
		{
			++numberOfParts;
		}
	
		prop = GetNextItemProperty(oItem1);
	}
	
	prop = GetFirstItemProperty(oItem2);
	while (GetIsItemPropertyValid(prop))
	{
		if (GetItemPropertyType(prop) == ITEM_PROPERTY_CAST_SPELL && GetItemPropertySubType(prop) == IP_CONST_CASTSPELL_CURE_SERIOUS_WOUNDS_10)
		{
			AddItemProperty(DURATION_TYPE_PERMANENT, prop, oItem1);
			++numberOfParts;
		}
		
		if (GetItemPropertyType(prop) == ITEM_PROPERTY_CAST_SPELL && GetItemPropertySubType(prop) == IP_CONST_CASTSPELL_SLOW_5)
		{
			AddItemProperty(DURATION_TYPE_PERMANENT, prop, oItem1);
			++numberOfParts;
		}
		
		if (GetItemPropertyType(prop) == ITEM_PROPERTY_CAST_SPELL && GetItemPropertySubType(prop) == IP_CONST_CASTSPELL_HASTE_10)
		{
			AddItemProperty(DURATION_TYPE_PERMANENT, prop, oItem1);
			++numberOfParts;
		}
		
		if (GetItemPropertyType(prop) == ITEM_PROPERTY_CAST_SPELL && GetItemPropertySubType(prop) == IP_CONST_CASTSPELL_GUST_OF_WIND_10)
		{
			AddItemProperty(DURATION_TYPE_PERMANENT, prop, oItem1);
			++numberOfParts;
		}
		
		if (GetItemPropertyType(prop) == ITEM_PROPERTY_CAST_SPELL && GetItemPropertySubType(prop) == IP_CONST_CASTSPELL_TRUE_SEEING_9)
		{
			AddItemProperty(DURATION_TYPE_PERMANENT, prop, oItem1);
			++numberOfParts;
		}
		
		if (GetItemPropertyType(prop) == ITEM_PROPERTY_CAST_SPELL && GetItemPropertySubType(prop) == IP_CONST_CASTSPELL_HOLD_MONSTER_7)
		{
			AddItemProperty(DURATION_TYPE_PERMANENT, prop, oItem1);
			++numberOfParts;
		}
		
		if (GetItemPropertyType(prop) == ITEM_PROPERTY_CAST_SPELL && GetItemPropertySubType(prop) == IP_CONST_CASTSPELL_HEAL_11)
		{
			AddItemProperty(DURATION_TYPE_PERMANENT, prop, oItem1);
			++numberOfParts;
		}
	
		prop = GetNextItemProperty(oItem2);
	}
	
	DestroyObject(oItem2);
	
	if (numberOfParts >= 2 && !GetItemHasItemProperty(oItem1, ITEM_PROPERTY_BONUS_FEAT))
	{
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(197), oItem1);
	}
	
	if (numberOfParts >= 3 && !GetItemHasItemProperty(oItem1, ITEM_PROPERTY_SPELL_RESISTANCE))
	{
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_30), oItem1);
	}
	
	if (numberOfParts >= 4 && !GetItemHasItemProperty(oItem1, ITEM_PROPERTY_ENHANCEMENT_BONUS))
	{
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(5), oItem1);
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyCastSpell(IP_CONST_CASTSPELL_DISPLACEMENT_9, IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY), oItem1);
	}
	
	if (numberOfParts >= 5 && !GetItemHasItemProperty(oItem1, ITEM_PROPERTY_DAMAGE_BONUS))
	{
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1d6), oItem1);
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyCastSpell(IP_CONST_CASTSPELL_SHAPECHANGE_17, IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY), oItem1);
	}
	
	if (numberOfParts >= 6 && !GetItemHasItemProperty(oItem1, ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP))
	{
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC, IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1d6), oItem1);
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(5), oItem1);
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyCastSpell(IP_CONST_CASTSPELL_STORM_OF_VENGEANCE_17, IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY), oItem1);
	}
	
	if (numberOfParts >= 7 && !GetItemHasItemProperty(oItem1, ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP))
	{
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1d6), oItem1);		
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyCastSpell(IP_CONST_CASTSPELL_GREATER_RESTORATION_13, IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY), oItem1);
	}
	
	// Turn into Quarterstaff
	if (numberOfParts >= 5)
	{
		object staff = CreateItemOnObject("rodofsevenstaff", oPC);
		
		prop = GetFirstItemProperty(oItem1);
		while (GetIsItemPropertyValid(prop))
		{
			AddItemProperty(DURATION_TYPE_PERMANENT, prop, staff);
			
			prop = GetNextItemProperty(oItem1);
		}
		
		
		if (numberOfParts == 7)
		{
			SetLocalInt(staff, "staffComplete", TRUE);
			SetDescription(staff, "This five foot long crystalline rod features an intricate pattern of dimples and depressions along its surface. For the first time since you found your first piece, the artifact finally feels whole. The finished piece is positively bursting with magical power, and you sense that it would be difficult to conceal its presence from any seeking to find it.");
		}
		
		DestroyObject(oItem1);
	}
}