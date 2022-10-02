#include "x2_inc_spellhook"
#include "X0_I0_SPELLS"
#include "ps_inc_functions"
#include "ps_inc_equipment"
#include "ps_inc_advscript"
#include "nw_i0_spells"
#include "x0_i0_match"
#include "ps_inc_bgspellfix"
#include "x2_inc_itemprop"

void Wild_Magic(object oPC,object oTarget, int nSpell)
{
if(GetIsOffensiveSpell(nSpell) == 0 || GetLocalInt(oPC,"NoWildMagic") == 1) return;
	
SetLocalInt(oPC,"NoWildMagic",1);
DelayCommand(3.0f,DeleteLocalInt(oPC,"NoWildMagic"));
int iCastLvl = GetSpellLevel(nSpell);
if(nSpell == 1521) iCastLvl = 3;
iCastLvl = iCastLvl + Random(4);
	if(iCastLvl > 9) iCastLvl = 9;
	
	
	int iHostile; int iWildSpell; string sWildSpell;
	string TargetUI = Get2DAString("spells", "TargetingUI", nSpell);
	
	while(iHostile == 0)
	{
		SQLExecDirect("SELECT `spellid` FROM `spellids` WHERE `spell_lvl`='"+IntToString(iCastLvl)+"' AND `targetingui`='"+TargetUI+"' OR `spell_lvl`='"+IntToString(iCastLvl)+"' AND `targetingui`='8' ORDER BY RAND() LIMIT 1;");
		SQLFetch();
		
		sWildSpell = SQLGetData(1);
		if(sWildSpell == "") {iWildSpell = 0; break;}
		iWildSpell = StringToInt(sWildSpell);

		if(GetIsOffensiveSpell(iWildSpell)) break;
	}
	
	FloatingTextStringOnCreature("<I>*Wild Magic: "+GetStringByStrRef(StringToInt(Get2DAString("spells", "Name", iWildSpell)))+"*", oCaster, TRUE, 3.0f);
	ExecuteScript(Get2DAString("spells", "ImpactScript", iWildSpell), oPC);		
	
	
	
}