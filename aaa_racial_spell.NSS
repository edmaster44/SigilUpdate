/* Feat created by Ceremorph 11/25/15
Spell-like abilities granted by race or racial PrC  */

#include "x2_inc_spellhook"
#include "aaa_racial_spell_inc"
#include "aaa_constants"
#include "ps_inc_functions"

void main()
{
	if (!X2PreSpellCastCode())
    {	return;	}

    object oPC 			= OBJECT_SELF;
	int nSpell 			= GetSpellId();
	object oTarget		= GetSpellTargetObject();
	location lTarget	= GetSpellTargetLocation();
	int iLevel;
	
	switch (nSpell)
	{
		case 580 :		//Hound Archon Hero - Aid
		{	iLevel = GetLevelByClass(CLASS_TYPE_HOUNDARCH_HERO_PRC, oPC);
			PS_Cast_HA_Aid(iLevel);	}
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 586 :		//Trumpet Archon - Trumpet Blast
			PS_Cast_TArchonBlast(oPC);
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 587 :		//Trumpet Archon - Trumpet Reveille
			PS_Cast_TArchonReveille(oPC);
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 597 :		//Yuan-ti Halfblood - Animal Trance
		{	iLevel = PS_GetLevel(oPC);
			PS_Cast_YTHBAnimalTrance(oPC, iLevel, lTarget, nSpell);}
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 598 :		//Yuan-ti Halfblood - Entangle
		{	iLevel = PS_GetLevel(oPC);
			PS_Cast_YTHBEntangle(oPC, lTarget, iLevel, nSpell);	}
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 599 :		//Youan-ti Halfblood - Neutralize Poison
		{	PS_Cast_YTHBNeutralizePoison(oPC, oTarget, nSpell);	}
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 1451 :		//Movanic Deva - Prayer
		{	iLevel = GetLevelByClass(CLASS_TYPE_MOVANIC_DEVA_PRC, oPC);
			PS_Cast_Prayer(iLevel);	}
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 1452 :		//Movanic Deva - Cure Critical Wounds
		{	iLevel = GetLevelByClass(CLASS_TYPE_MOVANIC_DEVA_PRC, oPC);
			PS_Cast_CureCritical(oTarget, iLevel);	}
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 1453 :		//Movanic Deva - Ethereal Jaunt
		{	iLevel = GetLevelByClass(CLASS_TYPE_MOVANIC_DEVA_PRC, oPC);
			PS_Cast_EtherealJaunt(oTarget, iLevel);	}
		break;
///////////////////////////////////////////////////////////////////////////////////
		case 1454 :		//Movanic Deva - Raise Dead
			PS_Cast_RaiseDead(oTarget);
		break;
///////////////////////////////////////////////////////////////////////////////////		
		case 1460 :		//Drider - Clairvoyance/Clairaudience
		{	iLevel = PS_GetLevel(oPC);
			PS_Cast_DR_Clairvoyance(oTarget, iLevel);	}
		break;
///////////////////////////////////////////////////////////////////////////////////		
		case 1461 :		//Drider - Dispel Magic
		{	iLevel = PS_GetLevel(oPC);
			PS_Cast_DR_DispelMagic(lTarget, oTarget, iLevel);	}
		break;
///////////////////////////////////////////////////////////////////////////////////	
		case 1462 :		//Drider - Summon Swarm
		{	PS_Cast_DR_SummonSwarm(oPC);	}
		break;
///////////////////////////////////////////////////////////////////////////////////		
		case 1466 :		//Bralani - Blur
		{	iLevel = GetLevelByClass(CLASS_TYPE_BRALANI_PRC, oPC);
			PS_Cast_BR_Blur(oPC, iLevel, nSpell);	}
		break;
///////////////////////////////////////////////////////////////////////////////////		
		case 1467 :		//Bralani - Lightning Bolt
		{	iLevel = PS_GetLevel(oPC);
			iLevel = iLevel / 2;
			PS_Cast_BR_LightningBolt(oPC, lTarget, oTarget, iLevel);	}
		break;
///////////////////////////////////////////////////////////////////////////////////		
		case 1470 :		//Firre - Magic Circle vs. Evil
		{	iLevel = PS_GetLevel(oPC);
			PS_Cast_EF_CircleVsEvil(oPC, iLevel, nSpell);	}
		break;
///////////////////////////////////////////////////////////////////////////////////		
		case 1487 :		//Xeph - Burst
		{	iLevel = GetHitDice(oPC);
			PS_Cast_XephBurst(oPC, iLevel, nSpell);	}
		break;
///////////////////////////////////////////////////////////////////////////////////		
		case 1489 :		//Night Hag - Sleep
		{	iLevel = GetHitDice(oPC);
			PS_Cast_Hag_Sleep(oPC, iLevel, nSpell);	}
		break;
///////////////////////////////////////////////////////////////////////////////////		
		case 1490 :		//Night Hag - Ray of Enfeeblement
		{	iLevel = GetHitDice(oPC);
			PS_Cast_Hag_Enfeeblement(oPC, iLevel, nSpell);	}
		break;
///////////////////////////////////////////////////////////////////////////////////		
		case 1494 :		//MotC - Magic Missile
		{	PS_Cast_MOTC_MagicMissile(oPC, nSpell);	}
		break;
///////////////////////////////////////////////////////////////////////////////////		
		case 1496 :		//MotC - Etherealness
		{	PS_Cast_MOTC_Etherealness(oPC, nSpell);	}
		break;
///////////////////////////////////////////////////////////////////////////////////		
		case 1497 :		//MotC - Soul Bind
		{	PS_Cast_MOTC_SoulBind(oPC, oTarget, nSpell);	}
		break;
///////////////////////////////////////////////////////////////////////////////////		
		case 1687 :		//Ogre Mage - Darkness
		{	iLevel = PS_GetLevel(oPC);
			PS_Cast_OM_Darkness(lTarget, iLevel);	}
		break;
///////////////////////////////////////////////////////////////////////////////////	
		case 1688 :		//Ogre Mage - Hiss of Sleep
		{	iLevel = PS_GetLevel(oPC);
			PS_Cast_OM_HissOfSleep(lTarget, iLevel);	}
		break;
///////////////////////////////////////////////////////////////////////////////////	
		case 1693 :		//Ogre Mage - Cone of Cold
		{	iLevel = PS_GetLevel(oPC);
			PS_Cast_OM_ConeOfCold(lTarget, iLevel);	}
		break;
///////////////////////////////////////////////////////////////////////////////////	
		case 1825 :		//Succubus - Summon Tanar'ri
		{	PS_Cast_SU_SummonTanarri(oPC);	}
		break;
///////////////////////////////////////////////////////////////////////////////////	
		case 1827 :		//Marquis Cambion - Mirror Image
		{	iLevel = GetLevelByClass(CLASS_TYPE_MARQUIS_CAMBION, oPC);
			PS_Cast_MQ_MirrorImage(oPC, iLevel, nSpell);	}
		break;
///////////////////////////////////////////////////////////////////////////////////	
		case 1831 :		//Lilitu's Gift
		{	PS_Cast_SU_LilitusGift(oPC, oTarget, nSpell);	}
		break;
///////////////////////////////////////////////////////////////////////////////////	
		case 1885 :		//Erinyes - Unholy Blight
		{	iLevel = GetLevelByClass(CLASS_TYPE_ERINYES, oPC);
			PS_Cast_EY_UnholyBlight(oPC, lTarget, nSpell, iLevel);	}
		break;
///////////////////////////////////////////////////////////////////////////////////	
		case 1887 :		//Erinyes - Summon Baatezu
		{	PS_Cast_EY_SummonBaatezu(oPC);	}
		break;
///////////////////////////////////////////////////////////////////////////////////	
		case 1890 :		//Brachina - Vampiric Touch
		{	PS_Cast_BR_VampiricTouch(oPC, oTarget, nSpell);	}
		break;
///////////////////////////////////////////////////////////////////////////////////	
		case 1891 :		//Brachina - Summon Baatezu
		{	PS_Cast_BR_SummonBaatezu(oPC);	}
		break;
///////////////////////////////////////////////////////////////////////////////////	
		case 1893 :		//Brachina - Beguile
		{	iLevel = PS_GetLevel(oPC);
			PS_Cast_BR_Beguile(oPC, oTarget, nSpell, iLevel);	}
		break;
///////////////////////////////////////////////////////////////////////////////////			
		case 1899 :		//Ice para-genasi - Hoarfrost Armor
		{	iLevel = PS_GetLevel(oPC);
			PS_Cast_IG_HoarfrostArmor(oPC, nSpell, iLevel);	}
		break;
///////////////////////////////////////////////////////////////////////////////////	
		case 2602 :		//Hezrou - Blasphemy
		{	PS_Cast_HE_Blasphemy(oPC);	}
		break;
///////////////////////////////////////////////////////////////////////////////////	
		case 2604 :		//Hezrou - Summon Tanar'ri
		{	PS_Cast_HE_SummonTanarri(oPC);	}
		break;
///////////////////////////////////////////////////////////////////////////////////	
		case 1901 :		//Rakshasa - Suggestion
		{	PS_Cast_Rakshasa_Suggestion(oPC, oTarget, nSpell);	}
		break;
///////////////////////////////////////////////////////////////////////////////////	
		case 1902 :		//Rakshasa - Pain Wave
		{	PS_Cast_Rakshasa_Pain_Wave(oPC, oTarget, nSpell);	}
		break;
///////////////////////////////////////////////////////////////////////////////////	
		case 1903 :		//Rakshasa - Imperious Command
		{	PS_Cast_Rakshasa_Imperious_Command(oPC, oTarget, nSpell);	}
		break;
///////////////////////////////////////////////////////////////////////////////////	
		case 1906 :		//Rakshasa - Mystic Palm Thrust
		{	PS_Cast_Rakshasa_Mystic_Palm(oPC, oTarget, nSpell);	}
		break;
///////////////////////////////////////////////////////////////////////////////////	
		case 1914 :		//Khayal Shadow Summon
		{	PS_Cast_Khayal_Shadow_Conjuration(oPC, nSpell);	}
		break;
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////	
		case 1917 :		//Khayal Shadow Armor
		{	PS_Cast_Khayal_Shadow_Armor (oPC, oTarget, nSpell);	}
		break;
///////////////////////////////////////////////////////////////////////////////////	
	}
}