function charge_to_SOC(com_load,com_psupply,com_temperature,discharge_voltage,charge_voltage,discharge_current,charge_current,end_current,desired_soc,cell_capacity)
%charge_to_SOC: Charge cell to specific state of charge with constant current.
    global stop_var
    global over_temperature_var
    
    % set up serial devices and start values
    device_load=serial(com_load,'BaudRate',115200);
    obj_load=load_act;
    device_psupply=serial(com_psupply,'BaudRate',57600,'Parity','odd');
    obj_psupply=psupply_act;
    device_temperature=serialport(com_temperature,9600);
    start_charge=0;
    start_time=0;
    plot_ctrl=plot_controller;
    generate_plots(plot_ctrl);
    % discharge cell to get into starting conditions
    [charge,current,voltage,temperature,time] = discharge_cell(device_load,obj_load,device_psupply,obj_psupply,device_temperature,discharge_voltage,discharge_current,end_current,plot_ctrl);
    
    tic
    [voltage(end+1),current(end+1)]=get_psupplyValues(obj_psupply,device_psupply);
    charge(end+1)=0;
    temperature(end+1)=temp_calc(device_temperature);
    
    % set up starting configuration of serial devices  
    set_psupplyRemote(obj_psupply,device_psupply,1);       
    set_loadInput(obj_load,device_load,0);
    set_psupplyVoltage(obj_psupply,device_psupply,charge_voltage);
    set_psupplyCurrent(obj_psupply,device_psupply,charge_current);
    set_psupplyOutput(obj_psupply,device_psupply,1);
    elapsed_time=toc;
    
    time(end+1)=time(end)+elapsed_time;
    
    tic
    while(charge(end)<=desired_soc*cell_capacity)
        % check termination condition
        drawnow
        if or(stop_var,over_temperature_var)
            break;
        end        
        
        % update data + plots
        temperature(end+1)=temp_calc(device_temperature);
        [meas_voltage,meas_current]=get_psupplyValues(obj_psupply,device_psupply);
        elapsed_time=toc;tic;
        charge(end+1)=charge(end)+meas_current*elapsed_time;
        current(end+1)=meas_current;
        voltage(end+1)=meas_voltage;
        time(end+1)=time(end)+elapsed_time;
        update_plots(plot_ctrl,charge,voltage,current,temperature,time)
    end
    
    set_psupplyOutput(obj_psupply,device_psupply,0);
    toc;
    save_data([charge,current,voltage,temperature,time]);
    disp('finishedCharging2SOC')
    delete(instrfindall)
end

