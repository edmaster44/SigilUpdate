#include "ps_inc_advscript"
#include "aaa_constants"
#include "ps0_newspells_inc"
#include "ps_inc_equipment"
#include "x2_inc_spellhook"
#include "ps_inc_time"

const int FEAT_AURA_DESPAIR = 1832;
const int SEASON_SUMMER = 0;
const int SEASON_FALL = 1;
const int SEASON_WINTER = 2;
const int SEASON_SPRING = 3;
const int WINTER1 = -256;
const int WINTER2 = -256;
const int FALL1 = 504037376;
const int FALL2 = -937885696;
const int SUMMER1 = 504037376;
const int SUMMER2 = 1967400448;
const int SPRING1 = 69731328;
const int SPRING2 = 1501898496;

//Fey trait choice on login
void PS_Fey_FeyTrait(object oPC) {

	//SendMessageToPC(oPC, "choosing fey heritage:");

	// Clangeddin UI script.
	AddScriptParameterString("START");
	AddScriptParameterString("");
	ExecuteScriptEnhanced("gui_extra_choices", oPC);
	
}

//Fey Hypnotism
void PS_Fey_FeyHypnotism(object oPC) {

	int nCasterLevel = GetHitDice(oPC);

	int maxCreatures = nCasterLevel; //max creatures is Caster HD
	int onlyOne = FALSE;
	if (maxCreatures <= 1)
		onlyOne = TRUE;
		
	int nDC = 10+(nCasterLevel/3)+GetAbilityModifier(ABILITY_CHARISMA, oPC);
	
	//Explosion effect
    effect eVFX = EffectNWN2SpecialEffectFile("sp_enchantment_aoe");
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVFX, GetLocation(oPC));
	
	//enchantment hit vfx
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);
	float fDur = RoundsToSeconds(d4(2));
	
	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(oPC), TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget)) {
	
		if (maxCreatures <= 0)
			return;
			
		int nMod = 0;
		if (onlyOne) nMod = -2;
	
	    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC) && oTarget != oPC) {
		
	        //Fire cast spell at event for the specified target
	        SignalEvent(oTarget, EventSpellCastAt(oPC, SPELL_HYPNOTISM));
	
			//You need a mind to be effected
	        if (spellsIsMindless(oTarget) == FALSE) {
			
				if (GetIsInCombat(oTarget)) {
					nMod = 2;
				}
			
	            if (!MyResistSpell(oPC, oTarget) && !MySavingThrow(SAVING_THROW_WILL, oTarget, nDC-nMod, SAVING_THROW_TYPE_MIND_SPELLS)) {
	                
					if ( !GetIsImmune(oTarget,IMMUNITY_TYPE_MIND_SPELLS, oPC )) {
					
						effect eFasc = EffectFascinate();
						SetEffectSpellId(eFasc, SPELL_HYPNOTISM);
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFasc, oTarget, fDur);
					
						//Make sure being damaged breaks the spell
						SetLocalString(oTarget, "DamagedScript", "scod_s_creature_distracted");
					
	                    maxCreatures--;
	                }
					
	            } 
	        }
	    } 
		
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(oPC), TRUE, OBJECT_TYPE_CREATURE);
	}
}

//Fey Sleep spell
void PS_Fey_FeySleep(object oPC, location lTarget) {

	object 		oCaster 	=	oPC;
    object 		oTarget 	= 	GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE,OBJECT_TYPE_CREATURE);
    effect 		eDur 		= 	EffectVisualEffect(VFX_DUR_SPELL_HISS_OF_SLEEP);
	effect		eSleep		=	EffectSleep();
	effect		eLink		=	EffectLinkEffects(eSleep, eDur);
	float		fDuration	=	RoundsToSeconds(GetHitDice(oCaster));
	
	int nMaxLevel = GetHitDice(oPC);
	int nDC = 10+(nMaxLevel/3)+GetAbilityModifier(ABILITY_CHARISMA, oPC);
	
	fDuration		=	ApplyMetamagicDurationMods(fDuration);

    while (GetIsObjectValid(oTarget))
    {
		if (GetHitDice(oTarget) < nMaxLevel) 
		{
	        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oPC) && oTarget != oPC)
	        {
				if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster))
				{
	            	SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE));
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
				}
	        }
		}
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}

//Fey Sleep spell
void PS_Fey_FeyFear(object oPC, location lTarget) {

	int nCasterLevel = GetHitDice(oPC);
    float fDuration = RoundsToSeconds(nCasterLevel);
    int nDamage;
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_FEAR );	// NWN2 VFX
    effect eFear = EffectFrightened();
	eFear = EffectLinkEffects( eFear, eVis );
    float fDelay;
	int nDC = 10+(nCasterLevel/3)+GetAbilityModifier(ABILITY_CHARISMA, oPC);

    object oTarget;
	
    //Get first target in the spell cone
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE);
    while(GetIsObjectValid(oTarget))
    {
		if (GetHitDice(oTarget) < nCasterLevel) 
		{
	        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC) && oTarget != oPC && 
			!GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR) &&
			    !GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF))
	    	{
	            fDelay = GetRandomDelay();
	            //Fire cast spell at event for the specified target
	            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FEAR));
	            //Make SR Check
	            if(!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
	            {
	                //Make a will save
	                if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR, oPC, fDelay))
	                {
	                    //Apply the linked effects and the VFX impact
	                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFear, oTarget, fDuration));
						
	                }
	            }
	        }
		}
        //Get next target in the spell cone
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE);
    }
}

