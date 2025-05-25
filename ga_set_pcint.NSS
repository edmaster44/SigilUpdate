

// ga_local_int(string sVariable, string sChange, string sTarget)
/*
   This script changes a local int variable's value
   
   Parameters:
     string sVariable   = Name of variable to change
     string sChange     = VALUE	  (EFFECT)
	 					  "5"     (Set to 5)
						  "=-2"   (Set to -2)
						  "+3"    (Add 3)
						  "+"     (Add 1)
						  "++"    (Add 1)
						  "-4"    (Subtract 4)
						  "-"     (Subtract 1)
						  "--"    (Subtract 1)
     string sTarget	= The PC Speaker
*/
// FAB 10/7
// BMA 4/15/05 added set operator, "=n"
// BMA 4/27/05 added GetTarget()
// ChazM 5/4/05 moved CalcNewIntValue() to "ginc_var_ops"
// BMA 7/19/05 added object invalid printstring

#include "ginc_param_const"
#include "ginc_var_ops"

void main(string sVariable, string sChange)
{
    object oTarg = GetPCSpeaker();

	int nOldValue = GetLocalInt(oTarg, sVariable);
	int nNewValue = CalcNewIntValue(nOldValue, sChange);

	SetLocalInt(oTarg, sVariable, nNewValue);
}