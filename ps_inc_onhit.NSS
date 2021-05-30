#include "x2_inc_itemprop"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 
#include "nw_i0_invocatns" 

const string abilityID = "abilityID";
const string abilityDC = "abilityDC";
//const string abilityCaster = "abilityCaster";

const string casterColor = "Turquoise";
const string reportColor = "DarkOrange";
const string saveColor = "Cyan";
const string enemyColor = "Plum";

//returns caster level of Arcane Archer when casting 
//their imbue arrow
int GetArcherCasterLevel(object oCaster) 
{
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///	Since its only used for arrow effects and the existing counting is already not accurate (10 Demo = 10 CL      ///
	/// instead of 7 CL) and I dont want to add lines each time a new racial PrC comes out, let alone adding the      ///
	/// missing prestiges, I simply make CL = HD * 0.9. The only issue is warlock but I dont think anyone figures out ///
	/// that its not based on CL. And even then, if they go melee they miss epic blast dice.						  ///
	///																												  ///
	/// If someone want to spend two hours of making it accurate, feel free. Alersia    						      ///
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	int nCasterLevel = PS_GetCasterLevel(oCaster);

	/*
	int nCasterLevel = GetLevelByClass(81, oCaster); //arcane archer level
	nCasterLevel = FloatToInt(IntToFloat(nCasterLevel)*0.7f); //adjusted for lack of spellcasting at some levels
	if (GetHasFeat(2700, oCaster)) { //Bard
		nCasterLevel += GetLevelByClass(CLASS_TYPE_BARD, oCaster);
		if (GetHasFeat(1512, oCaster)) nCasterLevel += GetLevelByClass(CLASS_TYPE_ARCANETRICKSTER, oCaster);
		if (GetHasFeat(1542, oCaster)) nCasterLevel += GetLevelByClass(44, oCaster); //Mystic Theurge
		if (GetHasFeat(1581, oCaster)) nCasterLevel += GetLevelByClass(CLASS_TYPE_HARPER, oCaster); //Harper
		if (GetHasFeat(1820, oCaster)) nCasterLevel += GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCaster); //Eldritch Knight
		if (GetHasFeat(1887, oCaster)) nCasterLevel += GetLevelByClass(CLASS_TYPE_ARCANE_SCHOLAR, oCaster); //Scholar
		if (GetHasFeat(2611, oCaster)) nCasterLevel += GetLevelByClass(69, oCaster); //Demonologist
	}
	else if (GetHasFeat(2701, oCaster)) { //Sorcerer
		nCasterLevel += GetLevelByClass(CLASS_TYPE_SORCERER, oCaster);
		if (GetHasFeat(1513, oCaster)) nCasterLevel += GetLevelByClass(CLASS_TYPE_ARCANETRICKSTER, oCaster);
		if (GetHasFeat(1543, oCaster)) nCasterLevel += GetLevelByClass(44, oCaster); //Mystic Theurge
		if (GetHasFeat(1569, oCaster)) nCasterLevel += GetLevelByClass(47, oCaster); //Neverwinter Nine
		if (GetHasFeat(1582, oCaster)) nCasterLevel += GetLevelByClass(CLASS_TYPE_HARPER, oCaster); //Harper
		if (GetHasFeat(1821, oCaster)) nCasterLevel += GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCaster); //Eknight
		if (GetHasFeat(1888, oCaster)) nCasterLevel += GetLevelByClass(CLASS_TYPE_ARCANE_SCHOLAR, oCaster); //Harper
		if (GetHasFeat(2612, oCaster)) nCasterLevel += GetLevelByClass(69, oCaster); //Demonologist
	}
	else if (GetHasFeat(2702, oCaster)) { //Wizard
		nCasterLevel += GetLevelByClass(CLASS_TYPE_WIZARD, oCaster);
		if (GetHasFeat(1514, oCaster)) nCasterLevel += GetLevelByClass(CLASS_TYPE_ARCANETRICKSTER, oCaster);
		if (GetHasFeat(1544, oCaster)) nCasterLevel += GetLevelByClass(44, oCaster); //Mystic Theurge
		if (GetHasFeat(1570, oCaster)) nCasterLevel += GetLevelByClass(47, oCaster); //Neverwinter Nine
		if (GetHasFeat(1583, oCaster)) nCasterLevel += GetLevelByClass(CLASS_TYPE_HARPER, oCaster); //Harper
		if (GetHasFeat(1822, oCaster)) nCasterLevel += GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oCaster); //Eknight
		if (GetHasFeat(1889, oCaster)) nCasterLevel += GetLevelByClass(CLASS_TYPE_ARCANE_SCHOLAR, oCaster); //Harper
		if (GetHasFeat(2613, oCaster)) nCasterLevel += GetLevelByClass(69, oCaster); //Demonologist
	}
	else if (GetHasFeat(2703, oCaster)) { //Warlock
		nCasterLevel += GetLevelByClass(CLASS_TYPE_WARLOCK, oCaster);
		nCasterLevel += GetLevelByClass(61, oCaster); //Hellfire
		nCasterLevel += GetLevelByClass(80, oCaster); //Fellblade
	}
	*/
	return nCasterLevel;
}

