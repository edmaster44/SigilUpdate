//////////////////////////////////////////
// On Exit script for Freezing Fog AOE	//
// Ceremorph 4/26/16					//
//////////////////////////////////////////

void main()
{
    object oTarget = GetExitingObject();
    int bValid = FALSE;
    effect eAOE;
    if(GetHasSpellEffect(1229, oTarget))
    {	eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE) && bValid == FALSE)
        {	if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {	if(GetEffectType(eAOE) == EFFECT_TYPE_SLOW)
                {	if(GetEffectSpellId(eAOE) == SPELL_INCENDIARY_CLOUD)
                    {	RemoveEffect(oTarget, eAOE);
                        bValid = TRUE;	}
                }
            }
            eAOE = GetNextEffect(oTarget);
        }
    }
}