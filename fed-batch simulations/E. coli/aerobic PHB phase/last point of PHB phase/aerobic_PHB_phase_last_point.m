%Calculation of operational costs for last point of aerobic simulations during PHB phase


%The following algorithm is used to calculate the costs with aeration, agitation and
%cooling for the past point of the PHB production phase of each two-stage production simulations, under
%aerobic conditions. In order to use this algorithm, first run the desired DFBA 
%simulation in MATLAB. With that, run this algorithm and the aeration, 
%agitation and cooling costs will be calculated.

%average biomass concentration (given initial and final volume) for last point 
%in PHB phase of fed-batch simulations, g/L
concentration_X = 0.23; 

%average volume (given initial and final volume) for last point 
%in PHB phase of fed-batch simulations, L
volume = 217500; 

VO2_max = 15; %maximum ocygen uptake for E. coli

% time as calculated with the excel formula in the last point of PHB phase 
%from fed-batch simulations excel file
t_PHB_phase = 216.66; 

% Aeration costs:
% Oxygen uptake rate OUR mmolO2/L.h:
OUR = VO2_max * concentration_X ; 

% Oxygen molar rate molO2/s that needs to be delivered to the bioreactor. 
%Assuming a transfer of 20% of the oxygen mols from the bubble to the medium, 
%the following calculations were made.
nO2 = ((((OUR * volume)./1000)./3600)./0.20); 

% O2 flow rate m3/s
QO2_in = ((nO2*0.082* 298.15)./1)./1000; 

% air flow rate m3/s in the inlet
Qair_in = QO2_in./0.21; 

% air flow rate m3/s in the outlet
Qair_out = ((1* Qair_in)./298.15)*(310.15/2.78); 

%power consumption of the compressor (pc)  kW:
Pc = ((101325* Qair_in)*(1.4/(1.4-1))*(((281200/101325)^((1.4-1)/1.4)) - 1)*(1/0.7)./1000); % power consumption of the compressor (pc), kW:

%total energy consumption of the compressor kWh
ECtotal = Pc* t_PHB_phase; 

Cost_aera = 0.126* ECtotal; 

%cost of agitation

% Concentration of O2 in the medium is constant at a chosen value of 3.2 mg/L = 0.1 mmol/L
% Concentration of O2 at saturation for 37 ?C is = 6.71 mg/L = 0.21 mmol/L
kLa = ((OUR./( 0.21 - 0.1))./3600);  % kLa in s-1  
Vsuper = ((Qair_out)./19.63);        % Superficial gas velocity in m/s

Ps = (((kLa*((volume/1000)^0.7))./( 0.002 *( (Vsuper).^0.2)))).^(10/7); % gassed power input in W      

%total energy consumption of the stirrer kWh
EStotal = (Ps./1000)* t_PHB_phase; 

Cost_agi = EStotal*0.126; 

% Cost of cooling:
Qheat = (0.50*OUR*volume)./3600; % heat released in kW

% Total energy consumption of the cooling system kWh:
EMtotal = Qheat* t_PHB_phase; 

Cost_cool = (0.126/0.7)*(EStotal + EMtotal); 

% Print results:
Cost_operation = [Cost_aera Cost_agi Cost_cool]; % all bioreactor operating costs in USD