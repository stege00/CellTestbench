function record_ocv(com_load,com_psupply,com_temperature,discharge_voltage,charge_voltage,discharge_current,charge_current,end_current,discharge_time,ocv_time)
% record_ocv: records open circuit voltage curves of cell
    global stop_var
    global over_temperature_var

    % set up serial devices and start values
    device_load=serial(com_load,'BaudRate',115200);
    obj_load=load_act;
    device_psupply=serial(com_psupply,'BaudRate',57600);
    obj_psupply=psupply_act;
    set_psupplyRemote(obj_psupply,device_psupply,1);
    device_temperature=serialport(com_temperature,9600);
    start_charge=0;
    start_time=0;
    plot_ctrl=plot_controller;
    generate_plots(plot_ctrl);

    % charge cell to get into starting conditions to record ocv
    chargeCell(device_load,obj_load,device_psupply,obj_psupply,device_temperature,charge_voltage,charge_current,start_charge,start_time,end_current,plot_ctrl)

    meas_voltage=meas_loadVoltage(obj_load,device_load);
    meas_current=meas_loadCurrent(obj_load,device_load);
    start_temperature=temp_calc(device_temperature);

    temperature=[start_temperature];
    charge=[start_charge];
    current=[meas_current];
    voltage=[meas_voltage];
    time=[start_time];    

    % set up starting configuration of serial devices
    set_psupplyOutput(obj_psupply,device_psupply,0);
    set_loadInput(obj_load,device_load,0);
    set_loadCurrent(obj_load,device_load,discharge_current);
    set_loadUVP(obj_load,device_load,discharge_voltage);
    set_loadVoltage(obj_load,device_load,discharge_voltage);
    set_loadOCP(obj_load,device_load,discharge_current);
    set_loadMode(obj_load,device_load,0);
    
    while(voltage(end)>=discharge_voltage)
        % check termination condition
        drawnow
        if or(stop_var,over_temperature_var)
            break;
        end

        % set to discharge
        set_loadInput(obj_load,device_load,1);
        tic
        while(toc<discharge_time)
            drawnow
            if or(stop_var,over_temperature_var)
                break;
            end
            % measure + update data & plots
            meas_temperature=temp_calc(device_temperature);
            meas_voltage=meas_loadVoltage(obj_load,device_load);
            meas_current=meas_loadCurrent(obj_load,device_load);
            time(end+1)=toc;
            elapsed_time=time(end)-time(end-1);
            charge(end+1)=charge(end)-meas_current*elapsed_time;
            current(end+1)=meas_current;
            voltage(end+1)=meas_voltage;
            temperature(end+1)=meas_temperature;

            update_plots(plot_ctrl,charge,voltage,current,temperature,time)
        end
        % set to hold
        set_loadInput(obj_load,device_load,0);
        tic
        while(toc<ocv_time)
            drawnow
            if or(stop_var,over_temperature_var)
                break;
            end
            % measure + update data & plots
            meas_temperature=temp_calc(device_temperature);
            meas_voltage=meas_loadVoltage(obj_load,device_load);
            meas_current=meas_loadCurrent(obj_load,device_load);
            time(end+1)=toc;
            elapsed_time=time(end)-time(end-1);
            charge(end+1)=charge(end)-meas_current*elapsed_time;
            current(end+1)=meas_current;
            voltage(end+1)=meas_voltage;
            temperature(end+1)=meas_temperature;
            update_plots(plot_ctrl,charge,voltage,current,temperature,time)
        end
    end
    save_data([charge,current,voltage,temperature,time]);
    disp('finishedRecordingOCV');
    delete(instrfindall)
end

