#include "x2_inc_spellhook"
#include "X0_I0_SPELLS"
#include "ps_inc_functions"
#include "ps_inc_advscript"
#include "aaa_constants"
#include "nw_i0_spells"
#include "aaa_changeself_inc"
#include "x0_i0_match"
#include "nwn2_inc_spells"
#include "x2_inc_itemprop"


/*	This is the include file for the reforging mechanic.
	Every individual feature in spells.2da will need its own script created in here, which will in turn be called by 
	ps0_reforge-inc, which acts as the universal spell with a case-based system.
*/

int PS_GetWeaponSize(object oWeapon)
{
	int nBaseItem = GetBaseItemType(oWeapon);
	int nWeapSize = 99;
	
	switch (nBaseItem)
	{
		case 0 : nWeapSize = 2; break; 		//shortsword
		case 1 : nWeapSize = 3; break; 		//longsword
		case 2 : nWeapSize = 3; break;		//battleaxe
		case 3 : nWeapSize = 3; break;		//bastard sword
		case 5 : nWeapSize = 3; break;		//warhammer
		case 9 : nWeapSize = 2; break;		//mace
		case 10 : nWeapSize = 4; break;		//halberd
		case 13 : nWeapSize = 4; break;		//greatsword
		case 18 : nWeapSize = 4; break;		//greataxe
		case 22 : nWeapSize = 1; break;		//dagger
		case 37 : nWeapSize = 2; break;		//light hammer
		case 38 : nWeapSize = 2; break;		//handaxe
		case 40 : nWeapSize = 2; break;		//kama
		case 41 : nWeapSize = 3; break;		//katana
		case 42 : nWeapSize = 1; break;		//kukri
		case 47 : nWeapSize = 3; break;		//morningstar
		case 51 : nWeapSize = 3; break;		//rapier
		case 53 : nWeapSize = 3; break;		//scimitar
		case 55 : nWeapSize = 4; break;		//scythe
		case 60 : nWeapSize = 2; break;		//sickle
		case 108 : nWeapSize = 3; break;	//dwarven waraxe
		case 114 : nWeapSize = 4; break;	//falchion
		case 116 : nWeapSize = 3; break;	//flail
		case 119 : nWeapSize = 4; break;	//spear
		case 126 : nWeapSize = 4; break;	//warmace
	}
	return nWeapSize;
}

int PS_GetShieldSize(object oShield)
{
	int nBaseItem = GetBaseItemType(oShield);
	int nShieldSize = 99;
	
	switch (nBaseItem)
	{
		case 14 : nShieldSize = 1; break; 	//light shield
		case 56 : nShieldSize = 2; break;	//heavy shield
		case 57 : nShieldSize = 3; break;	//tower shield
	}
	return nShieldSize;
}

int PS_GetArmorSize(object oArmor)
{	
	int nArmorRules = GetArmorRulesType(oArmor);
	int nArmorRank = 99;
	
	switch (nArmorRules)
	{
		case 6 : nArmorRank = 2; break;		//banded mail
		case 7 : nArmorRank = 3; break;		//half plate
		case 8 : nArmorRank = 4; break;		//full plate
		case 14 : nArmorRank = 1; break;	//breastplate
	}
	return nArmorRank;
}

void PS_Reforge_Weapon(object oWeapon, object oPC)
{

}

void PS_Reforge_Armor(object oArmor, object oPC)
{
}

void PS_Reforge_Shield(object oShield, object oPC)
{
}