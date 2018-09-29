//////////////////////////////////////////////////
/*                  Includes                    */
//////////////////////////////////////////////////

#include "psi_inc_fillin"
//#include "psi_feat_const"


//////////////////////////////////////////////////
/*                 Constants                    */
//////////////////////////////////////////////////

/// No metapsionics
const int METAPSIONIC_NONE          = 0x0;
/// Chain Power
const int METAPSIONIC_CHAIN         = 0x2;
/// Empower Power
const int METAPSIONIC_EMPOWER       = 0x4;
/// Extend Power
const int METAPSIONIC_EXTEND        = 0x8;
/// Maximize Power
const int METAPSIONIC_MAXIMIZE      = 0x10;
/// Split Psionic Ray
const int METAPSIONIC_SPLIT         = 0x20;
/// Twin Power
const int METAPSIONIC_TWIN          = 0x40;
/// Widen Power
const int METAPSIONIC_WIDEN         = 0x80;
/// Quicken Power
const int METAPSIONIC_QUICKEN       = 0x90;
/// Augment Power
const int METAPSIONIC_AUGMENT       = 0x100;

/// How much PP Chain Power costs to use
const int METAPSIONIC_CHAIN_COST    = 6;
/// How much PP Empower Power costs to use
const int METAPSIONIC_EMPOWER_COST  = 2;
/// How much PP Extend Power costs to use
const int METAPSIONIC_EXTEND_COST   = 2;
/// How much PP Maximize Power costs to use
const int METAPSIONIC_MAXIMIZE_COST = 4;
/// How much PP Split Psionic Ray costs to use
const int METAPSIONIC_SPLIT_COST    = 2;
/// How much PP Twin Power costs to use
const int METAPSIONIC_TWIN_COST     = 6;
/// How much PP Widen Power costs to use
const int METAPSIONIC_WIDEN_COST    = 4;
/// How much PP Quicken Power costs to use
const int METAPSIONIC_QUICKEN_COST  = 6;

/// Internal constant. Value is equal to the lowest metapsionic constant. Used when looping over metapsionic flag variables
const int METAPSIONIC_MIN           = 0x2;
/// Internal constant. Value is equal to the highest metapsionic constant. Used when looping over metapsionic flag variables
const int METAPSIONIC_MAX           = 0x100;

/// Chain Power variable name
const string METAPSIONIC_CHAIN_VAR     = "PRC_PsiMeta_Chain";
/// Empower Power variable name
const string METAPSIONIC_EMPOWER_VAR   = "METAPSI_EMPOWER";
/// Extend Power variable name
const string METAPSIONIC_EXTEND_VAR    = "METAPSI_EXTEND";
/// Maximize Power variable name
const string METAPSIONIC_MAXIMIZE_VAR  = "METAPSI_MAXIMIZE";
/// Split Psionic Ray variable name
const string METAPSIONIC_SPLIT_VAR     = "PRC_PsiMeta_Split";
/// Twin Power variable name
const string METAPSIONIC_TWIN_VAR      = "METAPSI_TWIN";
/// Widen Power variable name
const string METAPSIONIC_WIDEN_VAR     = "PRC_PsiMeta_Widen";
/// Quicken Power variable name
const string METAPSIONIC_QUICKEN_VAR   = "PRC_PsiMeta_Quicken";
/// Quicken Power variable name
const string METAPSIONIC_AUGMENT_VAR   = "METAPSI_AUGMENT";


//////////////////////////////////////////////////
/*             Internal functions               */
//////////////////////////////////////////////////

/** Internal function.
 * @param nCost     The base cost of the metapsionic power to calculate the actual cost for
 * @param nIMPsiRed The amount the PP cost might be reduced by due to Improved Metapsionics feats
 * @param bUseSum   Whether to account for Improved Metapsionics here or not
 * @return          Either nCost or the greater of nCost - nIMPsiRed and 1
 */
