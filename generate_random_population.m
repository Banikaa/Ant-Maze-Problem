function population = generate_random_population(population_size) 
    population = zeros(population_size, 30);
    population = [population zeros(population_size, 1)];
    for i = 1:population_size
        for j = 1:30
            if(rem(j, 3) == 1)
                population(i, j) = randi([1 4]); 
            end
            if(rem(j, 3) ~= 1)
                population(i, j) = randi([0 9]);
            end
        end
    end
    
end