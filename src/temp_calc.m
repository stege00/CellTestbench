function T = temp_calc(channel)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global stop_var
global over_temperature_var
flush(channel)
data=readline(channel)
% something like:
% {"time":283.300,"voltages":[0.000,0.000,0.000,0.000,0.000,0.046,0.008,0.000]},
%volt1=str2double(data(35:39));
a=36;
b=40;

B_coeff=3435;
T_0=298.15;
U_q=4.096;
R_ref=12000*0.99;
R_pulldown=12000*1.1;

for i=1:8
    volt(i)=U_q-str2double(extractBetween(data,a,b));
    a=a+5;
    b=b+5;
end
disp(volt);


%in späterer Version mit:
%R_pulldown=[12000,12000,12000...] -> gemessen
%R_ref=[10000,10000,10000...] -> gemessen

for i=1:4
   % T(i)=T_0*B_coeff/(log(volt(i).*R_pulldown./(U_q-volt(i)./R_ref))*T_0+B_coeff);
   R_t(i)=(volt(i)./(U_q-volt(i)))*R_pulldown;
   T(i)=1/((1/T_0)+(1/B_coeff)*log(R_t(i)./R_ref))-273,15;
end
if max(T)>=60
    over_temperature_var=1;
end
disp(T);
end

