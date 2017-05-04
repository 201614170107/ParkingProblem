% Dual pricing is modeled by considering two separate queues for the two
% different types of users.
% c1 spots for Type1 users (those with parking time < 1hr)
% c2 spots for Type2 users (those with parking time > 1hr)
% All prices are in $/hr
%Defing all the parameters required to find social utility
global c;
c=30; %total no. of parking spots
global c_1;
c_1 = 10;
global c_2;
c_2 = 20;
global mu;
mu = 1/2; % 1/2 used in paper %service time parameter for single queue scenario
global T; %mean service time of users
T = 1/mu;
global mu_1;
mu_1 = mu*(1-exp(-mu*T))/(1-exp(-mu*T)-mu*T*exp(-mu*T));
global mu_2;
mu_2 = mu/2;
global lambda;
lambda = 60/5; %rate of poisson process arrivals in single queue (per hr)
global lambda_1;
lambda_1 = lambda*(1-exp(-mu*T)); %rate of poisson process for Type1
global lambda_2;
lambda_2 = lambda*exp(-mu*T); %rate of poisson process for Type2
global P;
P = 5; %initial parking price
global P_1;
P_1 = 2; %parking price for Type1 users 
global P_2;
P_2 = 5; %parking price for Type2 users
global P_w;
P_w = 48; %price for waiting in the queue
global R;
R = 75; %reward for parking
global rho;
rho = lambda/(c*mu); %traffic intensity of single queue
global rho_1;
rho_1 = lambda_1/(c_1*mu_1); %traffic intensity of Type1 queue
global rho_2;
rho_2 = lambda_2/(c_2*mu_2); %traffic intensity of Type1 queue
global delta;
delta=0.2; %change it to p_nb1(nb1) later
global gamma;
gamma = 0; %proportion of Type1 users in Queue2
global mu_tilda;
mu_tilda = gamma*mu_1 + (1-gamma)*mu_2;
global lambda_tilda;
lambda_tilda = delta*lambda_1 + lambda_2;
global rho_tilda;
rho_tilda = lambda_tilda/mu_tilda;
global rho_hat;
rho_hat = delta*lambda_1/mu_tilda;
n_b1 = floor((R*mu_1*c_1 + P_w*c_1 - P_1*c_1)/P_w); %balking level of type1 users
n_b2 = floor((R*mu_2*mu_tilda*c_2 + P_w*mu_2*c_2 - P_2*mu_tilda*c_2)/(P_w*mu_2)); %balking level of type2 users
n_b = floor((R*mu*c + P_w*c - P*c)/P_w); %balking level in single pricing model assuming the price to be P_2

global n; %max number of customers in the system for simulation purposes
n = 120;

%Defining the acceptance rates
global kappa; %acceptance rate for type 1 cars arriving at queue 2
global zeta; %acceptance rate for type 2 cars arriving at queue 2
global psi; %overall acceptance rate for cars arriving at queue 2

utility = zeros(1,n);
utility_1 = zeros(1,n);
utility_2 = zeros(1,n);

for i=1:n
    utility(i) = findutility_n(i);
    utility_1(i) = findutility_n_1(i);
    utility_2(i) = findutility_n_2(i);
end


n1=20;
n2=30;
%Stationary distribution of queue2
p_k_n_2=zeros(1,n1+1);
d_k_2=zeros(1,n1+1);
D_n_2=0;
alpha_k_2 = zeros(1,n1+1);
for i=1:n1+1
    d_k_2(i) = findd_k_2(i-1,n2);
    D_n_2 = D_n_2+d_k_n_2(i);
end
for i=1:n1+1
    p_k_n_2(i) = d_k_2(i)/D_n_2;
    alpha_k_2(i) = findalpha_2(i-1);