//returns true if spell resisted
int OnHitResistSpell(object oCaster, object oTarget) {
	int nResist = GetSpellResistance(oTarget);
	int casterLevel = GetArcherCasterLevel(oCaster);
	int result = d20()+casterLevel;
	string sReport = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> casts spell on "+GetName(oTarget)+": <i>";
	if (result < nResist) {
		sReport += "Spell Resisted</i></color>";
		SendMessageToPC(oCaster, sReport);
	}
	return (result < nResist);
}

int OnHitSavingThrow(int nSavingThrow, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay = 0.0)
{
    if (nDC<1)
    {
       nDC = 1;
    }
    else if (nDC > 255)
    {
      nDC = 255;
    }

    effect eVis;
    int bValid = FALSE;
    int nSpellID;
	int nBonus = 0;
	int nRoll = d20();
	int nResult = 0;
	string sReport = "<Color="+enemyColor+">"+GetName(oTarget)+"</color><Color="+saveColor+"> : ";
	if(nSavingThrow == SAVING_THROW_FORT)
    {
		sReport += "Fortitude Save: ";
		nBonus = GetFortitudeSavingThrow(oTarget);
		bValid = FortitudeSave(oTarget, nDC, nSaveType, oSaveVersus);
    }
    else if(nSavingThrow == SAVING_THROW_REFLEX)
    {
		sReport += "Reflex Save: ";
		nBonus = GetReflexSavingThrow(oTarget);
		bValid = ReflexSave(oTarget, nDC, nSaveType, oSaveVersus);
    }
    else if(nSavingThrow == SAVING_THROW_WILL)
    {
		sReport += "Will Save: ";
		nBonus = GetWillSavingThrow(oTarget);
		bValid = WillSave(oTarget, nDC, nSaveType, oSaveVersus);
    }
	
	nResult = nBonus+nRoll;
	if (nResult >= nDC) {
		sReport += "*success* :";
		if (bValid != 2)
			bValid = 1;
			
	} else {
		sReport += "*failure* :";
		if (bValid != 2)
			bValid = 0;
	}
	sReport += "("+IntToString(nRoll)+" + "+IntToString(nBonus)+" = "+IntToString(nResult)+")</color>";
	SendMessageToPC(oSaveVersus, sReport);
	
    if(bValid == 1 || bValid == 2)
    {
        if(bValid == 2)
        {
			eVis = EffectVisualEffect( VFX_DUR_SPELL_SPELL_RESISTANCE );	// makes use of NWN2 VFX
            bValid = FALSE;
        }
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
    }
    return bValid;
}


int GetBestSpellID(int nSpell, object oCaster) {
	if (nSpell == SPELL_DISMISSAL && GetHasSpell(SPELL_BANISHMENT, oCaster) > 0) 
		return SPELL_BANISHMENT;
	else if (nSpell == SPELL_MASS_CURE_LIGHT_WOUNDS && GetHasSpell(SPELL_MASS_CURE_MODERATE_WOUNDS, oCaster) > 0)
		return SPELL_MASS_CURE_MODERATE_WOUNDS;
	else if (nSpell == SPELL_DISPEL_MAGIC) {
		if (GetHasSpell(SPELL_MORDENKAINENS_DISJUNCTION, oCaster) > 0)
			return SPELL_MORDENKAINENS_DISJUNCTION;
		else if (GetHasSpell(SPELL_GREATER_DISPELLING, oCaster) > 0)
			return SPELL_GREATER_DISPELLING;
	}
	else if (nSpell == SPELL_SLEEP) {
		if (GetHasSpell(SPELL_DEEP_SLUMBER, oCaster) > 0)
			return SPELL_DEEP_SLUMBER;
		else if (GetHasSpell(SPELL_HISS_OF_SLEEP, oCaster) > 0)
			return SPELL_HISS_OF_SLEEP;
	}
	else if (nSpell == SPELL_SHOUT) {
		if (GetHasSpell(SPELL_GREATER_SHOUT, oCaster) > 0)
			return SPELL_GREATER_SHOUT;
		else
			return SPELL_SHOUT;
	}
	return nSpell;
}
void SetTempOnHitProperty(object oItem, object oCaster, int nAbilityID, int nDC, float fDuration) {
	SetLocalInt(oItem, abilityID, nAbilityID);
	SetLocalInt(oItem, abilityDC, nDC);
	SetLocalObject(oItem, abilityCaster, oCaster);
	
	itemproperty ip = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1);
	IPSafeAddItemProperty(oItem, ip, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
}

