boxWidth = toolbox_width[lang];
boxWidth = math.min(200, math.max(146, boxWidth));

boxHeight = 20;
boxheight_t =
    {
        timeBoxH = 98,
        lightBoxH = 43,
        magnitudeBoxH = 43,
        galaxyLightBoxH = 43,
        renderBoxH = 22,
        obsModeBoxH = 77,
        solarSystemBoxH = 22,
        fovBoxH = 43,
        addsBoxH = 22,
        --infoBoxH = 20,
        --coordinatesBoxH = 20,
        --distanceBoxH = 20,
        --magnificationBoxH = 20,
        --HRBoxH = 20,
        --KeplerParamBoxH = 20,
        --virtualPadBoxH = 20,
        --compassBoxH = 20,
    }

setToolBoxVisibility = function(b)
    boxtop = {}
    toolBoxH = 0;
    for i = 1, table.getn(toolset) do
        if toolset[i] == "timeBox" then
            timeBoxTop = 0;
            break
        else
            timeBoxTop = 35;
        end
    end
    for k,v in ipairs(toolset) do
        if pcall( function() require (v) end ) then
            require(v);
            _G[v].Visible = b;
            local boxH = boxheight_t[v.."H"] or boxHeight;
            boxtop[v] = toolBoxH + timeBoxTop;
            toolBoxH = toolBoxH + boxH;
        end
    end
end

enableCheckBox = function(checkBox)
    checkBox.Bordercolor = cbubordoff;
    checkBox.Active = true;
    checkBox.Textcolor = cbutextoff;
end

disableCheckBox = function(checkBox)
    checkBox.Bordercolor = nil;
    checkBox.Active = false;
    checkBox.Textcolor = {0,0,0,0};
end

setToolBoxVisibility(true);
toolBoxHeight = toolBoxH + timeBoxTop;

toolButton = CXBox:new()
        :init(0, 0, 0, 0)
        :movable(false)
        :active(true)
        :attach(screenBox, width, height, 0, 0);

toolButton.Customdraw =
    function(this)
        toolButton:attach(screenBox, width-5, height-toolBoxHeight, 0, 0)
    end;

toolButton.Action = (function()
        return
            function()
                overlay.toggle();
            end
        end) ();
