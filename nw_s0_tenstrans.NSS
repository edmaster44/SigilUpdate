//::///////////////////////////////////////////////
//:: Tensor's Transformation
//:: NW_S0_TensTrans.nss
//:: Originally hacked all to hell by: BitRaiser
//:: Additional refinements by: Alex Moskwa
//:://////////////////////////////////////////////
/*
PnP description:
Transmutation
Level: Sor/Wiz 6
Components: V, S, M
Casting Time: 1 action
Range: Personal
Target: The character
Duration: 1 round/level
The character gains 1d6 temporary hit points per caster level (NOPE),
a +4 natural armor bonus to AC, a +2d4 Strength enhancement bonus,
a +2d4 Dexterity enhancement bonus,
a +1 base attack bonus per two caster levels
(which may give the character an extra attack),
a +5 competence bonus on Fortitude saves,
and proficiency with all simple and martial weapons.
The character attacks opponents with melee or ranged weapons if the character
can, even resorting to unarmed attacks if that�s all the character can do.
The character can�t cast spells, even from magic items.
Material Component: A potion of Strength,
which the character drinks (and whose effects are subsumed by the spell effects).
*/

#include "x2_inc_spellhook"
#include "x2_inc_itemprop"
#include "x2_inc_shifter"
#include "nwn2_inc_spells"
#include "ps_inc_functions"

//The following function tells you how many attacks you have given a Base Attack Bonus Value.
int Attacks (int BAB) 
{
  if (BAB%5)
  {
    return BAB/5 + 1;

  }
  else {
    return BAB/5;;
  }
}


void main()
{


  //----------------------------------------------------------------------------
  // GZ, Nov 3, 2003
  // There is a serious problems with creatures turning into unstoppable killer
  // machines when affected by tensors transformation. NPC AI can't handle that
  // spell anyway, so I added this code to disable the use of Tensors by any
  // NPC.
  //----------------------------------------------------------------------------
  if (!GetIsPC(OBJECT_SELF))
  {
      WriteTimestampedLogEntry(GetName(OBJECT_SELF) + "[" + GetTag (OBJECT_SELF) +"] tried to cast Tensors Transformation. Bad! Remove that spell from the creature");
      return;
  }

  /*
    Spellcast Hook Code
      Added 2003-06-23 by GeorgZ
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more
    */

if (!X2PreSpellCastCode())
{
    return;
}

	// Remove effects of Divine Power when this spell is cast
	if (GetHasSpellEffect(SPELL_DIVINE_POWER, OBJECT_SELF))
	{
		RemoveSpellEffectsFromCaster(SPELL_DIVINE_POWER, OBJECT_SELF, OBJECT_INVALID);
		SendMessageToPC(OBJECT_SELF, "As this spell takes hold, the effects of Divine Power fade");
	} 

    // End of Spell Cast Hook


    //Declare major variables
    int nLevel = GetCasterLevel(OBJECT_SELF);
    int nHP, nCnt, nDuration, nSTR, nDEX;
    nDuration = GetCasterLevel(OBJECT_SELF);
    nSTR = 4;
    nDEX = 4;
    //Determine bonus HP
    nHP = nLevel*2;
    int nMeta = GetMetaMagicFeat();
    //Metamagic
    if(nMeta == METAMAGIC_MAXIMIZE)
    {
        nHP = nLevel * 3;
        nSTR = 7;
        nDEX = 7;
    }
    else if(nMeta == METAMAGIC_EMPOWER)
    {
        nHP = nHP + (nHP/2);
        nSTR += nSTR/2;
        nDEX += nDEX/2;
    }
    else if(nMeta == METAMAGIC_EXTEND)
    {
        nDuration *= 2;
    }

    //Add temporary proficiency feats to the currently equipped armor for Transformation
    itemproperty ipAdd1 = ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_SIMPLE);
    itemproperty ipAdd2 = ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_MARTIAL);
	itemproperty ipAdd3 = ItemPropertyBonusFeat(2950); //This is magical abstinence to keep the player from casting from items
    object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF);
    if (GetIsObjectValid(oItem)) {
	IPSafeAddItemProperty(oItem, ipAdd1, RoundsToSeconds(nDuration));
	IPSafeAddItemProperty(oItem, ipAdd2, RoundsToSeconds(nDuration));
	IPSafeAddItemProperty(oItem, ipAdd3, RoundsToSeconds(nDuration));
    }

  //The following is the unfortunately rather involved logic it takes to add the proper number of attacks for the spell.
  int oBAB, nBAB, AddAttacks, n, cLevel;
  oBAB = GetBaseAttackBonus(OBJECT_SELF);
  cLevel=0;
  //Determine if the character is epic and adjust oBAB accordingly to determine # of attacks.
  for (n = 1;n <= 3; n++) {
    cLevel += GetLevelByPosition(n,OBJECT_SELF);
  }
  if (cLevel > 20) {
    oBAB -= ((cLevel - 19)/2);
  }
  //Figure out your new spell modified BAB and derive how many extra attacks it should give you.
  nBAB = oBAB + (nLevel/2);
  if (nBAB>20)
    AddAttacks = 4 - Attacks(oBAB);
  else
    AddAttacks = Attacks(nBAB) - Attacks(oBAB);
  if (Attacks(oBAB)>=4) {
    AddAttacks=0;
  }

   

    //Declare effects
    effect eSpellFail = EffectSpellFailure(100, SPELL_SCHOOL_GENERAL);
    effect eAttack = EffectAttackIncrease(nLevel/3);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_FORT, 5);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eSwing = EffectModifyAttacks(AddAttacks);
    effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, nSTR);
    effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, nDEX);
    effect eAC = EffectACIncrease(4,AC_NATURAL_BONUS);
    effect eDis = EffectSkillIncrease(SKILL_DISCIPLINE, (nLevel + 2));
    //effect ePoly = EffectPolymorph(POLYMORPH_TYPE_HEURODIS);
    //Link effects
    effect eLink = EffectLinkEffects(eAttack, eSave);
    eLink = EffectLinkEffects(eLink, eDis);
    eLink = EffectLinkEffects(eLink, eDex);
    eLink = EffectLinkEffects(eLink, eAC);
    eLink = EffectLinkEffects(eLink, eStr);
    eLink = EffectLinkEffects(eLink, eDur);
    if (AddAttacks > 0) 
      eLink = EffectLinkEffects(eLink, eSwing);
    eLink = EffectLinkEffects(eLink, eSpellFail);
    //eLink = EffectLinkEffects(eLink, ePoly);
    effect eHP = EffectTemporaryHitpoints(nHP);
    effect eVis = EffectNWN2SpecialEffectFile("sp_skin_6.sef", OBJECT_SELF);
    //Signal Spell Event
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_TENSERS_TRANSFORMATION, FALSE));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, OBJECT_SELF, RoundsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, OBJECT_SELF, RoundsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nDuration));

}