int GetOnHitAbilityID(object oObject) {
	return GetLocalInt(oObject, abilityID);
}

int GetOnHitAbilityDC(object oObject) {
	return GetLocalInt(oObject, abilityDC);
}

object GetOnHitAbilityCaster(object oObject) {
	return GetLocalObject(oObject, abilityCaster);
}

void ClearOnHitInfo(object oObject) {

	DeleteLocalInt(oObject, abilityID);
	DeleteLocalInt(oObject, abilityDC);
	DeleteLocalObject(oObject, abilityCaster);
	
}

void TransferProperties(object oItem, object oTarget) {

	SetLocalInt(oTarget, abilityID, GetOnHitAbilityID(oItem));
	SetLocalInt(oTarget, abilityDC, GetOnHitAbilityDC(oItem));
	SetLocalObject(oTarget, abilityCaster, GetOnHitAbilityCaster(oItem));
	
}

void RemoveTempOnHitProperty(object oItem) {
	DeleteLocalInt(oItem, abilityID);
	DeleteLocalInt(oItem, abilityDC);
	DeleteLocalInt(oItem, abilityCaster);
	
	itemproperty iProp = GetFirstItemProperty(oItem);
	while (GetIsItemPropertyValid(iProp)) {
		if (GetItemPropertyDurationType(iProp) != DURATION_TYPE_TEMPORARY)
		{
			iProp = GetNextItemProperty(oItem);
			continue;
		}
		if (GetItemPropertyType(iProp) == ITEM_PROPERTY_ONHITCASTSPELL)
			RemoveItemProperty(oItem, iProp);
		iProp = GetNextItemProperty(oItem);
	}
}

void ExecuteTempOnHitProperty(object oItem, object oTarget) {
	int nID = GetOnHitAbilityID(oItem);
	int nDC = GetOnHitAbilityDC(oItem);
	object oCaster = GetOnHitAbilityCaster(oItem);
	int spellID = nID+1751;
	
	TransferProperties(oItem, oTarget);
	
	string sScript = Get2DAString("iprp_onhit_abilities", "ScriptName", nID);
	
	ExecuteScript(sScript, oTarget);
	
	RemoveAnySpellEffects(spellID, oCaster);
	RemoveTempOnHitProperty(oItem);
}

int IsCraftedAmmunition(object oItem) {
	string sTag = GetTag(oItem);
	if (sTag == "ps_arrow_coldiron" ||
		sTag == "ps_bolt_coldiron" ||
		sTag == "ps_bullet_coldiron" ||
		sTag == "nx2_arrow_ciron" ||
		sTag == "ps_arrow_ciron" ||
		sTag == "nx2_bolt_ciron" ||
		sTag == "ps_bolt_ciron" ||
		sTag == "nx2_bullet_ciron" ||
		sTag == "ps_bullet_ciron" ||
		sTag == "ps_arrow_jman" ||
		sTag == "ps_bolt_ap")
		return TRUE;
		
	return FALSE;
}

int GetItemHasPermanentProperties(object oItem) {
	itemproperty iProp = GetFirstItemProperty(oItem);
	while (GetIsItemPropertyValid(iProp)) {
		if (GetItemPropertyDurationType(iProp) != DURATION_TYPE_TEMPORARY)
			return TRUE;
		iProp = GetNextItemProperty(oItem);
	}
	return FALSE;
}

int GetItemHasTemporaryProperties(object oItem) {
	itemproperty iProp = GetFirstItemProperty(oItem);
	while (GetIsItemPropertyValid(iProp)) {
		if (GetItemPropertyDurationType(iProp) == DURATION_TYPE_TEMPORARY)
			return TRUE;
		iProp = GetNextItemProperty(oItem);
	}
	return FALSE;
}

void DoElementalDamage(object oPC, object oTarget, int critical) {
	int nArcherLevel = GetLevelByClass(81, oPC);
	if (nArcherLevel >= 7 && critical) {
		effect ePhysical = EffectDamage(d10(2), DAMAGE_TYPE_PIERCING, DAMAGE_POWER_ENERGY);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, ePhysical, oTarget);
	}
	if (nArcherLevel >= 3) {
		effect eEnergy;
		if (GetLocalInt(oPC, "aa_elemental_flaming"))
			eEnergy = EffectDamage(d6(), DAMAGE_TYPE_FIRE, DAMAGE_POWER_ENERGY);
		else if (GetLocalInt(oPC, "aa_elemental_frost"))
			eEnergy = EffectDamage(d6(), DAMAGE_TYPE_COLD, DAMAGE_POWER_ENERGY);
		else if (GetLocalInt(oPC, "aa_elemental_shock"))
			eEnergy = EffectDamage(d6(), DAMAGE_TYPE_ELECTRICAL, DAMAGE_POWER_ENERGY);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eEnergy, oTarget);
	}
}

