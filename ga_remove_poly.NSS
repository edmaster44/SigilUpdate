// Script to remove polymorph for when talking to an appearance changer.

void main()
{
	object oPC = GetPCSpeaker();
	
	effect eEffect = GetFirstEffect(oPC);
	
	while (GetIsEffectValid(eEffect))
	{
		if (GetEffectType(eEffect) == EFFECT_TYPE_POLYMORPH)
		{
			RemoveEffect(oPC, eEffect);
		}
	    
	    eEffect = GetNextEffect(oPC);
	}
	

}