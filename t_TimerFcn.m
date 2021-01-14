function t_TimerFcn(hObject,eventdata)
    global count
    global count_pre
    
    FPS = count-count_pre;
    string = sprintf('½âÂëÖ¡ÂÊ£º%d',FPS);
    disp(string);
    count_pre = count;
    
end