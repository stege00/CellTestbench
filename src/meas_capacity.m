function meas_capacity(com_load,com_psupply,com_temperature,discharge_voltage,charge_voltage,discharge_current,charge_current,end_current)
%meas_capacity: measures capacity of cell over 2 cycles
    global stop_var
    global over_temperature_var
    device_load=serial(com_load,'BaudRate',115200);
    obj_load=load_act;
    device_psupply=serial(com_psupply,'BaudRate',57600);
    obj_psupply=psupply_act;
    device_temperature=serialport(com_temperature,9600);
    start_charge=0;
    start_time=0;
    plot_ctrl=plot_controller;
    generate_plots(plot_ctrl);
    discharge_cell(device_load,obj_load,device_psupply,obj_psupply,device_temperature,discharge_voltage,discharge_current,end_current,plot_ctrl);

    % first cycle
    [charge,current,voltage,temperature,time] = charge_cell(device_load,obj_load,device_psupply,obj_psupply,device_temperature,charge_voltage,charge_current,start_charge,start_time,end_current,plot_ctrl);
    capacity=charge(end);
    [charge_temp,current_temp,voltage_temp,temperature_temp,time_temp] = discharge_cell(device_load,obj_load,device_psupply,obj_psupply,device_temperature,discharge_voltage,discharge_current,charge(end),time(end),end_current,plot_ctrl);
    % append measured data
    capacity=cat(2,capacity,charge(end)-charge_temp(end));  
    charge=cat(2,charge,charge_temp);
    current=cat(2,current,current_temp);
    voltage=cat(2,voltage,voltage_temp);
    temperature=cat(2,temperature,temperature_temp);
    time=cat(2,time,time_temp);

    %second cycle
    [charge_temp,current_temp,voltage_temp,temperature_temp,time_temp] = charge_cell(device_load,obj_load,device_psupply,obj_psupply,device_temperature,charge_voltage,charge_current,charge(end),time(end),end_current,plot_ctrl);

    % append measured data
    capacity=cat(2,capacity,charge_temp(end)-charge(end));  
    charge=cat(2,charge,charge_temp);
    current=cat(2,current,current_temp);
    voltage=cat(2,voltage,voltage_temp);
    temperature=cat(2,temperature,temperature_temp);
    time=cat(2,time,time_temp);

    [charge_temp,current_temp,voltage_temp,temperature_temp,time_temp] = discharge_cell(device_load,obj_load,device_psupply,obj_psupply,device_temperature,discharge_voltage,discharge_current,charge(end),time(end),end_current,plot_ctrl);

    % append measured data
    capacity=cat(2,capacity,charge(end)-charge_temp(end));  
    charge=cat(2,charge,charge_temp);
    current=cat(2,current,current_temp);
    voltage=cat(2,voltage,voltage_temp);
    temperature=cat(2,temperature,temperature_temp);
    time=cat(2,time,time_temp);
    
    C=mean(capacity); disp(C);
    save_data([charge,current,voltage,temperature,time]);
    disp('finishedMeasuringCapacity');
    delete(instrfindall)
end

