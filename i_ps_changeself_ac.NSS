// i_ps_changeself_ac
/*	Script created by Dedic8ed for use in the Sigil: City of Doors PW
	   
Attempt to recreate the PnP spell "change self" through use of a PnP item. This will require the use of the updated polymorph.2da
from the SCoD PW, which has different rows set up for both male and female versions of all playable races.

*/  

void main()
{
    object oPC      = GetItemActivator();
    object oItem    = GetItemActivated();
	effect eVis		= EffectVisualEffect(VFX_IMP_POLYMORPH);
	
	switch (GetLocalInt(oItem,"change"))
	
{
case 1 :
//Human Change
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
	DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
	
if (GetGender(oPC) == 1)
{
	effect ePoly	= EffectPolymorph(244, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 2);
}
else
{
	effect ePoly	= EffectPolymorph(243, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 2);
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
	SetLocalInt(oItem, "change", 3);
}
else
{
	effect ePoly	= EffectPolymorph(258, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 3);
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
	SetLocalInt(oItem, "change", 4);
}
else
{
	effect ePoly	= EffectPolymorph(233, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 4);
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
	SetLocalInt(oItem, "change", 5);
}
else
{
	effect ePoly	= EffectPolymorph(235, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 5);
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
	SetLocalInt(oItem, "change", 6);
}
else
{
	effect ePoly	= EffectPolymorph(237, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 6);
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
	SetLocalInt(oItem, "change", 7);
}
else
{
	effect ePoly	= EffectPolymorph(59, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 7);
}
break;

case 7 :
//Half-elf Change
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
	DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
	
if (GetGender(oPC) == 1)
{
	effect ePoly	= EffectPolymorph(240, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 8);
}
else
{
	effect ePoly	= EffectPolymorph(239, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 8);
}
break;

case 8 :
//Half-Drow Change
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
	DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
	
if (GetGender(oPC) == 1)
{
	effect ePoly	= EffectPolymorph(242, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 9);
}
else
{
	effect ePoly	= EffectPolymorph(241, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 9);
}
break;

case 9 :
//Aasimar Change
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
	DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
	
if (GetGender(oPC) == 1)
{
	effect ePoly	= EffectPolymorph(261, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 10);
}
else
{
	effect ePoly	= EffectPolymorph(260, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 10);
}
break;

case 10 :
//Half-orc Change
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
	DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
	
if (GetGender(oPC) == 1)
{
	effect ePoly	= EffectPolymorph(250, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 11);
}
else
{
	effect ePoly	= EffectPolymorph(249, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 11);
}
break;

case 11 :
//Gray Orc Change
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
	DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
	
if (GetGender(oPC) == 1)
{
	effect ePoly	= EffectPolymorph(252, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 12);
}
else
{
	effect ePoly	= EffectPolymorph(251, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 12);
}
break;

case 12 :
//Yuan-ti Pureblood Change
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
	DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
	
if (GetGender(oPC) == 1)
{
	effect ePoly	= EffectPolymorph(232, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 13);
}
else
{
	effect ePoly	= EffectPolymorph(231, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 13);
}
break;

case 13 :
//Shield Dwarf Change
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
	DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
	
if (GetGender(oPC) == 1)
{
	effect ePoly	= EffectPolymorph(245, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 14);
}
else
{
	effect ePoly	= EffectPolymorph(217, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 14);
}
break;

case 14 :
//Duergar Change
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
	DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
	
if (GetGender(oPC) == 1)
{
	effect ePoly	= EffectPolymorph(248, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 15);
}
else
{
	effect ePoly	= EffectPolymorph(216, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 15);
}
break;

case 15 :
//Gold Dwarf Change
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
	DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
	
if (GetGender(oPC) == 1)
{
	effect ePoly	= EffectPolymorph(247, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 16);
}
else
{
	effect ePoly	= EffectPolymorph(246, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 16);
}
break;

case 16 :
//Strongheart Halfling Change
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
	DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
	
if (GetGender(oPC) == 1)
{
	effect ePoly	= EffectPolymorph(256, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 17);
}
else
{
	effect ePoly	= EffectPolymorph(255, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 17);
}
break;

case 17 :
//Lightfoot Halfling Change
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
	DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
	
if (GetGender(oPC) == 1)
{
	effect ePoly	= EffectPolymorph(254, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 18);
}
else
{
	effect ePoly	= EffectPolymorph(253, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 18);
}
break;

case 18 :
//Gnome Change
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
	DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
	
if (GetGender(oPC) == 1)
{
	effect ePoly	= EffectPolymorph(215, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 19);
}
else
{
	effect ePoly	= EffectPolymorph(214, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 19);
}
break;

case 19 :
//Deep Gnome Change
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
	DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
	
if (GetGender(oPC) == 1)
{
	effect ePoly	= EffectPolymorph(257, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 20);
}
else
{
	effect ePoly	= EffectPolymorph(213, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 20);
}
break;

case 20 :
//Air Genasi Change
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
	DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
	
if (GetGender(oPC) == 1)
{
	effect ePoly	= EffectPolymorph(263, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 21);
}
else
{
	effect ePoly	= EffectPolymorph(262, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 21);
}
break;

case 21 :
//Earth Genasi Change
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
	DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
	
if (GetGender(oPC) == 1)
{
	effect ePoly	= EffectPolymorph(265, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 22);
}
else
{
	effect ePoly	= EffectPolymorph(264, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 22);
}
break;

case 22 :
//Fire Genasi Change
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
	DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
	
if (GetGender(oPC) == 1)
{
	effect ePoly	= EffectPolymorph(267, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 23);
}
else
{
	effect ePoly	= EffectPolymorph(266, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 23);
}
break;

case 23 :
//Water Genasi Change
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
	DelayCommand(0.4, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
	
if (GetGender(oPC) == 1)
{
	effect ePoly	= EffectPolymorph(269, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 2);
}
else
{
	effect ePoly	= EffectPolymorph(268, 0, 0);
	DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC));
	SetLocalInt(oItem, "change", 2);
}
break;
}
}