/*
	Assigns specific innate or natural AC values to certain feats that previously had used dodge AC
	-Flatted Fifth, Jan 17, 2025
*/


#include "nwnx_dae"
#include "aaa_constants"

void SetFeatAC(){

	dae_AddInnateACFeat(FEAT_SITUATIONAL_AWARENESS_1_AC, 1);
	dae_AddInnateACFeat(FEAT_SITUATIONAL_AWARENESS_2_AC, 2);
	dae_AddInnateACFeat(FEAT_SITUATIONAL_AWARENESS_3_AC, 3);
	dae_AddInnateACFeat(FEAT_METHODICAL_DEF_AC_1, 1);
	dae_AddInnateACFeat(FEAT_METHODICAL_DEF_AC_2, 2);
	dae_AddInnateACFeat(FEAT_METHODICAL_DEF_AC_3, 3);
	dae_AddInnateACFeat(FEAT_ARMOR_OPT_AC_1, 1);
	dae_AddInnateACFeat(FEAT_ARMOR_OPT_AC_2, 2);
	dae_AddInnateACFeat(FEAT_ARMOR_OPT_AC_4, 4);
	dae_AddInnateACFeat(FEAT_STAL_DEF_AC_1, 1);
	dae_AddInnateACFeat(FEAT_STAL_DEF_AC_2, 2);
	dae_AddInnateACFeat(FEAT_STAL_DEF_AC_3, 3);
	dae_AddInnateACFeat(FEAT_STAL_DEF_AC_4, 4);
	dae_AddInnateACFeat(FEAT_STAL_DEF_STANCE_AC, 4);
	
	// turns out the Bone Skin series of feats for Pale Master
	// do NOT grant any AC in and of themselves. The game engine
	// does that for default Pale Master and the feats are just
	// there for the player to read. Assigning 2 AC to bone skin 2,
	// which is the only one we're currently using.
	dae_AddInnateACFeat(FEAT_BONE_SKIN_2, 2);
	// if we want to use the other bone skin feats for anything, uncomment
	// the following:
	//dae_AddInnateACFeat(FEAT_BONE_SKIN_4, 4);
	//dae_AddInnateACFeat(FEAT_BONE_SKIN_6, 6);

	dae_AddInnateACFeat(FEAT_CROC_ARMOR_AC_1, 1);
	dae_AddInnateACFeat(FEAT_CROC_ARMOR_AC_2, 2);
	dae_AddInnateACFeat(FEAT_CROC_ARMOR_AC_3, 3);

}



















