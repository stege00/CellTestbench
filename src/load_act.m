classdef load_act
% Script with electric load actuator
% s = serialport(port,baudrate)
    
    properties
        
    end
    
    methods
        
        function set_loadInput(obj,s,value)
        % 1 = On, 0 = Off
            if s.Status~="open"
                fopen(s);
            end
            if (value == 1)
                fprintf(s,'INP ON\n');%OUTPKeysight
            else
                fprintf(s,'INP OFF\n');%OUTPKeysight
            end
            fclose(s);
        end
        
        function set_loadMode(obj,s,value)
            % 1 = CV, 0 = CC
            fopen(s);
            if (value == 1)
                fprintf(s,'FUNC:MODE VOLT\n');
            else
                fprintf(s,'FUNC:MODE CURR\n');
            end
            fclose(s);
        end
        
        function set_loadCurrent(obj,s,value)
            fopen(s);
            tmp = string(value);
            tmp = ' '+ tmp;
            temp = strcat('Curr ',tmp,'\n');
            temp = char(temp);
            fprintf(s,temp);
            fclose(s);
        end
        
        function set_loadVoltage(obj,s,value)
            fopen(s);
            tmp = string(value);
            tmp = ' '+ tmp;
            temp = strcat('Volt ',tmp,'\n');
            temp = char(temp);
            fprintf(s,temp);
            fclose(s);
        end
        
        function set_loadOCP(obj,s,value)
            fopen(s);
            tmp = string(value);
            tmp = ' '+ tmp;
            temp = strcat('CURR:PROT ',tmp,'\n');
            temp = char(temp);
            fprintf(s,temp);
            fclose(s);
        end

        function set_loadUVP(obj,s,value)
            fopen(s);
            tmp = string(value);
            tmp = ' '+ tmp;
            temp = strcat('VOLT:PROT ',tmp,'\n');
            temp = char(temp);
            fprintf(s,temp);
            fclose(s);
        end

        function out = meas_loadCurrent(obj,s)
            fopen(s);
            fprintf(s,'MEAS:CURR?\n');
            out = fscanf(s);
            out=str2double(out);
            fclose(s);
        end

        function out = meas_loadVoltage(obj,s)
            fopen(s);
            fprintf(s,'MEAS:VOLT?\n');
            out = fscanf(s);
            out=str2double(out);
            fclose(s);
        end

    end
end

