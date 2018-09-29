struct TimeFields {
	int Year;
	int Month;
	int Day;
	int Weekday; // [0, 6] -> [Sun, Sat]
	int Hour;
	int Minute;
	int Second;
};

struct TimeFields TimeToTimeFields(int Time)
{
	int ed;
	int z;
	int era;
	int doe;
	int yoe;
	int y;
	int doy;
	int mp;
	int d;
	int m;
	struct TimeFields Tf;

	//
	// This implements the civil_from_day algorithm from this page:
	//
	// http://howardhinnant.github.io/date_algorithms.html
	//

	Tf.Hour = (Time / (60 * 60)) % 24;
	Tf.Minute = (Time / 60) % 60;
	Tf.Second = Time % 60;

	ed = (Time / (60 * 60 * 24));
	z = ed + 719468;
	era = (z >= 0 ? z : z - 146096) / 146097;
	doe = z - era * 146097;                                 // [0, 146096]
	yoe = (doe - doe/1460 + doe/36524 - doe/146096) / 365;  // [0, 399]
	y = yoe + era * 400;
	doy = doe - (365*yoe + yoe/4 - yoe/100);                // [0, 365]
	mp = (5*doy + 2)/153;                                   // [0, 11]
	d = doy - (153*mp+2)/5 + 1;                             // [1, 31]
	m = mp + (mp < 10 ? 3 : -9);                            // [1, 12]

	Tf.Year = y + (m <= 2);
	Tf.Month = m;
	Tf.Day = d;

	//
	// This implements the weekday_from_days algorithm.
	//

	Tf.Weekday = (ed >= -4 ? (ed + 4) % 7 : (ed + 5) % 7 + 6);

	return Tf;
}

void main(int Time)
{
	struct TimeFields Tf;

	PrintInteger(Time);

	Tf = TimeToTimeFields(Time);

	PrintInteger(Tf.Year);
	PrintInteger(Tf.Month);
	PrintInteger(Tf.Day);
	PrintInteger(Tf.Weekday);
	PrintInteger(Tf.Hour);
	PrintInteger(Tf.Minute);
	PrintInteger(Tf.Second);
}