void DoAlignedDamage(object oCaster, object oTarget) {
	int nArcherLevel = GetLevelByClass(81, oCaster);
	if (nArcherLevel < 9)
		return;
		
	effect eEnergy;
	if (GetAlignmentGoodEvil(oCaster) == ALIGNMENT_GOOD &&
		GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL) {	
		eEnergy = EffectDamage(d6(2), DAMAGE_TYPE_PIERCING, DAMAGE_POWER_ENERGY, TRUE);
	}
	else if (GetAlignmentGoodEvil(oCaster) == ALIGNMENT_EVIL &&
		GetAlignmentGoodEvil(oTarget) == ALIGNMENT_GOOD) {	
		eEnergy = EffectDamage(d6(2), DAMAGE_TYPE_PIERCING, DAMAGE_POWER_ENERGY, TRUE);
	}
	else if (GetAlignmentLawChaos(oCaster) == ALIGNMENT_CHAOTIC &&
		GetAlignmentLawChaos(oTarget) == ALIGNMENT_LAWFUL) {	
		eEnergy = EffectDamage(d6(2), DAMAGE_TYPE_PIERCING, DAMAGE_POWER_ENERGY, TRUE);
	}
	else if (GetAlignmentLawChaos(oCaster) == ALIGNMENT_LAWFUL &&
		GetAlignmentLawChaos(oTarget) == ALIGNMENT_CHAOTIC) {	
		eEnergy = EffectDamage(d6(2), DAMAGE_TYPE_PIERCING, DAMAGE_POWER_ENERGY, TRUE);
	}
	else if (GetAlignmentGoodEvil(oCaster) == ALIGNMENT_NEUTRAL &&
			 GetAlignmentLawChaos(oCaster) == ALIGNMENT_NEUTRAL) {
			 if (GetAlignmentGoodEvil(oCaster) != GetAlignmentGoodEvil(oTarget) ||
			 GetAlignmentLawChaos(oCaster) != GetAlignmentLawChaos(oTarget))
				eEnergy = EffectDamage(4, DAMAGE_TYPE_PIERCING, DAMAGE_POWER_ENERGY, TRUE);
	}
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eEnergy, oTarget);
}

//1411-1419 1-9
//1948-1952 10-14
int GetBaseEldritchDamage(object oCaster) {
	int dNum = 1;
	if (GetHasFeat(FEAT_ELDRITCH_BLAST_14, oCaster))
		dNum = 14;
	else if (GetHasFeat(FEAT_ELDRITCH_BLAST_13, oCaster))
		dNum = 13;
	else if (GetHasFeat(FEAT_ELDRITCH_BLAST_12, oCaster))
		dNum = 12;
	else if (GetHasFeat(FEAT_ELDRITCH_BLAST_11, oCaster))
		dNum = 11;
	else if (GetHasFeat(FEAT_ELDRITCH_BLAST_10, oCaster))
		dNum = 10;
	else if (GetHasFeat(FEAT_ELDRITCH_BLAST_9, oCaster))
		dNum = 9;
	else if (GetHasFeat(FEAT_ELDRITCH_BLAST_8, oCaster))
		dNum = 8;
	else if (GetHasFeat(FEAT_ELDRITCH_BLAST_7, oCaster))
		dNum = 7;
	else if (GetHasFeat(FEAT_ELDRITCH_BLAST_6, oCaster))
		dNum = 6;
	else if (GetHasFeat(FEAT_ELDRITCH_BLAST_5, oCaster))
		dNum = 5;
	else if (GetHasFeat(FEAT_ELDRITCH_BLAST_4, oCaster))
		dNum = 4;
	else if (GetHasFeat(FEAT_ELDRITCH_BLAST_3, oCaster))
		dNum = 3;
	else if (GetHasFeat(FEAT_ELDRITCH_BLAST_2, oCaster))
		dNum = 2;
	else 
		dNum = 1;
		
	int result = d6(dNum);
	if (GetHasFeat(1958, oCaster)) //Edritch Master
		result = FloatToInt(IntToFloat(result)*1.5f);
	return result;
}

int DoEldritchOnHitBlast(object oCaster, object oTarget, int nDmgType, int nVFX, int nDC, int nID) {
	int nHitVFX = VFX_INVOCATION_ELDRITCH_HIT;	// default is Edlritch
	int nTouch;effect eBeam = EffectBeam(nVFX, oCaster, BODY_NODE_HAND);

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster) == TRUE)
    {
        SignalEvent(oTarget, EventSpellCastAt(oCaster, nID));

        int nDmg = GetBaseEldritchDamage(oCaster);

        SignalEvent(oTarget, EventSpellCastAt(oCaster, nID, TRUE));

        effect eDam = EffectDamage(nDmg, nDmgType);
        effect eVis = EffectVisualEffect( nHitVFX );
            
        //Apply the damage effect
		int hp = GetCurrentHitPoints(oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
		string damageDone = IntToString(hp-GetCurrentHitPoints(oTarget));
		string report = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> damages "+GetName(oTarget)+": "+damageDone+"</color>";
		SendMessageToPC(oCaster, report);
		
        return TRUE;
    }
    return FALSE;
}

