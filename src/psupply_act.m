% Script with power supply actuator
%
% To find further information on sending and recieving telegrams take a look at the 
% Official user guide called programming with interface cards or the hand-over document 
%
% s = serialport(port,baudrate)
% Device node = 5

classdef psupply_act
    properties
        
    end
    methods   
% to find further information on sending and recieving telegrams take a look at the 
% official user guide called programming with interface cards or the hand-over document

function set_psupplyRemote(obj,s,value)
remoteON = [209,5,54,16,16,1,44];
remoteOFF = [209,5,54,16,0,1,28];
setOVP = [209,5,38,5,64,1,29];%ovp auf 4.2 V
fopen(s);
if (value == 1)
        fwrite(s,remoteON,"uint8")
		%fwrite(s,setOVP,"uint8")
else
        fwrite(s,remoteOFF,"uint8");
end
fclose(s);
end

function set_psupplyOutput(obj,s,value)
 outputON = [209,5,54,17,17,1,46];    
 outputOFF = [209,5,54,17,16,1,45];   
fopen(s);
 if (value == 1)
    fwrite(s,outputON,"uint8");
else
    fwrite(s,outputOFF,"uint8");
end
fclose(s);
end

function set_psupplyVoltage(obj,s,value)
V_nom = 80.0;
V_percent = int16((value / V_nom) * 25600);
send_byte  = [0 0];
send_byte = int2arr(obj,V_percent);
checksum = int16(209 + 5 + 50 + send_byte(1) + send_byte(2));
checksumByte = [0 0];
checksumByte = int2arr(obj,checksum);
setVoltage = [ 209, 5, 50, send_byte(1), send_byte(2), checksumByte(1), checksumByte(2) ];
fopen(s);
fwrite(s,setVoltage,"uint8");
fclose(s);
end

function set_psupplyCurrent(obj,s,value)
I_nom = 60.0;
value=value/2; %da 2 netzteile
I_percent = int16((value / I_nom) * 25600);
sendByte  = [0 0];
sendByte = int2arr(obj,I_percent);
checksum = int16(209 + 5 + 51 + sendByte(1) + sendByte(2));
checksumByte = [0 0];
checksumByte = int2arr(obj,checksum);
setCurrent = [ 209, 5, 51, sendByte(1), sendByte(2), checksumByte(1), checksumByte(2) ]
fopen(s);
fwrite(s,setCurrent,"uint8");
fclose(s);
end

function real_values = get_psupplyValues(obj,s)
request = [85,5,71,0,161];   
fopen(s);
fwrite(s,request,"uint8");
answer=fread(s,11,"uint8");
fclose(s);
% extracting Data bytes from telegram
data=answer(4:9);
% extracting real values from Data
voltage_percent=arr2int(obj,data(1:2));
voltage_real=voltage_percent*80/25600;
current_percent=arr2int(obj,data(3:4));
current_real=current_percent*60/25600;
% output
real_values=[voltage_real,current_real];
end

 function set_psupplyMode(obj,s,value)
    fopen(s);
    request=[81,5,70,0,156];
    fwrite(s,request,"uint8");
    answer=fread(s,7,"uint8")
    setMode=[209,5,70,answer(4)]
    if (value == 1)%CV
        dataByte2=bitand(answer(5),249)
    else %cc
        dataByte2=bitor(answer(5),4)
    end
    checksum=209+5+70+answer(4)+dataByte2
    csbytes=int2arr(obj,checksum);
    setMode(5:7)=[dataByte2,csbytes(1),csbytes(2)]
    fwrite(s,setMode,"uint8");
    fclose(s);
 end

function out = int2arr(obj,value)
temp = dec2bin(value,16);
out = [0 0]; %higherbyte lowerbyte
out(1) = bin2dec(temp(1:8));
out(2) = bin2dec(temp(9:16));
end

function out = arr2int(obj,value)
temp1=dec2bin(value(1),8);
temp2=dec2bin(value(2),8);
temp=strcat(temp1,temp2);

out=bin2dec(temp);    
end
    
    end
end