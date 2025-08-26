#include "x2_inc_spellhook"
#include "X0_I0_SPELLS"
#include "ps_inc_functions"
#include "ps_inc_advscript"
#include "nw_i0_spells"
#include "aaa_changeself_inc"
#include "x0_i0_match"
#include "x0_i0_position"
#include "ginc_math"
//#include "aaa_constants" redundant include, already included in ps_inc_functions

/*	This is the include file for all dragon features.
	Every individual feature in spells.2da will need its own script created in here, which will in turn be called by 
	aaa_dragon, which acts as the universal spell with a case-based system.
	
	1. Shield Armor
	2. Dragon Immunities (Paralysis, Sleep, Element)
	3. Breaths
	4. Race Abilities (and Dragon Age/Size)
	5. Class Abilities
		
*/


void ApplyDraconicImmunities(object oPC, int nSpell, effect eFX){
	if (!GetHasSpellEffect(nSpell, oPC))
		SendMessageToPC(oPC, "Applying Draconic Immunities");
	eFX = SupernaturalEffect(eFX);
	eFX = SetEffectSpellId(eFX, nSpell);
	PS_RemoveEffects(oPC, nSpell);	
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oPC);
}

//-------------------------------------------------------------------------------------------------------------------
// Applies Shield AC based on characterlevel and DR (new as per FlattedFifth, May 7, 2025)
//-------------------------------------------------------------------------------------------------------------------

void PS_ShieldArmor_Dragon(object oPC, int nSpell){	
	
	int nDR = 5;
	// if has melee path of new dragon prc, dr increases by 1 per lvl beyond first
	// for a total of 10 at lvl 6.
	if (GetHasFeat(3670, oPC, TRUE)){ // melee path of new dragon prc
		int nDragonPrcDr = GetLevelByClass(129, oPC) - 1; // new dragon prc
		if (nDragonPrcDr > 0) nDR += nDragonPrcDr;
	}
	
	// chaotic species of dragons are Black, Copper, Red, Shadow, Topaz, and White.
	// They and Amethyst (TN) will get DR / cold iron. The rest will get DR / silver.
	int nMat = GMATERIAL_METAL_ALCHEMICAL_SILVER;
	switch (GetSubRace(oPC)){
		case 223: //Red
		case 225: //Shadow
		case 226: //Black
		case 227: //Copper
		case 237: //Amethyst
		case 239: //Topaz
		case 240:{ //White
			nMat = GMATERIAL_METAL_COLD_IRON;
			break;
		}
	}

	effect eDR = EffectDamageReduction(nDR, nMat, 0, DR_TYPE_GMATERIAL);
	
	if (!GetLocalInt(GetItemPossessedBy(oPC, "ps_essence"), "TempChange")){
		int iHD = GetTotalLevels(oPC, TRUE);
		int iShield;
		if (GetHasFeat(260, oPC)) iShield = 4;  //  monk						  
		else {					
			if (iHD >= 20) iShield = 9;
			else if (iHD >= 10)	iShield = 8;
			else iShield = 7;
		}
		effect eAC = EffectACIncrease(iShield, AC_SHIELD_ENCHANTMENT_BONUS);
		eDR = EffectLinkEffects(eAC, eDR);
	} else SendMessageToPC(oPC, "<c=red>Shield AC bonus for Dragons does not work in Humanoid Form.</c>");

	eDR = SupernaturalEffect(eDR);
	eDR = SetEffectSpellId(eDR, nSpell);
	PS_RemoveEffects(oPC, nSpell);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDR, oPC);		
}

//----------------------------------------------------------------------------------------------------
// Applies Electricity Immunity to Bronze and Blue Dragons
//----------------------------------------------------------------------------------------------------

void PS_Immunity_Electricity(object oPC, int nSpell)
{ 
	int iImmElec = 9999;

	effect eElec    = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, iImmElec);
	effect eSlep    = EffectImmunity(IMMUNITY_TYPE_SLEEP);
	effect ePara    = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
	effect eBronze	= EffectLinkEffects(eSlep, ePara);		
	eBronze 	= EffectLinkEffects(eElec, eBronze);
	ApplyDraconicImmunities(oPC, nSpell, eBronze);		
}


//----------------------------------------------------------------------------------------------------------------------
// Applies Acid Immunity to Black and Copper Dragons
//----------------------------------------------------------------------------------------------------------------------

void PS_Immunity_Acid(object oPC, int nSpell)
{ 
	int iImmAcid = 9999;
	
	effect eAcid    = EffectDamageResistance(DAMAGE_TYPE_ACID, iImmAcid);
	effect eSlep    = EffectImmunity(IMMUNITY_TYPE_SLEEP);
	effect ePara    = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
	effect eBlack	= EffectLinkEffects(eSlep, ePara);		
	eBlack 	= EffectLinkEffects(eAcid, eBlack);
	ApplyDraconicImmunities(oPC, nSpell, eBlack);
}

//----------------------------------------------------------------------------------------------------------------------
// Applies Sonic Immunity to Emerald Dragons
//----------------------------------------------------------------------------------------------------------------------

void PS_Immunity_Sonic(object oPC, int nSpell)
{ 
	int iImmSonic = 9999;

	effect eSonic    = EffectDamageResistance(DAMAGE_TYPE_SONIC, iImmSonic);
	effect eSlep    = EffectImmunity(IMMUNITY_TYPE_SLEEP);
	effect ePara    = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
	effect eEmerald	= EffectLinkEffects(eSlep, ePara);		
	eEmerald 	= EffectLinkEffects(eSonic, eEmerald);
	ApplyDraconicImmunities(oPC, nSpell, eEmerald);
}

//----------------------------------------------------------------------------------------------------------------------
// Applies Cold Immunity to Topaz Dragons
//----------------------------------------------------------------------------------------------------------------------

void PS_Immunity_Cold(object oPC, int nSpell)
{ 
	int iImmCold = 9999;

	effect eCold    = EffectDamageResistance(DAMAGE_TYPE_COLD, iImmCold);
	effect eSlep    = EffectImmunity(IMMUNITY_TYPE_SLEEP);
	effect ePara    = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
	effect eTopaz	= EffectLinkEffects(eSlep, ePara);		
	eTopaz 	= EffectLinkEffects(eCold, eTopaz);
	ApplyDraconicImmunities(oPC, nSpell, eTopaz);
}


//----------------------------------------------------------------------------------------------------------------------
// Applies Fire Immunity to Red and Brass Dragons. Also Vulnerability to cold
//----------------------------------------------------------------------------------------------------------------------

void PS_Immunity_Fire(object oPC, int nSpell){ 
	int iImmFire = 9999;
	int iVulCold = 50;
	effect eFire = EffectDamageResistance(DAMAGE_TYPE_FIRE, iImmFire);
	effect eCold = EffectDamageImmunityDecrease(DAMAGE_TYPE_COLD, iVulCold);
	effect eSlep = EffectImmunity(IMMUNITY_TYPE_SLEEP);
	effect ePara = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
	
	effect eRed = EffectLinkEffects(eCold, eFire);
	eRed = EffectLinkEffects(eSlep, eRed);
	eRed = EffectLinkEffects(ePara, eRed);
	ApplyDraconicImmunities(oPC, nSpell, eRed);
}

//----------------------------------------------------------------------------------------------------------------------
// Applies Cold Immunity to White and Silver Dragons. Also Vulnerability to cold
//----------------------------------------------------------------------------------------------------------------------

void PS_Immunity_Cold_White(object oPC, int nSpell)
{ 
	int iImmFire = 100;
	int iVulCold = 50;
	
	effect eFire    = EffectDamageResistance(DAMAGE_TYPE_COLD, iImmFire);
	effect eCold    = EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, iVulCold);
	effect eSleep    = EffectImmunity(IMMUNITY_TYPE_SLEEP);
	effect ePara    = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
	effect eWhite	= EffectLinkEffects(eFire, eCold);
	eWhite   = EffectLinkEffects(eSleep, eWhite);		
	eWhite 	= EffectLinkEffects(ePara, eWhite);
	ApplyDraconicImmunities(oPC, nSpell, eWhite);	
}

//----------------------------------------------------------------------------------------------------------------------
// Applies Negative Energy Immunity to Shadow Dragons
//----------------------------------------------------------------------------------------------------------------------

void PS_Immunity_Negative(object oPC, int nSpell)
{ 
	int iImmNeg = 9999;
	
	effect eNeg     = EffectDamageResistance(DAMAGE_TYPE_NEGATIVE, iImmNeg);
	effect eSlep    = EffectImmunity(IMMUNITY_TYPE_SLEEP);
	effect ePara    = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
	effect eShadow	= EffectLinkEffects(eSlep, ePara);		
	eShadow = EffectLinkEffects(eNeg, eShadow);
	ApplyDraconicImmunities(oPC, nSpell, eShadow);
}

//----------------------------------------------------------------------------------------------------------------------
// Applies Light Magic Immunity to Radiant Dragons
//----------------------------------------------------------------------------------------------------------------------

void PS_Immunity_Radiant(object oPC, int nSpell)
{  
	effect eSunbeam     = EffectSpellImmunity(183);
	effect eSunburst     = EffectSpellImmunity(427);
	effect eSunburstArrow     = EffectSpellImmunity(1789);
	effect eSearingLight     = EffectSpellImmunity(906);
	effect eLightBreath     = EffectSpellImmunity(2667);
	effect ePrismaticSpray     = EffectSpellImmunity(135);
	effect eBlind	= EffectImmunity(IMMUNITY_TYPE_BLINDNESS);
	effect eSleep    = EffectImmunity(IMMUNITY_TYPE_SLEEP);
	effect ePara    = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
	
	effect eRadiant	= EffectLinkEffects(eSunbeam, eSunburst);
	eRadiant	= EffectLinkEffects(eSunburstArrow, eRadiant);
	eRadiant	= EffectLinkEffects(eSearingLight, eRadiant);
	eRadiant	= EffectLinkEffects(eLightBreath, eRadiant);
	eRadiant	= EffectLinkEffects(ePrismaticSpray, eRadiant);
	eRadiant	= EffectLinkEffects(eBlind, eRadiant);
	eRadiant	= EffectLinkEffects(eSleep, eRadiant);
	eRadiant	= EffectLinkEffects(ePara, eRadiant);
	ApplyDraconicImmunities(oPC, nSpell, eRadiant);
}

