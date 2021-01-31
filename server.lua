local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
heyy = {}
Tunnel.bindInterface("emp_salvavidas",heyy)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
function heyy.checkPayment()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local randmoney = math.random(cfg.minMoney,cfg.maxMoney)
        vRP.giveMoney(user_id,parseInt(randmoney))
        
		TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..parseInt(randmoney).." dólares</b>.")
    end
end