end
%{
m = 33;
m_1 = 15;
m_2 = 20;
%Stationary dist
p_k_n = zeros(1,m+1);
beta_k_n = zeros(1,m+1);
p_k_n_1 = zeros(1,m_1+1);
beta_k_n_1 = zeros(1,m_1+1);
p_k_n_2 = zeros(1,m_2+1);
beta_k_n_2 = zeros(1,m_2+1);
d_k_n = zeros(1,m+1);
d_k_n_1 = zeros(1,m_1+1);
d_k_n_2 = zeros(1,m_2+1);
d_k_total = 0;
d_k_total_1 = 0;
d_k_total_2 = 0;

for i=1:m+1
    d_k_n(i) = findd_k(i-1);
    d_k_total = d_k_total+d_k_n(i);
end
for i=1:m_1+1
    d_k_n_1(i) = findd_k_1(i-1);
    d_k_total_1 = d_k_total_1+d_k_n_1(i);
end
for i=1:m_2+1
    d_k_n_2(i) = findd_k_2(i-1);
    d_k_total_2 = d_k_total_2+d_k_n_2(i);
end

for i=1:m+1
    p_k_n(i) = d_k_n(i)/d_k_total;
    beta_k_n(i) = findbeta(i-1);
end
for i=1:m_1+1
    p_k_n_1(i) = d_k_n_1(i)/d_k_total_1;
    beta_k_n_1(i) = findbeta_1(i-1);
end
for i=1:m_2+1
    p_k_n_2(i) = d_k_n_2(i)/d_k_total_2;
    beta_k_n_2(i) = findbeta_2(i-1);
end
%}

[U_sw,f] = max(utility);
[U_sw_1,g] = max(utility_1);
[U_sw_2,h] = max(utility_2);
n_so=f-1;
n_so_1=g-1;
n_so_2=h-1;
U_sw_new = U_sw_1+U_sw_2;
U_sw_user = U_sw/n_so;
U_sw_new_user = U_sw_new/(n_so_1+n_so_2);
%{
figure(1);
bar(utility);
title('Total expected utility vs n');
ylabel('utility');

figure(2);
bar(utility_1);
title('Total expected utility of Type1 users vs n');
ylabel('utility1');

figure(3);
bar(utility_2);
title('Total expected utility of Type2 users vs n');
ylabel('utility2');

figure(4);
bar(p_k_n);
title('Stationary probability of initial queue');
figure(5);
bar(p_k_n_1);
title('Stationary probability of Type1 queue');
figure(6);
bar(p_k_n_2);
title('Stationary probability of Type2 queue');
figure(7);
bar(beta_k_n);
title('beta_k(n)');
figure(8);
bar(beta_k_n_1);
title('beta_k(n)_1');
figure(9);
bar(beta_k_n_2);
title('beta_k(n)_2');
%}

function utility_n = findutility_n(n) %function to find total expected utility per unit time obtained by the customers in the system
global lambda;
p_k_n = zeros(1,n+1);
d_k_n = zeros(1,n+1);
beta_k_n = zeros(1,n+1);
d_k_total = 0;
sigma_total=0;
for i=1:n+1
    d_k_n(i) = findd_k(i-1);
    d_k_total = d_k_total+d_k_n(i);
end
for i=1:n+1
    p_k_n(i) = d_k_n(i)/d_k_total;
end
for i=1:n+1
    beta_k_n(i) = findbeta(i-1);
end
for k=0:n-1
    sigma_total = sigma_total + (p_k_n(k+1)*beta_k_n(k+1));
end
utility_n = lambda*sigma_total;
end

function utility_n_1 = findutility_n_1(n) %function to find total expected utility per unit time obtained by the customers in the system
global lambda_1;
p_k_n_1 = zeros(1,n+1);
d_k_n_1 = zeros(1,n+1);
beta_k_n_1 = zeros(1,n+1);
d_k_total_1 = 0;
sigma_total_1 = 0;
for i=1:n+1
    d_k_n_1(i) = findd_k_1(i-1);
    d_k_total_1 = d_k_total_1 + d_k_n_1(i);
end
for i=1:n+1
    p_k_n_1(i) = d_k_n_1(i)/d_k_total_1;
end
for i=1:n+1
    beta_k_n_1(i) = findbeta_1(i-1);
end
for k=0:n-1
    sigma_total_1 = sigma_total_1 + (p_k_n_1(k+1)*beta_k_n_1(k+1));
end
utility_n_1 = lambda_1*sigma_total_1;
end

function utility_n_2 = findutility_n_2(n) %function to find total expected utility per unit time obtained by the customers in the system
global lambda_2;
p_k_n_2 = zeros(1,n+1);
d_k_n_2 = zeros(1,n+1);
beta_k_n_2 = zeros(1,n+1);
d_k_total_2 = 0;
sigma_total_2 = 0;
for i=1:n+1
    d_k_n_2(i) = findd_k_2(i-1);
    d_k_total_2 = d_k_total_2 + d_k_n_2(i);