//----------------------------------------------------------------------------------------------------------------------
// Applies Acid and Poison Immunity to Copper Dragons
//----------------------------------------------------------------------------------------------------------------------

void PS_Immunity_Acid_Poison(object oPC, int nSpell)
{ 
	int iImmAcid = 9999;

	effect eAcid    = EffectDamageResistance(DAMAGE_TYPE_ACID, iImmAcid);
	effect eSleep    = EffectImmunity(IMMUNITY_TYPE_SLEEP);
	effect ePara    = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
	effect ePois    = EffectImmunity(IMMUNITY_TYPE_POISON);	
	effect eBlack	= EffectLinkEffects(eSleep, ePara);
	eBlack	= EffectLinkEffects(eAcid, eBlack);		
	eBlack	= EffectLinkEffects(ePois, eBlack);	
	ApplyDraconicImmunities(oPC, nSpell, eBlack);
}

//----------------------------------------------------------------------------------------------------------------------
// Applies Force Immunity to Amethyst Dragons
//----------------------------------------------------------------------------------------------------------------------

void PS_Immunity_Force(object oPC, int nSpell)
{ 
	int nLvl = GetHitDice(oPC);
	
	effect eSleep   = EffectImmunity(IMMUNITY_TYPE_SLEEP);
	effect ePara    = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
	effect ePois    = EffectImmunity(IMMUNITY_TYPE_POISON);	
	effect eMissile = EffectSpellImmunity(SPELL_MAGIC_MISSILE);
	effect eBlades 	= EffectSpellImmunity(14332); // Psychokinetic Blades
	effect eForce	= EffectLinkEffects(eSleep, ePara);
	eForce = EffectLinkEffects(ePois, eForce);
	eForce = EffectLinkEffects(eMissile, eForce);
	eForce = EffectLinkEffects(eBlades, eForce);
	
	
	if (nLvl >= 4){
		eForce = EffectLinkEffects(EffectSpellImmunity(SPELL_BIGBYS_INTERPOSING_HAND), eForce);
		eForce = EffectLinkEffects(EffectSpellImmunity(14414), eForce); // Concussion Blast
	}
	if (nLvl >= 8){
		eForce = EffectLinkEffects(EffectSpellImmunity(SPELL_BIGBYS_FORCEFUL_HAND), eForce);
		eForce = EffectLinkEffects(EffectSpellImmunity(14519), eForce); // Telekinetic Maneuver
	}
	if (nLvl >= 12){
		eForce = EffectLinkEffects(EffectSpellImmunity(SPELL_BIGBYS_GRASPING_HAND), eForce);
		eForce = EffectLinkEffects(EffectSpellImmunity(SPELL_ISAACS_LESSER_MISSILE_STORM), eForce);
	}
	if (nLvl >= 16){
		eForce = EffectLinkEffects(EffectSpellImmunity(SPELL_BIGBYS_CLENCHED_FIST), eForce);
		eForce = EffectLinkEffects(EffectSpellImmunity(14672), eForce); // Force Beam
	}
	if (nLvl >= 20){
		eForce = EffectLinkEffects(EffectSpellImmunity(SPELL_BIGBYS_CRUSHING_HAND), eForce);
		eForce = EffectLinkEffects(EffectSpellImmunity(SPELL_ISAACS_GREATER_MISSILE_STORM), eForce);
	}

	ApplyDraconicImmunities(oPC, nSpell, eForce);	
}


//---------------------------------------------------------------------------------------------------------------------
// Shadow Blend
//---------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Shadow_Blend(object oPC, int nSpell)
{
   if (!X2PreSpellCastCode())
    {
        return;
    }
	
    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
    effect eVis = EffectVisualEffect(VFX_DUR_INVISIBILITY);
    effect eDur = EffectNWN2SpecialEffectFile("sp_darkness_hit");
    effect eLink = EffectLinkEffects(eDur,eVis);

    effect eOnDispell = EffectOnDispel(0.0f, RemoveEffectsFromSpell(oPC, SPELLABILITY_AS_GREATER_INVISIBLITY));
    eLink = EffectLinkEffects(eLink, eOnDispell);
    eInvis = EffectLinkEffects(eInvis, eOnDispell);

    SignalEvent(oPC, EventSpellCastAt(oPC, GetSpellId(), FALSE));
    int nDuration = 6;
	
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oPC, RoundsToSeconds(nDuration));
}

//---------------------------------------------------------------------------------------------------------------------------
// Darkness
//---------------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Black_Darkness(object oPC, int nSpell)
{
    effect eAOE 	 = EffectAreaOfEffect(AOE_PER_DARKNESS);
    location lTarget = GetSpellTargetLocation();
    int nDuration    = GetTotalLevels(oPC, TRUE);

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}

//---------------------------------------------------------------------------------------------------------------------------
// Sound Imitation
//---------------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Blue_Sound_Imitation(object oPC, int nSpell)
{

    location lLoc = GetSpellTargetLocation();
    int nDice = GetTotalLevels(oPC, TRUE);
	int nDC = 10 + nDice/2 + GetAbilityModifier(ABILITY_CHARISMA, oPC);
    int nDamage;
    effect eStun = EffectStunned();
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_SONIC);
    effect eMind = EffectVisualEffect(VFX_DUR_STUN);
    effect eLink = EffectLinkEffects(eStun, eMind);
    effect eDam;
	
	effect eBurst = EffectVisualEffect(VFX_FNF_SOUND_BURST);
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eBurst, lLoc, 0.2); 
	
	
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,RADIUS_SIZE_HUGE, lLoc);
    while (GetIsObjectValid(oTarget))
    {	 				
	    if (oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            SignalEvent(oTarget, EventSpellCastAt(oPC, SPELL_SOUND_BURST));
			nDamage = d8();
			
                //Make a Fort roll to avoid being stunned
                if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SONIC))
                {
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(3));
                }
                //Set the damage effect
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_SONIC);
                //Apply the VFX impact and damage effect
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis,oTarget);
                DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam,oTarget));
            
        }
        //Get the next target in the spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLoc);
    }
}

//---------------------------------------------------------------------------------------------------------------------------
// Stone to Mud
//---------------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Copper_Stone_Mud(object oPC, int nSpell)
{

    int nDice = GetTotalLevels(oPC, TRUE);
	int nDuration = nDice;
	
    effect eAOE = EffectAreaOfEffect(AOE_PER_GREASE);
    location lTarget = GetSpellTargetLocation();
	
	
	
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}

//---------------------------------------------------------------------------------------------------------------------------
// Allows to change Dragon Size
//---------------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Size(object oPC, int nSpell)
{

	object oItem	= GetItemPossessedBy(oPC, "ps_essence");

	if (!X2PreSpellCastCode())
    {	return;	}
	
		// Disallows conversation if in humanoid form.	
		if (GetLocalInt(oItem, "TempChange") == 0)
		{
			AssignCommand(oPC, ActionStartConversation(oPC, "dragon_conv", TRUE, FALSE, TRUE, FALSE));
		}
		else 
		{
			SendMessageToPC(oPC, "<c=red>You cannot change size in humanoid form.");
		}
}

//---------------------------------------------------------------------------------------------------------------------
// PRC: Hardening Scales (Applies Natural Armor)
//---------------------------------------------------------------------------------------------------------------------

void PS_Hardening_Scales(object oPC, int nSpell){
	int iLevel = GetLevelByClass(CLASS_TYPE_DRAGON_PRC, oPC); //old dragon prc
	iLevel += GetLevelByClass(128, oPC); // old gem dragon prc
	int iLevelNew = GetLevelByClass(129, oPC);
	iLevelNew += GetLevelByClass(130, oPC);
	int iNatural;
	int iDR;
	int iPower;
	effect eAC;
	
	// OLD PRC FX
	if (iLevel > 0 && iLevelNew < 1){
		if (GetHasFeat(3649, oPC)){ //Path of the claw
			if (iLevel >= 10) 			//+10 bonus at level 10
				{	iNatural = 10;
					iDR = 10;
					iPower = DAMAGE_POWER_PLUS_THREE;	} 
			else if (iLevel >= 8)		//+8 bonus at level 8
				{	iNatural = 8;
					iDR = 5;
					iPower = DAMAGE_POWER_PLUS_ONE;		} 
			else if (iLevel >= 6)		//+6 bonus at level 6
				{	iNatural = 6;
					iDR = 5;
					iPower = DAMAGE_POWER_PLUS_ONE;		} 
			else if (iLevel >= 4)		//+4 bonus at level 4
				{	iNatural = 4;
					iDR = 5;
					iPower = DAMAGE_POWER_PLUS_ONE;		} 
			else if (iLevel >= 2)		//+2 bonus at level 2
				{	iNatural = 2;	
					iDR = 0;
					iPower = DAMAGE_POWER_NORMAL;		} 
			else 						//+0 at level 1
				{	iNatural = 0;
					iDR = 0;
					iPower = DAMAGE_POWER_NORMAL;		}
		}else{		
			if (iLevel >= 10) 			//+8 bonus at level 10
				{	iNatural = 8;
					iDR = 0;
					iPower = DAMAGE_POWER_NORMAL;		} 
			else if (iLevel >= 6)		//+6 bonus at level 6
				{	iNatural = 6;
					iDR = 0;
					iPower = DAMAGE_POWER_NORMAL;		} 
			else if (iLevel >= 4)		//+4 bonus at level 4
				{	iNatural = 4;
					iDR = 0;
					iPower = DAMAGE_POWER_NORMAL;		} 
			else if (iLevel >= 2)		//+2 bonus at level 2
				{	iNatural = 2;
					iDR = 0;
					iPower = DAMAGE_POWER_NORMAL;		} 
			else 						//+0 at level 1
				{	iNatural = 0;
					iDR = 0;
					iPower = DAMAGE_POWER_NORMAL;		}			
		}	
			
		if (!GetHasSpellEffect(nSpell, oPC)){	
			SendMessageToPC(oPC, "Damage Reduction of " + IntToString(iDR) + "/piercing and +" + IntToString(iPower) + " applied.");
			SendMessageToPC(oPC, "Natural Armor of " + IntToString(iNatural) + " is applied.");	
		}
		
		eAC	= EffectACIncrease(iNatural, AC_NATURAL_BONUS);
		effect eMagic = EffectDamageReduction(iDR, iPower, 0, DR_TYPE_MAGICBONUS);
		effect ePierc = EffectDamageReduction(iDR, DAMAGE_TYPE_PIERCING, 0, DR_TYPE_DMGTYPE);
		effect eDR = EffectLinkEffects(eMagic, ePierc);
		eAC = EffectLinkEffects(eDR, eAC);
				
	} // END OLD PRC FX
	else { //NEW PRC FX
		if (iLevelNew >= 6 && GetHasFeat(3670, oPC))
			iNatural = 10;
		else iNatural = 2 + iLevelNew;
		eAC	= EffectACIncrease(iNatural, AC_NATURAL_BONUS);
	}
	eAC = SupernaturalEffect(eAC);
	eAC	= SetEffectSpellId(eAC, nSpell);
	PS_RemoveEffects(oPC, nSpell);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC);					
}

