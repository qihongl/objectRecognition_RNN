% testing
clear all; close all; clc
%%

nObjs = 2;
nTimePts = 500; 

for n = 1 : nObjs
    h{n} = animatedline;
end

% set up the plotting panel
axis([0 4*pi -1 1])
% x domain
x = linspace(0,4*pi,nTimePts);

for t = 1:nTimePts
    % y values at time t
    for n = 1 : nObjs
        % create the t-th location for n-th object
        y(t,n) = sin(n * x(t));
        % add the point 
        addpoints(h{n},x(t),y(t,n)); drawnow;
    end
    
end