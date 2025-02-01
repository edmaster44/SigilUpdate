#include "ff_safevar"

const int STRONG_EVIL = 0;
const int MILD_EVIL = 1;
const int MILD_NEUTRAL = 2;
const int STRONG_NEUTRAL = 3;
const int MILD_GOOD = 4;
const int STRONG_GOOD = 5;
const int STRONG_CHAOS = 0;
const int MILD_CHAOS = 1;
const int MILD_LAW = 4;
const int STRONG_LAW = 5;

const string YSGARD = "Ysgard";
const string LIMBO = "Limbo";
const string PANDEMONIUM = "Pandemonium";
const string ABYSS = "Abyss";
const string CARCERI = "Carceri";
const string HADES = "Hades";
const string GEHENNA = "Gehenna";
const string BAATOR = "Baator";
const string ACHERON = "Acheron";
const string MECHANUS = "Mechanus";
const string ARCADIA = "Arcadia";
const string CELESTIA = "Celestia";
const string BYTOPIA = "Bytopia";
const string ELYSIUM = "Elysium";
const string BEASTLANDS = "Beastlands";
const string ARBOREA = "Arborea";
const string ASTRAL = "Astral";
const string CITYOFBRASS = "City of Brass";
const string ELEMENTAL_AIR = "Elemental Plane of Air";
const string ELEMENTAL_FIRE = "Elemental Plane of Fire";
const string ELEMENTAL_WATER = "Elemental Plane of Water";
const string ELEMENTAL_EARTH = "Elemental Plane of Earth";
const string ELEMENTAL_MAGMA = "Para-Elemental Plane of Magma";
const string ELEMENTAL_ICE = "Para-Elemental Plane of Ice";
const string ELEMENTAL_OOZE = "Para-Elemental Plane of Ooze";

int GetPlanarAlignmentLawChaos(string plane) {
	if (plane == YSGARD) 
		return MILD_CHAOS;
	if (plane == LIMBO) 
		return STRONG_CHAOS;
	if (plane == PANDEMONIUM) 
		return MILD_CHAOS;
	if (plane == ABYSS) 
		return MILD_CHAOS;
	if (plane == BAATOR) 
		return MILD_LAW;
	if (plane == ACHERON) 
		return MILD_LAW;
	if (plane == MECHANUS) 
		return STRONG_LAW;
	if (plane == ARCADIA) 
		return MILD_LAW;
	if (plane == CELESTIA) 
		return MILD_LAW;
	if (plane == ARBOREA) 
		return MILD_CHAOS;
	return MILD_NEUTRAL;
}

int GetPlanarAlignmentGoodEvil(string plane) {
	if (plane == ABYSS) 
		return MILD_EVIL;
	if (plane == CARCERI) 
		return MILD_EVIL;
	if (plane == HADES) 
		return STRONG_EVIL;
	if (plane == GEHENNA) 
		return MILD_EVIL;
	if (plane == BAATOR) 
		return MILD_EVIL;
	if (plane == CITYOFBRASS) 
		return MILD_EVIL;
	if (plane == CELESTIA) 
		return MILD_GOOD;
	if (plane == BYTOPIA) 
		return MILD_GOOD;
	if (plane == ELYSIUM) 
		return STRONG_GOOD;
	if (plane == BEASTLANDS) 
		return MILD_GOOD;
	if (plane == ARBOREA) 
		return MILD_GOOD;
	return MILD_NEUTRAL;
}

//This returns the penalty which the character would suffer if
//we were doing penalties. Since we're not doing penalties, this
//mostly judges your level of discomfort = 0, -2, or -4.
int GetAlignmentDifference(object oPC, string plane) {
	int goodEvil = GetAlignmentGoodEvil(oPC);
	int lawChaos = GetAlignmentLawChaos(oPC);
	int planeGoodEvil = GetPlanarAlignmentGoodEvil(plane);
	int planeLawChaos = GetPlanarAlignmentLawChaos(plane);
	int totalNegative = 0;
	
	//Good/Evil
	if (planeGoodEvil == STRONG_GOOD &&
		goodEvil != ALIGNMENT_GOOD)
		totalNegative -= 2;
	if (planeGoodEvil == MILD_GOOD &&
		goodEvil == ALIGNMENT_EVIL)
		totalNegative -= 2;
	if (planeGoodEvil == STRONG_EVIL &&
		goodEvil != ALIGNMENT_EVIL)
		totalNegative -= 2;
	if (planeGoodEvil == MILD_EVIL &&
		goodEvil == ALIGNMENT_GOOD)
		totalNegative -= 2;
		
	//Law/Chaos
	if (planeLawChaos == STRONG_CHAOS &&
		lawChaos != ALIGNMENT_CHAOTIC)
		totalNegative -= 2;
	if (planeLawChaos == MILD_CHAOS &&
		lawChaos == ALIGNMENT_LAWFUL)
		totalNegative -= 2;
	if (planeLawChaos == STRONG_LAW &&
		lawChaos != ALIGNMENT_LAWFUL)
		totalNegative -= 2;
	if (planeLawChaos == MILD_LAW &&
		lawChaos == ALIGNMENT_CHAOTIC)
		totalNegative -= 2;
		
	return totalNegative;
}

