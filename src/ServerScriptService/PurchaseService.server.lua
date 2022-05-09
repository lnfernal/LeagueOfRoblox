local market = game:GetService("MarketplaceService")
local purchases = game:GetService("DataStoreService"):GetDataStore("Purchases")

market.ProcessReceipt = function(rec)
	print(rec.PlayerId,"bought",rec.ProductId)
	
	local success, message = pcall(function()
		purchases:SetAsync(rec.PlayerId.."has"..rec.ProductId, true)
	end)
	
	if(success) then
		return Enum.ProductPurchaseDecision.PurchaseGranted
	else
		return Enum.ProductPurchaseDecision.NotProcessedYet;
	end
end