//---------------------------------------------------------------------------------------------------------------------
// PRC: Dragon Senses (Applies Skill Bonuses)
//---------------------------------------------------------------------------------------------------------------------
void PS_Dragon_Senses(object oPC, int nSpell){
	int iLevel = GetLevelByClass(CLASS_TYPE_DRAGON_PRC, oPC); // old dragon PrC
	iLevel += GetLevelByClass(128, oPC); // old gem Dragon
	int iLevelNew = GetLevelByClass(129, oPC); // new dragon PrC
	iLevelNew += GetLevelByClass(130, oPC);

	int nSubRace = GetSubRace(oPC);
	int iSkillBonus = 0;
	int iSkill1;
	int iSkill2;
	string sMessage = "";
	
	if (iLevel >= 10 || iLevelNew >= 6){	
		iSkillBonus = 6;
		sMessage = "Draconic - Greater Skill Bonuses are applied.";			
	} else if (iLevel >= 4 || iLevelNew >= 3){	
		iSkillBonus = 3;
		sMessage = "Draconic - Skill Bonuses are applied.";	
	} else {	
		return; // If they don't have any bonus then don't apply a skill bonus effect, just bail
	}
	
	switch (nSubRace){
		case 0:{ //Debug
			SendMessageToPC(oPC, "Unknown Dragon Subrace for Feat Dragon Senses. Contact Dev team.");
			return;
		}
		case 222:{ //Bronze
			iSkill1 = SKILL_BLUFF;
			iSkill2 = SKILL_SURVIVAL;
			break;
		}
		case 223:{ //Red
			iSkill1 = SKILL_INTIMIDATE;
			iSkill2 = SKILL_APPRAISE;
			break;
		}
		case 224:{ //Blue
			iSkill1 = SKILL_BLUFF;
			iSkill2 = SKILL_HIDE;
			break;
		}
		case 225: case 226:{ //Shadow & black
			iSkill1 = SKILL_HIDE;
			iSkill2 = SKILL_MOVE_SILENTLY;
			break;
		}
		case 227:{ //Copper
			iSkill1 = SKILL_BLUFF;
			iSkill2 = SKILL_SLEIGHT_OF_HAND;
			break;
		}
		case 228:{ //Iron
			iSkill1 = SKILL_DIPLOMACY;
			iSkill2 = SKILL_INTIMIDATE;
			break;
		}
		case 237:{ //Amethyst
			iSkill1 = SKILL_BLUFF;
			iSkill2 = SKILL_DIPLOMACY;
			break;
		}
		case 238:{ //Emerald
			iSkill1 = SKILL_LORE;
			iSkill2 = SKILL_SEARCH;
			break;
		}
		case 239:{ //Topaz
			iSkill1 = SKILL_TUMBLE;
			iSkill2 = SKILL_SURVIVAL;
			break;	
		}
		case 240:{ //White
			iSkill1 = SKILL_SEARCH;
			iSkill2 = SKILL_SURVIVAL;
			break; 
		}
		case 244: {//Radiant
			iSkill1 = SKILL_HEAL;
			iSkill2 = SKILL_DIPLOMACY;
			break; 
		}
		default:{
			iSkill1 = SKILL_DIPLOMACY;
			iSkill2 = SKILL_INTIMIDATE;
			break;
		}
	}
	
	effect eSk1		=	EffectSkillIncrease(SKILL_SPOT, iSkillBonus);
	effect eSk2 	=	EffectSkillIncrease(SKILL_LISTEN, iSkillBonus);
	effect eSk3 	=	EffectSkillIncrease(iSkill1, iSkillBonus);
	effect eSk4 	=	EffectSkillIncrease(iSkill2, iSkillBonus);
	effect eLink1	=	EffectLinkEffects(eSk1,eSk2);
	effect eLink2	=	EffectLinkEffects(eSk3,eSk4);
	effect eSense	=	EffectLinkEffects(eLink1,eLink2);
			eSense 	= 	SetEffectSpellId(eSense, nSpell);
			eSense	=	SupernaturalEffect(eSense);
	
	if (!GetHasSpellEffect(nSpell,oPC) && sMessage != "")
		SendMessageToPC(oPC, sMessage);	
	PS_RemoveEffects(oPC, nSpell);		
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSense, oPC);	
}



//----------------------------------------------------------------------------------------------------------------------
// PRC: Dragon Roar 
//----------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Roar(object oPC, int nSpell){
		// Dragon Roar does not work when in humanoid form (Temp = 1)	
	if (GetLocalInt(GetItemPossessedBy(oPC, "ps_essence"), "TempChange")){
		SendMessageToPC(oPC, "<c=red>Your lung is not strong enough in humanoid form!");
		return;
	}
	string sSound = "dragon_roar4";
	int nRoar = d6(1);

	switch (nRoar){	
		case 1: sSound = "dragon_roar1"; break;
		case 2: sSound = "dragon_roar2"; break;
		case 3: sSound = "dragon_roar3"; break;
		case 4: sSound = "dragon_roar4"; break;
		case 5: sSound = "dragon_roar5"; break;
		case 6: sSound = "dragon_roar4"; break;	 	 
	}
	
	ClearAllActions();
	PlaySound(sSound, TRUE);
	DelayCommand(0.2f, AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_TAUNT, 1.0, 3.0)));	

	effect eAttack	= EffectAttackIncrease(2);
	effect eDmg		= EffectDamageIncrease(2);
	effect eFear 	= EffectSavingThrowIncrease(SAVING_THROW_TYPE_FEAR, 5, SAVING_THROW_TYPE_FEAR);
	effect eDur 	= EffectVisualEffect(VFX_DUR_SPELL_HEROISM);		    
	effect eLink1 	= EffectLinkEffects(eAttack, eDmg);
	effect eLink2 	= EffectLinkEffects(eDur, eFear);
	effect eAlly 	= EffectLinkEffects(eLink1, eLink2);
 
	effect eAttackPen	= EffectAttackDecrease(2, ATTACK_BONUS_MISC);
	effect eDur2 		= EffectVisualEffect(VFX_DUR_SPELL_DOOM);
	effect eEnemy	 	= EffectLinkEffects(eAttackPen, eDur2);
 
	int iHD = GetTotalLevels(oPC, TRUE) - 2;
	
	int nDuration 	= 10 + GetAbilityModifier(ABILITY_CHARISMA, oPC);		
	location lLoc 	= GetSpellTargetLocation();
	float fDelay;

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_ASTRONOMIC, lLoc);
	while(GetIsObjectValid(oTarget)){
		if ((GetRacialType(oTarget) != 11) && spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oPC)){
			fDelay = GetRandomDelay(0.8, 2.0);
			SignalEvent(oTarget, EventSpellCastAt(oPC, GetSpellId(), FALSE));
			DelayCommand(fDelay-0.01, RemoveEffectsFromSpell(oTarget, nSpell));
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAlly, oTarget, RoundsToSeconds(nDuration)));
		} else if ((GetRacialType(oTarget) != 11) && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC)){
			if (GetHitDice(oTarget) < iHD)	{	
				if (!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS)){		
					fDelay = GetRandomDelay(0.8, 2.0);
					SignalEvent(oTarget, EventSpellCastAt(oPC, GetSpellId(), FALSE));
					DelayCommand(fDelay-0.01, RemoveEffectsFromSpell(oTarget, nSpell));
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEnemy, oTarget, RoundsToSeconds(nDuration)));				
				}
			}
		}		
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_ASTRONOMIC, lLoc);
	}	
}	

//---------------------------------------------------------------------------------------------------------------------
// PRC: Frightful Presence or Dragon Presence
//---------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Presence(object oPC, int nSpell){
	
	PS_RemoveEffects(oPC, nSpell);
	if (GetLocalInt(GetItemPossessedBy(oPC, "ps_essence"), "TempChange")){
		SendMessageToPC(oPC, "You can only use this ability in dragon form");
		return;
	}
	effect eAOE = EffectAreaOfEffect(VFX_MOB_DRAGON_FEAR_PC);
	eAOE = SetEffectSpellId(eAOE, nSpell);
	eAOE = SupernaturalEffect(eAOE);
	
	SignalEvent(oPC, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));	
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oPC, HoursToSeconds(100));
}

