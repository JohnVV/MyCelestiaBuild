makeCloseButton = function(closeButton, box, setButton)
    local boxW, boxH = box:size();
    closeButton = CXBox:new()
        :init(0, 0, 0, 0)
        --:fillcolor(csetbofill)
        :bordercolor(cbubordoff)
        :textfont(smallfont)
        :textcolor(cclotext)
        :textpos("center")
        :movetext(0, 10)
        :text("x")
        :movable(false)
        :active(true)
        :attach(box, boxW-13, boxH-13, 2, 2);

    closeButton.Action = (function()
        return
            function()
                setButton.Action();
            end
        end) ();
end
