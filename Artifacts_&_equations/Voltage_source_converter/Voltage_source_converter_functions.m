% PLL
function [ud, uq, thetaPLL] = pll(Ki, Kp, Vm, Va, theta, xPLL)
Ki = Pvsc(:,p.Ki);
Kp = Pvsc(:,p.Kp);
Vm     = V(vidx_Vm,1);
Va     = V(vidx_Va,1);    
theta = X(xidx.thetaPLL,1);
xPLL  = X(xidx.xPLL,1);

ud = Vm .* cos(Va-theta);
uq = Vm .* sin(Va-theta); 
dwPLL =  Kp .* uq + Ki .* xPLL;
dx(thetaPLL) = dwPLL;
end

%% Outer Control
function [Idref, Iqref] = limiter_outerControl(Imaxd)
idx_bool_imaxd = abs(i_dpr_ref) > Imaxd;
i_dpr_ref = sign(i_dpr_ref(idx_bool_imaxd)).*Imaxd(idx_bool_imaxd);

idx_bool_imaxq = abs(i_qpr_ref) > Imaxq;
i_qpr_ref(idx_bool_imaxq) = sign(i_qpr_ref(idx_bool_imaxq)).*Imaxq(idx_bool_imaxq);

Idref   = i_dpr_ref; 
Iqref   = i_qpr_ref;  
end

% Type 1 Active power control and AC voltage regulation
function [IdrefOut,IqrefOut] = OuterCotrol1(Kawd, Kawq, Kp_d, Kp_q, Ki_d, Ki_q, b_sw,Pac, vd, Uref, Pref, Id0, Iq0)
%Calculate Changes of Statevariables
deltaP   = (Pref-Pac);
deltaUac = (Uref-vd);
dNd = (deltaP   + Kawd.*deltaId(type1,1)) .* (Ki_d ~= 0);
dNq = (deltaUac - Kawq.*deltaIq(type1,1)) .* (Ki_q ~= 0);

%OuterControl State Variables
dx(Nd) = dNd;
dx(Nq) = dNd;

%Calculate algebraic equations
deltaP   =   b_sw.*Pref - Pac;
deltaUac =   Uref - vd;

%return Values
IdrefOut(type1,1) =  Ki_d.*Nd+Kp_d.*deltaP    + Id0 ;
IqrefOut(type1,1) =-(Ki_q.*Nq+Kp_q.*deltaUac) + Iq0 ;
end

% Type 2 DC and AC voltage regulation
function [IdrefOut,IqrefOut] = OuterCotrol2(Kawd, Kawq, Kp_d, Kp_q, Ki_d, Ki_q, b_sw, Udc_ref, vd, Uref, U_dc, Id0, Iq0)

%Calculate Changes of Statevariables
deltaUdc = (Udc_ref-U_dc);
deltaUac = (Uref-vd);
dNd= (deltaUdc  - Kawd.*deltaId(type2,1))  .* (Ki_d ~= 0);
dNq= (deltaUac  - Kawq.*deltaIq(type2,1))  .* (Ki_q ~= 0);

%OuterControl State Variables
dx(Nd) = dNd;
dx(Nq) = dNd;

%Calculate algebraic equations
deltaUdc = (b_sw.*Udc_ref-U_dc);
deltaUac = (Uref - vd);

%return Values
IdrefOut(type2,1) = -(Ki_d.*Nd + Kp_d.*deltaUdc) + Id0;
IqrefOut(type2,1) = -(Ki_q.*Nq + Kp_q.*deltaUac) + Iq0;

end

% Type 3 Active and reactive power control
function [IdrefOut,IqrefOut] = OuterCotrol3(Kawd, Kawq,Kp_d, Kp_q, Ki_d, Ki_q, ff_d, ff_q, b_sw, Pref, Qref, Pac, Qac, vd, Id0, Iq0)

deltaP = (Pref-Pac);
deltaQ = (Qref-Qac);

%Calculate Changes of Statevariables
dNd = (deltaP + Kawd.*deltaId(type3,1))  .* (Ki_d ~= 0);
dNq = (deltaQ - Kawq.*deltaIq(type3,1))  .* (Ki_q ~= 0);

