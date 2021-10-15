function save_data(data)
% creates new folder under ..\data\
% to save the given data
command=strcat('mkdir ..\data\',date,'_',datestr(now,'HH-MM-SS'));
system(command)
command=strcat('cd ..\data\',date,'_',datestr(now,'HH-MM-SS'));
system(command)
save('meas_data',data)
system('cd ..\..\src');
end

