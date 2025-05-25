

// Created by Agony_Aunt/Loki_666
// used for Astral Plane - Divinty Leech

void main()
{
	object oPC = GetExitingObject();
	
	if (GetIsPC(oPC))
	{
		SendMessageToPC(oPC, "<COLOR=YELLOW><i>As you leave the light you feel the energy gained slowly start to leave you.");
		SetLocalInt(oPC, "ASTRAL_LIGHT", 0);
		/*
		effect eEffect = GetFirstEffect(oPC);
		
		while (GetIsEffectValid(eEffect))
		{
			if (GetEffectType(eEffect) == EFFECT_TYPE_TEMPORARY_HITPOINTS)
			{
				RemoveEffect(oPC, eEffect);
			}
			eEffect = GetNextEffect(oPC);
		}
		*/
	}
}