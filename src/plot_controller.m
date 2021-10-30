classdef plot_controller
    %plot_controller: responsible to represent the measured live data.
    
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
            xlabel('time / s');
            ylabel('charge / C');
            title('Cell charge over time');
            subplot(2,2,2);
            plot(time,temperature);
            xlabel('time / s');
            ylabel('temperature / °C');
            title('Cell temperature over time');
            subplot(2,2,[3,4]);
            xlabel('time / s');
            yyaxis left
            plot(time,voltage);
            ylabel('voltage / V')
            yyaxis right
            plot(time,current);
            ylabel('current / A')
            legend('voltage','current')
        end
    end
end

