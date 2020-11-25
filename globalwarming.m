% This script will calculate the internal variability of the mean
% temperatures
%
% globalwarming.m
% Written by Suvam S. Patel
% 11/06/2019
%
%--------------------------------------------------------------------------

% load data
load('surface_temperature_10daily.mat');
load('coastlines.mat');

% define intervals
recent_year1 = 2000;
recent_year2 = 2010;
control_year1 = 1980;
control_year2 = 1990;

% extract temperature maps
% Test sample (recent climate):
indices_time_recent = find(year >= recent_year1 & year <= recent_year2);
temp_recent = temperature(:,:,indices_time_recent);

% Test sample (past climate):
indices_time_past = find(year >= control_year1 & year <= control_year2);
temp_past = temperature(:,:,indices_time_past);

% Calculate difference in mean
difference_in_means = mean(temp_recent,3) - mean(temp_past,3);

% Plot difference in means
subplot(2,1,1);
imagesc(lon,lat,difference_in_means);
hold on
axis xy;
colormap([1 1 1;jet]);
colorbar;
caxis([-4 4]);
plot(coastlon,coastlat,'-k');
title('Difference (2000-2010) minus(1980-1990) in temperature (Celsius)');
xlabel('longitude');
ylabel('latitude');

% compute critical value
a = temp_recent;
b = temp_past;
d = (a + b);
n = length(d);
dof = n - 1;
tcrit = tinv(0.025,dof);

% Plot difference in means where it is not significant
size(difference_in_means);
difference_in_means_95sig = NaN(121,240);

% Calculate tstat
for index_lon = 1:length(lon)
    for index_lat = 1:length(lat)

        %DO YOUR T-TEST HERE for current location (pixel i,j)
        %1. get the recent temperature time series for this pixel
        temp_recent_here = temp_recent(index_lat,index_lon,:);
        %2. get the “past” temperature time series for this pixel
        temp_past_here = temp_past(index_lat,index_lon,:);
        %3. make vector d
        d = temp_recent_here-temp_past_here;
        %4. perform t-test
        tstat = mean(d)/(std(d)/sqrt(n));
        %5. if we can reject the null hypothesis, then:
        if abs(tstat) >= abs(tcrit)
           difference_in_means_95sig(index_lat,index_lon) = mean(d);
        end
    end
end

% Plot difference in means 95sig
subplot(2,1,2);
imagesc(lon,lat,difference_in_means_95sig);
hold on
axis xy;
colormap([1 1 1;jet]);
colorbar;
caxis([-4 4]);
plot(coastlon,coastlat,'-k');
title('95% significant only');
xlabel('longitude');
ylabel('latitude');
 
