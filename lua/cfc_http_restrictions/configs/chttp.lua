---@diagnostic disable-next-line: undefined-global
if not util.IsBinaryModuleInstalled( "chttp" ) then return end

AddCSLuaFile()

local config = {
    version = "1",
    addresses = {
        -- CHTTP update notifications and metrics
        ["chttp.timschumi.net"] = { allowed = true },
    }
}

return config