int DoEssenceOnHitBeshadowedBlast(object oCaster, object oTarget, int nDC, int nID) {

    // First, do Base Effects:
    if ( DoEldritchOnHitBlast(oCaster, oTarget, DAMAGE_TYPE_MAGICAL, VFX_INVOCATION_BESHADOWED_RAY, nDC, nID) )
    {
        // Additional Effects: (Darkness)
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            //Make Fort save
            if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
            {
                float fDuration = RoundsToSeconds(1);
				int nDex = GetAbilityScore( oTarget, ABILITY_DEXTERITY );
				

                //effect eDark = EffectDarkness();
				effect eDark = EffectBlindness();
				effect eAC = EffectACDecrease( 2 );
				effect eLink = EffectLinkEffects( eDark, eAC );

                // Spell Effects not allowed to stack...
                RemoveEffectsFromSpell(oTarget, nID);

                //Apply the effect and VFX impact
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
				
				if (nDex > 10)
				{
					int nDecr = (nDex-10);
					effect eDex = EffectAbilityDecrease( ABILITY_DEXTERITY, nDecr);
					
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDex, oTarget, fDuration);
				}
                return TRUE;
            }
        }
    }
    return FALSE;
}

int DoEssenceOnHitBewitchingBlast(object oCaster, object oTarget, int nDC, int nID) {
	// First, do Base Effects:
    if ( DoEldritchOnHitBlast(oCaster, oTarget, DAMAGE_TYPE_MAGICAL, VFX_INVOCATION_BEWITCHING_RAY, nDC, nID) )
    {
        // Additional Effects: (Confusion)
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
            {
                float fDuration = RoundsToSeconds(1);

                effect eConfuse = EffectConfused();
                effect eMind = EffectVisualEffect( VFX_DUR_SPELL_CONFUSION );
                effect eLink = EffectLinkEffects(eMind, eConfuse);
				
                RemoveEffectsFromSpell(oTarget, nID);

                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
                return TRUE;
            }
        }
    }
    return FALSE;
}

int DoEssenceOnHitBindingBlast(object oCaster, object oTarget, int nDC, int nID) {
	// First, do Base Effects:
    if ( DoEldritchOnHitBlast(oCaster, oTarget, DAMAGE_TYPE_MAGICAL, VFX_INVOCATION_BINDING_RAY, nDC, nID) )
    {
		if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC))
        {
            effect eVis = EffectVisualEffect( VFX_DUR_STUN );
            effect eStun = EffectStunned();
            eStun = SupernaturalEffect(eStun);
			effect eLink = EffectLinkEffects( eStun, eVis );

            // Spell Effects not allowed to stack...
            RemoveEffectsFromSpell(oTarget, nID);

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1));
            return TRUE;
        }
    }
    return FALSE;
}

int DoEssenceOnHitBrimstoneBlast(object oCaster, object oTarget, int nDC, int nID) {
	// First, do Base Effects:
	int nHasSpellEffect = GetHasSpellEffect(nID, oTarget);

    if ( DoEldritchOnHitBlast(oCaster, oTarget, DAMAGE_TYPE_FIRE, VFX_INVOCATION_BRIMSTONE_RAY, nDC, nID) )
    {
		// Additional Effects: (Combust)
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
			
            // Doesn't Stack!
            if (nHasSpellEffect == 1)
            {
                //FloatingTextStrRefOnCreature(100775, OBJECT_SELF, FALSE);
                return FALSE;
            }

            int nCasterLvl = GetCasterLevel(oCaster);
            int nRoundsLeft;
            if ( nCasterLvl >= 20 )       { nRoundsLeft = 4; }
            else if ( nCasterLvl >= 15 )  { nRoundsLeft = 3; }
            else if ( nCasterLvl >= 10 )  { nRoundsLeft = 2; }
            else                          { nRoundsLeft = 1; }

            SaveDelayedSpellInfo(SPELL_I_BRIMSTONE_BLAST, oTarget, oCaster, nDC);
			effect eVFX = ExtraordinaryEffect(EffectVisualEffect(894));
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oTarget, RoundsToSeconds(nRoundsLeft));	
			DelayCommand(RoundsToSeconds(1), RunEssenceBrimstoneBlastImpact(oTarget, oCaster, nRoundsLeft));	// First check should be one round after the blast hit
				
	        return TRUE;
        }
	}
	return FALSE;
}