//Fey Sleep spell
void PS_Fey_FeyInvisbility(object oPC) {

	effect eVis = EffectVisualEffect( VFX_DUR_INVISIBILITY );
    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE); //NWN1 VFX

    //effect eLink = EffectLinkEffects(eInvis, eDur);
    //eLink = EffectLinkEffects(eLink, eVis);
	effect eLink = EffectLinkEffects( eInvis, eVis );

    //Fire cast spell at event for the specified target
    SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_INVISIBILITY, FALSE));

	int nDuration = GetHitDice(oPC);
	
    float fDuration = TurnsToSeconds(nDuration);

    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	//Apply the VFX impact and effects
    ApplyEffectToObject(nDurType, eLink, oPC, fDuration);
}

//Fey Glamer spell
void PS_Fey_FeyGlamer(object oPC, location lTarget) {

	object oGlamer = GetLocalObject(oPC, "Glamer_2");
	if (GetIsObjectValid(oGlamer)) {
		SendMessageToPC(oPC, "You may not have more than one fey Glamer active at a time!");
		DestroyObject(oGlamer);
	}
	
    int nDuration = GetHitDice(oPC);
	
	object oClone = CreateIllusoryClone(oPC, "ps_summon_glamer", lTarget);
	effect eShadow = EffectNWN2SpecialEffectFile("fx_shadowfiend_2");
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eShadow, oClone);
	
	string sImmune = "Immunity_"+IntToString(Random(10000));
	SetLocalString(oClone, "Immunity_String", sImmune);
	SetLocalFloat(oClone, "Duration", RoundsToSeconds(nDuration));
	SetLocalObject(oClone, "Caster", oPC);
	SetLocalInt(oClone, "SaveDC", GetSpellSaveDC());
	PS_Timestamp_UNIX(oClone, "Glamer_Timestamp");
	SetLocalInt(oClone, "Spell_ID", GetSpellId());
	SetLocalObject(oPC, "Glamer_2", oClone);
	
	AssignCommand(oClone, ActionRandomWalk());
	
	GetAttentionOfHostiles(oClone, RADIUS_SIZE_COLOSSAL, SPELL_GLAMER, sImmune);
	
	DestroyObject(oClone, RoundsToSeconds(nDuration));

}

//Fey Kiss power
void PS_Fey_Kiss(object oPC, object oTarget) {

	int iLevels = GetTotalLevels(oPC, TRUE);

	int iDC;
	int iTouchBonus=0;
	int iResult;
	
	// is it a valid target? Bonus if one of the core humanoid types (elf, human, dwarf, etc), and cannot be undead/construct/plant.
	int iRaceType = GetRacialType(oTarget);
	int iVictim = 0; // 0 = not viable, 1 = possible, 2 = possible with bonus.
	
	switch (iRaceType)
	{	
		case RACIAL_TYPE_ANIMAL:
		case RACIAL_TYPE_BEAST:
		case RACIAL_TYPE_DRAGON:
		case RACIAL_TYPE_FEY:
		case RACIAL_TYPE_HUMANOID_MONSTROUS:
		case RACIAL_TYPE_HUMANOID_REPTILIAN:
		case RACIAL_TYPE_OUTSIDER:
		case RACIAL_TYPE_YUANTI:
		case RACIAL_TYPE_SHAPECHANGER:
			iVictim = 1;
			break;
		case RACIAL_TYPE_DWARF:
		case RACIAL_TYPE_ELF:
		case RACIAL_TYPE_GIANT:
		case RACIAL_TYPE_GNOME:
		case RACIAL_TYPE_HALFELF:
		case RACIAL_TYPE_GRAYORC:
		case RACIAL_TYPE_HALFLING:
		case RACIAL_TYPE_HALFORC:
		case RACIAL_TYPE_HUMAN:
		case RACIAL_TYPE_HUMANOID_GOBLINOID:
		case RACIAL_TYPE_HUMANOID_ORC:
		case 21: // planetouched
			iVictim = 2;
			break;
		default:
			iVictim = 0;
			break;
	}
	
	if (iVictim > 0)
	{
		PlayCustomAnimation(oPC, "flirt", FALSE);
		
		if (iVictim == 2)
		{
			iDC = 10 + iLevels + GetAbilityModifier(ABILITY_CHARISMA, oPC);
			iTouchBonus = 4;
			// adds +4 to AB for one second (for the touch attack)
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackIncrease(iTouchBonus, ATTACK_BONUS_MISC), oPC, 1.0f);
		}
		else 
		{
			iDC = 10 + iLevels/2 + GetAbilityModifier(ABILITY_CHARISMA, oPC);
		}
		
		iResult = TouchAttackMelee(oTarget, TRUE);
		
		if (iResult > 0)
		{
			iResult = WillSave(oTarget, iDC, SAVING_THROW_TYPE_MIND_SPELLS, oPC);
			
			if (iResult == 0)
			{
				// effect depends on relative level of target.
				if (iLevels > GetHitDice(oTarget))
				{
					// dominate
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDominated(), oTarget, RoundsToSeconds(d6(iLevels)));
					SendMessageToPC(oPC, "The target falls under your complete control");
				}
				else
				{
					// charm
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCharmed(), oTarget, RoundsToSeconds(d6(iLevels)));
					SendMessageToPC(oPC, "The target is too strong for you to control, but it now no longer wants to hurt you as long as you take no action against it.");
				}
			}
			else
			{
				SendMessageToPC(oPC, "The target fails to fall under your influence");
			}
		}
		else
		{
			SendMessageToPC(oPC, "You failed to plant a kiss on the target.");
		}
	}
	else
	{
		SendMessageToPC(oPC, "You're not going to kiss <i>that!!!</i>");
		PlayCustomAnimation(oPC, "crying", FALSE);
	}
}

