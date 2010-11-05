
#
# Ce fichier, donné ici en exemple et provenant d'un autre avion, contient du code 
# en Nasal que vous écrirez en fonction de vos besoin.
# Ce fichier doit être référencé depuis votre fichier <avion>-set.xml dans un bloc
# de type <nasal>...</nasal> afin qu'il puisse être pris en compte.
# Lors du chargement de l'avion, regardez la console, c'est à cet endroit que vous
# verrez des éventuelles erreurs de votre script, ce qui est bien pratique pour 
# vous aider à le debugger.
#

var Mig31throttle0 = props.globals.getNode("/controls/engines/engine[0]/throttle");
var Mig31throttle1 = props.globals.getNode("/controls/engines/engine[1]/throttle");
var Mig31reheat0 = props.globals.getNode("/controls/engines/engine[0]/reheat");
var Mig31reheat1 = props.globals.getNode("/controls/engines/engine[1]/reheat");

var MPthrottle0 = props.globals.getNode("/sim/multiplay/generic/float[0]");
var MPthrottle1 = props.globals.getNode("/sim/multiplay/generic/float[1]");
var MPreheat0 = props.globals.getNode("/sim/multiplay/generic/float[2]");
var MPreheat1 = props.globals.getNode("/sim/multiplay/generic/float[3]");


var ManageThrottle0 = func 
{
	if (Mig31throttle0.getValue() >= 0.98) 
	{
		Mig31reheat0.setValue(1);
	}
	elsif (Mig31throttle0.getValue() <= 0.95)
	{
		Mig31reheat0.setValue(0);
	}
	# Pass throttle value over MP.
	MPthrottle0.setValue(Mig31throttle0.getValue());
}

var ManageThrottle1 = func 
{
	if (Mig31throttle1.getValue() >= 0.98) 
	{
		Mig31reheat1.setValue(1);
	}
	elsif (Mig31throttle1.getValue() <= 0.95)
	{
		Mig31reheat1.setValue(0);
	}
	# Pass throttle value over MP.
	MPthrottle1.setValue(Mig31throttle1.getValue());
}

setlistener("/controls/engines/engine[0]/throttle", ManageThrottle0, 1);
setlistener(Mig31throttle1, ManageThrottle1, 1);


#
# Pass reheat values over MP when a change triggers.
#
setlistener(Mig31reheat0, func {
	MPreheat0.setValue(Mig31reheat0.getValue());
});

setlistener(Mig31reheat1, func {
	MPreheat1.setValue(Mig31reheat1.getValue());
});


#
# Make tail rudder vibrate if mach number is greater than 2.90.
# Vibration level increases as the mach number gets higher.
#
var coef = 1;
var vibration_level = func
{
	var mach = getprop("/velocities/mach");
	if(mach >= 2.95)
	{
		var aleat = 0.55 * rand();
		var offset = coef * (mach - 2.90) * aleat;
		setprop("/controls/flight/elevator-trim", offset);
		coef = -coef;
	}
	settimer(vibration_level, 0.080);
}

settimer(vibration_level, 0.125);

#
# Light management.
#
var strobe = aircraft.light.new("/sim/model/lights/strobe1", [0.10, 0.90]);
strobe.interval = 0;
strobe.switch(1);


#
# End of file.
#

