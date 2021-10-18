function [charge,current,voltage,temperature,time] = dischargeCell(device_load,obj_load,device_psupply,obj_psupply,device_temperature,discharge_voltage,discharge_current,start_charge,start_time,end_current,plot_ctrl)
%dischargeCell: discharges Cell with constant current (discharge_current) until discharge_voltage is
%reached. Discharges with constant voltage until end_current is reached.
%Returns data to charge, current, voltage and temperature over time.
    tic
    global stop_var
    global over_temperature_var
    meas_voltage=meas_loadVoltage(obj_load,device_load);
    meas_current=meas_loadCurrent(obj_load,device_load);
    start_temperature=temp_calc(device_temperature);
    
    temperature=[start_temperature];
    charge=[start_charge];
    current=[0];
    voltage=[meas_voltage];
    
    set_psupplyRemote(obj_psupply,device_psupply,1);
    set_psupplyOutput(obj_psupply,device_psupply,0);
    set_loadCurrent(obj_load,device_load,discharge_current);
    set_loadUVP(obj_load,device_load,discharge_voltage);
    set_loadVoltage(obj_load,device_load,discharge_voltage);
    set_loadOCP(obj_load,device_load,discharge_current);
    set_loadMode(obj_load,device_load,0);
    set_loadInput(obj_load,device_load,0);
    elapsed_time=toc;
    
    time=[start_time];
    
    tic
    while(meas_voltage<=discharge_voltage)
        drawnow
        if or(stop_var,over_temperature_var)
            break;
        end
        meas_temperature=temp_calc(device_temperature);
        meas_voltage=meas_loadVoltage(obj_load,device_load);
        meas_current=meas_loadCurrent(obj_load,device_load);
        elapsed_time=toc;tic;
        charge(end+1)=charge(end)-meas_current*elapsed_time;
        current(end+1)=meas_current;
        voltage(end+1)=meas_voltage;
        temperature(end+1)=meas_temperature;
        time(end+1)=time(end)+elapsed_time;
        update_plots(plot_ctrl,charge,voltage,current,temperature,time)
    end 
    set_loadMode(obj_load,device_load,1);
    while(meas_current<=end_current)
        drawnow
        if or(stop_var,over_temperature_var)
            break;
        end
        meas_temperature=temp_calc(device_temperature);
        meas_voltage=meas_loadVoltage(obj_load,device_load);
        meas_current=meas_loadCurrent(obj_load,device_load);
        elapsed_time=toc;tic;
        charge(end+1)=charge(end)-meas_current*elapsed_time;
        current(end+1)=meas_current;
        voltage(end+1)=meas_voltage;
        temperature(end+1)=meas_temperature;
        time(end+1)=time(end)+elapsed_time;
        update_plots(plot_ctrl,charge,voltage,current,temperature,time)
    end
    set_loadInput(obj_load,device_load,0);
    toc;
    disp('finishedDischarging')
end

