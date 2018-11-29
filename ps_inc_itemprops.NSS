const int SPECIAL_MAT_BLOODIRON = 0;
const int SPECIAL_MAT_ALCHEMIC_PLATINUM = 1;
const int SPECIAL_MAT_ARBOREAL_OAK = 31;
const int SPECIAL_MAT_AURORUM = 2;
const int SPECIAL_MAT_AXIOMATIC_BRASS = 3;
const int SPECIAL_MAT_BLOOD_GLASS = 4;
const int SPECIAL_MAT_BYESHK = 5;
const int SPECIAL_MAT_CELESTIAL_PLUMES = 27;
const int SPECIAL_MAT_COPPER = 16;
const int SPECIAL_MAT_DEMON_SCALE = 28;
const int SPECIAL_MAT_DEVIL_SCALE = 29;
const int SPECIAL_MAT_DRAGON_BONE = 32;
const int SPECIAL_MAT_DHIDE_BLACK = 22;
const int SPECIAL_MAT_DHIDE_BLUE = 23;
const int SPECIAL_MAT_DHIDE_GREEN = 26;
const int SPECIAL_MAT_DHIDE_RED = 24;
const int SPECIAL_MAT_DHIDE_WHITE = 25;
const int SPECIAL_MAT_DRAGON_SINEW = 35;
const int SPECIAL_MAT_ELECTRUM = 17;
const int SPECIAL_MAT_FORMIC_AMBER = 33;
const int SPECIAL_MAT_GLASSTEEL = 6;
const int SPECIAL_MAT_GOLD = 18;
const int SPECIAL_MAT_METALLINE = 7;
const int SPECIAL_MAT_METEORIC_IRON = 8;
const int SPECIAL_MAT_MINDSILVER = 9;
const int SPECIAL_MAT_MORGUTH_IRON = 10;
const int SPECIAL_MAT_NEUMANNIC_FLYWHEEL = 36;
const int SPECIAL_MAT_OERTHBLOOD = 11;
const int SPECIAL_MAT_OPHIDIAN = 30;
const int SPECIAL_MAT_PANDEMONIC_SILVER = 12;
const int SPECIAL_MAT_PLATINUM = 19;
const int SPECIAL_MAT_REGULAN_GEARSPRING = 37;
const int SPECIAL_MAT_RIVERINE = 13;
const int SPECIAL_MAT_SILVER = 20;
const int SPECIAL_MAT_SOLANION_TRUESTEEL = 14;
const int SPECIAL_MAT_TANTULHOR = 15;
const int SPECIAL_MAT_TWELVETREES_BARK = 34;
const int SPECIAL_MAT_WHITE_GOLD = 21;
const int SPECIAL_MAT_IRON = 38;
const int SPECIAL_MAT_LEATHER = 39;
const int SPECIAL_MAT_WOOD = 40;
const int SPECIAL_MAT_COLD_IRON = 41;

//Cycles through objects in the DM area until it finds the correct one
object GetObjectFromDMArea(string sTag)
{
	int iDMArea = GetGlobalInt("DM_AREA");
	object oDMArea = IntToObject(iDMArea);
	
	object oObj = GetFirstObjectInArea(oDMArea);
	while (GetTag(oObj) != sTag && oObj != OBJECT_INVALID) {
		oObj = GetNextObjectInArea(oDMArea);
	}
	
	return oObj;
}