%OuterControl State Variables
dx(Nd) = dNd;
dx(Nq) = dNd;

%Calculate algebraic equations
deltaP = b_sw.*Pref - Pac;
deltaQ = Qref - Qac;

%return Values
IdrefOut(type3,1) =  Ki_d.*Nd+Kp_d.*deltaP  + ~ff_d.*Id0 + ff_d.*  Pref./vd;
IqrefOut(type3,1) =-(Ki_q.*Nq+Kp_q.*deltaQ) + ~ff_q.*Iq0 - ff_q.*  Qref./vd;

end

% Type 4 DC voltage regulation and reactive power control
function [IdrefOut,IqrefOut] = OuterCotrol4(Kawd, Kawq,Kp_d, Kp_q, Ki_d, Ki_q, ff_q, b_sw, Udc_ref, Qref, Qac, vd,U_dc, Id0, Iq0)
%Calculate Changes of Statevariables
deltaUdc = (Udc_ref-U_dc);
deltaUac = (Uref-vd);
dNd= (deltaUdc  - Kawd.*deltaId(type2,1))  .* (Ki_d ~= 0);
dNq= (deltaUac  - Kawq.*deltaIq(type2,1))  .* (Ki_q ~= 0);
    
%OuterControl State Variables
dx(Nd) = dNd;
dx(Nq) = dNq;

%Calculate algebraic equations
deltaUdc = (b_sw.*Udc_ref - U_dc);
deltaQ   = (Qref    - Qac);

%return Values
IdrefOut(type4,1)  = -(Ki_d.*Nd + Kp_d.*deltaUdc) + Id0;
IqrefOut(type4,1)  = -(Ki_q.*Nq + Kp_q.*deltaQ  ) + ~ff_q.*Iq0 - ff_q.*Qref./vd;
end 

% Initialization
function [Pref, Pref0,Vref, Nd, Nq, Idref0, Iqref0, Id0, Iq0 ] = initialization_outerControl1(b_sw,Id0, Iq0,Vm)
% algebr. Variables
vd0   = Vm;
vq0   = 0;
i_dpr0 = Id0;
i_qpr0 = Iq0;


Kp_d=Pout;
b_sw=Pout;
% set References
Pref = 3/3 * (vd0.*i_dpr0 + vq0.*i_qpr0);
Uref = vd0;

% Initial states
Nd0 =0;
Nq0 =0;

% Calculate initial values
i_dpr_ref=i_dpr0;
i_qpr_ref=i_qpr0;

% return values
Pref  = Pref;
Pref0  = Pref;
Vref  = Uref;
Nd  = Nd0;
Nq  = Nq0;
Idref0 = i_dpr_ref;
Iqref0 = i_qpr_ref;
Id0 = i_dpr0 + (1-b_sw).*Kp_d.*Pref;
Iq0 = i_qpr0;
end

function [Udcref, Udcref0,Vref, Nd, Nq, Idref0, Iqref0, Id0, Iq0 ] = initialization_outerControl2(b_sw,Id0, Iq0,Vm, Udc, Kp_d)
% algebr. Variables
U_dc0 = Udc;
vd0   = Vm;
i_dpr0 = Id0;
i_qpr0 = Iq0;

% set References
Udc_ref = U_dc0;
Uref    = vd0;

% Initial states
Nd0=0;
Nq0=0;

% Calculate initial values
i_dpr_ref=i_dpr0;
i_qpr_ref=i_qpr0;

% return values
Udcref  = Udc_ref;
Udcref0 = Udc_ref;
Vref  = Uref;
Nd  = Nd0;
Nq  = Nq0;
Idref0 = i_dpr_ref;
Iqref0 = i_qpr_ref;
Id0 = i_dpr0 - (1-b_sw).*Kp_d.*Udc_ref;
Iq0 = i_qpr0;
end

function [Pref, Pref0,Qref, Qref0, Nd, Nq, Idref0, Iqref0, Id0, Iq0 ] = initialization_outerControl3(b_sw,Id0, Iq0,Vm, Kp_d, ff_d, ff_q)
% variables
vd0   = Vm;
vq0   = 0;
i_dpr0 = Id0;
i_qpr0 = Iq0;

