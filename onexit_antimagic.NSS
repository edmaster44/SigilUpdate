#include "ff_applyeffect" 


void RemoveAntimagic(object creature)
{
	effect eEffect = GetFirstEffect(creature);
	int nType;
	while(GetIsEffectValid(eEffect))
	{
		nType = GetEffectType(eEffect);

		if(nType == EFFECT_TYPE_SPELL_FAILURE || nType == EFFECT_TYPE_SILENCE)
		{
			RemoveEffect(creature, eEffect);
			eEffect = GetFirstEffect(creature);
		} else eEffect = GetNextEffect(creature);
	}
	
	SetLocalInt(creature, "ps_anti_magic_zone", 0);
}

void main()
{
	object exitingChar = GetExitingObject();
	RemoveAntimagic(exitingChar);
	ExecuteScript("bar_onareaexit",OBJECT_SELF);
}