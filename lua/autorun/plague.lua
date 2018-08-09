
if SERVER then
	include("plague/settings.lua")
	include("plague/sv_init.lua")
else
	include("plague/cl_init.lua")
end


