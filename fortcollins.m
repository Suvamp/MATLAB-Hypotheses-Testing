% This script will test the hypothesis of the amount of precipitation
% changed per year in Fort Collins between two time periods: 1899-1939 and
% 1940-1980
%
% fortcollins.m
% Written by Suvam S. Patel
% 11/06/2019
%
% This script will test hypothesis on the Fort Collins precipitation data
%
%--------------------------------------------------------------------------

% open data
filepath = 'Fort_Collins_P.txt';
fid = fopen(filepath);
data = textscan(fid,'%f %f','Headerlines',8);
fclose(fid);

time = data{1};
precip = data{2};

% plot amount of precipitation per year as a function of time
plot(time,precip,'-b');
xlabel('Time(years)');
ylabel('Precipitation(in inches)');

% restrict x values between 1896 and 2010
xlim([1896 2010]);

% extract data for time intervals 1899,1939,1940,and 1980
pos1899 = find(time==1899);
pos1939 = find(time==1939);
pos1940 = find(time==1940);
pos1980 = find(time==1980);

% calculate the average precipitation for [1899 1939] and [1940 1980]
mean1 = mean(precip(pos1899:pos1939));
mean2 = mean(precip(pos1940:pos1980));

% display mean values
fprintf('Fort Collins average precipitations \n');
fprintf('1899 to 1939 = %.2f inches \n', mean1);
fprintf('1940 to 1980 = %.2f inches  \n', mean2);

% perform t-test
a = precip(pos1899:pos1939);
b = precip(pos1940:pos1980);
d = (a - b);
std1 = std(d);
n = length(d);
tstat = mean(d)/(std1/n^1/2);

% compute critical value
dof = n-1;
tcrit = tinv(0.05,dof);

% compare tstat and tcrit
fprintf('tstat = %.2f \n', tstat);
fprintf('tcrit = %.2f \n', tcrit);
fprintf('tcrit = 1.68 < tstat = 4.57 the amount of precipitation has changed significantly in Fort Collins \n');

