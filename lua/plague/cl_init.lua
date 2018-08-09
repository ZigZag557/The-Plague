include("settings.lua")


local PlagueMainFontData = 
{
	font = "Elephant",
	size = 55
}

local PlagueDoctorFontData =
{
	font = "Elephant",
	size = 50
}


local LocalVariables = 
{
	AlertCame = false,
	Infected = false
}



include("settings.lua")

surface.CreateFont("PlagueMainFont",PlagueMainFontData)
surface.CreateFont("PlagueDoctorFont",PlagueDoctorFontData)


local function DrawCS()

	local ply = LocalPlayer()
	local h = ScrH()
	local w = ScrW()

	if LocalVariables.AlertCame then

			draw.SimpleText("The Plague has began to spread!","PlagueMainFont", w/2, h/2 - h/3, Color(0,100,0) , 1, 3)
	end

	if LocalVariables.Infected then
		draw.SimpleText("You are infected!","PlagueMainFont", w/2, h/12, Color(255,255,255) , 1, 3)
		draw.SimpleText("Contain yourself or spread it to others!","PlagueMainFont", w/2, h/8, Color(255,255,255), 1, 3)
		draw.RoundedBox(0,0,0,w,h,Color(0,100,0,150))
	end

	if LocalVariables.EndPlague then
		draw.SimpleText("The Plague is no more!","PlagueMainFont", w/2, h/2 - h/3, Color(190,255,0) , 1, 3)
	end

end

local function AlertSiren()
	surface.PlaySound(thePlague.Settings.sirenPath)
end


hook.Add("HUDPaint","PlagueEffectsDraw",DrawCS)

net.Receive("NotifyPlagueStart",

function() 
LocalVariables.AlertCame = true 
AlertSiren()
	timer.Simple(3, function()
		LocalVariables.AlertCame = false 
	end )

end)

net.Receive("NotifyInfection", function() LocalVariables.Infected = true end)
net.Receive("InfectionGone",function() LocalVariables.Infected = false end)

net.Receive("PlagueEnded", function() LocalVariables.EndPlague = true
timer.Simple(3, function() LocalVariables.EndPlague = false  end)
AlertSiren() end)
