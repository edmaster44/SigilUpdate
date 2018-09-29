/*
Constants:

1 - weapon, axe
2 - weapon, large axe
3 - weapon, bladed light (dagger, kama, kukri, sickle, short sword, rapier)
4 - weapon, bladed (katana, bastard sword, scimitar, longsword)
5 - weapon, large bladed (great sword, falchion)
6 - weapon, blunt
7 - weapon, large blunt
8 - weapon, large (staff, polearm)
9 - weapon, bow
10 - weapon, crossbow
11 - weapon, sling
12- armor, clothes
13- armor, light
14- armor, medium
15- armor, heavy
16- shield
17- shield, tower
18- boots
19- cloak
20- bracers
21- belts
22- hats
23- rings
24- amulets

*/

#include "ps_inc_functions"
#include "ginc_crafting"

int weapon_enhancement_bonus(object oItem, int nLevel, int nPrice)
{
	int nEnhancement = 0;
	
	if ( nLevel < 4 )
		nEnhancement = 1;
	else if ( nLevel < 9 )
		nEnhancement = Random(2) + 1;
	else if ( nLevel < 13 )
		nEnhancement = Random(3) + 1;
	else if ( nLevel < 17 )
		nEnhancement = Random(4) + 1;
	else
		nEnhancement = Random(5) + 1;

	switch (nEnhancement)
	{
        case 1: ApplyEncodedEffectsToItem(oItem, "6,1,0,0,0"); nPrice-=500; break; //+1
        case 2: ApplyEncodedEffectsToItem(oItem, "6,2,0,0,0"); nPrice-=1000; break; //+2
        case 3: ApplyEncodedEffectsToItem(oItem, "6,3,0,0,0"); nPrice-=2000; break; //+3
        case 4: ApplyEncodedEffectsToItem(oItem, "6,4,0,0,0"); nPrice-=3500; break; //+4
        case 5: ApplyEncodedEffectsToItem(oItem, "6,5,0,0,0"); nPrice-=5000; break; //+5
	}
	
	return nPrice;
}

void melee_second_power(object oItem, int nLevel, int nPrice)
{
	int nPower = Random(9) + 1;
	int nRandom = Random(100)+1;
	
	switch (nPower)
	{
		case 1: //acid
			
		case 2:
		case 3:
		case 4:
		case 5:
		case 6:
		case 7:
		case 8:
		case 9:
	}
	
/*
WeaponAcidD4	ps_ench_recipe_006	"16,6,6,0,0"
WeaponAcidD6	ps_ench_recipe_007	"16,6,7,0,0"
WeaponFireD4	ps_ench_recipe_008	"16,10,6,0,0"
WeaponFireD6	ps_ench_recipe_009	"16,10,7,0,0"
WeaponColdD4	ps_ench_recipe_010	"16,7,6,0,0"
WeaponColdD6	ps_ench_recipe_011	"16,7,7,0,0"
WeaponElecD4	ps_ench_recipe_012	"16,9,6,0,0"
WeaponElecD6	ps_ench_recipe_013	"16,9,7,0,0"
WeaponVamp+1	ps_ench_recipe_014	"67,1,0,0,0"
WeaponVamp+3	ps_ench_recipe_015	"67,3,0,0,0"
WeaponAnarchicD4	ps_ench_recipe_016	"17,2,6,0,0"
WeaponAnarchicD6	ps_ench_recipe_017	"17,2,7,0,0"
WeaponAxiomaticD4	ps_ench_recipe_018	"17,3,6,0,0"
WeaponAxiomaticD6	ps_ench_recipe_019	"17,3,7,0,0"
WeaponHolyD4	ps_ench_recipe_020	"17,5,6,0,0"
WeaponHolyD6	ps_ench_recipe_021	"17,5,7,0,0"
WeaponUnholyD4	ps_ench_recipe_022	"17,4,6,0,0"
WeaponUnholyD6	ps_ench_recipe_023	"17,4,7,0,0"
*/
}

object random_weapon_bladed(object oPC, int nLevel, int nPrice)
{ //katana, bastard sword, scimitar, longsword)
	int nRandom = Random(100) + 1;
	string sItemtag = "";
	if ( nRandom < 40 ) //iron
	{
		int nRandomtype = Random(4) + 1;
	    switch (nRandomtype)
	    {
	        case 1: sItemtag="NW_WSWLS001"; break; //longsword
	        case 2: sItemtag="NW_WSWKA001"; break; //katana
	        case 3: sItemtag="NW_WSWBS001"; break; //bastard sword
	        case 4: sItemtag="NW_WSWSC001"; break; //scimitar
		}
	}
	else if ( nRandom < 60 ) //darksteel
	{
		int nRandomtype = Random(4) + 1;
	    switch (nRandomtype)
	    {
	        case 1: sItemtag="mst_swls_drk_3"; break; //longsword
	        case 2: sItemtag="mst_swka_drk_3"; break; //katana
	        case 3: sItemtag="mst_swbs_drk_3"; break; //bastard sword
	        case 4: sItemtag="mst_swsc_drk_3"; break; //scimitar
		}
	}
	else if ( nRandom < 80 ) //cold iron
	{
		int nRandomtype = Random(4) + 1;
	    switch (nRandomtype)
	    {
	        case 1: sItemtag="mst_swls_cld_3"; break; //longsword
	        case 2: sItemtag="mst_swka_cld_3"; break; //katana
	        case 3: sItemtag="mst_swbs_cld_3"; break; //bastard sword
	        case 4: sItemtag="mst_swsc_cld_3"; break; //scimitar
		}
	}
	else //silver
	{
		int nRandomtype = Random(4) + 1;
	    switch (nRandomtype)
	    {
	        case 1: sItemtag="mst_swls_slv_3"; //longsword
	        case 2: sItemtag="mst_swka_slv_3"; break; //katana
	        case 3: sItemtag="mst_swbs_slv_3"; break; //bastard sword
	        case 4: sItemtag="mst_swsc_slv_3"; break; //scimitar
		}
	}
	
	object oItem = CreateItemOnObject(sItemtag, oPC, 1);
	
	nPrice = weapon_enhancement_bonus(oItem, nLevel, nPrice);
	
	if ( nPrice > 0 )
		melee_second_power(oItem, nLevel, nPrice);
	
	return oItem;
}

void main(int nType)
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	int nLevel = PS_GetLevel(oPC);
	int nPrice = nLevel * 1000;
	object oItem = OBJECT_INVALID;
    switch (nType)
    {
        case 1: oItem = random_weapon_bladed(oPC,nLevel,nPrice); break;
        case 2: break;
        case 3: break;
        case 4: break;
        case 5: break;
        case 6: break;
        case 7: break;
        case 8: break;
        case 9: break;
        case 10: break;
        case 11: break;
        case 12: break;
		case 13: break;
		case 14: break;
		case 15: break;						
		case 16: break;
		case 17: break;		
    }
	
	SetStolenFlag(oItem, TRUE);
}

/*
void EnchantTargetItem(int nIndex, object oItem, string sTable, object oPC)
{
	string sEffects = Get2DAString(sTable, "EFFECT_STRING", nIndex);
	string sSound = Get2DAString(sTable, "SOUND", nIndex);
	ApplyEncodedEffectsToItem(oItem, sEffects);
	AssignCommand(oPC, ClearAllActions());
	AssignCommand(oPC, PlaySound(sSound, TRUE));
}
/*