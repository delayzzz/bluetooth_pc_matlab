%% 清除数据
try
  fclose(col_test);
  clear('col_test');
catch
  disp('无需清除蓝牙数据')
end

clc;clear;
disp('已清除所有数据')

%% 定义诸多变量

FREE  = 1;
HEAD1 = 2;
HEAD2 = 3;
DATA  = 4;
TAIL1 = 5;
TAIL2 = 6;
Command_data = [85 0 0 1 0 170];%使能命令
Stop_data    = [85 0 0 0 0 170];%停止命令
err_flag = 1;

global count count_pre
global stRobot_x stRobot_y stGyro
global t_data px py path dt
global t_start timing
global equal_flag

STATE = FREE;
raw_data1 = [0 0 0 0];
raw_data2 = [0 0 0 0];
raw_data3 = [0 0 0 0];
% raw_data4 = [0 0 0 0];
% raw_data5 = [0 0 0 0];
% raw_data6 = [0 0 0 0];
% raw_data7 = [0 0 0 0];
% raw_data8 = [0 0 0 0];
% raw_data9 = [0 0 0 0];
% raw_data10 = [0 0 0 0];
% raw_data11 = [0 0 0 0];
% raw_data12 = [0 0 0 0];
% raw_data13 = [0 0 0 0];
% raw_data14 = [0 0 0 0];
% raw_data15 = [0 0 0 0];
% raw_data16 = [0 0 0 0];
% raw_data17 = [0 0 0 0];
% raw_data18 = [0 0 0 0];
% raw_data19 = [0 0 0 0];
% raw_data20 = [0 0 0 0];

count = 0;
count_pre = 0;

stRobot_x = [0];
stRobot_y = [0];
stGyro = [0];

% data4 = [0];
% data5 = [0];
% data6 = [0];
% data7 = [0];
% data8 = [0];
% data9 = [0];
% data10 = [0];
% data11 = [0];
% data12 = [0];
% data13 = [0];
% data14 = [0];
% data15 = [0];
% data16 = [0];
% data17 = [0];
% data18 = [0];
% data19 = [0];
% data20 = [0];

t_data = [0];

% figure(1);
% px = plot(t_data,stRobot_x,'EraseMode','background','MarkerSize',5);  
% grid on ;
% figure(2)
% py = plot(t_data,stRobot_y,'EraseMode','background','MarkerSize',5);  
% grid on ;
% figure(3)
% pq = plot(t_data,stGyro,'EraseMode','background','MarkerSize',5);  
% grid on ;
% figure(4)
% 
% path = plot(0,0,'b.');
% dt=title('');%标题
% 
% axis([-100 2000 -100 2000])
% grid on
% 
% drawnow

%% 开启定时器，定时1s

t = timer('StartDelay',1,'TimerFcn',@t_TimerFcn,'Period',1,'ExecutionMode','fixedDelay');
t2 = timer('StartDelay',1,'TimerFcn',@t_TimerFcn2,'Period',0.04,'ExecutionMode','fixedRate');

%% 配置蓝牙操作

instrhwinfo('Bluetooth');
instrhwinfo('Bluetooth','col_test');
col_test = Bluetooth('col_test',1);

% col_test.TimerPeriod = 0.1;
% col_test.TimerFcn = {@plotcallback,p};
col_test.Timeout = 10;


%% 开启蓝牙数据监控，同时开启定时器
% fopen(col_test);
try
  fopen(col_test);
catch err
  disp('col_test蓝牙通道打开失败');
  err_flag = 0;
end

if err_flag 
    disp('col_test蓝牙通道成功打开');
    pause(3)
    fwrite(col_test,0);
    fwrite(col_test,0);
    fwrite(col_test,0);
    for k = 1:6
        fwrite(col_test,Command_data(k));
    end
     
    start([t,t2]);
    t_start = cputime;
%% 循环接受数据并绘制图像

while(1)

if STATE == FREE
    test_data = fread(col_test,1);
    if test_data == 85
        STATE = HEAD1;
    else
        STATE = FREE; 
    end