int DoEssenceOnHitDrainingBlast(object oCaster, object oTarget, int nDC, int nID) {
	if ( DoEldritchOnHitBlast(oCaster, oTarget, DAMAGE_TYPE_MAGICAL, VFX_INVOCATION_DRAINING_RAY, nDC, nID) )
    {
		// Additional Effects: (Slow Effect)
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC))
            {
                float fDuration = RoundsToSeconds(1);

                effect eSlow = EffectSlow();
                effect eDur = EffectVisualEffect( VFX_IMP_SLOW );
                effect eLink = EffectLinkEffects(eSlow, eDur);
                //effect eVis = EffectVisualEffect( VFX_INVOCATION_DRAINING_HIT );	// handled by DoEldritchBlast()

                // Spell Effects not allowed to stack...
                RemoveEffectsFromSpell(oTarget, nID);

                //Apply the slow effect and VFX impact
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
                //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	// handled by DoEldritchBlast()
                return TRUE;
            }
        }
	}
	return FALSE;
}

int DoEssenceOnHitFrightfulBlast(object oCaster, object oTarget, int nDC, int nID) {
	if ( DoEldritchOnHitBlast(oCaster, oTarget, DAMAGE_TYPE_MAGICAL, VFX_INVOCATION_FRIGHTFUL_RAY, nDC, nID) )
    {
		if ((GetHitDice(oTarget) < 6) && GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))
            {
                float fDuration = RoundsToSeconds(10);

                effect eScare = EffectFrightened();
                effect eSave = EffectSavingThrowDecrease(SAVING_THROW_WILL, 2, SAVING_THROW_TYPE_MIND_SPELLS);
                effect eMind = EffectVisualEffect( VFX_DUR_SPELL_FEAR );
                //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);	// handled by VFX_DUR_SPELL_FEAR
                effect eDamagePenalty = EffectDamageDecrease(2);
                effect eAttackPenalty = EffectAttackDecrease(2);
                effect eLink = EffectLinkEffects(eMind, eScare);
                effect eLink2 = EffectLinkEffects(eSave, eDamagePenalty);
                eLink2 = EffectLinkEffects(eLink2, eAttackPenalty);
                eLink2 = EffectLinkEffects(eLink2, eLink);

                // Spell Effects not allowed to stack...
                RemoveEffectsFromSpell(oTarget, nID);

                //Apply linked effects and VFX impact
                //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, fDuration);
                return TRUE;
            }
        }
    }
	return FALSE;
}

int DoEssenceOnHitHellrimeBlast(object oCaster, object oTarget, int nDC, int nID) {
	if ( DoEldritchOnHitBlast(oCaster, oTarget, DAMAGE_TYPE_COLD, VFX_INVOCATION_HELLRIME_RAY, nDC, nID) )
    {
		// Additional Effects: (Dex Penalty)
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
            {
                float fDuration = RoundsToSeconds(3);

                effect eDex = EffectAbilityDecrease(ABILITY_DEXTERITY, 4);

                // Spell Effects not allowed to stack...
                RemoveEffectsFromSpell(oTarget, nID);

                //Apply the effect and VFX impact
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDex, oTarget, fDuration);
                //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	// handled by DoEldritchBlast()
                return TRUE;
            }
        }
	}
	return FALSE;
}

int DoEssenceOnHitHinderingBlast(object oCaster, object oTarget, int nDC, int nID) {
	if ( DoEldritchOnHitBlast(oCaster, oTarget, DAMAGE_TYPE_MAGICAL, VFX_INVOCATION_HINDERING_RAY, nDC, nID) )
    {
		if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC))
        {
            effect eVis = EffectVisualEffect( VFX_DUR_SPELL_SLOW );
            effect eSlow = EffectSlow();
            eSlow = SupernaturalEffect(eSlow);
			effect eLink = EffectLinkEffects( eSlow, eVis );

            // Spell Effects not allowed to stack...
            RemoveEffectsFromSpell(oTarget, nID);

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1));
            return TRUE;
        }
	}
	return FALSE;
}


int DoEssenceOnHitNoxiousBlast(object oCaster, object oTarget, int nDC, int nID) {
	if ( DoEldritchOnHitBlast(oCaster, oTarget, DAMAGE_TYPE_MAGICAL, VFX_INVOCATION_NOXIOUS_RAY, nDC, nID) )
    {
		// Additional Effects: (Daze)
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
            {
                float fDuration = RoundsToSeconds(10);

                effect eMind = EffectVisualEffect( VFX_DUR_SPELL_DAZE );
                effect eDaze = EffectDazed();
                //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                effect eLink = EffectLinkEffects(eMind, eDaze);
                //eLink = EffectLinkEffects(eLink, eDur);
                //effect eVis = EffectVisualEffect( VFX_INVOCATION_NOXIOUS_HIT );	// handled by DoEldritchBlast()

                // Spell Effects not allowed to stack...
                RemoveEffectsFromSpell(oTarget, nID);

                //Apply the effect and VFX impact
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
                //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	// handled by DoEldritchBlast()
                return TRUE;
            }
        }
	}
	return FALSE;
}

