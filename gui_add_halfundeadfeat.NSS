#include "ps_inc_functions"
#include "ps_class_inc"
#include "aaa_constants"


int HalfUndeadFeat(object oPC);

//GUI Stuff
int HalfUndeadFeat(object oPC)
{

	int nHalfUndead = GetLevelByClass(114, oPC);

	if (nHalfUndead > 0)
	{
		if (!GetHasFeat(FEAT_FETCH,oPC) &&
			!GetHasFeat(FEAT_HALFVAMPIRE,oPC) &&
			!GetHasFeat(FEAT_GHUL,oPC) &&
			!GetHasFeat(FEAT_GHAEDEN,oPC))
		{
			AddScriptParameterString("START");
			AddScriptParameterString("");
			ExecuteScriptEnhanced("gui_extra_choices", oPC);
		}
	}
	return nHalfUndead;
}