int _GetMetaPsiPPCost(int nCost, int nIMPsiRed, int bUseSum)
{
    return nCost <= 2 ? // Metapsionic powers costing 2 or less are not affected by Improved Metapsionics
            nCost :
             bUseSum ? nCost :
             // When calculating Improved Metapsionics separately, it cannot make the cost of a single metapsionic use go below 1
             max(nCost - nIMPsiRed, 1);
}


/**
 * A structure that contains common data used during power manifestation.
 */
struct manifestation{
    /* Generic stuff */
    /// The creature manifesting the power
    object oManifester;
    /// Whether the manifestation is successfull or not
    int bCanManifest;
    /// How much Power Points the manifestation costs
    int nPPCost;
    /// How many psionic focus uses the manifester would have remaining at a particular point in the manifestation
    int nPsiFocUsesRemain;
    /// The creature's manifester level in regards to this power
    int nManifesterLevel;
    /// The power's spell ID
    int nSpellID;

    /* Metapsionics */
    /// Whether Chain Power was used with this manifestation
    int bChain;
    /// Whether Empower Power was used with this manifestation
    int bEmpower;
    /// Whether Extend Power was used with this manifestation
    int bExtend;
    /// Whether Maximize Power was used with this manifestation
    int bMaximize;
    /// Whether Split Psionic Ray was used with this manifestation
    int bSplit;
    /// Whether Twin Power was used with this manifestation
    int bTwin;
    /// Whether Widen Power was used with this manifestation
    int bWiden;
    /// Whether Quicken Power was used with this manifestation
    int bQuicken;
    /// Whether this manifestation is augmented
    int bAugment;
};

//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////
struct manifestation EvaluateMetapsionicsNew(struct manifestation manif, int nMetaPsiFlags)
{
    int nMetaPsiPP = 0;
    int bUseSum = 0;
	int nImpMetapsiReduction = 0; 
	
    /* Calculate the added cost from metapsionics and set the use markers for the powers used */
	if((nMetaPsiFlags & METAPSIONIC_AUGMENT) &&
        GetLocalInt(manif.oManifester, METAPSIONIC_AUGMENT_VAR))
    {
        nMetaPsiPP = max(1, manif.nPPCost/2); //forces cost to be at least 1
        manif.bAugment = TRUE;
    }
    if((nMetaPsiFlags & METAPSIONIC_EMPOWER) &&
        GetLocalInt(manif.oManifester, METAPSIONIC_EMPOWER_VAR))
    {
        nMetaPsiPP += _GetMetaPsiPPCost(METAPSIONIC_EMPOWER_COST, nImpMetapsiReduction, bUseSum);
        manif.bEmpower = TRUE;
    }
    if((nMetaPsiFlags & METAPSIONIC_EXTEND)  &&
       GetLocalInt(manif.oManifester, METAPSIONIC_EXTEND_VAR))
    {
        nMetaPsiPP += _GetMetaPsiPPCost(METAPSIONIC_EXTEND_COST, nImpMetapsiReduction, bUseSum);
        manif.bExtend = TRUE;
    }
    if((nMetaPsiFlags & METAPSIONIC_MAXIMIZE) &&
       GetLocalInt(manif.oManifester, METAPSIONIC_MAXIMIZE_VAR))
    {
        nMetaPsiPP += _GetMetaPsiPPCost(METAPSIONIC_MAXIMIZE_COST, nImpMetapsiReduction, bUseSum);
        manif.bMaximize = TRUE;
    }
    if((nMetaPsiFlags & METAPSIONIC_TWIN)      &&
       GetLocalInt(manif.oManifester, METAPSIONIC_TWIN_VAR))
    {
        nMetaPsiPP += _GetMetaPsiPPCost(METAPSIONIC_TWIN_COST, nImpMetapsiReduction, bUseSum);
        manif.bTwin = TRUE;
    }

    // Add in the cost of the metapsionics uses
    manif.nPPCost += nMetaPsiPP;

    return manif;
}