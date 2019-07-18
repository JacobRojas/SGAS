function [] = SGAS5_Stats(highway, stoppingEq, ...
    alpha, beta, percentCalc, percentSecretary)
%New solution separtes range of car into 3 sections: Density Observation,
%Secretary Solution, and Critical. 1) Density Observation: Uses TCP RTO
%calculations to estimate how many k gast stations will be seen in the
%Secretary section of the car's range. 2) Secretary Solution: Runs the
%Secretary Solution assuming k gas stations 3) Critical: Stops at the first
%available Gas Station.
fileID = fopen('realStats.csv', 'a');

len = length(highway);
stopCalc = floor(len * percentCalc);
stopSecretary = floor(len * percentSecretary);


gasStations = 0;
lastStation = 0;
dev = 0;
est = 0;
%Calculate density for predicting k
for position = 1:stopCalc
    if highway(position) ~= 0
          gasStations = gasStations + 1;
          if(gasStations == 1)
              est = position;
          else
              est = alpha*est + (1-alpha)*(position - lastStation);
              dev = beta*dev + (1-beta)*abs(est - (position - lastStation));
          end
          lastStation = position;
    end
end


k = round((stopSecretary - stopCalc)/est);
stationsToPass = stoppingEq(k);
stationRates = [];

%Run the secretary problem
for position = stopCalc:stopSecretary
    if highway(position) ~= 0
        stationRates = [stationRates highway(position)];
    end
end

fprintf(fileID, '%d, %d, %d, %d\n', gasStations, len, dev, length(stationRates));
fclose(fileID);