%Control Parameters
Kp_d=Pout(type3,p.KpP);
ff_d =Pout(type3,p.ffd);
ff_q =Pout(type3,p.ffq);
b_sw=Pout(type3,p.b_sw);
        
% set References
Pref= 3/3 * ( vd0.*i_dpr0 + vq0.*i_qpr0);
Qref= 3/3 * (-vd0.*i_qpr0 + vq0.*i_dpr0);

% Initial states
Nd0=0;
Nq0=0;

% Calculate initial values
i_dpr_ref=i_dpr0;
i_qpr_ref=i_qpr0;
        
% return values
Pref  = Pref;
Pref0  = Pref;
Qref  = Qref;
Qre0  = Qref;
Nd  = Nd0;
Nq  = Nq0;
Idref0 = i_dpr_ref;
Iqref0 = i_qpr_ref;
Id0 = ~ff_d.*i_dpr0 + (1-b_sw).*Kp_d.*Pref;
Iq0 = ~ff_q.*i_qpr0;
end

function [Pref, Pref0,Qref, Qref0, Nd, Nq, Idref0, Iqref0, Id0, Iq0 ] = initialization_outerControl4(b_sw,Id0, Iq0,Vm, Udc, Kp_d, ff_d, ff_q)
% variables
vd0    = Vm;
vq0    = 0;
i_dpr0 = Id0;
i_qpr0 = Iq0;
U_dc0  = Udc;
        
%Control Parameters
Kp_d=Pout(type4,p.KpDC);
ff_d =Pout(type4,p.ffd);
ff_q =Pout(type4,p.ffq);
b_sw=Pout(type4,p.b_sw);
        
% set References
Udc_ref = U_dc0;
Qref    = -vd0.*i_qpr0 + vq0.*i_dpr0;

% Initial States
Nd0 =0;
Nq0 =0;

% Calculate initial values
i_dpr_ref=i_dpr0;
i_qpr_ref=i_qpr0;
        
% return values
Udcref  = Udc_ref;
Udcref0 = Udc_ref;
Qref  = Qref;
Qref0 = Qref;
Nd  = Nd0;
Nq  = Nq0;
Idref0 = i_dpr_ref;
Iqref0 = i_qpr_ref;
Id0 = ~ff_d.*i_dpr0 - (1-b_sw).*Kp_d.*Udc_ref;
Iq0 = ~ff_q.*i_qpr0;
end

%% Inner Control
function [EdrefInn, EqrefInn] = InnerControl(Kp_q, Kp_d, Ki_q, Ki_d, X_pr, i_dpr, i_qpr, i_dpr_ref, i_qpr_ref, Ed0, Eq0, Ud, Uq)    
dx(Md) = dMd;
dx(Mq) = dMq;

dMd=(i_dpr_ref-i_dpr);
dMq=(i_qpr_ref-i_qpr);

EdrefInn = (Kp_d.*dMd+Ki_d.*Md + Ed0 - i_qpr.*X_pr + ud); % with feed forward
EqrefInn = (Kp_q.*dMq+Ki_q.*Mq + Eq0 + i_dpr.*X_pr + uq); % with feed forward
end

% Initilization: Id0, Iq0 and U0 are values set by other models
function [Ed0, Eq0, Id, Iq, Edref, Eqref, EdrefInn, EqrefInn] = initialize_innerControl(R_pr, X_pr, Id0, Iq0, U0)
i_dpr=Id0;
i_qpr=Iq0;
Ed0=R_pr*i_dpr;
Eq0=R_pr*i_qpr;

Md = Ed0*0;
Mq = Eq0*0;

% Calculate initial values
vd0 = U0;    %Set d reference to terminal voltage
vq0 = 0;               %Set q reference to terminal voltage
ed0 = (R_pr*i_dpr-X.*i_qpr+vd0);%
eq0 = (R_pr*i_qpr+X.*i_dpr+vq0);

Ed0  = Ed0;
Eq0  = Eq0;
Id   = i_dpr;
Iq   = i_qpr;
Edref    = ed0;
Eqref    = eq0;
EdrefInn = ed0;
EqrefInn = eq0;    
end

