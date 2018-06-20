scrollUpImage = celestia:loadtexture("../images/scroll_up_button.png");
scrollDownImage = celestia:loadtexture("../images/scroll_down_button.png");

makeScrollButton = function(scrollUpButton, scrollDownButton, scrollbarFrame)
    local scrollbarFrameW, scrollbarFrameH = scrollbarFrame:size();

    scrollUpButton = CXBox:new()
    :init(0, 0, 0, 0)
    :fillimage(scrollUpImage)
    :movable(false)
    :attach(scrollbarFrame, 0, scrollbarFrameH, 0, -11);

    scrollDownButton = CXBox:new()
    :init(0, 0, 0, 0)
    :fillimage(scrollDownImage)
    :movable(false)
    :attach(scrollbarFrame, 0, -11, 0, scrollbarFrameH);    -- Inverted but OK (not active).

end