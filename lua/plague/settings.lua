thePlague = {}
thePlague.sickPeople = {}
thePlague.Settings = {}
thePlague.doctors = {}



thePlague.Settings.killTimer = 45 -- Time until the plague kills (separate for every player).
thePlague.Settings.spreadRange = 300 -- The range virus spreads. If the number is closer to zero, the sick person must get closer to spread.
thePlague.Settings.spreadTick = 1 -- How often will the virus spread in seconds?

thePlague.Settings.infectionSlow = 100 -- How slower will the infected target be? You can make it 0 to don't change player speed.
thePlague.Settings.infectionSlowRun = 150 -- Same as above, changes the run speed.

thePlague.Settings.isSilent = false -- Turn it on if you didn't like the alarm sound.

thePlague.Settings.sirenPath = "theplague/alarm.wav" -- Change it if you would like to have another alarm sound.


