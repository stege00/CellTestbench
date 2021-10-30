function save_data(data)
% creates new folder under ..\data\
% to save the given data

filename=strcat('data\',date,'_',datestr(now,'HH-MM-SS'),'\meas_data');
command=strcat('mkdir data\',date,'_',datestr(now,'HH-MM-SS'));
system(command)
save(filename,'data')
end