int DoEssenceOnHitUtterdarkBlast(object oCaster, object oTarget, int nDC, int nID) {
	if ( DoEldritchOnHitBlast(oCaster, oTarget, DAMAGE_TYPE_NEGATIVE, VFX_INVOCATION_UTTERDARK_RAY, nDC, nID) )
    {
		if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
        {
            effect eVis = EffectVisualEffect( VFX_DUR_SPELL_ENERGY_DRAIN );
            effect eDrain = EffectNegativeLevel(2);
            eDrain = SupernaturalEffect(eDrain);
			effect eLink = EffectLinkEffects( eDrain, eVis );

            // Spell Effects not allowed to stack...
            RemoveEffectsFromSpell(oTarget, nID);

            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
            return TRUE;
        }
	}
	return FALSE;
}

int DoEssenceOnHitVitriolicBlast(object oCaster, object oTarget, int nDC, int nID) {
	int nHasSpellEffect = GetHasSpellEffect(GetSpellId(), oTarget);
	if ( DoEldritchOnHitBlast(oCaster, oTarget, DAMAGE_TYPE_ACID, VFX_INVOCATION_VITRIOLIC_RAY, nDC, nID) )
    {
		// Additional Effects: (Acid)
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            {
                if (nHasSpellEffect == 1)
				{
                    return FALSE;
                }

                int nCasterLvl = GetCasterLevel(oCaster);
                int nRoundsLeft;
                if ( nCasterLvl >= 20 )       { nRoundsLeft = 4; }
                else if ( nCasterLvl >= 15 )  { nRoundsLeft = 3; }
                else if ( nCasterLvl >= 10 )  { nRoundsLeft = 2; }
                else                          { nRoundsLeft = 1; }


                DelayCommand(RoundsToSeconds(1), RunEssenceVitriolicBlastImpact(oTarget, oCaster, nRoundsLeft)); // First check should be one round after the blast hit

                return TRUE;
            }
        }
	}
	return FALSE;
}

void DoEldritchOnHit(object oCaster, object oTarget, int nEssence, int nDC, int nID)
{
    //Declare major variables 
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetLocation(oTarget);
	
	int nDoomVFX = VFX_INVOCATION_ELDRITCH_AOE;
	if (nEssence == METAMAGIC_INVOC_BESHADOWED_BLAST) {
		DoEssenceOnHitBeshadowedBlast(oCaster, oTarget, nDC, nID);
		nDoomVFX = VFX_INVOCATION_BESHADOWED_DOOM;
	}
	else if (nEssence == METAMAGIC_INVOC_BEWITCHING_BLAST) {
		DoEssenceOnHitBewitchingBlast(oCaster, oTarget, nDC, nID);
		nDoomVFX = VFX_INVOCATION_BEWITCHING_DOOM;
	}
	else if (nEssence == METAMAGIC_INVOC_BINDING_BLAST) {
		DoEssenceOnHitBindingBlast(oCaster, oTarget, nDC, nID);
		nDoomVFX = VFX_INVOCATION_BINDING_DOOM;
	}
	else if (nEssence == METAMAGIC_INVOC_BRIMSTONE_BLAST) {
		DoEssenceOnHitBrimstoneBlast(oCaster, oTarget, nDC, nID);
		nDoomVFX = VFX_INVOCATION_BRIMSTONE_DOOM;
	}
	else if (nEssence == METAMAGIC_INVOC_DRAINING_BLAST) {
		DoEssenceOnHitDrainingBlast(oCaster, oTarget, nDC, nID);
		nDoomVFX = VFX_INVOCATION_DRAINING_DOOM;
	}
	else if (nEssence == METAMAGIC_INVOC_FRIGHTFUL_BLAST) {
		DoEssenceOnHitFrightfulBlast(oCaster, oTarget, nDC, nID);
		nDoomVFX = VFX_INVOCATION_FRIGHTFUL_DOOM;
	}
	else if (nEssence == METAMAGIC_INVOC_HELLRIME_BLAST) {
		DoEssenceOnHitHellrimeBlast(oCaster, oTarget, nDC, nID);
		nDoomVFX = VFX_INVOCATION_HELLRIME_DOOM;
	}
	else if (nEssence == METAMAGIC_INVOC_HINDERING_BLAST) {
		DoEssenceOnHitHinderingBlast(oCaster, oTarget, nDC, nID);
		nDoomVFX = VFX_INVOCATION_HINDERING_DOOM;
	}
	else if (nEssence == METAMAGIC_INVOC_NOXIOUS_BLAST) {
		DoEssenceOnHitNoxiousBlast(oCaster, oTarget, nDC, nID);
		nDoomVFX = VFX_INVOCATION_NOXIOUS_HIT;
	}
	else if (nEssence == METAMAGIC_INVOC_UTTERDARK_BLAST) {
		DoEssenceOnHitUtterdarkBlast(oCaster, oTarget, nDC, nID);
		nDoomVFX = VFX_INVOCATION_UTTERDARK_DOOM;
	}
	else if (nEssence == METAMAGIC_INVOC_VITRIOLIC_BLAST) {
		DoEssenceOnHitVitriolicBlast(oCaster, oTarget, nDC, nID);
		nDoomVFX = VFX_INVOCATION_VITRIOLIC_DOOM;
	}
	
    effect eExplode = EffectVisualEffect( nDoomVFX );
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
}

