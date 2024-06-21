%Calculation of operational costs for PHB-phase of two-stage simulations 

%On this work, the bioreactor operation costs for anaerobic conditions were calculated 
%directly with excel equations written on the excel files with the full tables, 
%but they can also be calculated with the following MATLAB algorithm. 
%This algorithm calculates the costs with aeration, agitation and cooling for 
%the two-stage production simulations, under anaerobic conditions. To use this algorithm, 
%first run the desired DFBA simulation in MATLAB. With that, run this algorithm and 
%the aeration, agitation and cooling costs will be calculated.

% Bioreactor dimensions:
% Height of the bioreactor = 15 m
% Height of medium in the bioreactor = 10.19 m
% Bioreactor diameter = 5 m                                                                                             % Bioreactor impeller diameter = 2.25 m
% Bioreactor area = 19.63 m2
% Volume of medium in the bioreactor = 200000 L = 200 m3

% Medium properties and operational conditions:
% Mineral medium estimated density = 1032 kg/ m3

% Hydrostatic pressure in the bottom of the bioreactor = 1032 * 9.81*10.19 = 103162.74 pa = 1.02 atm
% Absolute pressure in the bottom of the bioreactor (Preact) = 263200 pa = 2.60 atm 


%PHB concentration for each time step:
concentration_PHB = y(:,4);

% Volume of medium in the bioreactor:
volume = 200000;% L                                                                      volume = 200000; % L

% Aeration costs:

% Zero, as there is no aeration for the anaerobic cultures.

% Agitation costs:

% Agitation of 50 rpm was assumed. With this agitation and the medium properties being similar to those of water, the Reynolds number (Re) calculated is 4336335, therefore, a turbulent flow. Choosing a flat-blade impeller (W/D=1/5), the power number (c) is then 4. With that, the power for stirring can be calculated:
% Power = (4)*(1032 kg/m3)*(0.83 s?1)^3*(2.25 m)^5
% Power = 136108.9  W
% Power = 136.1 kW

% With the stirring power needed, the energy for stirring is calculated by multiplying it by the duration time of the growth phase (t_OP) from the simulation.
t_OP = t((find((round(diff(concentration_PHB),4)<0.01), 1)));                                                                
EStotal = 136.1*t_OP;
Cost_agi = EStotal*0.126;

% Cost of cooling:
So = y(1,2);  %initial glucose concentration in mmol/L                              
glucose_consumed = (So*volume)/1000;   % mols                                                                                
EMtotal = (glucose_consumed*235)/3600;    % kWh                                                                      
Cost_cool = (0.126/0.7)*(EStotal + EMtotal);

% Print results:
Cost_agi
Cost_cool
