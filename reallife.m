function highway = reallife(file)
[distances prices] = readvars("RealLife.csv");
highway = double.empty();
for i = 1:length(distances)
    highway = [highway zeros(1, distances(i)-1) prices(i)];
end
end