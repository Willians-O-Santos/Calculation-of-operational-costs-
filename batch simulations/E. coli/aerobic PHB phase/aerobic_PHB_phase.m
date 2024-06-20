%Calculation of operational costs for aerobic simulations during PHB phase


%The following algorithm is used to calculate the costs with aeration, agitation and
%cooling for the PHB production phase of each two-stage production simulations, under
%aerobic conditions. In order to use this algorithm, first run the desired DFBA 
%simulation in MATLAB. With that, run this algorithm and the aeration, 
%agitation and cooling costs will be calculated.


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


%biomass concentration for each time step:
concentration_X = y(:,1);

%PHB concentration for each time step:
concentration_PHB = y(:,4);

% Volume of medium in the bioreactor:
volume = 200000;% L

% Aeration costs:
% Oxygen uptake rate OUR mmolO2/L.h:
OUR  = 15 * concentration_X ; 

% Oxygen molar rate molO2/s that needs to be delivered to the bioreactor. 
%Assuming a transfer of 20% of the oxygen mols from the bubble to the medium, 
%the following calculations were made.
no2 = ((((OUR .* volume)./1000)./3600)./0.20);

% O2 flow rate m3/s
Qo2_in = ((no2*0.082* 298.15)./1)./1000;

% air flow rate m3/s in the inlet
Qair_in = Qo2_in./0.21;

% air flow rate m3/s in the outlet
Qair_out = ((1* Qair_in)./298.15)*(310.15/2.60);

%power consumption of the compressor (pc)  kW:
Pc = ((101325* Qair_in )*(1.4/(1.4-1))*(((263200/101325)^((1.4-1)/1.4)) - 1)*(1/0.7)./1000);

%energy consumption of the compressor kWh
Ec = Pc*h;

%total energy consumption of the compressor kWh
Ec_seg = Ec(1:(find((round(diff(concentration_PHB),4)<0.01), 1)));
Ectotal = sum(Ec_seg);  

Cost_aera = 0.126* Ectotal;

%cost of agitation

% Concentration of O2 in the medium is constant at a chosen value of 3.2 mg/L = 0.1 mmol/L
% Concentration of O2 at saturation for 37 ◦C is = 6.71 mg/L = 0.21 mmol/L
kla = ((OUR./( 0.21 - 0.1))./3600);     % kLa in s-1
Vsuper = ((Qair_out)./19.63);           % Superficial gas velocity in m/s

Ps = (((kla.*(((volume./1000).^0.7))./(0.002 *((Vsuper).^0.2)))).^(10/7)); % gassed power input in W

% Energy consumption of the stirrer (kWh) for each time step:
Es = (Ps./1000)*h;

%total energy consumption of the stirrer kWh
Es_seg = Es(1:(find((round(diff(concentration_PHB),4)<0.01), 1)));
Estotal = sum(Es_seg);         
Cost_agi = Estotal*0.126;

% Cost of cooling:
Qheat = (0.50*OUR.*volume)./3600;    % Qheat in kW:

% Energy consumption of the cooling system (kWh) for each time step:
Em = Qheat*h;

% Total energy consumption of the cooling system kWh:
Em_seg = Em(1:(find((round(diff(concentration_PHB),4)<0.01), 1)));
Emtotal = sum(Em_seg); 
Cost_cool = (0.126/0.7)*(Estotal + Emtotal);

% Print results:
Cost_aera;
Cost_agi;
Cost_cool;
Cost_operation = [Cost_aera Cost_agi Cost_cool];
