function [charge,current,voltage,temperature,time] = charge_cell(device_load,obj_load,device_psupply,obj_psupply,device_temperature,charge_voltage,charge_current,start_charge,start_time,end_current,plot_ctrl)
%chargeCell: Charges Cell with constant current (charge_current) until charge_voltage is
%reached. Charges with constant voltage until end_current is reached.
%Returns data to charge, current, voltage and temperature over time.
    tic
    global stop_var
    global over_temperature_var
    [meas_voltage,meas_current]=get_psupplyValues(obj_psupply,device_psupply);
    start_temperature=temp_calc(device_temperature);
    if ~start_charge
        start_charge=0;
    end
    if ~start_time
        start_time=0;
    end
    temperature=[start_temperature];
    charge=[start_charge];
    current=[0];
    voltage=[meas_voltage];
    
    set_psupplyRemote(obj_psupply,device_psupply,1);       
    set_loadInput(obj_load,device_load,0);
    set_psupplyVoltage(obj_psupply,device_psupply,charge_voltage);
    set_psupplyCurrent(obj_psupply,device_psupply,charge_current);
    set_psupplyOutput(obj_psupply,device_psupply,1);
    elapsed_time=toc;
    
    time=[start_time+elapsed_time];
    
    tic
    while(meas_voltage<=charge_voltage)
        drawnow
        if or(stop_var,over_temperature_var)
            break;
        end
        % load not checked to safe time
        temperature(end+1)=temp_calc(device_temperature);
        [meas_voltage,meas_current]=get_psupplyValues(obj_psupply,device_psupply);
        elapsed_time=toc;tic;
        charge(end+1)=charge(end)+meas_current*elapsed_time;
        current(end+1)=meas_current;
        voltage(end+1)=meas_voltage;
        time(end+1)=time(end)+elapsed_time;
        update_plots(plot_ctrl,charge,voltage,current,temperature,time)
    end 
    while(meas_current<=end_current)
        drawnow
        if or(stop_var,over_temperature_var)
            break;
        end        
        % load not checked to safe time
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
    disp('finishedCharging')
end

