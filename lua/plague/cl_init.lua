include("settings.lua")


surface.CreateFont( "Plague", {
	font = "arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 50,
} )


surface.CreateFont( "PlagueSmall", {
	font = "arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 25,
})




local LocalVariables = 
{
	AlertCame = false,
	Infected = false
}




local function DrawCS()

	local ply = LocalPlayer()
	local h = ScrH()
	local w = ScrW()
	local Warn = Material( "icon16/error.png" )
	local Cancel = Material( "icon16/cancel.png" )
	local Exclamation = Material( "icon16/exclamation.png" )

	if LocalVariables.AlertCame then

	draw.RoundedBox(7,w /2  - 405,h /2 - 450 ,810 , 150,Color(13,96,5,240)) -- Hud Background
	draw.RoundedBox(0,w /2 - 393 ,h /2 - 440 ,785 , 129,Color(40,40,40,245)) -- Inside
	draw.DrawText("The Plague Is Spreading", "Plague",w /2 - 242,h - 942,Color(255,255,255)) -- Plague Spreading Text

	surface.SetMaterial( Warn )
		surface.SetDrawColor( 255, 255, 255 )
		surface.DrawTexturedRect( w /2 - 340,h - 950, 60,60)

	surface.SetMaterial( Warn )
		surface.SetDrawColor( 255, 255, 255 )
		surface.DrawTexturedRect( w /2 + 285,h - 950, 60,60)

	end

	if LocalVariables.Infected then

	draw.RoundedBox(0,0,0,w,h,Color(0,255,0,20))
	draw.RoundedBox(7,w /2  - 405,h /2 - 450 ,810 , 150,Color(13,96,5,240)) -- Hud Background
	draw.RoundedBox(0,w /2 - 393 ,h /2 - 440 ,785 , 129,Color(40,40,40,245)) -- Inside
	draw.DrawText("You Are Infected!", "Plague",w /2 - 182,h - 952,Color(255,255,255)) -- Plague Spreading Text
	draw.DrawText("  Contain yourself or spread it to others.", "PlagueSmall",w /2 - 203,h - 905,Color(255,255,255)) -- Plague Spreading Text

	surface.SetMaterial( Warn )
		surface.SetDrawColor( 255, 255, 255 )
		surface.DrawTexturedRect( w /2 - 340,h - 950, 60,60)

	surface.SetMaterial( Warn )
    	surface.SetDrawColor( 255, 255, 255 )
    	surface.DrawTexturedRect( w /2 + 285,h - 950, 60,60)

	end

	if LocalVariables.EndPlague then

	draw.RoundedBox(7,w /2  - 405,h /2 - 450 ,810 , 150,Color(13,96,5,240)) -- Hud Background
	draw.RoundedBox(0,w /2 - 393 ,h /2 - 440 ,785 , 129,Color(40,40,40,245)) -- Inside
	draw.DrawText("The Plague Is No More!", "Plague",w /2 - 242,h - 942,Color(255,255,255)) -- Plague Spreading Text

	surface.SetMaterial( Warn )
		surface.SetDrawColor( 255, 255, 255 )
		surface.DrawTexturedRect( w /2 - 340,h - 950, 60,60)

	surface.SetMaterial( Warn )
		surface.SetDrawColor( 255, 255, 255 )
		surface.DrawTexturedRect( w /2 + 285,h - 950, 60,60)

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
