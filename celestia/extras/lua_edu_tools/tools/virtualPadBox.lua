require "locale";

----------------------------------------------
-- Load images.
----------------------------------------------
padImage = celestia:loadtexture("../images/virtual_pad.png");
cursorImage = celestia:loadtexture("../images/pad_cursor.png");

----------------------------------------------
-- Define some useful functions
---------------------------------------------
setObsRotation = function(vectX, vectY)
    local obs = celestia:getobserver();
    local rotVect = celestia:newvector(vectY, vectX, 0);
    local rot = celestia:newrotation(rotVect, math.pi*rotCoeff);
    obs:rotate(rot);
    -- Set speed to the current value to make the
    -- observer move in the direction of the view.
    local speed = obs:getspeed();
    obs:setspeed(speed);
end

resetRotation = function()
    rotateUp = false;
    rotateDown = false;
    rotateLeft = false;
    rotateRight = false;
end

----------------------------------------------
-- Set initial values
----------------------------------------------
pad_first_tick = true;

-- Get centerPad initial value from 'config.lua'.
centerPad = center_virtual_pad;

-- Get the size of the virtual pad from 'config.lua'.
virtual_pad_size = math.min(120, math.max(50, virtual_pad_size));
padFrameW, padFrameH = virtual_pad_size, virtual_pad_size;

arrowSize = padFrameW/5;
padCursorFrameW, padCursorFrameH = 2*padFrameW/3, 2*padFrameH/3;
padCursorW, padCursorH = 15, 15;
cursorXMax, cursorYMax = (padCursorFrameW - padCursorW - 6)/2, (padCursorFrameH - padCursorH - 6)/2;

-- Get the rotation speed of the virtual pad from 'config.lua'.
virtual_pad_speed = math.min(10, math.max(1, virtual_pad_speed));
rotCoeff = virtual_pad_speed / 1e3;

----------------------------------------------
-- Set up and Draw the boxes
---------------------------------------------
virtualPadBox = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor({1, 1, 0, 1})
    --:fillcolor({1,1,0,.2})
    :movable(false)
    :attach(screenBox, width, height, 0, 0);

virtualPadBox.Customdraw = 
    function(this)
        textlayout:setfont(normalfont);
        textlayout:setfontcolor(ctext);
        textlayout:setpos(this.lb+25, this.tb-14);
        textlayout:println(_("Virtual Pad"));
    end;         

virtualPadCheck = CXBox:new()
        :init(0, 0, 0, 0)
        :bordercolor(cbubordoff)
        --:fillcolor({1,1,0,.2})
        :textfont(smallfont)
        :textcolor(cbutextoff)
        :textpos("center")
        :movetext(0, 10)
        :text("")
        :movable(false)
        :active(true)
        :attach(virtualPadBox, boxWidth - 40, 4, 29, 5)

virtualPadCheck.Customdraw =
    function(this)
        -- Set the initial state of the check-box from 'config.lua'.
        if pad_first_tick and enable_virtual_pad then
            virtualPadCheck.Action();
        end
        pad_first_tick = false;
    end

virtualPadCheck.Action = (function()
        return
            function()
                padFrame.Visible = not(padFrame.Visible);
                if padFrame.Visible then
                    virtualPadCheck.Text = "x";
                else
                    virtualPadCheck.Text = "";
                end
            end
        end) ();

padFrame = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor(cbubordoff)
    :visible(false)
    :movable(false)
    :fillimage(padImage)
    :attach(screenBox, width/2, height/2, width/2, height/2)

padFrame.Customdraw = 
    function(this)
        -- Disable virtual pad position switch when compass is enabled.
        -- The position of virtual pad is determined according to the position of compass.
        if compassBox and compassFrameBox.Visible then
            if padCursorFrame.Active then
                padCursorFrame.Active = false;
            end
            if centerPad == centerCompass then
                centerPad = not(centerCompass);
            end
        else
            padCursorFrame.Active = true;
        end

        if not(centerPad) and height < toolBoxHeight+2+padFrameH+5 then
            if compassBox and compassFrameBox.Visible then
                -- Disable virtual pad if the screen height does not allow displaying
                -- it under the toolbox (when compass is enabled).
                virtualPadCheck.Action();
            else
                -- Don't display virtual pad under the toolbox if the screen height
                -- does not allow (when compass is disabled).
                centerPad = true;
            end
        end

        if centerPad then
            -- Display virtual pad at the bottom center of the screen.
            padFrame:attach(screenBox, (width-padFrameW)/2, 10, (width-padFrameW)/2, height-padFrameH-10);
        else
            -- Display virtual pad under the toolbox.
            padFrame:attach(screenBox, (width-(boxWidth+padFrameW)/2-2), height-toolBoxHeight-padFrameH-5,
            (boxWidth-padFrameW)/2+2, toolBoxHeight+5);
        end
    end;

