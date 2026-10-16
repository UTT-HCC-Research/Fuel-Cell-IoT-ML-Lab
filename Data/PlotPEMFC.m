function PlotPEMFC(t_fc,Ifc,Vfc)
% Plot fuel-cell current over time

figure
plot(t_fc,Ifc)
xlabel("Time (s)")
ylabel("Current (A)")
grid on

% Plot fuel-cell voltage over time

figure
plot(t_fc,Vfc)
xlabel("Time (s)")
ylabel("Voltage (V)")
grid on
% Plot fuel-cell electrical power over time
P_fc = Vfc .* Ifc;
figure
plot(t_fc, P_fc)
xlabel("Time (s)")
ylabel("Electrical Power (W)")
grid on