%% VSC-model
function [Edref, Eqref] = voltageLimiter(EdrefInn, EqrefInn, Udc, M)
% Limiting valve voltages
Eabs = abs(EdrefInn + 1i*EqrefInn);
Emax = Udc.*M;
isLim = Eabs > Emax
if isLim
    Edref  = EdrefInn* Emax/Eabs;
    Eqref  = EqrefInn* Emax/Eabs;
else
    Edref  = EdrefInn;
    Eqref  = EqrefInn;
end
end

function [Ivsc, Ir, Ii] = vsc(thetaPLL, Id, Iq, Ed, Eq, ud, uq, R_pr, X_pr, kUdc, Ta)
id     = Id;
iq     = Iq;
ed     = Ed;
eq     = Eq;
theta  = thetaPLL;

Uconvd = ed + Udc.*kUdc;
Uconvq = eq + Udc.*kUdc;
    
% Simplified valve control
ded=1./Ta.*(edref - Uconvd);
deq=1./Ta.*(eqref - Uconvq);
dx(Ed) = ded;
dx(Eq) = deq;

% Taking the 'real' AC Terminal phase since it is about the physical behavior
di_dpr =omegas./X_pr.*(-R_pr.*i_dpr+i_qpr.*X_pr + Uconvd-ud);
di_qpr =omegas./X_pr.*(-R_pr.*i_qpr-i_dpr.*X_pr + Uconvq-uq);
dx(Id) = di_dpr;
dx(Iq) = di_qpr;

Pac = ud.*id + uq.*iq;    
%Pr  = (id.^2+iq.^2).*R_pr;         
%Pl = Ldi_dpr .* id + Ldi_qpr .* iq;
Pdc = -(Uconvd.*id + Uconvq.*iq);
Ivsc = Pdc ./ Udc;    
%delta = Pac + Pr + Pl + Pdc;
Ir = id.*cos(theta) - iq.*sin(theta);
Ii = iq.*cos(theta) + id.*sin(theta);
end

function [Vm, Va, U0, Udc, Pdc, Ud, Uq, Pac, Ivsc, theta, Edref, Eqref, Id, Iq, Eq, Ed] =...
    initialize_vsc(SS_PCC_Vm,SS_PCC_Va,SS_PCC_P,SS_PCC_Q, R_pr, X_pr)
% Steady State values at the AC PCC    
% Voltage magnitude
Vm = SS_PCC_Vm;
% Voltage angle
Va = SS_PCC_Va;
% Voltage at t = 0
U0 = Vm.*exp(1i.*Va);
% Injected Power at PCC from loadflow calculation
P0 = SS_PCC_P;
Q0 = SS_PCC_Q;
S0   = P0+1i.*Q0;
Ia0 = conj(S0./U0);
E0  = U0+Ia0.*(R_pr+1i.*X_pr);

Pdc0= -real(E0 .* conj(Ia0));
Udc0 = X(xidx.VSC.Udc);
Ivsc0 = Pdc0./Udc0;

Udc  = Udc0;
Pdc  = Pdc0;
Ud  = Vm;
Uq  = 0;
Pac  = P0;
Ivsc = Ivsc0;

%Ac side

vd0   = Vm;    %Set d reference to terminal voltage
vq0   = 0          ; %Set q reference to terminal voltage
theta = Va;

i_dpr =   P0(type1,1)./vd0;
i_qpr = - Q0(type1,1)./vd0;
ed0 = (R_pr.*i_dpr-X_pr.*i_qpr+vd0);%
eq0 = (R_pr.*i_qpr+X_pr.*i_dpr+vq0);
Ivsc_ac = (i_dpr+1i.*i_qpr).*exp(1i.*theta);

Edref   = ed0;
Eqref   = eq0;
Id   = i_dpr; % Id0
Iq   = i_qpr; %Iq0
Ed   = ed0 - Udc0.*kUdc;
Eq   = eq0 - Udc0.*kUdc;
Ir   = real(Ivsc_ac);
Ii   = imag(Ivsc_ac);
end



