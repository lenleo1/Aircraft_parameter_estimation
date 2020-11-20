% Equation error least square system identification
% author lenleo
% 2020.11.20
clear;clc
load F16_lat_w_vnoise
% coeff: Cx_tot Cz_tot Cm_tot Cy_tot Cn_tot Cl_tot
% surfaces: dt de da dr (deg)
% ysim : [1]npos [2]epos [3]alt [4]phi [5]theta [6]psi [7]Vel [8]alpha...
%        [9]beta [10]p [11]q [12]r [13]~[15]nxyz [16]~[18]Mach,Qbar,Ps
%% Plot the measured inputs and outputs
figure(1)
subplot(3,2,1)
plot(T,surfaces(:,3),'LineWidth',1); 
grid on
ylabel('\delta_a(deg)');
subplot(3,2,2)
plot(T,surfaces(:,4),'LineWidth',1); 
grid on
ylabel('\delta_r(deg)');
subplot(3,2,3)
plot(T,y_sim(:,9),'LineWidth',1); 
grid on
ylabel('\beta(deg)');
subplot(3,2,4)
plot(T,y_sim(:,10),'LineWidth',1); 
grid on
ylabel('p(deg/s)');
subplot(3,2,5)
plot(T,y_sim(:,12),'LineWidth',1); 
grid on
xlabel('T(s)');
ylabel('r(deg/s)');
subplot(3,2,6)
plot(T,y_sim(:,4),'LineWidth',1); 
grid on
xlabel('T(s)');
ylabel('\phi(deg)');
%% Assemble the regressor matrix
% beta p r da dr
X=[y_sim(:,9),y_sim(:,10),y_sim(:,12),surfaces(:,3),surfaces(:,4)];
% plot the regressor
figure(2)
plot(T,X,'LineWidth',1)
grid on
legend('\beta(deg)','phat(deg/s)','rhat(deg/s)','\delta_a(deg)','\delta_r(deg)');
%% LS process
% requires a constant regressor for the bias term
X=[X,ones(size(X,1),1)];
Cn = Coeff(:,5);
[yn,pn,crbn,s2n]=LS_fcn(X,Cn);
%% plot the result
figure(3)
plot(T,Cn,T,yn,'--','LineWidth',1)
ylabel('Cn','Rotation',0);
title('Equation-Error Modeling','FontSize',10,'FontWeight','bold');
legend('data','model');
%% disp the result
fprintf('\n\n Display the parameter estimation ')
serrn=sqrt(diag(crbn));
xnames={'beta';'p';'r';'da';'dr'};
result_disp(pn,serrn,xnames);
%% residual analysis
figure(4)
subplot(2,1,1),plot(T,Cn-yn,'b.'),grid on, hold on,
%  Prediction interval calculation.
[syn,yln]=confin_interv(X,pn,s2n);
%  Plot the 95 percent confidence interval for prediction.
plot(T,yln(:,1)-yn,'r--'),
plot(T,yln(:,2)-yn,'r--'),
hold off,
grid off,
ylabel('residual')
xlabel('T(s)')

subplot(2,1,2),plot(yn,Cn-yn,'b.'),grid on, hold on,
npts=length(yn);
plot([-0.015:0.03/(npts-1):0.015]',yln(:,1)-yn,'r--'),
plot([-0.015:0.03/(npts-1):0.015]',yln(:,2)-yn,'r--'),
hold off,
grid off,
ylabel('residual')
xlabel('Cn')
%% prediction
load F16_lat_w_vnoise2
XP = [y_sim(:,9),y_sim(:,10),y_sim(:,12),surfaces(:,3),surfaces(:,4)];
XP = [XP,ones(size(XP,1),1)];
CnP = Coeff(:,5);
ynP = XP*pn;
figure(6)
plot(T,CnP,T,ynP,'LineWidth',1);
legend('data','model');
xlabel('time(s)')
ylabel('Cn')