//---------------------------------------------------------------------------------------------------------------------
// PRC: Dragon Tail Slap
//---------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Swipe(object oPC, int nSpell){

	if (GetLocalInt(GetItemPossessedBy(oPC, "ps_essence"), "TempChange")){
		SendMessageToPC(oPC, "<c=red>You dont have a dragon tail in humanoid form.");
		return;
	}
    int nHD 	= GetHitDice(oPC);
	int nSize	= GetCreatureSize(oPC);
    int nDamage;
	float fArea = RADIUS_SIZE_LARGE;
	if (nSize <= 3) fArea = RADIUS_SIZE_MEDIUM;
	int nDC  = 10 + (nHD/2) + GetAbilityModifier(ABILITY_STRENGTH, oPC);
	
    float fDelay;
	float fRandomDuration;	
	location lLocation = GetBehindLocation(OBJECT_SELF, 3.0f);
	
    effect eVis = EffectNWN2SpecialEffectFile("sp_sonic_hit.sef");
	effect eKnockdown = EffectKnockdown();
	effect eDamage;

	
	AssignCommand(oPC, ClearAllActions());
	PlayCustomAnimation(OBJECT_SELF, "Una_tailslap", 0, 0.4f);	
	
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fArea, lLocation, FALSE, OBJECT_TYPE_CREATURE);
	while(GetIsObjectValid(oTarget)){
		if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)){
			if(GetCreatureSize(oTarget) <= nSize){
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
				fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
				if (GetHasFeat(3649, oPC) || GetHasFeat(3670, oPC))
					nDamage = d6(nHD);
				else nDamage = d4(nHD);				
				nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nDC);
				fRandomDuration = RandomFloatBetween(6.0, 12.0);
				if (nDamage > 0){
					eDamage = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 3.0f));
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, fRandomDuration));
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
				}
			} else SendMessageToPC(oPC, "<c=yellow>Your target is too large to be affected.");				
		}				
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fArea, lLocation, FALSE, OBJECT_TYPE_CREATURE);
	}	
}

void DoBreathWeapon(object oPC, int nSpell){
	object oPC 	= OBJECT_SELF;
	// Breath Weapon does not work when in humanoid form (Temp = 1)	
	if (GetLocalInt(GetItemPossessedBy(oPC, "ps_essence"), "TempChange")){
		SendMessageToPC(oPC, "<c=red>You cannot use your breath weapon while in humanoid form.");
		return;
	}
	
	int nDice = GetTotalLevels(oPC, TRUE);
	int nDC = 10 + (nDice / 2) + GetAbilityModifier(ABILITY_CONSTITUTION, oPC);
	if (GetHasFeat(3649, oPC) || GetHasFeat(3670, oPC)) nDC += 4;// melee path feats for old & new prc
	
	// Breath weapon variable declarations, default values are for red dragon, except nDamageType
	effect eSecondary; // must be an effect that has a duration
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	int bSecondaryIsDrain = FALSE;
	int nAbilityDrained = ABILITY_CONSTITUTION;
	float fDur = 300.0f;
	string sDrainTag = "drain" + IntToString(nSpell);
	
	int nDamageType = NULL; // default value of NULL because some breath attacks do only secondary fx, not dmg
	int nDamageType2 = NULL;
	effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
	effect eBreath = EffectNWN2SpecialEffectFile("fx_red_dragon_breath.sef");
	int nShape = SHAPE_SPELLCONE;
	float fShapeSize = RADIUS_SIZE_TREMENDOUS;
	int nDieType = 10;
	int nDieType2 = NULL;
	int nSave = SAVING_THROW_REFLEX;
	int nSaveType = SAVING_THROW_TYPE_FIRE;
	// End breath weapon variables
	
	// Set variables according to breath weapon
	switch (nSpell){
		case 2625: case 2634:{	//bronze and blue lightning
			nDamageType = DAMAGE_TYPE_ELECTRICAL;
			eVis = EffectVisualEffect(VFX_HIT_SPELL_LIGHTNING);
			eBreath = EffectNWN2SpecialEffectFile("fx_lightningdragonbreath");
			nShape = SHAPE_SPELLCYLINDER;
			fShapeSize = 16.0f;
			nDieType = 8;
			nSaveType = SAVING_THROW_TYPE_ELECTRICITY;
			break;						
		}
		case 2660:{	//amethyst and radiant magic + blunt
			nDamageType = DAMAGE_TYPE_MAGICAL;
			nDamageType2 = DAMAGE_TYPE_BLUDGEONING;
			eVis = EffectVisualEffect(VFX_HIT_SPELL_MAGIC);
			eBreath = EffectNWN2SpecialEffectFile("fx_amethystdragonbreath");
			nShape = SHAPE_SPELLCYLINDER;
			fShapeSize = 16.0f;
			nDieType = 4;
			nSave = SAVING_THROW_FORT;
			nSaveType = SAVING_THROW_TYPE_SPELL;
			break;					
		}
		case 2661:{ // emerald sonic
			nDamageType = DAMAGE_TYPE_SONIC;
			eVis = EffectVisualEffect(VFX_HIT_SPELL_SONIC);
			eBreath = EffectNWN2SpecialEffectFile("fx_emeralddragonbreath.sef");
			nDieType = 6;
			eSecondary = EffectDeaf();
			eDur = EffectVisualEffect(VFX_DUR_BLIND);
			fDur = RoundsToSeconds(d6(1) + 5);
			nSave = SAVING_THROW_FORT;
			nSaveType = SAVING_THROW_TYPE_SONIC;	
			break;					
		}
		case 2662: case 2664:{	//topaz and white dehydrating cold
			nDamageType = DAMAGE_TYPE_COLD;
			eVis = EffectVisualEffect(VFX_HIT_SPELL_ICE);
			eBreath = EffectNWN2SpecialEffectFile("fx_dragonicebreath.sef");
			eSecondary = EffectAbilityDecrease(ABILITY_CONSTITUTION, 1); // drain amount randomized in loop
			bSecondaryIsDrain = TRUE;
			fDur = HoursToSeconds(d6(1) + 5);
			nDieType = 6;
			nSave = SAVING_THROW_FORT;
			nSaveType = SAVING_THROW_TYPE_COLD;	
			break;
		}
		case 2626:{ // bronze gas
			eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
			eBreath = EffectNWN2SpecialEffectFile("fx_dragonrepulsebreath");
			eSecondary = EffectDazed();
			effect eDur2 = EffectVisualEffect(VFX_DUR_SPELL_DAZE);
			eDur = EffectLinkEffects(eDur2, eDur);
			fDur = RoundsToSeconds(d6(1) + 5);
			nSave = SAVING_THROW_WILL;
			nSaveType = SAVING_THROW_TYPE_MIND_SPELLS;
			break;						
		}
		case 2667:{	//radiant light
			nDamageType = DAMAGE_TYPE_DIVINE;
			eVis = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
			eBreath = EffectNWN2SpecialEffectFile("fx_radiantdragonbreath");	
			eSecondary = EffectNewBlindness();
			eDur = EffectVisualEffect(VFX_DUR_BLIND);
			eSecondary = EffectLinkEffects(eDur, eSecondary);
			fDur = RoundsToSeconds(d4(1) + 5);
			nSave = SAVING_THROW_FORT;
			nSaveType = SAVING_THROW_TYPE_DIVINE;
			//RACIAL_TYPE_UNDEAD=24. This will signal loop to do 1d6 dmg to non undead and 1d6/lvl to undead
			nDieType = RACIAL_TYPE_UNDEAD; 
			break;
		}	
		case 2631: case 2651:{	//black and copper acid
			nDamageType = DAMAGE_TYPE_ACID;
			eVis = EffectVisualEffect(VFX_HIT_SPELL_ACID);
			eBreath = EffectNWN2SpecialEffectFile("fx_dragonacidbreath");
			nShape = SHAPE_SPELLCYLINDER;
			fShapeSize = 16.0f;
			nDieType = 8;
			nSaveType = SAVING_THROW_TYPE_ACID;
			break;						
		}
		case 2632:{	//red dragon
			nDamageType = DAMAGE_TYPE_FIRE;
			break;
		}
		case 2633:{	//shadow dragon 
			nDamageType = DAMAGE_TYPE_NEGATIVE;
			eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
			EffectNWN2SpecialEffectFile("fx_shadowdragonbreath");
			eSecondary = EffectAbilityDecrease(ABILITY_CONSTITUTION, 1); // drain amount randomized in loop
			bSecondaryIsDrain = TRUE;
			fDur = HoursToSeconds(d6(1) + 5);
			nDieType = 6;
			nSave = SAVING_THROW_FORT;
			nSaveType = SAVING_THROW_TYPE_NEGATIVE;
			break;
		}
		case 2652:{	//copper slow
			eVis = EffectVisualEffect(VFX_IMP_SLOW);
			eBreath = EffectNWN2SpecialEffectFile("fx_dragonslowbreath");
			eSecondary = EffectSlow();
			effect eDur2 = EffectVisualEffect(VFX_DUR_SPELL_SLOW);
			eSecondary = EffectLinkEffects(eDur, eSecondary);
			eSecondary = EffectLinkEffects(eDur2, eSecondary);
			fDur = RoundsToSeconds(d4(1) + 5);
			nSave = SAVING_THROW_FORT;
			nSaveType = SAVING_THROW_TYPE_SPELL;
			break;
		}
		case 2655:{	//iron dragon spark
			nDamageType = DAMAGE_TYPE_FIRE;
			nDamageType2 = DAMAGE_TYPE_ELECTRICAL;
			eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
			eBreath = EffectNWN2SpecialEffectFile("fx_irondragonbreath");
			nDieType = 6;
			nDieType2 = 4;
			break;
		}
		case 2656:{	//iron gas
			eVis = EffectVisualEffect(VFX_IMP_SLEEP);
			eBreath = EffectNWN2SpecialEffectFile("fx_dragonslowbreath");
			eSecondary = EffectSleep();
			effect eDur2 = EffectVisualEffect(VFX_DUR_SLEEP);
			eSecondary = EffectLinkEffects(eDur, eSecondary);
			eSecondary = EffectLinkEffects(eDur2, eSecondary);
			fDur = RoundsToSeconds(d6(1) + 5);
			nSave = SAVING_THROW_FORT;
			nSaveType = SAVING_THROW_TYPE_SPELL;
			break;
		}
		default:{
			nDamageType = DAMAGE_TYPE_FIRE;
			break;
		}
	}
	
	PlayCustomAnimation(oPC, "Una_breathattack01", 0, 0.3f); 
	DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0f));
	
	int nRace;
	int nDamage = 0;
	int nAdjustedDmgType;
	float fDelay;
	effect eDamage;
	effect eDamage2;
	vector vOrigin  = GetPosition(oPC);
	int bImmuneSecondary = FALSE;

	
	//--------------------------------------------------------------------------
	//Loop through all targets and do damage and apply effects, if any
	//--------------------------------------------------------------------------

	object oTarget = GetFirstObjectInShape(nShape, fShapeSize, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
	
	while(GetIsObjectValid(oTarget)){
		if(oTarget != oPC && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC)){
			nRace = GetRacialType(oTarget);
			SignalEvent(oTarget, EventSpellCastAt(oPC, nSpell));
			fDelay = GetDistanceBetween(oPC, oTarget)/15;
			
			// Apply damage, if any
			if (nDamageType != NULL){
				if (nDieType == RACIAL_TYPE_UNDEAD){
					if (nRace == RACIAL_TYPE_UNDEAD) nDieType = 6;
					else nDieType = 1;
				}
				if (nDieType == 10) nDamage = d10(nDice);
				else if (nDieType == 8) nDamage = d8(nDice);
				else if (nDieType == 6) nDamage = d6(nDice);
				else if (nDieType == 1) nDamage = d6(1);
				else nDamage = d4(nDice);
				nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nDC);
				if (nDamage > 0){
					nAdjustedDmgType = nDamageType;
					// convert neg damage to 1/2 magic so we don't heal undead with it
					if (nRace == RACIAL_TYPE_UNDEAD && nDamageType == DAMAGE_TYPE_NEGATIVE){
						nAdjustedDmgType = DAMAGE_TYPE_MAGICAL;
						nDamage = nDamage / 2;
						if (nDamage < 1) nDamage = 1;
					}
					eDamage = EffectDamage(nDamage, nAdjustedDmgType);
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
					if (nDamageType2 != NULL){
						if (nDieType2 == NULL) nDieType2 = nDieType;
						if (nDieType2 == 10) nDamage = d10(nDice);
						else if (nDieType2 == 8) nDamage = d8(nDice);
						else if (nDieType2 == 6) nDamage = d6(nDice);
						else if (nDieType2 == 1) nDamage = d6(1);
						else nDamage = d4(nDice);
					}
					nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nDC);
					// convert neg damage to 1/2 magic so we don't heal undead with it
					if (nRace == RACIAL_TYPE_UNDEAD && nDamageType2 == DAMAGE_TYPE_NEGATIVE){
						nAdjustedDmgType = DAMAGE_TYPE_MAGICAL;
						nDamage = nDamage / 2;
						if (nDamage < 1) nDamage = 1;
					} else nAdjustedDmgType = nDamageType2;
					eDamage2 = EffectDamage(nDamage, nAdjustedDmgType);
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage2, oTarget));
				}
			}
			
			
			// apply secondary effect, if any
			if (GetIsEffectValid(eSecondary)){
				if (bSecondaryIsDrain){
					// the ability drain breaths will have no effect on constructs, undead, elementals, 
					// anything that has already been drained by the same breath weapon and anything 
					// immune to the main damage.
					bImmuneSecondary = (nRace == RACIAL_TYPE_CONSTRUCT || nRace == RACIAL_TYPE_UNDEAD || 
					nRace == RACIAL_TYPE_ELEMENTAL || GetLocalInt(oTarget, sDrainTag));
					if (nDamageType != NULL && !bImmuneSecondary) 
						bImmuneSecondary = IsImmuneToDamage(oPC, nDamageType, TRUE);
					
					if (!bImmuneSecondary){
						int nDrain = d4(1) + 1;
						// topaz cold drains 2x from plants and oozes
						if (nSpell == 2662 && (nRace == RACIAL_TYPE_OOZE || nRace == RACIAL_SUBTYPE_PLANT))
							nDrain *= 2;
						eSecondary = EffectAbilityDecrease(nAbilityDrained, nDrain);
						eSecondary = EffectLinkEffects(eDur, eSecondary);
					}
				// creatures immune to divine damage, if there are any, will be immune to radiant blinding breath
				} else if (nSpell == 2667){
					bImmuneSecondary = IsImmuneToDamage(oPC, nDamageType, TRUE);
				}if (eSecondary == EffectNewBlindness()){
					bImmuneSecondary = GetIsImmune(oTarget, IMMUNITY_TYPE_BLINDNESS);
				}
				if(!bImmuneSecondary && !MySavingThrow(nSave, oTarget, nDC, nSaveType, OBJECT_SELF, fDelay)){
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSecondary, oTarget, fDur));
					// tag the target with the spell id if it's a con drain from shadow or topaz
					// so that the same target cannot suffer multiple con drains from the same breath weapon
					if (bSecondaryIsDrain) SetLocalInt(oTarget, sDrainTag, TRUE);
					// only apply the impact effect if it hasn't already been applied in damage part
					if (nDamage <= 0) DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
       		    }
			}
		}
		oTarget = GetNextObjectInShape(nShape, fShapeSize, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
	}
}

