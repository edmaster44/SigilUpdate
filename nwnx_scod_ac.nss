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
	dae_AddInnateACFeat(FEAT_METHODICAL_DEF_AC_1, 2);
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

	dae_AddInnateACFeat(FEAT_CROC_ARMOR_AC_1, 1);
	dae_AddInnateACFeat(FEAT_CROC_ARMOR_AC_2, 2);
	dae_AddInnateACFeat(FEAT_CROC_ARMOR_AC_3, 3);

}



















