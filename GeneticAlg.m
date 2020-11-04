
clear all
close all
%RUN THIS FUNCTION
%NOTE: Function is defined in genAlgFuncEval

bitres=14;  %number of bits
minrange=-500;
maxrange=500;
population=60; %number of chromosomes
mutationprob=0.03; %mutation probability
flag='Tournament'; % 'Roulette' or 'Tournament'
numVars=2;
iteration=0;
numberMaxGen=1000; %max number of generations
optimization='min'; % if 'min' then MINIMIZATION is selected, 'max' gives Maximization
crossover='double'; %Single or double
crossprob=0.60; %crossover probability
stopcond=0; % if 1 then it breaks the loop
stopNumItNoImprovement=50; %stalling condition

%1. Create random population
for var=1:numVars
    for i=1:population
        for bits=1:bitres
            pop(var,i,bits)=round(rand(1));
        end
    end
end

%2. Decode binary value to variable value
for i=1:population
    for var=1:numVars
        %Get the decoded variable values(amount "population" for each varible)
        varval(var,i)=minrange+(maxrange-minrange)*bin2dec(num2str(pop(var,i,:)))/(2^bitres-1);
    end
    %3. Create the fitness values
    fitness(i)=genAlgFuncEval(i,varval);
end

%4. Adjust and normalize fitness function values
if any(fitness<0)==1  % make values nonnegative if negative
    adjfitness=fitness-min(fitness);
else
    adjfitness=fitness;
end

%Start loop
while iteration<numberMaxGen==1 && isequal(stopcond,0)==1
    %Visualization of convergence
    iteration=iteration+1;
    if optimization=='min'
        bestVal=min(fitness);
        plot(iteration,bestVal,'o')
        hold on
    elseif optimization=='max'
        bestVal=max(fitness);
        plot(iteration,bestVal,'o')
        hold on
    end
    %Loop of Roulette, crossover and mutation
    for k=1:2:population-1
        if isequal(flag,'Roulette')
            rouletteSelection=Roulette(adjfitness,population,optimization);
            selection=rouletteSelection;
        elseif isequal(flag,'Tournament')
            tournamentSelection=Tournament(adjfitness,population,optimization);
            selection=tournamentSelection;
        end
        
     %%   CROSSOVER (single point)
        if isequal(crossover,'single')
            for var=1:numVars
                crossoverloc=round(rand(1)*(bitres-1))+1;
                parent1=pop(var,selection(1),:);
                parent2=pop(var,selection(2),:);
                child1=parent1;
                child2=parent2;
                if rand(1)<crossprob
                    for i=1:crossoverloc
                        k1=parent1(i);
                        k2=parent2(i);
                        child1(i)=k2;
                        child2(i)=k1;
                    end
                end
                if rand(1)<mutationprob  % probability to mutate child1
                    mutationloc=round(rand(1)*(bitres-1))+1;
                    if child1(mutationloc)== 1;
                        child1(mutationloc)=0;
                    else
                        child1(mutationloc)=1;
                    end
                end
                if rand(1)<mutationprob  % probability to mutate child2
                    mutationloc=round(rand(1)*(bitres-1))+1;
                    if child2(mutationloc)== 1;
                        child2(mutationloc)=0;
                    else
                        child2(mutationloc)=1;
                    end
                end
                newpop(var,k,:)=child1;
                newpop(var,k+1,:)=child2;
            end
        
       %     CROSSOVER DOUBLE POINT
            
        elseif isequal(crossover,'double')
            for var=1:numVars
                crossoverloc=round(rand(1)*(bitres-1))+1;
                parent1=pop(var,selection(1),:);
                parent2=pop(var,selection(2),:);
                child1=parent1;
                child2=parent2;
                if rand(1)<crossprob
                    for i=1:crossoverloc
                        k1=parent1(i);
                        k2=parent2(i);
                        child1(i)=k2;
                        child2(i)=k1;
                    end
                end
                newpop(var,k,:)=child1;
                newpop(var,k+1,:)=child2;
                parent1=newpop(var,k,:);
                parent2=newpop(var,k+1,:);
                crossoverloc2=round(rand(1)*(bitres-1))+1;
                if rand(1)<crossprob
                    for i=1:crossoverloc2
                        k1=parent1(i);
                        k2=parent2(i);
                        child1(i)=k2;
                        child2(i)=k1;
                    end
                end
                if rand(1)<mutationprob  % probability to mutate child1
                    mutationloc=round(rand(1)*(bitres-1))+1;
                    if child1(mutationloc)== 1;
                        child1(mutationloc)=0;
                    else
                        child1(mutationloc)=1;
                    end
                end
                if rand(1)<mutationprob  % probability to mutate child2
                    mutationloc=round(rand(1)*(bitres-1))+1;
                    if child2(mutationloc)== 1;
                        child2(mutationloc)=0;
                    else
                        child2(mutationloc)=1;
                    end
                end
                newpop(var,k,:)=child1;
                newpop(var,k+1,:)=child2;
            end
        end
     
    end
    pop=newpop;
    
    %2. Decode binary value to variable value
    for i=1:population
        for var=1:numVars
            %Get the decoded variable values(amount "population" for each varible)
            varval(var,i)=minrange+(maxrange-minrange)*bin2dec(num2str(pop(var,i,:)))/(2^bitres-1);
        end
        %3. Create the fitness values
        fitness(i)=genAlgFuncEval(i,varval);
    end
    
    %4. Adjust and normalize fitness function values
    if any(fitness<0)==1  % make values nonnegative if negative
        adjfitness=fitness-min(fitness);
    else
        adjfitness=fitness;
    end
    %For updating the "best" value found so far
    if isequal(optimization,'min')
        itVal(iteration)=min(fitness);
        if min(fitness)<bestVal
            bestVal=min(fitness)
        end
        if length(itVal)>stopNumItNoImprovement
            if itVal(iteration-stopNumItNoImprovement)<=itVal(iteration)
                stopcond=1;
            end
        end
    elseif isequal(optimization,'max')
        itVal(iteration)=min(fitness);
        if max(fitness)>bestVal
            bestVal=max(fitness)
        end
        if length(itVal)>stopNumItNoImprovement
            if itVal(iteration-stopNumItNoImprovement)>=itVal(iteration)
                stopcond=1;
            end
        end
    end
    
end

if optimization=='min'
    disp('Reached minimum function value: ')
    opt=bestVal;
    disp(opt)
    
elseif optimization=='max'
    disp('Reached maximum function value: ')
    opt=bestVal;
    disp(opt)
end


%integer values only on x-axis
title({"Optimizing for " + optimization + "-value using population size of " + population + " and selection: " + flag; ...
    "Mutation probability: " + mutationprob + " and crossover probability: " + crossprob ;"Reached function value: " +  opt})
ylabel('Function value')
xlabel('Iteration')
itVals = get(gca, 'XTick');
set(gca, 'XTick', unique(round(itVals)))
