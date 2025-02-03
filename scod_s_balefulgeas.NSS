//:://////////////////////////////////////////////
/*
   Baleful Geas - Dragon Magic
   scod_s_balefulgeas.nss
*/
//:://////////////////////////////////////////////
//:: Created By: Xndar
//:: Created On: July 1st, 2014
//:://////////////////////////////////////////////
/*
rapsam2003 03/26/2018: Remove save against NPCs and
	Hexer feats increase the strength of the target.
*/

#include "nw_i0_invocatns"

void main() {

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

    //Declare major variables
	object 		oCaster 	= 	OBJECT_SELF;
    object 		oTarget 	= 	GetSpellTargetObject();
    effect 		eGeas 		= 	EffectDominated();
	int 		nDC			= 	GetSpellSaveDC();
	
	
    eGeas = GetScaledEffect(eGeas, oTarget);
	
    effect eDur = EffectVisualEffect(VFX_HIT_SPELL_INFLICT_6);
	int nGeasDice = d4(2);
	
	//Link domination and persistant VFX
    effect eLink = EffectLinkEffects(eDur, eGeas);
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nDuration = 3 + nCasterLevel/2;
	
	int nHexerBuff = 0;
	
	//Hexen's Hexer and Cursemaster feats buff the effected
	//creature and increase the duration of the curse
	if (GetHasFeat(FEAT_HEXEN_CURSEMASTER, OBJECT_SELF)) {
		nHexerBuff = d4(2);
		nDuration += 3 + (nCasterLevel*2);
		nDC += 4;
	} else if (GetHasFeat(FEAT_HEXEN_HEXER_3, OBJECT_SELF)) {
		nHexerBuff = d4(2);
		nDuration += 3 + nCasterLevel;
		nDC += 3;
	} else if (GetHasFeat(FEAT_HEXEN_HEXER_2, OBJECT_SELF)) {
		nHexerBuff = d4(1)+1;
		nDuration += 3 + nCasterLevel;
		nDC += 2;
	} else if (GetHasFeat(FEAT_HEXEN_HEXER_1, OBJECT_SELF)) {
		nHexerBuff = 2;
		nDuration += 3 + nCasterLevel;
		nDC += 1;
	}

	effect eAbilityChange;
	
	nHexerBuff += nGeasDice;
	
	if (nHexerBuff > 0) {
		eAbilityChange = EffectAbilityIncrease(ABILITY_STRENGTH, nHexerBuff);
		if (GetHasFeat(FEAT_HEXEN_CURSEMASTER, OBJECT_SELF)) { //extra buffs from cursemaster!
			eAbilityChange = EffectLinkEffects(eAbilityChange, EffectAbilityIncrease(ABILITY_DEXTERITY, nHexerBuff));
			eAbilityChange = EffectLinkEffects(eAbilityChange, EffectAbilityIncrease(ABILITY_CONSTITUTION, nHexerBuff));
		}
	} else {
		eAbilityChange = EffectAbilityDecrease(ABILITY_STRENGTH, nGeasDice);
	}
	
    nDuration = GetScaledDuration(nDuration, oTarget);
	
    //Signal spell cast at event.
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1374, FALSE));
	
	// Spell Resist check.
    if (!DoWarlockMyResistSpell(oCaster, oTarget) || GetHasFeat(FEAT_HEXEN_CURSEMASTER, oCaster))
    {
		// Do NOT want this cast on PCs.
		// Make a Will save, for balance.
   		if (!GetIsPC(oTarget) && !MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
		{                    
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAbilityChange, oTarget);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
			
			//Set the explosion for on death
			if (GetHasFeat(FEAT_HEXEN_BALEFUL_GEAS, OBJECT_SELF)) {
				SendMessageToPC(oCaster, "Explosion set.");
				int nDamage = GetEldritchBlastDmg(OBJECT_SELF, oTarget);
				SetLocalString(oTarget, "DeathScript", "ps_ondeath_eldritchblast");
				
				SetLocalInt(oTarget, "EldritchBlast_Damage", nDamage);
				SetLocalInt(oTarget, "EldritchBlast_DC", nDC);
				SetLocalObject(oTarget, "EldritchBlast_Caster", oCaster);
			}
			
			SendMessageToPC(oCaster, "The curse dominates the affected enemy.");
		} 
		//If has Hexen's Curse: Baleful Geas, then do eldritch strike
		/*else if (GetHasFeat(FEAT_HEXEN_BALEFUL_GEAS, OBJECT_SELF)) {
		
			int nDamage = GetEldritchBlastDmg(OBJECT_SELF, oTarget);
			DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage), oTarget));
		
		}*/
	}	
}