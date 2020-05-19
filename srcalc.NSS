#include "ps_inc_functions"

//The basic gist of it, check the Warlock's spell against the target's SR and give feedback.
//Just like MyResistSpell, 0 = no resist, 1 = SR resist, 2 = Immune resist, 3 = Mantle use.
int DoWarlockMyResistSpell(object oCaster, object oTarget, float fDelay = 0.0);

//Calculates Warlock levels correctly for SR checks
int DoWarlockMyResistSpell(object oCaster, object oTarget, float fDelay = 0.0)
{
    if (fDelay > 0.5)
    {
        fDelay = fDelay - 0.1;
    }	
	int Resisted = 0;
    effect eSR = EffectVisualEffect( VFX_DUR_SPELL_SPELL_RESISTANCE );
    effect eGlobe = EffectVisualEffect( VFX_DUR_SPELL_GLOBE_INV_LESS );
    effect eMantle = EffectVisualEffect( VFX_DUR_SPELL_SPELL_MANTLE );
    int nTargetSR = GetSpellResistance(oTarget);
    int nMyCasterLevel = GetWarlockAndPRCClassLevels(oCaster);
	
	int needsAnotherRoll = 0;
        switch(ResistSpell(oCaster, oTarget))
        {
           case 0:		   
		   needsAnotherRoll = 1;
           case 1:
           needsAnotherRoll = 1;
           break;
           case 2:
           DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eGlobe, oTarget));
           Resisted = 2;
           break;
           case 3:
           DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMantle, oTarget));
           Resisted = 3;
           break;		 
		   
        }
		if(needsAnotherRoll)
		{
			int roll = d20(1) + nMyCasterLevel;
			//This is the debug floating message, giving current SR and your roll. Uncomment to see.
			/*	string rollmsg = IntToString(roll);
				string casterlevel = IntToString(nMyCasterLevel);
				FloatingTextStringOnCreature("CL: " + casterlevel + ",SR Roll: " + rollmsg, oCaster); */
			if (roll < nTargetSR)
			{
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSR, oTarget));  
				Resisted = 1; 
			}
			else
			{ 
				Resisted = 0;
			}	 
		}
	return Resisted;
}