end

if STATE == HEAD1
    test_data = fread(col_test,1);
    if test_data == 0
        blank = fread(col_test,2);
        STATE = HEAD2;
    else
        STATE = FREE; 
    end
end

if STATE == HEAD2
    raw_data1 = fread(col_test,4);
    raw_data2 = fread(col_test,4);
    raw_data3 = fread(col_test,4);
%     raw_data4 = fread(col_test,4);
%     raw_data5 = fread(col_test,4);
%     raw_data6 = fread(col_test,4);
%     raw_data7 = fread(col_test,4);
%     raw_data8 = fread(col_test,4);
%     raw_data9 = fread(col_test,4);
%     raw_data10 = fread(col_test,4);
%     raw_data11 = fread(col_test,4);
%     raw_data12 = fread(col_test,4);
%     raw_data13 = fread(col_test,4);
%     raw_data14 = fread(col_test,4);
%     raw_data15 = fread(col_test,4);
%     raw_data16 = fread(col_test,4);
%     raw_data17 = fread(col_test,4);
%     raw_data18 = fread(col_test,4);
%     raw_data19 = fread(col_test,4);
%     raw_data20 = fread(col_test,4);
    STATE = DATA;
end

if STATE == DATA
    test_data = fread(col_test,1);
    if test_data == 0
        STATE = TAIL1;
    else
        STATE = FREE; 
    end
end

if STATE == TAIL1
    test_data = fread(col_test,1);
    if test_data == 170
        
        t_temp = cputime;
        timing = t_temp - t_start;
        count = count + 1;
        t_data(count) = timing;
        
        temp = uint8(raw_data1);
        stRobot_x(count) = typecast(temp,'single');
%         equal_flag = 0;
        temp = uint8(raw_data2);
        stRobot_y(count) = typecast(temp,'single');
%         equal_flag = 1;
        temp = uint8(raw_data3);
        stGyro(count) = typecast(temp,'single');
        
%         temp = uint8(raw_data4);
%         data4(count) = typecast(temp,'single');
%         temp = uint8(raw_data5);
%         data5(count) = typecast(temp,'single');
%         temp = uint8(raw_data6);
%         data6(count) = typecast(temp,'single');
%         temp = uint8(raw_data7);
%         data7(count) = typecast(temp,'single');
%         temp = uint8(raw_data8);
%         data8(count) = typecast(temp,'single');
%         temp = uint8(raw_data9);
%         data9(count) = typecast(temp,'single');
%         temp = uint8(raw_data10);
%         data10(count) = typecast(temp,'single');
%         temp = uint8(raw_data11);
%         data11(count) = typecast(temp,'single');
%         temp = uint8(raw_data12);
%         data12(count) = typecast(temp,'single');
%         temp = uint8(raw_data13);
%         data13(count) = typecast(temp,'single');
%         temp = uint8(raw_data14);
%         data14(count) = typecast(temp,'single');
%         temp = uint8(raw_data15);
%         data15(count) = typecast(temp,'single');
%         temp = uint8(raw_data16);
%         data16(count) = typecast(temp,'single');
%         temp = uint8(raw_data17);
%         data17(count) = typecast(temp,'single');
%         temp = uint8(raw_data18);
%         data18(count) = typecast(temp,'single');
%         temp = uint8(raw_data19);
%         data19(count) = typecast(temp,'single');
%         temp = uint8(raw_data20);
%         data20(count) = typecast(temp,'single');
        
%         string = sprintf('Have received stRobot_x：%d',stRobot_x(count));
%         disp(string)
%         string = sprintf('Have received stRobot_y：%d',stRobot_y(count));
%         disp(string)
        
%         set(px, 'XData',t_data,'YData',stRobot_x);    %定义XY的坐标值
%         set(py, 'XData',t_data,'YData',stRobot_y);    %定义XY的坐标值
%         set(pq, 'XData',t_data,'YData',stGyro);       %定义XY的坐标值
        
%         drawnow 

        STATE = FREE;
    else
        STATE = FREE; 
    end
end

end

end