string GetPlanarInfo(string plane) {
	int planeGoodEvil = GetPlanarAlignmentGoodEvil(plane);
	int planeLawChaos = GetPlanarAlignmentLawChaos(plane);
	int num = 0;
	string sResult = plane;
	
	//Good/Evil
	if (planeGoodEvil == MILD_GOOD) {
		sResult += " - Good-Aligned";
		num += 1;
	}
	if (planeGoodEvil == STRONG_GOOD) {
		sResult += " - Strongly Good-Aligned";
		num += 1;
	}
	if (planeGoodEvil == MILD_EVIL) {
		sResult += " - Evil-Aligned";
		num += 1;
	}
	if (planeGoodEvil == STRONG_EVIL) {
		sResult += " - Strongly Evil-Aligned";
		num += 1;
	}
	//commas!
	if (num > 0)
		sResult += ", ";
	else
		sResult += " - ";
	//Law/Chaos
	if (planeLawChaos == MILD_CHAOS) {
		sResult += "Chaos-Aligned";
		num += 1;
	}
	if (planeLawChaos == STRONG_CHAOS) {
		sResult += "Strongly Chaos-Aligned";
		num += 1;
	}
	if (planeLawChaos == MILD_LAW) {
		sResult += "Law-Aligned";
		num += 1;
	}
	if (planeLawChaos == STRONG_LAW) {
		sResult += "Strongly Law-Aligned";
		num += 1;
	}
	//Neutral fill-in
	if (num == 0)
		sResult += "Neutral-Aligned";
		
	sResult += "\n";
	return sResult;
}

string GetAlignmentEffect(int negative) {
	int rand = d100();
	if (negative >= 0)
		return "";
	else if (negative >= -2) {
		if (rand <= 20)
			return "The light is off. Too bright? Too dark? Its difficult to focus.";
		else if (rand <= 40)
			return "You become aware of a dull throbbing headache.";
		else if (rand <= 60)
			return "The air in this place is oppressive, making it difficult to breathe.";
		else if (rand <= 80)
			return "You become aware of a faint ringing noise - a persistent hum that will not go away.";
		else 
			return "You feel inexplicably anxious, as though there's something you've forgotten. Something is wrong. Why are you here?";
	}
	else if (negative >= -4) {
		if (rand <= 33)
			return "The air in this place is oppressive, stuffy. You have difficulty breathing; there's a heaviness in your chest, as though the plane itself is trying to crush you. The more time you spend here, the more you feel that your lungs are about the collapse.";
		else if (rand <= 58)
			return "As you enter this area, you suddenly feel a hostile presence: watching, waiting, ready to pounce on you. Is something following you? What was that noise? You cannot help but feel a twinge of fear and panic.";
		else if (rand <= 83)
			return "You become aware of a ringing in your ears - a persistent hum that will not go away. A wave of dizziness washes over you, and you feel the ground rolling as though you were at sea. The sensation passes, leaving you with a dull, throbbing headache.";
		else
			return "As you continue forward, you suddenly feel tired, as though your energy is being drained away with every step. Your limbs feel heavy. Even the air in this place weighs you down.";
	}
	return "";
}

void SetAreaValue(object oPC, string plane) {
	object oArea = GetArea(oPC);
	PS_SetLocalString(oArea, "Plane", plane);
}

string GetAreaValue(object oPC) {
	object oArea = GetArea(oPC);
 	return	PS_GetLocalString(oArea, "Plane");
}

void ApplyPlanarAlignmentEffects(object oPC, string plane, string description) {

	SetAreaValue(oPC, plane);
		
	int diff = GetAlignmentDifference(oPC, plane);
	string planarInfo = "<b>"+GetPlanarInfo(plane)+"</b>";
	string sAlign = "<color=red><i>"+GetAlignmentEffect(diff)+"</i></color>";
	description = "<i>"+description+"</i>";
	string finalMessage = "";
	if (PS_GetLocalInt(oPC, plane) == 0)
		finalMessage = planarInfo+sAlign+"\n\n"+description;
	else if (description != "")
		finalMessage = planarInfo+description;
		
	SendMessageToPC(oPC, finalMessage);
	PS_SetLocalInt(oPC, plane, 1);
}