void DoAreaOnHitBlast(object oCaster, object oTarget, int nEssence, int nDC, int nID)
{
   //Declare major variables 
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetLocation(oTarget);

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        // Handle combined Eldritch Essence Effects, if any
        DoEldritchOnHit(oCaster, oTarget, nEssence, nDC, nID);

        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}

int ArcaneArcherDamageDone(int bCrit = FALSE, object oUser = OBJECT_SELF)
{
    object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    int nDamage;
    int bSpec = FALSE;
    int bGrSpec = FALSE;
    int bEpSpec = FALSE;

    if (GetIsObjectValid(oItem) == TRUE)
    {
        if (GetBaseItemType(oItem) == BASE_ITEM_LONGBOW || GetBaseItemType(oItem) == 192)
        {
            nDamage = d8();
            if (GetHasFeat(FEAT_WEAPON_SPECIALIZATION_LONGBOW,oUser))
            {
              bSpec = TRUE;
            }
            if (GetHasFeat(FEAT_GREATER_WEAPON_SPECIALIZATION_LONGBOW,oUser))
            {
              bGrSpec = TRUE;
            }
            if (GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_LONGBOW,oUser))
            {
              bEpSpec = TRUE;
            }
        }
        else
        if (GetBaseItemType(oItem) == BASE_ITEM_SHORTBOW || GetBaseItemType(oItem) == 193)
        {
            nDamage = d6();
            if (GetHasFeat(FEAT_WEAPON_SPECIALIZATION_SHORTBOW,oUser))
            {
              bSpec = TRUE;
            }
            if (GetHasFeat(FEAT_GREATER_WEAPON_SPECIALIZATION_SHORTBOW,oUser))
            {
              bGrSpec = TRUE;
            }
            if (GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTBOW,oUser))
            {
              bEpSpec = TRUE;
            }
        }
        else
        if (GetBaseItemType(oItem) == BASE_ITEM_LIGHTCROSSBOW || GetBaseItemType(oItem) == 191)
        {
            nDamage = d8();
            if (GetHasFeat(FEAT_WEAPON_SPECIALIZATION_LIGHT_CROSSBOW,oUser))
            {
              bSpec = TRUE;
            }
            if (GetHasFeat(FEAT_GREATER_WEAPON_SPECIALIZATION_LIGHTCROSSBOW,oUser))
            {
              bGrSpec = TRUE;
            }
            if (GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTCROSSBOW,oUser))
            {
              bEpSpec = TRUE;
            }
        }
        else
        if (GetBaseItemType(oItem) == BASE_ITEM_HEAVYCROSSBOW || GetBaseItemType(oItem) == 190)
        {
            nDamage = d10();
            if (GetHasFeat(FEAT_WEAPON_SPECIALIZATION_HEAVY_CROSSBOW,oUser))
            {
              bSpec = TRUE;
            }
            if (GetHasFeat(FEAT_GREATER_WEAPON_SPECIALIZATION_HEAVYCROSSBOW,oUser))
            {
              bGrSpec = TRUE;
            }
            if (GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_HEAVYCROSSBOW,oUser))
            {
              bEpSpec = TRUE;
            }
        }
        else
        if (GetBaseItemType(oItem) == BASE_ITEM_SLING || GetBaseItemType(oItem) == 194)
        {
            nDamage = d4();
            if (GetHasFeat(FEAT_WEAPON_SPECIALIZATION_SLING,oUser))
            {
              bSpec = TRUE;
            }
            if (GetHasFeat(FEAT_GREATER_WEAPON_SPECIALIZATION_SLING,oUser))
            {
              bGrSpec = TRUE;
            }
            if (GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_SLING,oUser))
            {
              bEpSpec = TRUE;
            }
        }
        else
            return 0;
    }
    else
    {
            return 0;
    }

    // add strength bonus
    if (GetItemHasItemProperty(oItem, ITEM_PROPERTY_MIGHTY))
    {
        int nStrength = GetAbilityModifier(ABILITY_STRENGTH,oUser);
        nDamage += nStrength;
    }
    nDamage += 1;

    if (bSpec == TRUE)
    {
        nDamage +=2;
    }
    if (bGrSpec == TRUE)
    {
        nDamage +=2;
    }
    if (bEpSpec == TRUE)
    {
        nDamage +=2;
    }
    if (bCrit == TRUE)
    {
         nDamage *=3;
    }

    return nDamage;
}