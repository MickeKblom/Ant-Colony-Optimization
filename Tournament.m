function tournamentSelection = Tournament(adjfitness,population,optimization)
    newadjfitness=zeros(population,1);
    for i=1:population
        pick1=round(rand(1)*population+0.5);
        pick2=round(rand(1)*population+0.5);
        cont1=adjfitness(pick1);
        cont2=adjfitness(pick2);
        if optimization=='min'
            if cont1<cont2
                newadjfitness(i)=cont1;
            else
                newadjfitness(i)=cont2;
            end
        elseif optimization=='max'
            if cont1>cont2
                newadjfitness(i)=cont1;
            else
                newadjfitness(i)=cont2;
            end
        end
    end
    
    
    
    pick1=round(rand(1)*population+0.5);
    pick2=round(rand(1)*population+0.5);
    while pick2==pick1
        pick2=round(rand(1)*population+0.5);
    end
    winner1val=newadjfitness(pick1);
    winner2val=newadjfitness(pick2);
    parent1=find(adjfitness==winner1val);
    parent2=find(adjfitness==winner2val);
    tournamentSelection=[parent1,parent2];
end
