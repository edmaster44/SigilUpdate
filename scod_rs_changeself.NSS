//::///////////////////////////////////////////////
//:: Polymorph Self
//:: NW_S0_PolySelf.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The PC is able to changed their form to one of
    several forms.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 21, 2002
//:://////////////////////////////////////////////
// ChazM 1/18/07 - EvenFlw modifications

#include "x2_inc_spellhook"

// fix supplied by Mick64
void RemoveExtraHitPoints(object oPC)
{
	int maxHP = GetMaxHitPoints(oPC);
	int totalHP = GetCurrentHitPoints(oPC);

	if (totalHP > maxHP)
	{
 		effect damage = EffectDamage((totalHP - maxHP), IP_CONST_DAMAGETYPE_MAGICAL, DAMAGE_POWER_NORMAL, TRUE);
 		ApplyEffectToObject(DURATION_TYPE_INSTANT, damage, oPC);
	}
}

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


  
		
    object oPC = GetSpellTargetObject();
    effect eVis = EffectVisualEffect( VFX_DUR_POLYMORPH );
    effect ePoly;


    //Determine Polymorph subradial type
    switch (d20(1))	
		{
		case 1 :
		//Human Change
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
			DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
			
		if (GetGender(oPC) == 1)
		{
			
			effect ePoly	= EffectPolymorph(244, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		else
		{
			effect ePoly	= EffectPolymorph(243, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		break;
		
		case 2 :
		//Tiefling Change
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
			DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
			
		if (GetGender(oPC) == 1)
		{
			effect ePoly	= EffectPolymorph(259, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		else
		{
			effect ePoly	= EffectPolymorph(258, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		break;
		
		case 3 :
		//Moon Elf Change
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
			DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
			
		if (GetGender(oPC) == 1)
		{
			effect ePoly	= EffectPolymorph(234, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		else
		{
			effect ePoly	= EffectPolymorph(233, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		break;
		
		case 4 :
		//Sun Elf Change
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
			DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
			
		if (GetGender(oPC) == 1)
		{
			effect ePoly	= EffectPolymorph(236, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		else
		{
			effect ePoly	= EffectPolymorph(235, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		break;
		
		case 5 :
		//Wood Elf Change
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
			DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
			
		if (GetGender(oPC) == 1)
		{
			effect ePoly	= EffectPolymorph(238, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		else
		{
			effect ePoly	= EffectPolymorph(237, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		break;
		
		case 6 :
		//Drow Change
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
			DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
			
		if (GetGender(oPC) == 1)
		{
			effect ePoly	= EffectPolymorph(60, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		else
		{
			effect ePoly	= EffectPolymorph(59, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		break;
		
		case 7 :
		//Aasimar Change
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
			DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
			
		if (GetGender(oPC) == 1)
		{
			effect ePoly	= EffectPolymorph(261, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		else
		{
			effect ePoly	= EffectPolymorph(260, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		break;
		
		case 8 :
		//Half-orc Change
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
			DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
			
		if (GetGender(oPC) == 1)
		{
			effect ePoly	= EffectPolymorph(250, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		else
		{
			effect ePoly	= EffectPolymorph(249, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		break;
		
		case 9 :
		//Gray Orc Change
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
			DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
			
		if (GetGender(oPC) == 1)
		{
			effect ePoly	= EffectPolymorph(252, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		else
		{
			effect ePoly	= EffectPolymorph(251, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		break;
		
		case 10 :
		//Yuan-ti Pureblood Change
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
			DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
			
		if (GetGender(oPC) == 1)
		{
			effect ePoly	= EffectPolymorph(232, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		else
		{
			effect ePoly	= EffectPolymorph(231, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		break;
		
		case 11 :
		//Shield Dwarf Change
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
			DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
			
		if (GetGender(oPC) == 1)
		{
			effect ePoly	= EffectPolymorph(245, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		else
		{
			effect ePoly	= EffectPolymorph(217, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		break;
		
		case 12 :
		//Duergar Change
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
			DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
			
		if (GetGender(oPC) == 1)
		{
			effect ePoly	= EffectPolymorph(248, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		else
		{
			effect ePoly	= EffectPolymorph(216, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		break;
		
		case 13 :
		//Gold Dwarf Change
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
			DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
			
		if (GetGender(oPC) == 1)
		{
			effect ePoly	= EffectPolymorph(247, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		else
		{
			effect ePoly	= EffectPolymorph(246, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		break;
		
		case 14 :
		//Lightfoot Halfling Change
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
			DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
			
		if (GetGender(oPC) == 1)
		{
			effect ePoly	= EffectPolymorph(254, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		else
		{
			effect ePoly	= EffectPolymorph(253, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		break;
		
		case 15 :
		//Gnome Change
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
			DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
			
		if (GetGender(oPC) == 1)
		{
			effect ePoly	= EffectPolymorph(215, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		else
		{
			effect ePoly	= EffectPolymorph(214, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		break;
		
		case 16 :
		//Deep Gnome Change
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
			DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
			
		if (GetGender(oPC) == 1)
		{
			effect ePoly	= EffectPolymorph(257, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		else
		{
			effect ePoly	= EffectPolymorph(213, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		break;
		
		case 17 :
		//Air Genasi Change
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
			DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
			
		if (GetGender(oPC) == 1)
		{
			effect ePoly	= EffectPolymorph(263, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		else
		{
			effect ePoly	= EffectPolymorph(262, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		break;
		
		case 18 :
		//Earth Genasi Change
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
			DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
			
		if (GetGender(oPC) == 1)
		{
			effect ePoly	= EffectPolymorph(265, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		else
		{
			effect ePoly	= EffectPolymorph(264, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		break;
		
		case 19 :
		//Fire Genasi Change
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
			DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
			
		if (GetGender(oPC) == 1)
		{
			effect ePoly	= EffectPolymorph(267, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		else
		{
			effect ePoly	= EffectPolymorph(266, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		break;
		
		case 20 :
		//Water Genasi Change
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
			DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
			
		if (GetGender(oPC) == 1)
		{
			effect ePoly	= EffectPolymorph(269, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		else
		{
			effect ePoly	= EffectPolymorph(268, 0, 0);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
			
		}
		break;
		}
    

    SignalEvent(oPC, EventSpellCastAt(OBJECT_SELF, 1379, FALSE));

}