itemproperty ItemPropertySpecialMaterial(int nMat) {

	object oChest = GetObjectFromDMArea("pc_utility_ipchest");
	string sItem = "";
	
	switch (nMat) {
		case SPECIAL_MAT_BLOODIRON: sItem = "ps_crft_utility_bi"; break;
		case SPECIAL_MAT_ALCHEMIC_PLATINUM: sItem = "ps_crft_utility_ap"; break;
		case SPECIAL_MAT_ARBOREAL_OAK: sItem = "ps_crft_utility_ae"; break;
		case SPECIAL_MAT_AURORUM: sItem = "ps_crft_utility_au"; break;
		case SPECIAL_MAT_AXIOMATIC_BRASS: sItem = "ps_crft_utility_ab"; break;
		case SPECIAL_MAT_BLOOD_GLASS: sItem = "ps_crft_utility_bg"; break;
		case SPECIAL_MAT_BYESHK: sItem = "ps_crft_utility_by"; break;
		case SPECIAL_MAT_CELESTIAL_PLUMES: sItem = "ps_crft_utility_cp"; break;
		case SPECIAL_MAT_COPPER: sItem = "ps_crft_utility_cop"; break;
		case SPECIAL_MAT_DEMON_SCALE: sItem = "ps_crft_utility_demon"; break;
		case SPECIAL_MAT_DEVIL_SCALE: sItem = "ps_crft_utility_devil"; break;
		case SPECIAL_MAT_DRAGON_BONE: sItem = "ps_crft_utility_dbone"; break;
		case SPECIAL_MAT_DHIDE_BLACK: sItem = "ps_crft_utility_dhideblack"; break;
		case SPECIAL_MAT_DHIDE_BLUE: sItem = "ps_crft_utility_dhideblue"; break;
		case SPECIAL_MAT_DHIDE_GREEN: sItem = "ps_crft_utility_dhidegreen"; break;
		case SPECIAL_MAT_DHIDE_RED: sItem = "ps_crft_utility_dhidered"; break;
		case SPECIAL_MAT_DHIDE_WHITE: sItem = "ps_crft_utility_dhidewhite"; break;
		case SPECIAL_MAT_DRAGON_SINEW: sItem = "ps_crft_utility_dsinew"; break;
		case SPECIAL_MAT_ELECTRUM: sItem = "ps_crft_utility_electrum"; break;
		case SPECIAL_MAT_FORMIC_AMBER: sItem = "ps_crft_utility_famber"; break;
		case SPECIAL_MAT_GLASSTEEL: sItem = "ps_crft_utility_gsteel"; break;
		case SPECIAL_MAT_GOLD: sItem = "ps_crft_utility_gold"; break;
		case SPECIAL_MAT_METALLINE: sItem = "ps_crft_utility_metal"; break;
		case SPECIAL_MAT_METEORIC_IRON: sItem = "ps_crft_utility_miron"; break;
		case SPECIAL_MAT_MINDSILVER: sItem = "ps_crft_utility_msilver"; break;
		case SPECIAL_MAT_MORGUTH_IRON: sItem = "ps_crft_utility_morguth"; break;
		case SPECIAL_MAT_NEUMANNIC_FLYWHEEL: sItem = "ps_crft_utility_nfly"; break;
		case SPECIAL_MAT_OERTHBLOOD: sItem = "ps_crft_utility_oerth"; break;
		case SPECIAL_MAT_OPHIDIAN: sItem = "ps_crft_utility_ophid"; break;
		case SPECIAL_MAT_PANDEMONIC_SILVER: sItem = "ps_crft_utility_psilver"; break;
		case SPECIAL_MAT_PLATINUM: sItem = "ps_crft_utility_plat"; break;
		case SPECIAL_MAT_REGULAN_GEARSPRING: sItem = "ps_crft_utility_rgear"; break;
		case SPECIAL_MAT_RIVERINE: sItem = "ps_crft_utility_river"; break;
		case SPECIAL_MAT_SILVER: sItem = "ps_crft_utility_silver"; break;
		case SPECIAL_MAT_SOLANION_TRUESTEEL: sItem = "ps_crft_utility_strue"; break;
		case SPECIAL_MAT_TANTULHOR: sItem = "ps_crft_utility_tantul"; break;
		case SPECIAL_MAT_TWELVETREES_BARK: sItem = "ps_crft_utility_twelvebark"; break;
		case SPECIAL_MAT_WHITE_GOLD: sItem = "ps_crft_utility_wgold"; break;
		case SPECIAL_MAT_IRON: sItem = "ps_crft_utility_iron"; break;
		case SPECIAL_MAT_LEATHER: sItem = "ps_crft_utility_leather"; break;
		case SPECIAL_MAT_WOOD: sItem = "ps_crft_utility_wood"; break;
		case SPECIAL_MAT_COLD_IRON: sItem = "ps_crft_utility_coldiron"; break;
	}
	
	object oSpoon = CreateItemOnObject(sItem, oChest);
	
	itemproperty ip = GetFirstItemProperty(oSpoon);	
	DestroyObject(oSpoon, 1.0f);
	return ip;
}

//Gets the base material type (i.e. DR piercing) from the 
//item MadeOf Property. 
int GetItemMaterialTypeFromProperty(itemproperty ip) {

	if (GetItemPropertyType(ip) != 100)
		return 0;

	int nSub = GetItemPropertySubType(ip);
	
	if (nSub == SPECIAL_MAT_BLOODIRON || nSub ==  SPECIAL_MAT_PANDEMONIC_SILVER || 
	nSub == SPECIAL_MAT_SILVER)
		return GMATERIAL_METAL_ALCHEMICAL_SILVER;	
	else if (nSub == SPECIAL_MAT_METEORIC_IRON || nSub == SPECIAL_MAT_BYESHK ||
	nSub == SPECIAL_MAT_BLOOD_GLASS || nSub == SPECIAL_MAT_TANTULHOR)
		return GMATERIAL_METAL_ADAMANTINE;
	else if (nSub == SPECIAL_MAT_SOLANION_TRUESTEEL || nSub == SPECIAL_MAT_MORGUTH_IRON || nSub == SPECIAL_MAT_ALCHEMIC_PLATINUM)
		return GMATERIAL_METAL_MITHRAL;
	else if (nSub == SPECIAL_MAT_AXIOMATIC_BRASS || nSub == SPECIAL_MAT_COLD_IRON)
		return GMATERIAL_METAL_COLD_IRON;
	else 
		return GMATERIAL_NONSPECIFIC;
}