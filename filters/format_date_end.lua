-- Adapted from https://github.com/iagoleal/iagoleal.github.io/blob/master/filters/date.lua

--[[ Set the date if it is not already set
     and properly format it
--]]
local function split(s, delimiter)
    result = {}
    for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

function Meta(m)
    if m.date_end then
        local date = pandoc.utils.normalize_date(pandoc.utils.stringify(m.date_end))
        local year, month, day = table.unpack(split(date, '-'))
        m.date_end = os.date("%A, %B %d, %Y", os.time({ year = year, month = month, day = day })):gsub(" 0", " ")
    end
    return m
end
