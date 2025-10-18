local function chttpCallerFromStack( stack )
    -- CFunctions can't default to a proper funcname / namewhat, so we have to rely on the stack layout.
    -- This should remain stable as long as hook.Run gets tail call optimized into hook.Call.
    --
    -- 1: "stack traceback"
    -- 2: hook function
    -- 3: hook.Call
    -- 4: CHTTP
    -- 5: caller
    return stack[5]
end

hook.Add( "OnCHTTPRequest", "CFC_HTTP_CHTTP", function( req )
    if not req.url and not req.method then return end

    local options = CFCHTTP.GetOptionsForURL( req.url )
    local isAllowed = options and options.allowed
    local noisy = options and options.noisy

    local stack = string.Split( debug.traceback(), "\n" )
    CFCHTTP.LogRequest( {
        noisy = noisy,
        method = req.method,
        fileLocation = chttpCallerFromStack( stack ),
        urls = { { url = req.url, status = isAllowed and "allowed" or "blocked" } },
    } )

    if not isAllowed then
        return "URL is not whitelisted"
    end
end )