padCursorFrame = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor(cbubordoff)
    :visible(true)
    :movable(false)
    :active(true)
    :attach(padFrame,    (padFrameW-padCursorFrameW)/2, (padFrameH-padCursorFrameH)/2,
                                                                (padFrameW-padCursorFrameW)/2, (padFrameH-padCursorFrameH)/2)

padCursorFrame.Action = (function()
        return
        function()
            -- Switch the virtual pad position between the bottom
            -- center of the screen and the bottom of the toolBox.
            centerPad = not(centerPad)
        end
    end) ();

padCursor = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor(cbubordoff)
    --:fillcolor(cslidebofill)
    :visible(true)
    :movable(true)
    :fillimage(cursorImage)
    :attach(padCursorFrame,    (padCursorFrameW-padCursorW)/2, (padCursorFrameH-padCursorH)/2,
                                                                                    (padCursorFrameW-padCursorW)/2, (padCursorFrameH-padCursorH)/2)

padCursor.Customdraw = 
    function(this)
        if this.Move then
            -- Stop rotations from arrow buttons.
            resetRotation();

            -- Define cursor coordinates and rotation vector.
            local cursorCenterX, cursorCenterY = padCursor:center();
            local frameCenterX, frameCenterY = padCursorFrame:center();
            local cursorX, cursorY = cursorCenterX - frameCenterX, cursorCenterY - frameCenterY;
            local rotVectX, rotVectY = cursorX / cursorXMax, cursorY / cursorYMax;

            -- Set rotation of observer.
            if reverse_pad_pitch then
                setObsRotation(rotVectX, -rotVectY);
            else
                setObsRotation(rotVectX, rotVectY);
            end
        else
            -- Keep cursor centered in the Frame.
            padCursor:attach(padCursorFrame,    (padCursorFrameW-padCursorW)/2, (padCursorFrameH-padCursorH)/2,
                                                                                                                    (padCursorFrameW-padCursorW)/2, (padCursorFrameH-padCursorH)/2)
        end

        -- Set rotation from arrow buttons.
        if rotateUp then
            padCursor:move(0, cursorYMax);
            if reverse_pad_pitch then
                setObsRotation(0, -1);
            else
                setObsRotation(0, 1);
            end
        elseif rotateDown then
            padCursor:move(0, -cursorYMax);
            if reverse_pad_pitch then
                setObsRotation(0, 1);
            else
                setObsRotation(0, -1);
            end
        elseif rotateLeft then
            padCursor:move(-cursorXMax, 0);
            setObsRotation(-1, 0);
        elseif rotateRight then
            padCursor:move(cursorXMax, 0);
            setObsRotation(1, 0);
        end

    end;

padUpButton = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor(cbubordoff)
    :visible(true)
    :movable(false)
    :active(true)
    :attach(padFrame, (padFrameW-arrowSize)/2, padFrameH-arrowSize, (padFrameW-arrowSize)/2, 0)

padUpButton.Action = (function()
        return
            function()
                if rotateUp then
                    resetRotation();
                else
                    resetRotation();
                    rotateUp = true;
                end
            end
        end) ();

padDownButton = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor(cbubordoff)
    :visible(true)
    :movable(false)
    :active(true)
    :attach(padFrame, (padFrameW-arrowSize)/2, 0, (padFrameH-arrowSize)/2, padFrameW-arrowSize)

padDownButton.Action = (function()
        return
            function()
                if rotateDown then
                    resetRotation();
                else
                    resetRotation();
                    rotateDown = true;
                end
            end
        end) ();

padLeftButton = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor(cbubordoff)
    :visible(true)
    :movable(false)
    :active(true)
    :attach(padFrame, 0, (padFrameH-arrowSize)/2, padFrameW-arrowSize, (padFrameH-arrowSize)/2)

padLeftButton.Action = (function()
        return
            function()
                if rotateLeft then
                    resetRotation();
                else
                    resetRotation();
                    rotateLeft = true;
                end
            end
        end) ();

padRightButton = CXBox:new()
    :init(0, 0, 0, 0)
    --:bordercolor(cbubordoff)
    :visible(true)
    :movable(false)
    :active(true)
    :attach(padFrame, padFrameW-arrowSize, (padFrameH-arrowSize)/2, 0, (padFrameH-arrowSize)/2)

padRightButton.Action = (function()
        return
            function()
                if rotateRight then
                    resetRotation();
                else
                    resetRotation();
                    rotateRight = true;
                end
            end
        end) ();
