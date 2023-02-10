//::///////////////////////////////////////////////
//:: Summon Familiar
//:: NW_S2_Familiar
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell summons an Arcane casters familiar
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 27, 2001
//:://////////////////////////////////////////////
#include "aaa_constants"
#include "template_pseudonatural"

void ApplyPseudonaturalToFamiliar(object oCaster = OBJECT_SELF)
{
	object oFamiliar = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oCaster);
	if (GetHasFeat(FEAT_ALIENIST_PSEUDO_FAMILIAR, oCaster, TRUE) && GetIsObjectValid(oFamiliar))
	{
		ApplyTemplatePseudonatural(oFamiliar);
	}
}

void main()
{
    SummonFamiliar();
    DelayCommand(1.0, ApplyPseudonaturalToFamiliar());
}
