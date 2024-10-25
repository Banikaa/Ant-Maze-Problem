clear;

%------variables--------
iter = 1000;
chromosome_size = 30;
population_size = 200;
best_fitness = 0;
good_selection = false;
good_mutation = false;
good_crossover = false;
map = dlmread('muir_world.txt',' ');
average = 0;
average_counter = 1;

% repeat the iteration until the user inputs the right inputs
while(~good_selection)
    selection_algorithm = input("Please specify a selecion algorithm from WHEEL(0), STEADY STATE(1), TOURNAMENT(2): ");
    if(selection_algorithm == 0 || selection_algorithm == 1 || selection_algorithm == 2)
        good_selection = true;
    end
end
while(~good_crossover)
    crossover_algorithm = input("Please specify a crossover algorithm from K-POINT(0) and ORDER-BASED(1): ");
    if(crossover_algorithm == 0 || crossover_algorithm == 1)
        good_crossover = true;
    end
end
while(~good_mutation)
    mutation_algorithm = input("Please specify a mutation algorithm from FLIP(0) and  SWAP(1): ");
    if(mutation_algorithm == 0 || mutation_algorithm == 1)
        good_mutation = true;
    end
end

tic;

% create the first population and calculate the fitness for each individual
population = generate_random_population(population_size);
i = 1 : population_size;
string_controller = population(i ,1:chromosome_size);
[fitness, trail] = simulate_ant(map, string_controller);
population(i, chromosome_size+1) = fitness;

for Ngen = 1 : iter      
%   ------SELECTION-------  
    if(selection_algorithm == 0)  % roullete wheel selection
        modifier = 0.2;
        weights = population( 1: population_size, chromosome_size+1) / sum(population(1 : population_size, chromosome_size+1));
        temp_chromosome_1 = population(RouletteWheelSelection(weights), 1:chromosome_size);
        temp_chromosome_2 = population(RouletteWheelSelection(weights), 1:chromosome_size);
    elseif(selection_algorithm == 1)  % steady state selection 
        population = sort(population, chromosome_size+1);
        modifier = 0.2;  
        temp_chromosome_1 = population(end, 1:chromosome_size); % choose the first 2 members to be placed instead of the worst 2 in the new generation
        temp_chromosome_2 = population(end-1, 1:chromosome_size);
    elseif(selection_algorithm == 2)    % tournament selection
        modifier = 0.4;
        index_list(:, 1) = randperm(population_size, population_size/2);
        index_list(:, 2) = zeros;
        for i = 1:population_size/2
            index_list(i, 2) = population(index_list(i), end);
        end
        index_list = sortrows(index_list, 2);
        temp_chromosome_1 = population(index_list(end, 1), 1:30);
        temp_chromosome_2 = population(index_list(end-1, 1), 1:30);
    end

%     make the variable that controls how many parents are passed into the
%     next generation decrease as the algorithms evolves
    if (Ngen * 2 == iter)
            modifier = modifier / 2;
    elseif(Ngen * 4 == iter)
        modifier = modifier / 2;
    end
        
%       -----CROSSOVER--------
        offspring_1 = temp_chromosome_1;    % initiaolise the 4 offsrprings
        offspring_2 = temp_chromosome_2;
        offspring_3 = temp_chromosome_1;
        offspring_4 = temp_chromosome_2;

       if(crossover_algorithm == 0)     % k-point crossover with 2 points
            point_1 = randi([1 10]);
            point_2 = point_1 * 3;
%         first chromosome       
            offspring_1(1:point_1) = temp_chromosome_1(1:point_1);
            offspring_1(point_1 + 1 : point_2) = temp_chromosome_2(point_1+1 : point_2);
            offspring_1(point_2 + 1 : chromosome_size) = temp_chromosome_1(point_2+1 : chromosome_size);
%         second chromosome
            offspring_2(1:point_1) = temp_chromosome_2(1:point_1);
            offspring_2(point_1 + 1 : point_2) = temp_chromosome_1(point_1+1 : point_2);
            offspring_2(point_2 + 1 : chromosome_size) = temp_chromosome_2(point_2+1 : chromosome_size);

       elseif(crossover_algorithm == 1)   % uniform crossover    
            for i = 1:chromosome_size   % based on a random probability 
            %  cross transfer random genes from the parents to the offspring        
                if (rand < rand)
                    offspring_1(i) = temp_chromosome_2(i);
                end
                if (rand < rand)
                    offspring_2(i) = temp_chromosome_1(i);
                end
            end
       end

%       -----MUTATION----- ( the mutation algorithm is selected inside the
%       create 4 offsprings for mutating the 2 previous offsprings and the
%       temp_chromosomes chosen
        
        offspring_1 = Mutation(offspring_1, mutation_algorithm);
        offspring_2 = Mutation(offspring_2, mutation_algorithm);
        
%         for the offsprings 3 and 4 give them
        if(rand < 0.5)
            offspring_3 = Mutation(temp_chromosome_1, mutation_algorithm);
        end
        if(rand < 0.5)
            offspring_4 = Mutation(temp_chromosome_2, mutation_algorithm);
        end     

%         generate a new population and keep the best m parents and pass
%         them into the next population
        population_new = generate_random_population(population_size);
        population_new(end - end * modifier + 1 : end, 1 : chromosome_size) ...
            = population(end - end * modifier + 1 : end, 1 : chromosome_size);
             
%          calculate the fitness for each member of the population
        for i = 1 : population_size
            [fitness, trail] = simulate_ant(map, population_new(i ,1:chromosome_size));
            population_new(i, chromosome_size+1) = fitness;
        end
        
%          pass the 4 offsprings in the place of the 4 individuals with the
%          lowest fitness( part of steady state selection adapted for all
%          the offsprings)
        population_new = sortrows(population_new, chromosome_size+1);
        population_new(1, 1:chromosome_size) = offspring_1;
        population_new(2, 1:chromosome_size) = offspring_2;
        population_new(3, 1:chromosome_size) = offspring_3;
        population_new(4, 1:chromosome_size) = offspring_4;

%          pass the new generation further
        population = population_new;

%         checks if the average has been the same for more than 50
%         generations and quit if it remained unchanged
        if(average == cast(mean(population(:, chromosome_size+1)), "int8"))
            average_counter = average_counter + 1;
        else
            average = mean(population(:, chromosome_size+1));
            average = cast(average, "int8");
            average_counter = 1;
        end
        if average_counter == 50
            break;
        end

end
toc;
    
[best_fitness, trail] = simulate_ant(map, population(population_size, 1:chromosome_size));
display_trail(best_fitness, string_controller, trail,  Ngen);

