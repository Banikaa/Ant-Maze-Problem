function display_trail(best_fitness, string_controller, trail , Ngen)
    % read the John Moir Trail (world)
    filename_world = 'muir_world.txt';
    world_grid = dlmread(filename_world,' ');
    
    % display the John Moir Trail (world)
    world_grid = rot90(rot90(rot90(world_grid)));
    xmax = size(world_grid,2);
    ymax = size(world_grid,1);
    hf = figure(2); set(hf,'Color',[1 1 1]);
    
    for y=1:ymax
        for x=1:xmax
            if(world_grid(x,y) == 1)
                h1 = plot(x,y,'sk');
                hold on
            end
        end
    end
    
    grid on
    % display the fittest Individual trail
    for k=1:size(trail,1)
        h2 = plot(trail(k,2),33-trail(k,1),'*m');
        hold on
    end
    
    axis([1 32 1 32])
    title_str = sprintf('John Muri Trail - Hero Ant fitness %d%% in %d generation ',uint8(100*best_fitness/89), Ngen);
    title(title_str)
    lh = legend([h1 h2],'Food cell','Ant movement');
    set(lh,'Location','SouthEast');
end