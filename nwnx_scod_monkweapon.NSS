#include "nwnx_dae"


void EnableMonkNew(){

	dae_AddMonkWeapon(BASE_ITEM_STILETTO);
	dae_AddMonkWeapon(BASE_ITEM_DAGGER);
	dae_AddMonkWeapon(BASE_ITEM_KUKRI);
	dae_AddMonkWeapon(BASE_ITEM_SHORT_STAFF);
	dae_AddMonkWeapon(BASE_ITEM_GIANT_STAFF);

	/*Creature Weapons*/

	string sCat;
	int nMax = GetNum2DARows("baseitems");
	int i;
	for (i = 0; i < nMax; i++){
		sCat = GetStringLowerCase(Get2DAString("baseitems", "WeaponCategory", i));
		if (FindSubString(sCat, "creature") != -1)
			dae_AddMonkWeapon(i);
	}
}

/*
  	dae_AddMonkWeapon(160);
    dae_AddMonkWeapon(161);
    dae_AddMonkWeapon(162);
    dae_AddMonkWeapon(163);
    dae_AddMonkWeapon(164);
    dae_AddMonkWeapon(165);
	dae_AddMonkWeapon(166);
    dae_AddMonkWeapon(167);
    dae_AddMonkWeapon(168);
    dae_AddMonkWeapon(169);
    dae_AddMonkWeapon(170);
	dae_AddMonkWeapon(171);
    dae_AddMonkWeapon(172);
    dae_AddMonkWeapon(173);
    dae_AddMonkWeapon(174);
	dae_AddMonkWeapon(176);
    dae_AddMonkWeapon(177);
	dae_AddMonkWeapon(178);
    dae_AddMonkWeapon(179);
    dae_AddMonkWeapon(180);
*/