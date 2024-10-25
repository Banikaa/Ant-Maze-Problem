% applies Flip Mutation to chromosome 
% 2 random points are chosen and the values between flipped
function final_chromosome = Mutation(chromosome, type)
    
    if(type == 0)   % flip mutatios: swap teh values between 2 random points 
        point1 = randi([1 10]);
        point2 = point1 * 3;
        tobeflipped = chromosome(point1:point2);    % flip the chromosomes between the 2 points
        chromosome(point1:point2) = fliplr(tobeflipped);
        final_chromosome  = chromosome;
    elseif(type == 1)   % interchange chromosomes
        final_chromosome  = chromosome; % SWAP mutations
        rand1 = randi([1 5]);   % choose 2 points
        points = randperm(10, rand1);

        for i = 1 : rand1
            nb = randi([1 3]);
            final_chromosome (points(i) * nb) = chromosome(points(i));  % swaps a rand number of chromosomes
            final_chromosome (points(i)) = chromosome(points(i) * nb);
        end   
    end
end

