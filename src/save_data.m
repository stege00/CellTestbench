function save_data(data)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
command=strcat('mkdir ..\data\',date,'_',datestr(now,'HH-MM-SS'));
system(command)
command=strcat('cd ..\data\',date,'_',datestr(now,'HH-MM-SS'));
system(command)
save('meas_data',data)
system('cd ..\..\src');
end

