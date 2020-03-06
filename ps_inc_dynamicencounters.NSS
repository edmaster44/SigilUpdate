//*******************************************
//ps_inc_dynamicencounters
//Mimi Fearthegn
//Started 3-5-20
//*******************************************
//Include script for creating creatures
//suitable for encounters (fighting or flavor)
//of any level
//*******************************************
#include "ps_inc_advscript"

//creates a creature/npc at the given waypoint
//of decent challenge to nLevel
//and of the given class type
//can be set to non-hostile with isHostile = FALSE
//(if there is no blueprint of the given class type, defaults to fighter)
object CreateScaledCreatureofClass(object oWP, int nLevel, int classType, int isHostile = TRUE);