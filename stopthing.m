 stop([t,t2])
figure(1)
subplot(221)
plot(t_data,stRobot_x)
title('x坐标随时间变化');
xlabel('时间/s');
ylabel('x轴坐标/mm');
grid on
subplot(222)
plot(t_data,stRobot_y)
title('y坐标随时间变化');
xlabel('时间/s');
ylabel('y轴坐标/mm');
grid on
subplot(223)
plot(t_data,stGyro)
title('角度随时间变化');
xlabel('时间/s');
ylabel('角度/°');
grid on
figure(2)
plot(stRobot_x,stRobot_y)
title('路径图');
xlabel('x轴/mm');
ylabel('y轴/mm');
axis([-100 3000 -100 3000])
axis equal
grid on