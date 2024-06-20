%extra, adapting this script to Rafael´s MATLAB program
concentration_X = y(:,1);
volume = 200000; %volume fixo para batelada nesse estudo em litros
%custo de aeração:
% Oxygen uptake rate OUR mmolO2/l.h
OUR  = 15 * concentration_X ; %observar qual organismo, 15 para coli, 5 para necator, 1.5 para  S. cerevisiae. %14.8 or 15 para p. putida
% ideia antiga: oxygen molar rate molO2/s que precisa ser fornecido. Concentração de O2 na inlet % % % % % (condições ambientes) é de 8.4 mmol/l, e caso o tempo de residência e mistura fosse alta o %suficiente, o ar na saída do reator sairia em equilíbrio com a concentração de O2 no meio de %cultivo (0.1 mmol/l) do reator (37 Celsius, 2,27 atm), sendo assim, a concentração de O2 na %saída de gas seria de 3.85 mmol/l. Isso implica numa transferência de 54% do oxigênio da %entrada para o meio de cultivo. Assumindo transferência um pouco a baixo da ideal, de 48% %dos mols de o2 indo da bolha pro meio, os cálculos a seguir foram feitos. Referências, %capitulo 8 oxygen transfer um bioreactors, e tabela sobre Henry´s law do Wikipedia.
%ideia nova: o paper methods for treating wastewater from industry relata uma eficiência de transferência de oxigênio de 5 a 15%, e o artigo da InforsHT 
%https://www.infors-ht.com/en/blog/what-is-a-bioreactor-and-how-does-it-work/
%menciona uma vazão de ar usual de 1 a 1.5 vvm, logo irei usar uma eficiência de transferência de oxigênio de 20%
no2 = ((((OUR .* volume)./1000)./3600)./0.20);
% O2 flow rate m3/s
Qo2_in = ((no2*0.082* 298.15)./1)./1000;
% air flow rate m3/s in the inlet
Qair_in = Qo2_in./0.21;
% air flow rate m3/s in the outlet
Qair_out = ((1* Qair_in)./298.15)*(310.15/2.60);
%power consumption of the compressor (pc)  kW:
Pc = ((101325* Qair_in )*(1.4/(1.4-1))*(((263200/101325)^((1.4-1)/1.4)) - 1)*(1/0.7)./1000);
%energy consumption of the compressor (EC = ?PC.?t) kWh
Ec = Pc*h;
%total energy consumption of the compressor (EC = ?PC.?t) kWh
%Ec_seg = Ec(1:224);
Ec_seg = Ec(1:(find((round(diff(concentration_X),4)<0.0001), 1)));
Ectotal = sum(Ec_seg);       %verificar até que ponto vai a fase exponencial
% total volume of oxygen supplied std (21.1 celsius e 1 atm) m3 , não preciso levar em %consideração porque não estou fornecendo oxigênio puro no reator.
%molso2 = (OUR .* volume*0.1)./1000;
%molso2_seg = molso2(1:x);
%molso2_total = sum(molso2_seg);     %verificar até que ponto vai a fase exponencial
%Vo2 = (molso2_total*0.082*294.25)/1;
%Cost_aera = 0.52* (Vo2/1000) + 0.126* Ectotal;
Cost_aera = 0.126* Ectotal;
%cost of agitation
%C o2 no meio constante de 0.1 mmol/l = 3.2 mg/l
%C o2 na saturação para 37 celsius é de 6.71 mg/l = 0.21 mmol/l
kla = ((OUR./( 0.21 - 0.1))./3600);     % kla na unidade de s-1
Vsuper = ((Qair_out)./19.63);            %velocidade superficial do gas em m/s
% Ps = (exp(((log((kla./3600)*(200^0.7)))./(0.002*(Vsuper.^0.2)))./0.7));  %essa equação dava %errada no matlab
Ps = (((kla.*(((volume./1000).^0.7))./(0.002 *((Vsuper).^0.2)))).^(10/7)); % gassed power input %em W
%energy consumption of the stirrer (Es = ?Ps.?t) kWh
Es = (Ps./1000)*h;
%total energy consumption of the stirrer (Es = ?Ps.?t) kWh
%Es_seg = Es(1:224);
Es_seg = Es(1:(find((round(diff(concentration_X),4)<0.0001), 1)));
Estotal = sum(Es_seg);           %verificar até que ponto vai a fase exponencial
Cost_agi = Estotal*0.126;

% custo de refrigeração
Qheat = (0.50*OUR.*volume)./3600;    % Qheat em kW
%energy consumption of the cooling system kWh
Em = Qheat*h;
%total energy consumption of the cooling system kWh
%Em_seg = Em(1:224);
Em_seg = Em(1:(find((round(diff(concentration_X),4)<0.0001), 1)));
Emtotal = sum(Em_seg); %verificar até que ponto vai a fase exponencial
Cost_cool = (0.126/0.7)*(Estotal + Emtotal);
Cost_aera;
Cost_agi;
Cost_cool;
Cost_operation = [Cost_aera Cost_agi Cost_cool];