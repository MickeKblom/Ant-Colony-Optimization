function rouletteSelection = Roulette(adjfitness,population,optimization)

if optimization=='max'
    normfitness=adjfitness/sum(adjfitness); 
elseif optimization=='min'
    normfitness=1./(adjfitness+1);
    normfitness=normfitness/sum(normfitness);
end
for b=1:population
    t1=rand(1);
    sumfit=normfitness(1);
    for i=1:population
        if t1>sumfit
            sumfit=sumfit+normfitness(i+1);
        else
            break 
        end
    end
    winner(b)=i;
end
rouletteSelection1=winner(round(rand(1)*population+0.5));
rouletteSelection2=winner(round(rand(1)*population+0.5));
 
while rouletteSelection2==rouletteSelection1
    rouletteSelection2=winner(round(rand(1)*population+0.5));
end

rouletteSelection=[rouletteSelection1,rouletteSelection2];

