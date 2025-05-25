

//gb_hydra_ondamage - Hydra On Damage script
//
//Temporarily remove regen property from hide 
//for 1 round per 3 points of fire or acid damage.
//
//Pyrohydras require cold instead of fire damage
//
//if local int on creature 'KeepHeads' is not 1,
//then apply head remove effects

#include "ginc_ai"
#include "x0_i0_spells"

void HealthCheck(object oTarget);

void main() {

	if (GetLocalInt(OBJECT_SELF, "KeepHeads") != 1)
		HealthCheck(OBJECT_SELF);
		
	//Both of these damage types will slow down his regen
	//These variables -must- be set on the creature
	int nDamageVulnerability1 = GetLocalInt(OBJECT_SELF, "DamageVulnerabilityType1");
	int nDamageVulnerability2 = GetLocalInt(OBJECT_SELF, "DamageVulnerabilityType2");
	
	int nAcid = GetDamageDealtByType(nDamageVulnerability1)+1; //returns -1 if none is dealt, 0 if acid damage was dealt, but a very meager amount
	int nFire = GetDamageDealtByType(nDamageVulnerability2)+1;
	
	if (GetLocalString(OBJECT_SELF, "Breath") == "fire")//pyrohydra
		nFire = GetDamageDealtByType(DAMAGE_TYPE_COLD)+1;
	
	if (nAcid < 3 && nFire < 3) {
		ExecuteScript("nw_c2_default6", OBJECT_SELF);
		return;
	}
	
	int iDmg = nAcid;	
	if (nFire > nAcid) iDmg = nFire;
	
	int iWait = GetLocalInt(OBJECT_SELF, "Wait");
	if (iWait < 0) iWait = 0;
	int iCounter = GetLocalInt(OBJECT_SELF, "Counter");
	int iRounds = iDmg / 3;
	if (iRounds > 5) iRounds = 5;
	iRounds = iWait + iRounds;
	if (iCounter < 0) 
		SetLocalInt(OBJECT_SELF, "Counter", 0);
	
	SetLocalInt(OBJECT_SELF, "Wait", iRounds);
	
	object oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR, OBJECT_SELF);
	int iHasRegen = GetItemHasItemProperty(oHide, ITEM_PROPERTY_REGENERATION);
	
	if(iHasRegen == TRUE) {
	
		itemproperty ipHide = GetFirstItemProperty(oHide);
		while ( GetIsItemPropertyValid(ipHide) ) {
		
			if (GetItemPropertyType(ipHide) == ITEM_PROPERTY_REGENERATION) {
				RemoveItemProperty(oHide, ipHide);
			}//end if regen property	
			ipHide = GetNextItemProperty(oHide);
			
		}//end while
			
	}//end if had regen property
		
	ExecuteScript("nw_c2_default6", OBJECT_SELF);
	
}

void HealthCheck(object oTarget) {

	effect eBlood;
	int iHP = GetCurrentHitPoints(oTarget);
	
	if (iHP < 1)  {
	
		eBlood = EffectNWN2SpecialEffectFile("fx_hydra_blood5.sef");
		RemoveAnySpellEffects(100, oTarget);
		DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBlood, oTarget));
		//death animation
		return;
		
	}
	
	int iHPperc = GetHealthPercent(oTarget);
	int iHeadsGone = GetLocalInt(oTarget, "HeadsGone");
	int iHP1 = ( iHPperc / 20 ) + 1;
	if (iHP1 > 5) iHP1 = 5;
	int iHP2 = 5 - iHP1;
	
	if (iHP2 == iHeadsGone) return;
	iHeadsGone = iHP2;
	SetLocalInt(oTarget, "HeadsGone", iHeadsGone);
	RemoveAnySpellEffects(100, oTarget);
	if (iHeadsGone == 0) return;
	string sEffect = "fx_hydra_blood"+IntToString(iHeadsGone)+".sef";
	eBlood = SetEffectSpellId(EffectNWN2SpecialEffectFile(sEffect),100);
	DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBlood, oTarget));
	
}