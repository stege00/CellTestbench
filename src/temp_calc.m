function T = temp_calc(channel)
% get measured voltage via serial device (multi purpuse board),
% calculate temperature via defined constants
global over_temperature_var

% constants for temperature calculation
B_coeff=3435;
T_0=298.15;
U_q=4.096;
R_ref=12000*0.99;
R_pulldown=12000*1.1;

flush(channel)
data=readline(channel);
% something like:
% {"time":283.300,"voltages":[0.000,0.000,0.000,0.000,0.000,0.046,0.008,0.000]},
a=36;
b=40;

for i=1:8
    volt(i)=U_q-str2double(extractBetween(data,a,b));
    a=a+5;
    b=b+5;
end

% to do in future version:
%R_pulldown=[12000,12000,12000...] -> measured
%R_ref=[10000,10000,10000...] -> measured

for i=1:8
   R_t(i)=(volt(i)./(U_q-volt(i)))*R_pulldown;
   T(i)=1/((1/T_0)+(1/B_coeff)*log(R_t(i)./R_ref))-273,15;
end
if max(T)>=60
    over_temperature_var=1;
end
end

