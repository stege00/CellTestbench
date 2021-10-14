classdef plot_controller
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fig
    end
    
    methods
        function [obj] = generate_plots(obj)
            %generate_plots: generates and prepares figures
            % needs: obj
            obj.fig = figure;
            subplot(2,2,1);
            xlabel('time / s');
            ylabel('charge / C');
            title('Cell charge over time');

            subplot(2,2,2);
            xlabel('time / s');
            ylabel('temperature / °C');
            title('Cell temperature over time');

            subplot(2,2,[3,4]);
            xlabel('time / s');
            title('Cell current and voltage over time');
            yyaxis left
            ylabel('voltage / V')
            yyaxis right
            ylabel('current / A')
        end
        
        function update_plots(obj,charge,voltage,current,temperature,time)
            %update_plots: called every loop iteration to update plots
            % needs: obj,charge,voltage,current,temperature,time
            subplot(2,2,1);
            plot(time,charge);
            subplot(2,2,2);
            plot(time,temperature);
            subplot(2,2,[3,4]);
            yyaxis left
            plot(time,voltage);
            yyaxis right
            plot(time,current);
            legend('voltage','current')
        end
    end
end

