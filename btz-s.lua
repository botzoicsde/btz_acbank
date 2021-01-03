serverside = {}

local Proxy = module("vrp", "lib/Proxy")
local Tunnel =  module("vrp", "lib/Tunnel")

vRP = Proxy.getInterface("vRP")
Tunnel.bindInterface("btz_acbanca",serverside)

-----------------------------------------------------------------
-- Configuratie
local valoareamodificatacash = 700000 	-- Daca valoarea de bani cash pe care o are playerul este mai mare decat asta, ii va da Kick/Ban
local valoareamodificatabanca = 500000 	-- Daca valoarea de bani din banca pe care o are playerul este mai mare decat asta, ii va da Kick/Ban
local VerificaBanca = false			-- Variabila ce va verifica banca
local KickSauBan = "ban" 		-- Alege ce pedeapsa va primi playerul ce abuzeaza. Ban sau Kick?
local folosesteDiscord = true 		-- Foloseste Discord Webhook pentru a tine evidenta. Modifica in linia 40 si linia 47 Linkul
-----------------------------------------------------------------

local valoarevechecash = {}
local valoarevechebanca = {}
local cash = {}
local banca = {}
local AccesGiveMoney = false

function VerificaBaniiJucatorului(user_id)
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	if user_id ~= nil then
		cash[user_id] = vRP.getMoney({user_id})
		banca[user_id] = vRP.getBankMoney({user_id})
		if valoarevechecash[user_id] == nil then
			valoarevechecash[user_id] = cash[user_id]
		elseif valoarevechecash[user_id] ~= nil then
			if cash[user_id] ~= nil and AccesGiveMoney == false then
				local diferenta = cash[user_id] - valoarevechecash[user_id]
				if valoarevechecash[user_id] ~= banca[user_id] then
					if cash[user_id] > (valoarevechecash[user_id] + valoareamodificatacash) then
						print("ID: " ..user_id.. " a primit mai mult decat "..valoareamodificatacash.." in mai putin de 5 secunde. Valoarea veche: " ..valoarevechecash[user_id].. " Valoarea noua: " ..cash[user_id].. " Diferenta: $" ..diferenta)
						if folosesteDiscord == true then
							if KickSauBan == "ban" then
								vRP.getUserIdentity({user_id, function(identity)
									local mesaj = "ID: " ..user_id.. " a primit mai mult decat "..valoareamodificatacash.." cash in mai putin de 5 secunde. Valoarea veche: $" ..valoarevechecash[user_id].. " Valoarea noua: $" ..cash[user_id].. " Diferenta: $" ..diferenta.. " si a primit automat ban. @everyone"
									PerformHttpRequest('linkwebhook', function(err, text, headers) end, 'POST', json.encode({username = identity.firstname.. " " ..identity.name , content = mesaj}), { ['Content-Type'] = 'application/json' })
									vRP.ban({player,"ID: " ..user_id.. " a primit ban pentru cheating. *bani*. Diferenta: $" ..diferenta})
								end})
							end
							if KickSauBan == "kick" then
								vRP.getUserIdentity({user_id, function(identity)
									local mesaj = "ID: " ..user_id.. " A primit mai mult decat "..valoareamodificatacash.." cash in mai putin de 5 secunde. Valoarea veche: $" ..valoarevechecash[user_id].. " Valoarea noua: $" ..cash[user_id].. " Diferenta: $" ..diferenta.. " si a primit automat kick. @everyone"
									PerformHttpRequest('linkwebhook', function(err, text, headers) end, 'POST', json.encode({username = identity.firstname.. " " ..identity.name , content = mesaj}), { ['Content-Type'] = 'application/json' })
									vRP.kick({player,"ID: " ..user_id.. " a primit kick pentru cheating. *bani*. Diferenta: $" ..diferenta})
								end})
							end
						elseif folosesteDiscord == false then
							if KickSauBan == "ban" then
								vRP.ban({player,"ID: " ..user_id.. ". De ce folosest hack-uri?. *bani*. Diferenta: $" ..diferenta})
							elseif KickSauBan == "kick" then
								vRP.kick({player,"ID: " ..user_id.. ". De ce folosest hack-uri?. *bani*. Diferenta: $" ..diferenta})
							end
						end
					end
				end	
				cash[user_id] = valoarevechecash[user_id]
			end
		end
		if VerificaBanca == true then
			if valoarevechebanca[user_id] == nil then
				valoarevechebanca[user_id] = banca[user_id]
			elseif valoarevechebanca[user_id] ~= nil then
				if banca[user_id] ~= nil and AccesGiveMoney == false then
					local diferenta = banca[user_id] - valoarevechebanca[user_id]
					if valoarevechebanca[user_id] ~= cash[user_id] then
						if banca[user_id] > (valoarevechebanca[user_id] + valoareamodificatabanca) then
							print("ID: " ..user_id.. " A primit mai mult decat "..valoareamodificatabanca.." in mai putin de 5 secunde. Valoare Veche: " ..valoarevechebanca.. " Valoare Noua: " ..banca.. " Diferenta: $" ..diferenta)
							if folosesteDiscord == true then
								if KickSauBan == "ban" then
									vRP.getUserIdentity({user_id, function(identity)
										local mesaj = "ID: " ..user_id.. " A primit mai mult decat "..valoareamodificatabanca.." in Bank Money in mai putin de 5 secunde. Valoarea veche: $" ..valoarevechebanca[user_id].. " Valoare noua: $" ..banca[user_id].. " Diferenta: $" ..diferenta.. " si a primit automat ban. @everyone"
										PerformHttpRequest('linkwebhook', function(err, text, headers) end, 'POST', json.encode({username = identity.firstname.. " " ..identity.name , content = mesaj}), { ['Content-Type'] = 'application/json' })
										vRP.ban({player,"ID: " ..user_id.. ". De ce folosest hack-uri?. *bani*. Diferenta: $" ..diferenta})
									end})
								end
								if KickSauBan == "kick" then
									vRP.getUserIdentity({user_id, function(identity)
										local mesaj = "ID: " ..user_id.. " A primit mai mult decat "..valoareamodificatabanca.." in Bank Money in mai putin de 5 secunde. Valoarea veche: $" ..valoarevechebanca[user_id].. " Valoare noua: $" ..banca[user_id].. " Diferenta: $" ..diferenta.. " si a primit automat kick. @everyone"
										PerformHttpRequest('linkwebhook', function(err, text, headers) end, 'POST', json.encode({username = identity.firstname.. " " ..identity.name , content = mesaj}), { ['Content-Type'] = 'application/json' })
										vRP.kick({player,"UserID: " ..user_id.. ". De ce folosest hack-uri?. *bani*. Diferenta: $" ..diferenta})
									end})
								end
							elseif folosesteDiscord == false then
								if KickSauBan == "ban" then
									vRP.ban({player,"ID: " ..user_id.. ". De ce folosest hack-uri?. *bani*. Diferenta: $" ..diferenta})
								elseif KickSauBan == "kick" then
									vRP.kick({player,"ID: " ..user_id.. ". De ce folosest hack-uri?. *bani*. Diferenta: $" ..diferenta})
								end
							end
						end
					end	
					banca[user_id] = valoarevechebanca[user_id]
				end
			end
		end
	end
end

RegisterNetEvent("verificadacaelegit")
AddEventHandler("verificadacaelegit", function()
	local source = source
	if source then
		local user_id = vRP.getUserId({source})
		AccesGiveMoney = vRP.hasGroup({user_id,"bypassbanca"}) -- se poate adauga si permisiune vRP.hasPermission({user_id,"player.givemoney"})
		VerificaBaniiJucatorului(user_id)
	end
end)