end
for i=1:n+1
    p_k_n_2(i) = d_k_n_2(i)/d_k_total_2;
end
for i=1:n+1
    beta_k_n_2(i) = findbeta_2(i-1);
end
for k=0:n-1
    sigma_total_2 = sigma_total_2 + (p_k_n_2(k+1)*beta_k_n_2(k+1));
end
utility_n_2 = lambda_2*sigma_total_2;
end

function d_k = findd_k(k) 
global rho;
global c;
if k<c
    d_k = ((rho*c)^k)/factorial(k);
else
    d_k = (((rho*c)^c)*(rho^(k-c)))/factorial(c);
end
end

function d_k_1 = findd_k_1(k) 
global rho_1;
global c_1;
if k<c_1
    d_k_1 = ((rho_1*c_1)^k)/factorial(k);
else
    d_k_1 = ((rho_1*c_1)^c_1)*(rho_1^(k-c_1))/factorial(c_1);
end
end

function beta = findbeta(k) %expected utility of a user who enters the system in state k
global R;
global P_w;
%global P;
global mu;
global c;
if k==0
    beta = 0;
elseif k<c
    beta = R ;%- P/mu;
else
    beta = R - (P_w*(k-c+1))/(c*mu);% - P/mu ;%beta = R - (P_w*(k+1))/(c*mu) - P/mu ;
end
end

function beta_1 = findbeta_1(k) %expected utility of a Type1 user who enters the system in state k
global R;
global P_w;
%global P_1;
global mu_1;
global c_1;
if k==0
    beta_1 = 0;
elseif k<c_1
    beta_1 = R ;%- P_1/mu_1;
else
    beta_1 = R - (P_w*(k-c_1+1))/(c_1*mu_1);% - P_1/mu_1 ;
end
end

function beta_2 = findbeta_2(k) %expected utility of a Type2 user who enters the system in state k
global R;
global P_w;
%global P_2;
global mu_2;
global c_2;
if k==0
    beta_2 = 0;
elseif k<c_2
    beta_2 = R ;%- P_2/mu_2;
else
    beta_2 = R - (P_w*(k-c_2+1))/(c_2*mu_2);% - P_2/mu_2 ;
end    
end

function d_k_2 = findd_k_2(k,n2)
global rho_tilda;
global rho_hat;
global c_2;
if k<c_2
    d_k_2 = ((rho_tilda)^k)/factorial(k);
elseif k<n2
    d_k_2 = ((rho_tilda)^c_2)*((rho_tilda/c_2)^(k-c_2))/factorial(c_2);
else
    d_k_2 = ((rho_tilda)^n2)*((rho_hat/c_2)^(k-n2))/(factorial(c_2)*(c_2^(n2-c_2)));
end
end

function alpha_k_2 = findalpha_k_2(k)
global R;
global P_w;
global mu_tilda;
global c_2;
if k==0
    alpha_k_2 = 0;
elseif k<c_2
    alpha_k_2 = R ;
else
    alpha_k_2 = R - (P_w*(k-c_2+1))/(c_2*mu_tilda);
end 
end

function gamma = findgamma(n1,n2,mu_tilda)
global kappa;
p_k_n_2=findp_k_n_2(n1,n2,mu_tilda);
kappa = 1-p_k_n_2(n1+1);
global delta;
global lambda_1;
global lambda_2;
global zeta;
zeta = findzeta(n1,n2,mu_tilda);
gamma = (kappa*delta*lambda_1)/(kappa*delta*lambda_1+zeta*lambda_2);
end

function p_k_n_2 = findp_k_n_2(n1,n2,mu_tilda)
p_k_n_2=zeros(1,n1+1);
d_k_2=zeros(1,n1+1);
D_n_2=0;
for i=1:n1+1
    d_k_2(i) = findd_k_2(i-1,n2,mu_tilda);
    D_n_2 = D_n_2+d_k_n_2(i);
end
for i=1:n1+1
    p_k_n_2(i) = d_k_2(i)/D_n_2;
end
end