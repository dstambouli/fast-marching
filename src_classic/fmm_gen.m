clc
clear all
close all

N = 30;
dx = 1/N;

% t = 0 les poinst acceptés sont 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               EXEMPLES                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ap = zeros(N+1);

% Exemple 1 : exemple de Tim avec falaise et point au milieu
% ap(1,1)= 1; ap(1,2) = 1; ap(2,1) = 1; ap(2,2) = 1;

% Exemple 2 : front au milieu et vitesse négative
 ap(10:20, 15:26) = 1;

% Exemple 3 : 2 fronts au milieu et vitesse positive 
%ap(5:10, 12:16) = 1; ap(15:19,15:19) = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AP = zeros(N+3); 
%AP(2:end-1,2:end-1) = ap; % on applique le mm padding
%AP(9,2:end-1) = 1;
%AP(2:end-1,9) = 1;
AP(2:end-1,2:end-1) = ap; 
%AP(2,2:end-1) = 1; AP(16,15) = 1;
 AP = logical(AP);

t = 0; % décompte du temps 

theta = -ones(size(AP));
theta(AP) = 1;

u = 10^5*ones(size(AP));
u(find(theta == 1)) = 0;

[XX YY] = meshgrid([1:N+1],[1:N+1]); 
surf(XX,flipud(YY),u(2:end-1,2:end-1)); 
xlabel('x')
ylabel('y')
zlabel('T')
title(['time : ' num2str(t)]);
drawnow
pause

while sum(AP(:)) < (N+1)^2
    NB = narrow_gen(theta);
    NB = logical(NB);

    c =  abs(velocity(N));

    NG = zeros(size(NB)); NG(2:end-1,1:end-2) = NB(2:end-1,2:end-1); % les noeuds à gauche;
    ND = zeros(size(NB)); ND(2:end-1,3:end) = NB(2:end-1,2:end-1); % les noeuds à droite;
    NH = zeros(size(NB)); NH(1:end-2,2:end-1) = NB(2:end-1,2:end-1); % les noeuds à en haut;
    Nb = zeros(size(NB)); Nb(3:end,2:end-1) = NB(2:end-1,2:end-1); % les noeuds à bas;

    NG = logical(NG); ND = logical(ND); NH = logical(NH); Nb = logical(Nb);

    TG = u(NG); TD = u(ND); TH = u(NH); Tb = u(Nb);
    Ti = u(NB);
    ci = c(NB);

    for j = 1:length(Ti)
        if (Ti(j) < TG(j) && Ti(j) < TD(j) && Ti(j) < TH(j) && Ti(j) < Tb(j))
            error('erreur résolution de l équation');
        elseif (max(max(Ti(j) - TG(j),Ti(j) - TD(j)),0) == 0)
            if (Ti(j) - TH(j) <= Ti(j) - Tb(j))
                % (Ti-Tb)^2 = ..
                Ti(j) = Tb(j) + (dx/ci(j));
            else 
                % (Ti-TH)^2 = ..
                Ti(j) = TH(j) + (dx/ci(j));
            end
        elseif (max(max(Ti(j) - TH(j),Ti(j) - Tb(j)),0) == 0)
            if (Ti(j) - TG(j) <= Ti(j) - TD(j))
                % (Ti-TD)^2 = ..
                Ti(j) = TD(j) + (dx/ci(j));
            else 
                % (Ti-TD)^2 = ..
                Ti(j) = TG(j) + (dx/ci(j));
            end
        elseif	(Ti(j) - TG(j) <= Ti(j) - TD(j) && Ti(j) - TH(j) <= Ti(j) - Tb(j))
            % (Ti-TD)^2 + (Ti-Tb)^2=..
            delta = (2*TD(j)+2*Tb(j))^2-4*2*(TD(j)^2+Tb(j)^2-(dx/ci(j))^2);
            Ti(j) = 0.5*(TD(j) + Tb(j)) + 0.25*sqrt(delta);
        elseif (Ti(j) - TG(j) < Ti(j) - TD(j) && Ti(j) - TH(j) > Ti(j) - Tb(j))
            % (Ti-TD)^2 + (Ti-TH)^2=..
            delta = (2*TD(j)+2*TH(j))^2-4*2*(TD(j)^2+TH(j)^2-(dx/ci(j))^2);
            Ti(j) = 0.5*(TD(j) + TH(j)) + 0.25*sqrt(delta);
        elseif (Ti(j) - TG(j) > Ti(j) - TD(j) && Ti(j) - TH(j) < Ti(j) - Tb(j))
            % (Ti-TG)^2 + (Ti-Tb)^2=..
            delta = (2*TG(j)+2*Tb(j))^2-4*2*(TG(j)^2+Tb(j)^2-(dx/ci(j))^2);
            Ti(j) = 0.5*(TG(j) + Tb(j)) + 0.25*sqrt(delta);
        elseif (Ti(j) - TG(j) >= Ti(j) - TD(j) && Ti(j) - TH(j) >= Ti(j) - Tb(j))
            % (Ti-TG)^2 + (Ti-TH)^2=..
            delta = (2*TG(j)+2*TH(j))^2-4*2*(TG(j)^2+TH(j)^2-(dx/ci(j))^2);
            Ti(j) = 0.5*(TG(j) + TH(j)) + 0.25*sqrt(delta);
        end
    end

    % trouver le min de Ti 
    m = min(Ti); 
    NA = find(Ti == m);

    Ti(~NA) = 10^5;
    u(NB) = Ti;
    
    % mise à jour des ts theta : 
    accept = zeros(length(u(NB)),1); accept(NA) = 1;
	AP(NB) = accept;
	AP = logical(AP);
    theta(AP) = 1;

    t = t + m;

    %% function plot 

    [XX YY] = meshgrid([1:N+1],[1:N+1]); 
    surf(XX,flipud(YY),u(2:end-1,2:end-1)); 
    xlabel('x')
    ylabel('y')
    zlabel('T')
    title(['time : ' num2str(t)]);
    drawnow
    %pause

end