//Fey Aspect of Seasons spell
void PS_Fey_SeasonalAspect(object oPC) {

	int currentSeason = GetLocalInt(oPC, "currentSeason") + 1;
	if (currentSeason == 4) currentSeason = 0;
	SetLocalInt(oPC, "currentSeason", currentSeason);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_ENTANGLE), oPC, 1.0f);
	
	//temporary
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);

	//Remove Effects
	effect currentEffect = GetFirstEffect(oPC);
	while (GetIsEffectValid(currentEffect))
	{
		if (GetEffectSpellId(currentEffect) == GetSpellId())
		{
			RemoveEffect(oPC, currentEffect);
		}
		currentEffect = GetNextEffect(oPC);
	}
	
	if (GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC) < 3)
	{
		FeatRemove(oPC, FEAT_AURA_DESPAIR);
	}
	
	if (GetLevelByClass(CLASS_TYPE_PALADIN, oPC) < 3)
	{
		FeatRemove(oPC, FEAT_AURA_OF_COURAGE);
	}
	
	
	//Add Effects
	if (currentSeason == SEASON_SUMMER)
	{
		SendMessageToPC(oPC, "You call upon the power of Summer.");
		effect summer = SupernaturalEffect(EffectAttackIncrease(1));
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, summer, oPC, 0.0f);
	}
	else if (currentSeason == SEASON_FALL)
	{
		SendMessageToPC(oPC, "You call upon the power of Autumn.");
		FeatAdd(oPC, FEAT_AURA_DESPAIR, FALSE);
	}
	else if (currentSeason == SEASON_WINTER)
	{
		SendMessageToPC(oPC, "You call upon the power of Winter.");
		effect winter = SupernaturalEffect(EffectACIncrease(1));
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, winter, oPC, 0.0f);
	}
	else if (currentSeason == SEASON_SPRING)
	{
		SendMessageToPC(oPC, "You call upon the power of Spring.");
		FeatAdd(oPC, FEAT_AURA_OF_COURAGE, FALSE);
	}

	if (currentSeason == SEASON_SUMMER)
	{
		app.HairTint_Color1 = SUMMER1;
		app.HairTint_Color2 = SUMMER2;
		app.HairTint_Mask = PS_CCA_TINT_COLOR1 | PS_CCA_TINT_COLOR2;
		app.HeadTint_Color2 = SUMMER1;
		app.HeadTint_Mask = PS_CCA_TINT_COLOR2;
	}
	else if (currentSeason == SEASON_FALL)
	{
		app.HairTint_Color1 = FALL1;
		app.HairTint_Color2 = FALL2;
		app.HairTint_Mask = PS_CCA_TINT_COLOR1 | PS_CCA_TINT_COLOR2;
		app.HeadTint_Color2 = FALL1;
		app.HeadTint_Mask = PS_CCA_TINT_COLOR2;
	}
	else if (currentSeason == SEASON_WINTER)
	{
		app.HairTint_Color1 = WINTER1;
		app.HairTint_Color2 = WINTER2;
		app.HairTint_Mask = PS_CCA_TINT_COLOR1 | PS_CCA_TINT_COLOR2;
		app.HeadTint_Color2 = WINTER1;
		app.HeadTint_Mask = PS_CCA_TINT_COLOR2;
	}
	else if (currentSeason == SEASON_SPRING)
	{
		app.HairTint_Color1 = SPRING1;
		app.HairTint_Color2 = SPRING2;
		app.HairTint_Mask = PS_CCA_TINT_COLOR1 | PS_CCA_TINT_COLOR2;
		app.HeadTint_Color2 = SPRING1;
		app.HeadTint_Mask = PS_CCA_TINT_COLOR2;
	}
	
	PS_SetCreatureCoreAppearance(oPC, app);
	
	// Refresh appearance
	PS_RefreshAppearance(oPC);

}