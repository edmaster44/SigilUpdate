//::///////////////////////////////////////////////
//:: Greater Wild Shape, Humanoid Shape
//:: x2_s2_gwildshp
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Allows the character to shift into one of these
    forms, gaining special abilities

    Credits must be given to mr_bumpkin from the NWN
    community who had the idea of merging item properties
    from weapon and armor to the creatures new forms.

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-02
//:://////////////////////////////////////////////
// AFW-OEI 05/04/2007: Handle Plant Wild Shape, too.

#include "x2_inc_itemprop"
//#include "x2_inc_shifter"
#include "nwn2_inc_spells"


void main()
{
    // AFW-OEI 02/28/2007: Early-out if you have no wildshape uses left.
    if (!GetHasFeat(FEAT_WILD_SHAPE, OBJECT_SELF))
    {
        SpeakStringByStrRef(STR_REF_FEEDBACK_NO_MORE_FEAT_USES);
        return;
    }

    //--------------------------------------------------------------------------
    // Declare major variables
    //--------------------------------------------------------------------------
    int    nSpell = GetSpellId();
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_DUR_POLYMORPH);
    //int    nShifter = GetLevelByClass(CLASS_TYPE_SHIFTER);
    effect ePoly;
    int    nPoly;

    // Feb 13, 2004, Jon: Added scripting to take care of case where it's an NPC
    // using one of the feats. It will randomly pick one of the shapes associated
    // with the feat.
    switch(nSpell)
    {
        // Greater Wildshape I
        case 646: nSpell = Random(5)+658; break;
        // Greater Wildshape II
        case 675: switch(Random(3))
                  {
                    case 0: nSpell = 672; break;
                    case 1: nSpell = 678; break;
                    case 2: nSpell = 680;
                  }
                  break;
        // Greater Wildshape III
        case 676: switch(Random(3))
                  {
                    case 0: nSpell = 670; break;
                    case 1: nSpell = 673; break;
                    case 2: nSpell = 674;
                  }
                  break;
        // Greater Wildshape IV
        case 677: switch(Random(3))
                  {
                    case 0: nSpell = 679; break;
                    case 1: nSpell = 691; break;
                    case 2: nSpell = 694;
                  }
                  break;
        // Humanoid Shape
        case 681:  nSpell = Random(3)+682; break;
        // Undead Shape
        case 685:  nSpell = Random(3)+704; break;
        // Dragon Shape
        case 725:  nSpell = Random(3)+707; break;
        // Outsider Shape
        case 732:  nSpell = Random(3)+733; break;
        // Construct Shape
        case 737:  nSpell = Random(3)+738; break;
        // Magical Beast Wild Shape
        case SPELLABILITY_MAGICAL_BEAST_WILD_SHAPE:
            nSpell = Random(3)+SPELLABILITY_MAGICAL_BEAST_WILD_SHAPE_CELESTIAL_BEAR; break;
		// Plant Wild Shape
		case SPELLABILITY_PLANT_WILD_SHAPE:
			nSpell = Random(2) + SPELLABILITY_PLANT_WILD_SHAPE_SHAMBLING_MOUND; break;	// 2 forms to choose from
    }

    //--------------------------------------------------------------------------
    // Determine which form to use based on spell id, gender and level
    //--------------------------------------------------------------------------
    switch (nSpell)
    {
       //-----------------------------------------------------------------------
       // Dragon Shape - Red, Blue, and Black Dragons
       //-----------------------------------------------------------------------
       case 707: nPoly = POLYMORPH_TYPE_RED_DRAGON; break;    // Red Dragon
       case 708: nPoly = POLYMORPH_TYPE_BLUE_DRAGON; break;   // Blue Dragon
       case 709: nPoly = POLYMORPH_TYPE_BLACK_DRAGON; break;  // Black Dragon
	   // Additions by Loki
	   case 1242: nPoly = 313;	break; // Bronze Dragon
	   
   

       //-----------------------------------------------------------------------
       // Magical Beast Wild Shape - Celestial Leopard, Phase Spider, Winter Wolf
       //-----------------------------------------------------------------------
       case SPELLABILITY_MAGICAL_BEAST_WILD_SHAPE_CELESTIAL_BEAR: 
            nPoly = POLYMORPH_TYPE_CELESTIAL_LEOPARD; break;    // Celestial Leopard; yes, everything says bear, but we don't have a bear in NX1
       case SPELLABILITY_MAGICAL_BEAST_WILD_SHAPE_PHASE_SPIDER:
            nPoly = POLYMORPH_TYPE_PHASE_SPIDER; break;      // Phase Spider
       case SPELLABILITY_MAGICAL_BEAST_WILD_SHAPE_WINTER_WOLF:
            nPoly = POLYMORPH_TYPE_WINTER_WOLF; break;       // Winter Wolf
			
	   //-----------------------------------------------------------------------
       // Plant Wild Shape -- Shambling Mound, Treant
       //-----------------------------------------------------------------------
       case SPELLABILITY_PLANT_WILD_SHAPE_SHAMBLING_MOUND: 
            nPoly = POLYMORPH_TYPE_SHAMBLING_MOUND; break;    // Shambling Mound
       case SPELLABILITY_PLANT_WILD_SHAPE_TREANT:
            nPoly = POLYMORPH_TYPE_TREANT; break;      // Treant

    }

	
	if ((nPoly == POLYMORPH_TYPE_RED_DRAGON)
		|| (nPoly == POLYMORPH_TYPE_BLUE_DRAGON)
		|| (nPoly == POLYMORPH_TYPE_BLACK_DRAGON)
		|| (nPoly == 313))
	{
		// injecting a little routine here to remove Reduce Person (and GRP) to avoid crash scenario
		
		effect eReduce = GetFirstEffect(oTarget);
		int iReduce;
		
		while(GetIsEffectValid(eReduce))
		{
			iReduce = GetEffectSpellId(eReduce);
		
			if ((iReduce == SPELL_REDUCE_PERSON) 
			|| (iReduce == SPELL_REDUCE_PERSON_GREATER) 
			|| (iReduce == SPELL_REDUCE_PERSON_GREATER))
			{
				RemoveEffectsFromSpell(oTarget, iReduce);
			}
			eReduce = GetNextEffect(oTarget);
		}
	}
	

    //--------------------------------------------------------------------------
    // Determine which items get their item properties merged onto the shifters
    // new form.
    //--------------------------------------------------------------------------
    /* AFW-OEI 02/28/2007: No more shifter stuff
    int bWeapon = ShifterMergeWeapon(nPoly);
    int bArmor  = ShifterMergeArmor(nPoly);
    int bItems  = ShifterMergeItems(nPoly);
    */
    
    //--------------------------------------------------------------------------
    // Determine which items get their item properties merged onto the new form.
    //--------------------------------------------------------------------------
    int bWeapon = StringToInt(Get2DAString("polymorph","MergeW",nPoly)) == 1;
    int bArmor  = StringToInt(Get2DAString("polymorph","MergeA",nPoly)) == 1;
    int bItems  = StringToInt(Get2DAString("polymorph","MergeI",nPoly)) == 1;

    //--------------------------------------------------------------------------
    // Store the old objects so we can access them after the character has
    // changed into his new form
    //--------------------------------------------------------------------------
    object oWeaponOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
    object oArmorOld  = GetItemInSlot(INVENTORY_SLOT_CHEST,OBJECT_SELF);
    object oRing1Old  = GetItemInSlot(INVENTORY_SLOT_LEFTRING,OBJECT_SELF);
    object oRing2Old  = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,OBJECT_SELF);
    object oAmuletOld = GetItemInSlot(INVENTORY_SLOT_NECK,OBJECT_SELF);
    object oCloakOld  = GetItemInSlot(INVENTORY_SLOT_CLOAK,OBJECT_SELF);
    object oBootsOld  = GetItemInSlot(INVENTORY_SLOT_BOOTS,OBJECT_SELF);
    object oBeltOld   = GetItemInSlot(INVENTORY_SLOT_BELT,OBJECT_SELF);
    object oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD,OBJECT_SELF);
    object oShield    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF);

    if (GetIsObjectValid(oShield))
    {
        if (GetBaseItemType(oShield) !=BASE_ITEM_LARGESHIELD &&
            GetBaseItemType(oShield) !=BASE_ITEM_SMALLSHIELD &&
            GetBaseItemType(oShield) !=BASE_ITEM_TOWERSHIELD)
        {
            oShield = OBJECT_INVALID;
        }
    }


    //--------------------------------------------------------------------------
    // Here the actual polymorphing is done
    //--------------------------------------------------------------------------
    ePoly = EffectPolymorph(nPoly, FALSE, TRUE);	// AFW-OEI 06/06/2007: Use 3rd boolean to say this is a wildshape polymorph.
    ePoly = ExtraordinaryEffect(ePoly);
    ClearAllActions(); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, OBJECT_SELF);
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //--------------------------------------------------------------------------
    // This code handles the merging of item properties
    //--------------------------------------------------------------------------
    object oWeaponNew = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,OBJECT_SELF);
	object oWeaponNew1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,OBJECT_SELF);
    object oWeaponNew2 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,OBJECT_SELF);
    object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,OBJECT_SELF);

    //identify weapon
    SetIdentified(oWeaponNew, TRUE);

    //--------------------------------------------------------------------------
    // ...Weapons
    //--------------------------------------------------------------------------
    if (bWeapon)
    {
            IPWildShapeCopyItemProperties(oWeaponOld,oWeaponNew, TRUE);
            IPWildShapeCopyItemProperties(oWeaponOld,oWeaponNew1, TRUE);
            IPWildShapeCopyItemProperties(oWeaponOld,oWeaponNew2, TRUE);	
    }

    //--------------------------------------------------------------------------
    // ...Armor
    //--------------------------------------------------------------------------
    if (bArmor)
    {
        //----------------------------------------------------------------------
        // Merge item properties from armor and helmet...
        //----------------------------------------------------------------------
        IPWildShapeCopyItemProperties(oArmorOld,oArmorNew);
        IPWildShapeCopyItemProperties(oHelmetOld,oArmorNew);
        IPWildShapeCopyItemProperties(oShield,oArmorNew);
    }

    //--------------------------------------------------------------------------
    // ...Magic Items
    //--------------------------------------------------------------------------
    if (bItems)
    {
        //----------------------------------------------------------------------
        // Merge item properties from from rings, amulets, cloak, boots, belt
        //----------------------------------------------------------------------
        IPWildShapeCopyItemProperties(oRing1Old,oArmorNew);
        IPWildShapeCopyItemProperties(oRing2Old,oArmorNew);
        IPWildShapeCopyItemProperties(oAmuletOld,oArmorNew);
        IPWildShapeCopyItemProperties(oCloakOld,oArmorNew);
        IPWildShapeCopyItemProperties(oBootsOld,oArmorNew);
        IPWildShapeCopyItemProperties(oBeltOld,oArmorNew);
    }

    //--------------------------------------------------------------------------
    // Set artificial usage limits for special ability spells to work around
    // the engine limitation of not being able to set a number of uses for
    // spells in the polymorph radial
    //--------------------------------------------------------------------------
    //ShifterSetGWildshapeSpellLimits(nSpell);  // AFW-OEI 02/28/2007: No more shifter stuff

    
    //--------------------------------------------------------------------------
    // Decrement wildshape uses
    //--------------------------------------------------------------------------
    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_WILD_SHAPE);
}