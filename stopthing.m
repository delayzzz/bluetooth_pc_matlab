 stop([t,t2])
figure(1)
subplot(221)
plot(t_data,stRobot_x)
title('x������ʱ��仯');
xlabel('ʱ��/s');
ylabel('x������/mm');
grid on
subplot(222)
plot(t_data,stRobot_y)
title('y������ʱ��仯');
xlabel('ʱ��/s');
ylabel('y������/mm');
grid on
subplot(223)
plot(t_data,stGyro)
title('�Ƕ���ʱ��仯');
xlabel('ʱ��/s');
ylabel('�Ƕ�/��');
grid on
figure(2)
plot(stRobot_x,stRobot_y)
title('·��ͼ');
xlabel('x��/mm');
ylabel('y��/mm');
axis([-100 3000 -100 3000])
axis equal
grid on