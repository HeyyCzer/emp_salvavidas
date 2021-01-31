local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
heyy = Tunnel.getInterface("emp_salvavidas")

local blips = false
local servico = false
local selecionado = 0

local startCoords = cfg.startCoords

local nowLocation = {}

-- Iniciar trabalho/rota
Citizen.CreateThread(function()
	while true do
		local sleepThread = 5
		if not servico then
			local v = startCoords
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local distance = GetDistanceBetweenCoords(v.x,v.y,v.z,x,y,z,true)
			if distance <= 6 then
				DrawMarker(21,v.x,v.y,v.z-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,255,0,0,20,0,0,0,1)
				if distance <= 1.2 then
					drawTxt("PRESSIONE ~b~E~w~ PARA TRABALHAR COMO ~r~SALVA-VIDAS",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) then
						servico = true
						selecionado = 1
						CriandoBlip(cfg.route,selecionado)
						TriggerEvent("Notify","sucesso","Você entrou em serviço.")
						nowLocation = cfg.route[selecionado]
					end
				end
			elseif distance > 12 then
				sleepThread = 2000
			end
		else
			sleepThread = 3000
		end
		Citizen.Wait(sleepThread)
	end
end)

-- Pegar pontos
Citizen.CreateThread(function()
	while true do
		local sleepThread = 5
		if servico then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local distance = GetDistanceBetweenCoords(nowLocation.x,nowLocation.y,nowLocation.z,x,y,z,true)

			if distance <= 40.0 then
				DrawMarker(21,nowLocation.x,nowLocation.y,nowLocation.z+0.20,0,0,0,0,180.0,130.0,2.0,2.0,1.0,255,0,0,20,1,0,0,1)
				if distance <= 10.5 then
					if IsPedInAnyVehicle(ped, false) and IsVehicleModel(GetVehiclePedIsUsing(PlayerPedId()), GetHashKey(cfg.necessaryVehicle)) then
						RemoveBlip(blips)
						if selecionado == #cfg.route then
							selecionado = 1
						else
							selecionado = selecionado + 1
						end
						nowLocation = cfg.route[selecionado]
						heyy.checkPayment()
						CriandoBlip(cfg.route,selecionado)
					end
				end
			else
				sleepThread = 1500
			end
		else
			sleepThread = 3000
		end
		Citizen.Wait(sleepThread)
	end
end)

-- Finalizar serviço
Citizen.CreateThread(function()
	while true do
		local sleepThread = 5
		if servico then
			if IsControlJustPressed(0,168) then
				servico = false
				RemoveBlip(blips)
				TriggerEvent("Notify","aviso","Você saiu de serviço.")
			end
		else
			sleepThread = 3000
		end
		Citizen.Wait(sleepThread)
	end
end)


-- Funções utilitárias
function CriandoBlip(route,selected)
	blips = AddBlipForCoord(route[selected].x,route[selected].y,route[selected].z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	-- SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Rota de Serviço")
	EndTextCommandSetBlipName(blips)
end
function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end