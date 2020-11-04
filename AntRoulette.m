function roulettePathSelec = AntRoulette(prob,currentNode,nodes,acceptedNodes)


%Roulette start
%random number
t1=rand(1);

sumprob=prob(1);

%Check if generated number is bigger than cumulative sum of node
%probabilities while adding nodes to the sum, if not break loop

for j=1:length(acceptedNodes)
    if t1>sumprob
        sumprob=sumprob+prob(j+1);
    else
        break
    end
    
end
roulettePathSelec=acceptedNodes(j);
end
