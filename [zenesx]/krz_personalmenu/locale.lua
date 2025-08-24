Locales = {}

function i18n(str, ...) -- Translate string
    if not str then
        print(("[^1ERROR^7] Resource ^5%s^7 You did not specify a parameter for the Translate function or the value is nil!"):format(GetInvokingResource() or GetCurrentResourceName()))
        return 'Given translate function parameter is nil!'
    end

    local localeCfg = Locales[Config.Locale]

    if localeCfg then
        if localeCfg[str] then
            return string.format(localeCfg[str], ...)
        elseif Config.Locale ~= 'de' and Locales['de'] and Locales['de'][str] then
            return string.format(Locales['de'][str], ...)
        else
            return 'Translation [' .. Config.Locale .. '][' .. str .. '] does not exist'
        end
    elseif Config.Locale ~= 'de' and Locales['de'] and Locales['de'][str] then
        return string.format(Locales['de'][str], ...)
    else
        return 'Locale [' .. Config.Locale .. '] does not exist'
    end
end

function i18nU(str, ...) -- Translate string first char uppercase
    return (i18n(str, ...):gsub("^%l", string.upper))
end