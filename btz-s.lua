-----------------------------------------------------------------
-- Configuratie
local valoareamodificatacash = 25000000 	-- Daca valoarea de bani cash pe care o are playerul este mai mare decat asta, ii va da Kick/Ban
local valoareamodificatabanca = 100000000 	-- Daca valoarea de bani din banca pe care o are playerul este mai mare decat asta, ii va da Kick/Ban
local VerificaBanca = false			-- Variabila ce va verifica banca
local KickSauBan = "ban" 		-- Alege ce pedeapsa va primi playerul ce abuzeaza. Ban sau Kick?
local folosesteDiscord = false 		-- Foloseste Discord Webhook pentru a tine evidenta. Modifica in linia 40 si linia 47 Linkul
-----------------------------------------------------------------

local Proxy = module("vrp", "lib/Proxy")
local Tunnel =  module("vrp", "lib/Tunnel")

btz = Proxy.getInterface("btz")
Tunnel.bindInterface("btz_acbanca",serverside)

local valoarevechecash = {}
local valoarevechebanca = {}
local cash = {}
local banca = {}
local AccesGiveMoney = false

serverside = {}

function serverside.VerificaBaniiJucatorului(userid)
	local user_id = userid
	cash[user_id] = btz.getMoney({user_id})
	banca[user_id] = btz.getBankMoney({user_id})
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
							btz.getUserIdentity({user_id, function(identity)
								local mesaj = "ID: " ..user_id.. " a primit mai mult decat "..valoareamodificatacash.." cash in mai putin de 5 secunde. Valoarea veche: $" ..valoarevechecash[user_id].. " Valoarea noua: $" ..cash[user_id].. " Diferenta: $" ..diferenta.. " si a primit automat ban. @everyone"
								PerformHttpRequest('Link-Webhook', function(err, text, headers) end, 'POST', json.encode({username = identity.firstname.. " " ..identity.name , content = mesaj}), { ['Content-Type'] = 'application/json' })
								btz.ban({source,"ID: " ..user_id.. " a primit ban pentru cheating. *bani*. Diferenta: $" ..diferenta})
							end})
						end
						if KickSauBan == "kick" then
							btz.getUserIdentity({user_id, function(identity)
								local mesaj = "ID: " ..user_id.. " A primit mai mult decat "..valoareamodificatacash.." cash in mai putin de 5 secunde. Valoarea veche: $" ..valoarevechecash[user_id].. " Valoarea noua: $" ..cash[user_id].. " Diferenta: $" ..diferenta.. " si a primit automat kick. @everyone"
								PerformHttpRequest('Link-Webhook', function(err, text, headers) end, 'POST', json.encode({username = identity.firstname.. " " ..identity.name , content = mesaj}), { ['Content-Type'] = 'application/json' })
								btz.kick({source,"ID: " ..user_id.. " a primit kick pentru cheating. *bani*. Diferenta: $" ..diferenta})
							end})
						end
					elseif folosesteDiscord == false then
						if KickSauBan == "ban" then
							btz.ban({source,"ID: " ..user_id.. " a primit ban pentru cheating. *bani*. Diferenta: $" ..diferenta})
						elseif KickSauBan == "kick" then
							btz.kick({source,"ID: " ..user_id.. " a primit kick pentru cheating. *bani*. Diferenta: $" ..diferenta})
						end
					end
				end
			end	
			valoarevechecash[user_id] = cash[user_id]
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
						print("ID: " ..user_id.. " A primit mai mult decat "..valoareamodificatabanca.." in mai putin de 5 secunde. Old Bank: " ..valoarevechebanca.. " New Bank: " ..banca.. " Diferenta: $" ..diferenta)
						if folosesteDiscord == true then
							if KickSauBan == "ban" then
								btz.getUserIdentity({user_id, function(identity)
									local mesaj = "ID: " ..user_id.. " A primit mai mult decat "..valoareamodificatabanca.." in Bank Money in mai putin de 5 secunde. Valoarea veche: $" ..valoarevechebanca[user_id].. " New Bank: $" ..banca[user_id].. " Diferenta: $" ..diferenta.. " and was automatically banned. @everyone"
									PerformHttpRequest('Link-Webhook', function(err, text, headers) end, 'POST', json.encode({username = identity.firstname.. " " ..identity.name , content = mesaj}), { ['Content-Type'] = 'application/json' })
									btz.ban({source,"ID: " ..user_id.. " a primit ban pentru cheating. *bani*. Diferenta: $" ..diferenta})
								end})
							end
							if KickSauBan == "kick" then
								btz.getUserIdentity({user_id, function(identity)
									local mesaj = "ID: " ..user_id.. " A primit mai mult decat "..valoareamodificatabanca.." in Bank Money in mai putin de 5 secunde. Valoarea veche: $" ..valoarevechebanca[user_id].. " New Bank: $" ..banca[user_id].. " Diferenta: $" ..diferenta.. " and was automatically kicked. @everyone"
									PerformHttpRequest('Link-Webhook', function(err, text, headers) end, 'POST', json.encode({username = identity.firstname.. " " ..identity.name , content = mesaj}), { ['Content-Type'] = 'application/json' })
									btz.kick({source,"UserID: " ..user_id.. " a primit kick pentru cheating. *bani*. Diferenta: $" ..diferenta})
								end})
							end
						elseif folosesteDiscord == false then
							if KickSauBan == "ban" then
								btz.ban({source,"ID: " ..user_id.. " a primit ban pentru cheating. *bani*. Diferenta: $" ..diferenta})
							elseif KickSauBan == "kick" then
								btz.kick({source,"ID: " ..user_id.. " a primit kick pentru cheating. *bani*. Diferenta: $" ..diferenta})
							end
						end
					end
				end	
				valoarevechebanca[user_id] = banca[user_id]
			end
		end
	end
end

RegisterNetEvent("verificadacaelegit")
AddEventHandler("verificadacaelegit", function()
	local source = source
	if source then
		local user_id = btz.getUserId({source})
		AccesGiveMoney = btz.hasPermission({user_id,"player.givemoney"})
		serverside.VerificaBaniiJucatorului(user_id)
	end
end)