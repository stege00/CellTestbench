function run_profile(com_load,com_psupply,com_temperature,discharge_voltage,charge_voltage,discharge_current,charge_current,profile,frequency)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
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
    
    tic
    [voltage_meas,current_meas]=get_psupplyValues(obj_psupply,device_psupply);
    voltage=[voltage_meas];
    current=[current_meas];
    charge=[0];
    temperature=[temp_calc(device_temperature)];
    time=[0];
    
    set_psupplyRemote(obj_psupply,device_psupply,1);       
    set_psupplyOutput(obj_psupply,device_psupply,0);
    set_psupplyVoltage(obj_psupply,device_psupply,charge_voltage);
    set_psupplyCurrent(obj_psupply,device_psupply,charge_current);
    set_loadInput(obj_load,device_load,0);
    set_loadCurrent(obj_load,device_load,discharge_current);
    set_loadUVP(obj_load,device_load,discharge_voltage);
    set_loadVoltage(obj_load,device_load,discharge_voltage);
    set_loadOCP(obj_load,device_load,discharge_current);
    set_loadMode(obj_load,device_load,0);

    elapsed_time=toc;
    tic
    while(len(time)<=len(profile))
        drawnow
        if or(stop_var,over_temperature_var)
            break;
        end

        if (profile(len(time))<0)
            set_psupplyOutput(obj_psupply,device_psupply,0);
            set_loadCurrent(obj_load,device_load,-profile(len(time)));
            set_loadInput(obj_load,device_load,1);
            meas_voltage=meas_loadVoltage(obj_load,device_load);
            meas_current=meas_loadCurrent(obj_load,device_load);
        else
            set_loadInput(obj_load,device_load,0);
            set_psupplyCurrent(obj_psupply,device_psupply,profile(len(time)));
            set_psupplyOutput(obj_psupply,device_psupply,1);
            [meas_voltage,meas_current]=get_psupplyValues(obj_psupply,device_psupply);
        end
        while(toc<1/frequency)
            drawnow
            if or(stop_var,over_temperature_var)
                break;
            end
            pause(0.01)
        end

        elapsed_time=toc;tic;
        temperature(end+1)=temp_calc(device_temperature);
        charge(end+1)=charge(end)+meas_current*elapsed_time;
        current(end+1)=meas_current;
        voltage(end+1)=meas_voltage;
        time(end+1)=time(end)+elapsed_time;
        update_plots(plot_ctrl,charge,voltage,current,temperature,time)

    end
delete(instrfindall)    
end