/* ORIGINAL DRAGON BREATH WEAPONS


//----------------------------------------------------------------------------------------------------------------------
// Dragon Breath, Electricity, Line (Bronze)
//----------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Breath_Bronze(object oPC, int nSpell)

{
    int nType;
    int nDamageType;
    int nDamageDie;
    int nVfx;
    int nSave;
    int nDice;
	int nBreath;
	int nBonus;
	object oPC 		= OBJECT_SELF;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	nDamageType = DAMAGE_TYPE_ELECTRICAL;
	nVfx        = VFX_HIT_SPELL_LIGHTNING;
	nSave       = SAVING_THROW_TYPE_ELECTRICITY;
		
	nDice = GetTotalLevels(oPC, TRUE);
	
	if (GetHasFeat(3649, oPC))
	{	
		nBonus = 4;
	}
	else
	{	
		nBonus = 0;
	}	
	
	int  nDC  = 10 + nDice/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + nBonus;

	// Breath Weapon does not work when in humanoid form (Temp = 1)	
	if (GetLocalInt(oItem, "TempChange") == 1)
	{
			SendMessageToPC(oPC, "<c=red>You cannot use your breath weapon while in humanoid form.");
	}
	else 
	{
			effect eVis = EffectVisualEffect(nVfx);
			effect eBreath = EffectNWN2SpecialEffectFile("fx_lightningdragonbreath");	
 
						
			PlayCustomAnimation(oPC, "Una_breathattack01", 0, 0.3f); 
			DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0f));

		    int nDamage;
		    int nDamStrike;
		    float fDelay;
		    object oTarget;
			effect eDamage;
			vector vOrigin  = GetPosition(oPC);

	//--------------------------------------------------------------------------
	//Loop through all targets and do damage
	//--------------------------------------------------------------------------

			oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, 16.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
			while(GetIsObjectValid(oTarget))
			{
				if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
				{
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
					fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
					nDamage = d6(nDice);
					nDamStrike =  GetReflexAdjustedDamage(nDamage, oTarget, nDC);
					if (nDamStrike > 0)
					{
					    eDamage = EffectDamage(nDamStrike, nDamageType);
		 			   	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				    	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
				 	}
				}
				oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, 16.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
			}
	}
}


//----------------------------------------------------------------------------------------------------------------------
// Dragon Breath, Concussive Force, Line (Amethyst)
//----------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Breath_Amethyst(object oPC, int nSpell)

{
    int nType;
    int nDamageType;
	int nDamageType2;
    int nDamageDie;
    int nVfx;
    int nSave;
    int nDice;
	int nBreath;
	int nBonus;
	object oPC 		= OBJECT_SELF;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	nDamageType = DAMAGE_TYPE_MAGICAL;
	nDamageType2 = DAMAGE_TYPE_BLUDGEONING;
	nVfx        = VFX_HIT_SPELL_MAGIC;
	nSave       = SAVING_THROW_TYPE_SPELL;
		
	nDice = GetTotalLevels(oPC, TRUE);
	
	if (GetHasFeat(3649, oPC))
	{	
		nBonus = 4;
	}
	else
	{	
		nBonus = 0;
	}	
	
	int  nDC  = 10 + nDice/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + nBonus;

	// Breath Weapon does not work when in humanoid form (Temp = 1)	
	if (GetLocalInt(oItem, "TempChange") == 1)
	{
			SendMessageToPC(oPC, "<c=red>You cannot use your breath weapon while in humanoid form.");
	}
	else 
	{
			effect eVis = EffectVisualEffect(nVfx);
			effect eBreath = EffectNWN2SpecialEffectFile("fx_amethystdragonbreath");	
 //	 	effect eBreath = EffectBeam(VFX_BEAM_LIGHTNING, oPC, BODY_NODE_CHEST); 
						
			PlayCustomAnimation(oPC, "Una_breathattack01", 0, 0.3f); 
			DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0f));

		    int nDamage;
		    int nDamStrike;
		    float fDelay;
		    object oTarget;
			effect eDamage;
			effect eDamage2;
			vector vOrigin  = GetPosition(oPC);

	//--------------------------------------------------------------------------
	//Loop through all targets and do damage
	//--------------------------------------------------------------------------

			oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, 16.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
			while(GetIsObjectValid(oTarget))
			{
				if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
				{
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
					fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
					nDamage = d4(nDice);
					nDamStrike =  GetReflexAdjustedDamage(nDamage, oTarget, nDC);
					if (nDamStrike > 0)
					{
					    eDamage = EffectDamage(nDamStrike, nDamageType);
						eDamage2 = EffectDamage(nDamStrike, nDamageType2);
		 			   	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				    	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
						DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage2, oTarget));
				 	}
				}
				oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, 16.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
			}
	}
}

//----------------------------------------------------------------------------------------------------------------------
// Dragon Breath, repulsive Gas, Cone (Bronze)
//----------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Breath_Bronze_Gas(object oPC, int nSpell)

{
	float fDelay;	
    object oTarget;
	object oPC 		= OBJECT_SELF;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	vector vOrigin = GetPosition(oPC);
	
	int  nSave     = SAVING_THROW_TYPE_MIND_SPELLS;	
	int  nType	   = SAVING_THROW_WILL;	
	int  nDice     = GetTotalLevels(oPC, TRUE);
	int  nDuration = d6(1) + 5;
	int  nBonus;
	
	if (GetHasFeat(3649, oPC))
	{	
		nBonus = 4;
	}
	else
	{	
		nBonus = 0;
	}	
	
	int  nDC	  = 10 + nDice/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + nBonus;
	
	effect eBreath = EffectNWN2SpecialEffectFile("fx_dragonrepulsebreath");	
	effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
    effect eDaze = EffectDazed();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_SPELL_DAZE);

    effect eLink = EffectLinkEffects(eDaze, eDur);
    eLink = EffectLinkEffects(eLink, eDur2);
	
	// Breath Weapon does not work when in humanoid form (Temp = 1)	
	if (GetLocalInt(oItem, "TempChange") == 1)
		{
			SendMessageToPC(oPC, "<c=red>You cannot use your breath weapon while in humanoid form.");
		}
	else 
		{
			PlayCustomAnimation(oPC, "Una_breathattack01", 0, 0.3f);
			DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0f));
   	
	//--------------------------------------------------------------------------
	//Loop through all targets and add effect.
	//--------------------------------------------------------------------------

			oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
			while(GetIsObjectValid(oTarget))
			{     
				if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))	 		
				{    			
	   		  
			 
					 // Daze Breath --------------------------------------------------------------
					 SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
					 fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
   					 if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
       			     {
                
						DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
      		            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
       		         }
				}	 
			         
     		   //Get next target in spell area
	  		   oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
  
			}
		}
}

//---------------------------------------------------------------------------------------------------------------------
// Dragon Breath, Acid, Line (Black)
//---------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Breath_Black(object oPC, int nSpell)

{
    int nType;
    int nDamageType;
    int nDamageDie;
    int nVfx;
    int nSave;
    int nDice;
	int nBreath;
	int nBonus;
	object oPC 		= OBJECT_SELF;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	nDamageType = DAMAGE_TYPE_ACID;
	nVfx        = VFX_HIT_SPELL_ACID;
	nSave       = SAVING_THROW_TYPE_ACID;
		
	nDice = GetTotalLevels(oPC, TRUE);
	
	
	if (GetHasFeat(3649, oPC))
	{	
		nBonus = 4;
	}
	else
	{	
		nBonus = 0;
	}	
	
	int  nDC  = 10 + nDice/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + nBonus;

	// Breath Weapon does not work when in humanoid form (Temp = 1)	
	if (GetLocalInt(oItem, "TempChange") == 1)
		{
			SendMessageToPC(oPC, "<c=red>You cannot use your breath weapon while in humanoid form.");
		}
	else 
		{
			effect eVis = EffectVisualEffect(nVfx);
			effect eBreath = EffectNWN2SpecialEffectFile("fx_dragonacidbreath");	
	//		effect eBreath = EffectBeam(VFX_BEAM_ACID, OBJECT_SELF, BODY_NODE_CHEST); 

			PlayCustomAnimation(oPC, "Una_breathattack01", 0, 0.3f);
			DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0f));

		    int nDamage;
		    int nDamStrike;
		    float fDelay;
		    object oTarget;
			effect eDamage;
			vector vOrigin  = GetPosition(oPC);

	//--------------------------------------------------------------------------
	//Loop through all targets and do damage
	//--------------------------------------------------------------------------

			oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, 16.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
			while(GetIsObjectValid(oTarget))
			{
				if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
				{
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
					fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
					nDamage = d8(nDice);
					nDamStrike =  GetReflexAdjustedDamage(nDamage, oTarget, nDC);
					if (nDamStrike > 0)
					{
					    eDamage = EffectDamage(nDamStrike, nDamageType);
		 			   	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				    	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
				 	}
				}
				oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, 16.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
			}
		}
}

//---------------------------------------------------------------------------------------------------------------------
// Dragon Breath, Fire, Cone (Red)
//---------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Breath_Red(object oPC, int nSpell)

{
	float fDelay;	
    object oTarget;
	object oPC 		= OBJECT_SELF;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	int nDamage;
    int nDamStrike;
	effect eDamage;
    int nDamageDie;
	int nBonus;
	
	vector vOrigin = GetPosition(oPC);
	
	int  nSave     = SAVING_THROW_TYPE_FIRE;	
	int  nType	   = SAVING_THROW_REFLEX;	
	int  nDice     = GetTotalLevels(oPC, TRUE);
	
	if (GetHasFeat(3649, oPC))
	{	
		nBonus = 4;
	}
	else
	{	
		nBonus = 0;
	}	
	
	int  nDC  = 10 + nDice/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + nBonus;
	int  nDamageType = DAMAGE_TYPE_FIRE;
	
	effect eBreath = EffectNWN2SpecialEffectFile("fx_red_dragon_breath.sef");
	effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
	
	// Breath Weapon does not work when in humanoid form (Temp = 1)	
	if (GetLocalInt(oItem, "TempChange") == 1)
		{
			SendMessageToPC(oPC, "<c=red>You cannot use your breath weapon while in humanoid form.");
		}
	else 
		{ 
			PlayCustomAnimation(oPC, "Una_breathattack01", 0, 0.3f);
			DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0f));

   	
	//--------------------------------------------------------------------------
	//Loop through all targets and add effect.
	//--------------------------------------------------------------------------

			oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
			while(GetIsObjectValid(oTarget))
			{     
				if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))	 		
				{    			
	   				
					// Damage Breath -------------------------------------------------------------
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
					fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
					nDamage = d10(nDice);
					nDamStrike =  GetReflexAdjustedDamage(nDamage, oTarget, nDC);
					if (nDamStrike > 0)
					{
			 	   		eDamage = EffectDamage(nDamStrike, nDamageType);
		   		 		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
			    		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
		 			}
			
				}	 
			         
     		   //Get next target in spell area
	  		   oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
  
			}
		}
}

//---------------------------------------------------------------------------------------------------------------------
// Dragon Breath, Sonic, Cone (Emerald)
//---------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Breath_Emerald(object oPC, int nSpell)

{
	float fDelay;	
    object oTarget;
	object oPC 		= OBJECT_SELF;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	int nDamage;
    int nDamStrike;
	effect eDamage;
    int nDamageDie;
	int nBonus;
	int  nDuration = d6(1) + 5;
	
	vector vOrigin = GetPosition(oPC);
	
	int  nSave     = SAVING_THROW_TYPE_SONIC;	
	int  nType	   = SAVING_THROW_FORT;	
	int  nDice     = GetTotalLevels(oPC, TRUE);
	
	if (GetHasFeat(3649, oPC))
	{	
		nBonus = 4;
	}
	else
	{	
		nBonus = 0;
	}	
	
	int  nDC  = 10 + nDice/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + nBonus;
	int  nDamageType = DAMAGE_TYPE_SONIC;
	
	effect eBreath = EffectNWN2SpecialEffectFile("fx_emeralddragonbreath.sef");
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_SONIC);
	
	// Breath Weapon does not work when in humanoid form (Temp = 1)	
	if (GetLocalInt(oItem, "TempChange") == 1)
		{
			SendMessageToPC(oPC, "<c=red>You cannot use your breath weapon while in humanoid form.");
		}
	else 
		{ 
			PlayCustomAnimation(oPC, "Una_breathattack01", 0, 0.3f);
			DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0f));

   	
	//--------------------------------------------------------------------------
	//Loop through all targets and add effect.
	//--------------------------------------------------------------------------

			oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
			while(GetIsObjectValid(oTarget))
			{     
				if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))	 		
				{    			
	   				
					// Damage Breath -------------------------------------------------------------
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
					fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
					nDamage = d6(nDice);
					nDamStrike =  GetReflexAdjustedDamage(nDamage, oTarget, nDC);
					if (nDamStrike > 0)
					{
			 	   		eDamage = EffectDamage(nDamStrike, nDamageType);
		   		 		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
			    		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
		 			}
					if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, nType, OBJECT_SELF, fDelay))
       			     {
                
						DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDeaf(), oTarget, RoundsToSeconds(nDuration)));
      		            
       		         }
			
				}	 
			         
     		   //Get next target in spell area
	  		   oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
  
			}
		}
}

//---------------------------------------------------------------------------------------------------------------------
// Dragon Breath, Cold (Dehydrating), Cone (Topaz)
//---------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Breath_Topaz(object oPC, int nSpell)

{
	float fDelay;	
    object oTarget;
	object oPC 		= OBJECT_SELF;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	int nDamage;
    int nDamStrike;
	effect eDamage;
	effect eDrain;
    int nDamageDie;
	int nBonus;
	int  nDuration = d6(1) + 5;
	int nDrainDice;
	
	vector vOrigin = GetPosition(oPC);
	
	int  nSave     = SAVING_THROW_TYPE_COLD;	
	int  nType	   = SAVING_THROW_REFLEX;
	int  nType2	   = SAVING_THROW_FORT;	
	int  nDice     = GetTotalLevels(oPC, TRUE);
	
	if (GetHasFeat(3649, oPC))
	{	
		nBonus = 4;
	}
	else
	{	
		nBonus = 0;
	}	
	
	int  nDC  = 10 + nDice/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + nBonus;
	int  nDamageType = DAMAGE_TYPE_COLD;
	
	effect eBreath = EffectNWN2SpecialEffectFile("fx_dragonicebreath.sef");
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ICE);
	
	// Breath Weapon does not work when in humanoid form (Temp = 1)	
	if (GetLocalInt(oItem, "TempChange") == 1)
		{
			SendMessageToPC(oPC, "<c=red>You cannot use your breath weapon while in humanoid form.");
		}
	else 
		{ 
			PlayCustomAnimation(oPC, "Una_breathattack01", 0, 0.3f);
			DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0f));

   	
	//--------------------------------------------------------------------------
	//Loop through all targets and add effect.
	//--------------------------------------------------------------------------

			oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
			while(GetIsObjectValid(oTarget))
			{     
				if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))	 		
				{    			
	   				
					// Damage Breath -------------------------------------------------------------
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
					fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
					nDamage = d8(nDice);
					nDamStrike =  GetReflexAdjustedDamage(nDamage, oTarget, nDC);
					if (nDamStrike > 0)
					{
			 	   		eDamage = EffectDamage(nDamStrike, nDamageType);
		   		 		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
			    		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
		 			}
					if(!GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT && !GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD && !GetRacialType(oTarget) == RACIAL_TYPE_ELEMENTAL)
					{
						if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, nType, OBJECT_SELF, fDelay))
	       			     {
						 	nDrainDice = d6(1) + GetAbilityModifier(ABILITY_CONSTITUTION, oPC);
							if(GetRacialType(oTarget) == RACIAL_TYPE_OOZE || GetRacialType(oTarget) == RACIAL_SUBTYPE_PLANT)
							{
								nDrainDice = nDrainDice * 2;
							}
	                		eDrain = EffectAbilityDecrease(ABILITY_CONSTITUTION, nDrainDice);
							DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDrain, oTarget, HoursToSeconds(nDuration)));
	      		            
	       		         }
					}
				}	 
			         
     		   //Get next target in spell area
	  		   oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
  
			}
		}
}
//---------------------------------------------------------------------------------------------------------------------
// Dragon Breath, Cold, Cone (White)
//---------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Breath_White(object oPC, int nSpell)

{
	float fDelay;	
    object oTarget;
	object oPC 		= OBJECT_SELF;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	int nDamage;
    int nDamStrike;
	effect eDamage;
	effect eDrain;
    int nDamageDie;
	int nBonus;
	int  nDuration = d6(1) + 5;
	int nDrainDice;
	
	vector vOrigin = GetPosition(oPC);
	
	int  nSave     = SAVING_THROW_TYPE_COLD;	
	int  nType	   = SAVING_THROW_REFLEX;
	int  nType2	   = SAVING_THROW_FORT;	
	int  nDice     = GetTotalLevels(oPC, TRUE);
	
	if (GetHasFeat(3649, oPC))
	{	
		nBonus = 4;
	}
	else
	{	
		nBonus = 0;
	}	
	
	int  nDC  = 10 + nDice/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + nBonus;
	int  nDamageType = DAMAGE_TYPE_COLD;
	
	effect eBreath = EffectNWN2SpecialEffectFile("fx_dragonicebreath.sef");
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ICE);
	
	// Breath Weapon does not work when in humanoid form (Temp = 1)	
	if (GetLocalInt(oItem, "TempChange") == 1)
		{
			SendMessageToPC(oPC, "<c=red>You cannot use your breath weapon while in humanoid form.");
		}
	else 
		{ 
			PlayCustomAnimation(oPC, "Una_breathattack01", 0, 0.3f);
			DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0f));

   	
	//--------------------------------------------------------------------------
	//Loop through all targets and add effect.
	//--------------------------------------------------------------------------

			oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
			while(GetIsObjectValid(oTarget))
			{     
				if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))	 		
				{    			
	   				
					// Damage Breath -------------------------------------------------------------
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
					fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
					nDamage = d8(nDice);
					nDamStrike =  GetReflexAdjustedDamage(nDamage, oTarget, nDC);
					if (nDamStrike > 0)
					{
			 	   		eDamage = EffectDamage(nDamStrike, nDamageType);
		   		 		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
			    		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
		 			}
					
				}	 
			         
     		   //Get next target in spell area
	  		   oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
  
			}
		}
}
//---------------------------------------------------------------------------------------------------------------------
// Dragon Breath, Negative, Cone (Shadow)
//---------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Breath_Shadow(object oPC, int nSpell)

{
	float fDelay;	
    object oTarget;
	object oPC 		= OBJECT_SELF;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	vector vOrigin = GetPosition(oPC);
	
	int  nSave     = SAVING_THROW_TYPE_NEGATIVE;	
	int  nType	   = SAVING_THROW_REFLEX;	
	int  nDice     = 2 + (GetTotalLevels(oPC, TRUE)/5);
	int  nDuration = d6(1) + 5;
	int  nBonus;
	
	if (GetHasFeat(3649, oPC))
	{	
		nBonus = 4;
	}
	else
	{	
		nBonus = 0;
	}	
	
	int  nDC  = 10 + nDice/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + nBonus;
	
	effect eBreath = EffectNWN2SpecialEffectFile("fx_shadowdragonbreath");
	effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eNeg = EffectNegativeLevel(nDice);
	effect eNeg2 = EffectNegativeLevel(nDice/2);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eLink = EffectLinkEffects(eNeg, eDur);
	effect eLink2 = EffectLinkEffects(eNeg2, eDur2);
	
	// Breath Weapon does not work when in humanoid form (Temp = 1)	EffectVisualEffect (VFX_DUR_CONE_EVIL
	if (GetLocalInt(oItem, "TempChange") == 1)
		{
			SendMessageToPC(oPC, "<c=red>You cannot use your breath weapon while in humanoid form.");
		}
	else 
		{
			PlayCustomAnimation(oPC, "Una_breathattack01", 0, 0.3f);
			DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0f)); 
   	
	//--------------------------------------------------------------------------
	//Loop through all targets and add effect.
	//--------------------------------------------------------------------------

			oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
			while(GetIsObjectValid(oTarget))
			{     
				if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))	 		
				{    			
	   		  
			 
					 // Level Drain Breath --------------------------------------------------------------
					 SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
					 fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
   					 if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_NEGATIVE, OBJECT_SELF, fDelay))
       			     {
                
						DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration)));
      		            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
       		         }
					 else 
					 {
					 	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, HoursToSeconds(nDuration)));
      		            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));      		 
					 }
			
				}	 
			         
     		   //Get next target in spell area
	  		   oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
  
			}
		}
}

//---------------------------------------------------------------------------------------------------------------------
// Dragon Breath, Electricity, Line (Blue)
//---------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Breath_Blue(object oPC, int nSpell)

{
    int nType;
    int nDamageType;
    int nDamageDie;
    int nVfx;
    int nSave;
    int nDice;
	int nBreath;
	int nBonus;
	object oPC 		= OBJECT_SELF;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	nDamageType = DAMAGE_TYPE_ELECTRICAL;
	nVfx        = VFX_HIT_SPELL_LIGHTNING;
	nSave       = SAVING_THROW_TYPE_ELECTRICITY;
		
	nDice = GetTotalLevels(oPC, TRUE);
	
	if (GetHasFeat(3649, oPC))
	{	
		nBonus = 4;
	}
	else
	{	
		nBonus = 0;
	}	
	
	int  nDC  = 10 + nDice/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + nBonus;

	// Breath Weapon does not work when in humanoid form (Temp = 1)	
	if (GetLocalInt(oItem, "TempChange") == 1)
		{
			SendMessageToPC(oPC, "<c=red>You cannot use your breath weapon while in humanoid form.");
		}
	else 
		{
			effect eVis = EffectVisualEffect(nVfx);
			effect eBreath = EffectNWN2SpecialEffectFile("fx_lightningdragonbreath");	
 	//	 	effect eBreath = EffectBeam(VFX_BEAM_LIGHTNING, oPC, BODY_NODE_CHEST); 

			PlayCustomAnimation(oPC, "Una_breathattack01", 0, 0.3f);
			DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0f));

		    int nDamage;
		    int nDamStrike;
		    float fDelay;
		    object oTarget;
			effect eDamage;
			vector vOrigin  = GetPosition(oPC);

	//--------------------------------------------------------------------------
	//Loop through all targets and do damage
	//--------------------------------------------------------------------------

			oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, 16.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
			while(GetIsObjectValid(oTarget))
			{
				if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
				{
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
					fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
					nDamage = d8(nDice);
					nDamStrike =  GetReflexAdjustedDamage(nDamage, oTarget, nDC);
					if (nDamStrike > 0)
					{
					    eDamage = EffectDamage(nDamStrike, nDamageType);
		 			   	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				    	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
				 	}
				}
				oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, 16.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
			}
		}
}

//---------------------------------------------------------------------------------------------------------------------
// Dragon Breath, Acid, Line (Copper)
//---------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Breath_Copper(object oPC, int nSpell)

{
    int nType;
    int nDamageType;
    int nDamageDie;
    int nVfx;
    int nSave;
    int nDice;
	int nBreath;
	int nBonus;
	object oPC 		= OBJECT_SELF;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	nDamageType = DAMAGE_TYPE_ACID;
	nVfx        = VFX_HIT_SPELL_ACID;
	nSave       = SAVING_THROW_TYPE_ACID;
		
	nDice = GetTotalLevels(oPC, TRUE);
	
	
	if (GetHasFeat(3649, oPC))
	{	
		nBonus = 4;
	}
	else
	{	
		nBonus = 0;
	}	
	
	int  nDC  = 10 + nDice/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + nBonus;

	// Breath Weapon does not work when in humanoid form (Temp = 1)	
	if (GetLocalInt(oItem, "TempChange") == 1)
		{
			SendMessageToPC(oPC, "<c=red>You cannot use your breath weapon while in humanoid form.");
		}
	else 
		{
			effect eVis = EffectVisualEffect(nVfx);
			effect eBreath = EffectNWN2SpecialEffectFile("fx_dragonacidbreath");	

			PlayCustomAnimation(oPC, "Una_breathattack01", 0, 0.3f);
			DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0f));

		    int nDamage;
		    int nDamStrike;
		    float fDelay;
		    object oTarget;
			effect eDamage;
			vector vOrigin  = GetPosition(oPC);

	//--------------------------------------------------------------------------
	//Loop through all targets and do damage
	//--------------------------------------------------------------------------

			oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, 16.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
			while(GetIsObjectValid(oTarget))
			{
				if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
				{
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
					fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
					nDamage = d8(nDice);
					nDamStrike =  GetReflexAdjustedDamage(nDamage, oTarget, nDC);
					if (nDamStrike > 0)
					{
					    eDamage = EffectDamage(nDamStrike, nDamageType);
		 			   	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				    	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
				 	}
				}
				oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, 16.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
			}
		}
}

//---------------------------------------------------------------------------------------------------------------------
// Dragon Breath, Slow Gas, Cone (Copper)
//---------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Breath_Copper_Gas(object oPC, int nSpell)

{
	float fDelay;	
    object oTarget;
	object oPC 		= OBJECT_SELF;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	vector vOrigin = GetPosition(oPC);
	
	int  nSave     = SAVING_THROW_TYPE_SPELL;	
	int  nType	   = SAVING_THROW_FORT;	
	int  nDice     = GetTotalLevels(oPC, TRUE);
	int  nDuration = d4(1) + 5;
	int  nBonus;
	
	if (GetHasFeat(3649, oPC))
	{	
		nBonus = 4;
	}
	else
	{	
		nBonus = 0;
	}	
	
	int  nDC	  = 10 + nDice/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + nBonus;
	
	effect eBreath = EffectNWN2SpecialEffectFile("fx_dragonslowbreath");	
	effect eVis = EffectVisualEffect(VFX_IMP_SLOW);
    effect eSlow = EffectSlow();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_SPELL_SLOW);

    effect eLink = EffectLinkEffects(eSlow, eDur);
    eLink = EffectLinkEffects(eLink, eDur2);
	
	// Breath Weapon does not work when in humanoid form (Temp = 1)	
	if (GetLocalInt(oItem, "TempChange") == 1)
		{
			SendMessageToPC(oPC, "<c=red>You cannot use your breath weapon while in humanoid form.");
		}
	else 
		{
			PlayCustomAnimation(oPC, "Una_breathattack01", 0, 0.3f);
			DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0f));
   	
	//--------------------------------------------------------------------------
	//Loop through all targets and add effect.
	//--------------------------------------------------------------------------

			oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
			while(GetIsObjectValid(oTarget))
			{     
				if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))	 		
				{    			
	   		  
			 
					 // Daze Breath --------------------------------------------------------------
					 SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
					 fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
   					 if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL, OBJECT_SELF, fDelay))
       			     {                
						DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
      		            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
       		         }
				}	 
			         
     		   //Get next target in spell area
	  		   oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
  
			}
		}
}

//---------------------------------------------------------------------------------------------------------------------
// Dragon Breath, Blinding Light, Cone (Radiant)
//---------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Breath_Radiant_Light(object oPC, int nSpell)

{
	float fDelay;	
    object oTarget;
	object oPC 		= OBJECT_SELF;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	vector vOrigin = GetPosition(oPC);
	
	int  nSave     = SAVING_THROW_TYPE_SPELL;	
	int  nType	   = SAVING_THROW_FORT;	
	int  nDice     = GetTotalLevels(oPC, TRUE);
	int  nDuration = d4(1) + 5;
	int  nBonus;
	
	
	if (GetHasFeat(3649, oPC))
	{	
		nBonus = 4;
	}
	else
	{	
		nBonus = 0;
	}	
	
	int  nDC	  = 10 + nDice/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + nBonus;
	
	effect eBreath = EffectNWN2SpecialEffectFile("fx_radiantdragonbreath");	
	effect eVis = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
    effect eSlow = EffectNewBlindness();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_BLIND);

    effect eLink = EffectLinkEffects(eSlow, eDur);
    eLink = EffectLinkEffects(eLink, eDur2);
	
	
	// Breath Weapon does not work when in humanoid form (Temp = 1)	
	if (GetLocalInt(oItem, "TempChange") == 1)
		{
			SendMessageToPC(oPC, "<c=red>You cannot use your breath weapon while in humanoid form.");
		}
	else 
		{
			PlayCustomAnimation(oPC, "Una_breathattack01", 0, 0.3f);
			DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0f));
   	
	//--------------------------------------------------------------------------
	//Loop through all targets and add effect.
	//--------------------------------------------------------------------------

			oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
			while(GetIsObjectValid(oTarget))
			{     
				if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))	 		
				{    			
	   		  
			 
					 // Blind Breath --------------------------------------------------------------
					 SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
					 fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
   					 if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL, OBJECT_SELF, fDelay))
       			     {                
						DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
       		         }
					 //Divine Damage ---------------------------------------------------------------
					 int	 nDamage = d6(1);
					 int	 nDamageUndead = d6(nDice);
					 effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE, FALSE);
					 effect eDamageUndead = EffectDamage(nDamageUndead, DAMAGE_TYPE_DIVINE, FALSE);
	
					 if(GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
					 {
					 	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDamageUndead, oTarget, RoundsToSeconds(nDuration)));
      		            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					 }
					 if(GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
					 {
					 	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDamage, oTarget, RoundsToSeconds(nDuration)));
      		            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					 }
		
				}	 
			         
     		   //Get next target in spell area
	  		   oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
  
			}
		}
}

//---------------------------------------------------------------------------------------------------------------------
// Dragon Breath, Sparks, Cone (Iron)
//---------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Breath_Iron(object oPC, int nSpell)

{
	float fDelay;	
    object oTarget;
	object oPC 		= OBJECT_SELF;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	int nDamage;
	int nDamage2;
    int nDamStrike;
	int nDamStrike2;
	effect eDamage;
	effect eDamage2;
    int nDamageDie;
	int nBonus;
	
	vector vOrigin = GetPosition(oPC);
	
	int  nSave     = SAVING_THROW_TYPE_FIRE;	
	int  nType	   = SAVING_THROW_REFLEX;	
	int  nDice     = GetTotalLevels(oPC, TRUE);
	
	if (GetHasFeat(3649, oPC))
	{	
		nBonus = 4;
	}
	else
	{	
		nBonus = 0;
	}	
	
	int  nDC  = 10 + nDice/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + nBonus;
	int  nDamageType = DAMAGE_TYPE_FIRE;
	int  nDamageType2 = DAMAGE_TYPE_ELECTRICAL;
	
	effect eBreath = EffectNWN2SpecialEffectFile("fx_irondragonbreath");
	effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
	
	// Breath Weapon does not work when in humanoid form (Temp = 1)	
	if (GetLocalInt(oItem, "TempChange") == 1)
		{
			SendMessageToPC(oPC, "<c=red>You cannot use your breath weapon while in humanoid form.");
		}
	else 
		{ 
			PlayCustomAnimation(oPC, "Una_breathattack01", 0, 0.3f);
			DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0f));

   	
	//--------------------------------------------------------------------------
	//Loop through all targets and add effect.
	//--------------------------------------------------------------------------

			oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
			while(GetIsObjectValid(oTarget))
			{     
				if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))	 		
				{    			
	   				
					// Damage Breath -------------------------------------------------------------
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
					fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
					nDamage = d6(nDice);
					nDamage2 = d4(nDice);
					nDamStrike =  GetReflexAdjustedDamage(nDamage, oTarget, nDC);
					nDamStrike2 =  GetReflexAdjustedDamage(nDamage2, oTarget, nDC);
					if (nDamStrike > 0)
					{
			 	   		eDamage = EffectDamage(nDamStrike, nDamageType);
			 	   		eDamage2 = EffectDamage(nDamStrike, nDamageType2);
						effect eDam = EffectLinkEffects(eDamage, eDamage2);				
		   		 		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
			    		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
		 			}
			
				}	 
			         
     		   //Get next target in spell area
	  		   oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
  
			}
		}
}

//---------------------------------------------------------------------------------------------------------------------
// Dragon Breath, Sleep Gas, Cone (Iron)
//---------------------------------------------------------------------------------------------------------------------

void PS_Dragon_Breath_Iron_Gas(object oPC, int nSpell)

{
	float fDelay;	
    object oTarget;
	object oPC 		= OBJECT_SELF;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	vector vOrigin = GetPosition(oPC);
	
	int  nSave     = SAVING_THROW_TYPE_SPELL;	
	int  nType	   = SAVING_THROW_FORT;	
	int  nDice     = GetTotalLevels(oPC, TRUE);
	int  nDuration = d6(1) + 5;
	int  nBonus;
	
	if (GetHasFeat(3649, oPC))
	{	
		nBonus = 4;
	}
	else
	{	
		nBonus = 0;
	}	
	
	int  nDC	  = 10 + nDice/2 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + nBonus;
	
	effect eBreath = EffectNWN2SpecialEffectFile("fx_dragonslowbreath");	
	effect eVis = EffectVisualEffect(VFX_IMP_SLEEP);
    effect eSleep = EffectSleep();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_SLEEP);

    effect eLink = EffectLinkEffects(eSleep, eDur);
    eLink = EffectLinkEffects(eLink, eDur2);
	
	// Breath Weapon does not work when in humanoid form (Temp = 1)	
	if (GetLocalInt(oItem, "TempChange") == 1)
		{
			SendMessageToPC(oPC, "<c=red>You cannot use your breath weapon while in humanoid form.");
		}
	else 
		{
			PlayCustomAnimation(oPC, "Una_breathattack01", 0, 0.3f);
			DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, oPC, 2.0f));
   	
	//--------------------------------------------------------------------------
	//Loop through all targets and add effect.
	//--------------------------------------------------------------------------

			oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
			while(GetIsObjectValid(oTarget))
			{     
				if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))	 		
				{    				   			 
					 // Sleep Breath --------------------------------------------------------------
					 SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
					 fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
   					 if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL, OBJECT_SELF, fDelay))
       			     {                
						DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
      		            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
       		         }
	
				}	 
			         
     		   //Get next target in spell area
	  		   oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_TREMENDOUS, GetSpellTargetLocation(), TRUE);
  
			}
		}
}

*/


					