// Feat created by Ceremorph 4/18/2016
// Spell-like abilities granted by certain classes
// Reviewed by Clangeddin 28/12/2017

#include "x2_inc_spellhook"
#include "ps0_classes2015_inc"
#include "aaa_constants"
#include "ps_inc_functions"

void main()
{
	if (!X2PreSpellCastCode()) return;

    object oPC 			= OBJECT_SELF;
	int nSpell 			= GetSpellId();
	object oTarget		= GetSpellTargetObject();
	location lTarget	= GetSpellTargetLocation();
	int iLevel;
	
	switch (nSpell)
	{
		//SHADOWDANCER
		case 475 : PS_Feat_SHD_ShadowDaze(oPC, oTarget, nSpell); break;
		case 476 : PS_Feat_SHD_SummonShadow(oPC, nSpell); break;
		case 477 : PS_Feat_SHD_ShadowEvade(oPC, nSpell); break;
		case 1217 :	PS_Feat_SHD_ShadowJump(oPC, lTarget, nSpell); break;
		
		//BLACKGUARD
		case 609 : PS_Feat_BG_CreateUndead(oPC, nSpell); break;
		case 610 : PS_Feat_BG_FiendishServant(oPC, nSpell);	break;
		
		//GATECRASHER
		case 1382 : PS_Feat_GC_FindPortal(oPC, nSpell);	break;

		//DEMONOLOGIST
		case 1616 :	PS_Feat_DMN_BinderOfFiends(oPC, nSpell); break;
		case 1617 :	PS_Feat_DMN_FiendishMantle(oPC, nSpell); break;
		case 1618 :	PS_Feat_DMN_FortificationVsFiends(oPC, nSpell); break;
		case 1620 :	PS_Feat_DMN_ReleaseBinding(oPC, nSpell); break;
		
		//SLAYER OF DOMIEL
		case 1621 :	PS_Feat_SOD_DeathTouch(oPC, oTarget, nSpell); break;
		case 1622 :	PS_Feat_SOD_BlessWeapon(oPC, oTarget, nSpell); break;
		case 1623 :	PS_Feat_SOD_DeathWard(oPC, oTarget, nSpell); break;
		
		//CELESTIAL ENVOY
		case 1626 : PS_Feat_CE_HolyAura(oPC, nSpell); break;
		case 1627 :	PS_Feat_CE_GreaterHolyAura(oPC, nSpell); break;
		case 1628 :	PS_Feat_CE_InspiredCalling(oPC, lTarget, nSpell); break;
		case 1630 :	PS_Feat_CE_HeroicValor(oPC, lTarget, nSpell); break;
		case 1631 :	PS_Feat_CE_HallowedWeapon(oPC, oTarget, nSpell); break;
		case 1632 :	PS_Feat_CE_FistOfTheHeavens(oPC, nSpell); break;
		case 1633 :	PS_Feat_CE_ArmorOfTheTome(oPC, nSpell);	break;
		case 1634 :	PS_Feat_CE_SanctifiedSoul(oPC, nSpell); break;
		case 1635 :	PS_Feat_CE_DivineEndurance(oPC, nSpell); break;
		case 1636 :	PS_Feat_CE_ArchonicPath(oPC); break;
		
		//GOLEM MASTER
		case 1638 :	PS_Feat_GM_Gargoyle(oPC, lTarget, nSpell); break;
	}
}