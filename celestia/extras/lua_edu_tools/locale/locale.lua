require "config"

-- List of translations which are available so far:
translation = {"de", "en", "fr", "it", "ko", "nl", "ru", "sv"}

lang_country_code =
    {
    -- Language codes:
        German = "de",
        English = "en",
        Spanish = "es",
        French = "fr",
        Italian = "it",
        Korean = "ko",
        Dutch = "nl",
        Portuguese = "pt",
        Russian = "ru",
        Swedish = "sv",
    -- Country codes:
        Brazil = "BR",
        ["United States"] = "US",
    }

country_date_format =
    {
    -- Date format by country:
        de = "day/month/year",
        en = "year/month/day",
        es = "day/month/year",
        fr = "day/month/year",
        it = "day/month/year",
        ko = "year/month/day",
        nl = "day/month/year",
        pt = "day/month/year",
        ru = "day/month/year",
        sv = "year/month/day",
    }

toolbox_width =
    {
    -- Define the width of the toolbox for each locale.
    -- This is used to allow longer strings to fit in the buttons.
        de = 156,
        en = 146,
        es = 146,
        fr = 146,
        it = 146,
        ko = 176,
        nl = 190,
        pt = 146,
        ru = 186,
        sv = 146,
    }

-- Set English as the default language.
local loc = "en";

-- Get language from 'config.lua'.
if language == "system_default" then
    -- Get the system locale (doesn't work properly on Mac OS-X).
    loc = os.setlocale("", "collate");
else
    -- Check out if the translation is available
    for k, v in pairs(translation) do
        if v == language then
            -- Use language set in 'config.lua'.
            loc = language;
            break;
        end
    end
end

-- On Windows, the system locale output doesn't correspond to the ISO 639-1
-- standard for languages and the ISO 3166 standard for countries.
-- So, we have to convert the system locale output to the repsective ISO codes.
pos_ = string.find(loc, "_");
posdot = string.find(loc, "%.");
if pos_ then
    langsubstr = string.sub(loc, 1, pos_-1);
    if string.len(langsubstr) > 2 then
        langsubstr = lang_country_code[langsubstr];
    end
    if posdot then
        countrysubstr = string.sub(loc, pos_+1, posdot-1);
        if string.len(countrysubstr) > 2 then
            countrysubstr = lang_country_code[countrysubstr];
        end
    else
        countrysubstr = string.sub(loc, pos_+1, -1);
    end
    if langsubstr then
        lang = langsubstr;
        if countrysubstr and string.lower(countrysubstr) ~= langsubstr then
            -- Take the country code into account when it is present in the locale output.
            lang = langsubstr.."_"..countrysubstr;
            if not(pcall( function() require (lang) end )) then
                -- Don't take the country code into account when no localization is found.
                lang = langsubstr;
            end
        end
    end
else
    lang = loc;
end

if not lang then lang = "en" end;

-- Set the numeric category to the system locale.
-- Only works with Lua 5.1.
setLocaleNumeric = function(locale)
    if _VERSION == "Lua 5.1" then
        os.setlocale(locale, "numeric");
    end
end

if pcall( function() require (lang) end ) then
    -- Define a localization function if 'lang.lua' is found.
    _ = function(string)
        if loc_str[string] then
            -- Return translated string if it exists.
            return loc_str[string];
        else
            -- Return default string if there is no translation available.
            return string;
        end
    end
else
    -- The function will return the default string if 'lang.lua' is not found.
   _ = function(string)
        return string;
    end
end

-- Use the localized version for infoText if 'infoText_lang.lua' is found.
infoTextLang = "infoText".."_"..lang;
if not(pcall( function() require (infoTextLang) end )) then
    -- Otherwise, use the default infoText.
    if not(pcall( function() require ("infoText") end )) then
        infoText = {};
    end
end

if date_format == "country_default" then
    if country_date_format [lang] then
        date_format = country_date_format [lang];
    else
        date_format = country_date_format [en];
    end
end

getlocalname = function(obj)
    if not(empty(obj)) then
        objlocalname = obj:localname();
        if obj:name() == "Sol" then
            -- Sol is not localized in Celestia; use localization from 'lang.lua'.
            objlocalname = _("Sol");
        elseif obj:name() == "Milky Way" then
            -- Milky Way is not localized in Celestia; use localization from 'lang.lua'.
            objlocalname = _("Milky Way");
        elseif obj:type() == "star" then
            -- Display star names using Bayer code (Greek Letters Abbreviation).
            -- Use replaceGreekLetterAbbr() function defined in 'textlayout.lua'.
            objlocalname = replaceGreekLetterAbbr(obj:name());
        elseif obj:type() == "location" then
            objlocalname = obj:name();
        end
    end
    return objlocalname
end
