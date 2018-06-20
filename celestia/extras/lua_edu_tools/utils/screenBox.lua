require "CXBox";

width, height = celestia:getscreendimension();
local newWidth, newHeight;

screenBox = CXBox:new()
    :init(0,0,0,0)
    :movable(false)
    :clickable(true)

screenBox.Customdraw =
    function(this)
        width, height = celestia:getscreendimension();
        local sel = celestia:getselection();
        if not(empty(sel)) then
            selection = true;
            if selname ~= sel:name() then
                selname = sel:name();
                newselection = true;
            else
                newselection = false;
            end
        else
            selname = nil;
            selection = false;
        end
        if newWidth ~= width or newHeight ~= height then
            newWidth, newHeight = width, height;
            -- Set the height of the Toolbox.
            if compassBox then
                if compassCheck.action then
                    toolBoxHeight = toolBoxH + timeBoxTop;
                    if compassFrame.Visible then
                        toolBoxHeight = toolBoxHeight + compassFrameHeight;
                    end
                    if compassFrameBox.Visible and not(centerCompass) then
                        toolBoxHeight = toolBoxHeight + compassH;
                    end
                end
            end
            for k,v in ipairs(toolset) do
                if pcall( function() require (v) end ) then
                    local boxH = boxheight_t[v.."H"] or boxHeight;
                    local boxT = boxtop[v];
                    _G[v]:attach(screenBox, width-boxWidth-5, height-boxH-boxT, 5, boxT);
                    _G[v]:orderfront();
                end
            end
        end
    end;