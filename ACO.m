clear all
close all

%MIKAEL KINDBLOM, ANT COLONY OPTIMIZATION, MANUFACTURING OPTIMIZATION

%This algorithm uses the files ACO, AntRoulette and AntProbability
%The nodes in the world are generated randomly.

% modify these parameters to your liking
nodes=40;
ants=6;
itThres=300;

%world map parameters (node location generated randomly)
%The world map is a (scale) x (scale) 2d map.
scale=60;
cityLocs=round(rand(nodes,2)*scale);


%Deposited amount on each edge (rows) for each ant (columns)
deltaTauAnt=zeros(nodes,nodes,ants);
deltaTau=0;

%initializing parameters
tau=ones(nodes,nodes)/2;
tau(1:1+size(tau,1):end)=0;
tau(:,:)=triu(tau(:,:))+tril(tau(:,:))';
antPathLength=zeros(ants);
Q=0.001;   %Additional factor that can be adjusted (influence of distance)
p=0.5;   %evaporation rate


%Compute the distances between all nodes
for i1=1:nodes
    for i2=1:nodes
        distances(i1,i2)=norm([cityLocs(i1,:)-cityLocs(i2,:)],2);
    end
end

%compute eta (=1/L_k)
eta=1./distances;
eta(1:1+size(eta,1):end)=0;
eta(:,:)=triu(eta(:,:))+tril(eta(:,:))';

%Create starting node in low left corner
for i=1:length(cityLocs(:,1))
    smallest(i)=norm([cityLocs(i,1),cityLocs(i,2)],2);
end
[val,startNode]=min(smallest);


%Start Loop
for iter=1:itThres
    %preallocate matrices
    antLocation=zeros(nodes+1,ants);
    antPathLength=zeros(ants);
    
    %Walk through all nodes in the map for all ants
    for ant=1:ants
        pos2 = [0.05 0.10 0.50 0.8];
        subplot('Position',pos2)
        plot(cityLocs(:,1),cityLocs(:,2),'o')
        hold on
        axis([0 scale 0 scale]);
        text(cityLocs(startNode,1),cityLocs(startNode,2)-0.015*scale,'Start Node','Color','black','FontSize',8)
        plot(cityLocs(startNode,1),cityLocs(startNode,2),'o')
        hold on
        
        %Define startNode as starting point for all ants
        antLocation(1,ant)=startNode;
        currentNode=antLocation(find(antLocation(:,ant),1,'last'),ant);
        
        for j=1:nodes-1
            %if we are at currentNode, based off the available non-visited
            %nodes, what will be the probabilities for visiting these nodes
            [acceptedNodes,prob]=AntProbability(antLocation,currentNode,nodes,ant,tau,eta);
            %From the probabilities, What will the roulettewheel choose next?
            antLocation(find(antLocation(:,ant),1,'last')+1,ant)=AntRoulette(prob,currentNode,nodes,acceptedNodes);
            %Update the length of the path for this ant
            antPathLength(ant)=antPathLength(ant)+distances(antLocation(find(antLocation(:,ant),1,'last'),ant),antLocation(find(antLocation(:,ant),1,'last')-1,ant));
            currentNode=antLocation(find(antLocation(:,ant),1,'last'),ant);
        end
        %return to the initial node
        antLocation(find(antLocation(:,ant),1,'last')+1,ant)=antLocation(1,ant);
        antPathLength(ant)=antPathLength(ant)+distances(antLocation(find(antLocation(:,ant),1,'last'),ant),antLocation(find(antLocation(:,ant),1,'last')-1,ant));
        
    end
    
    %Deposited amount of pheromone for each edge and ant (Local Update)
    for ant=1:ants
        for pos=2:1:nodes+1
            deltaTauAnt(antLocation(pos,ant),antLocation(pos-1,ant),ant)=Q/antPathLength(ant);
        end
    end
    
    %Make the matrix upper triangular
    for i=1:ants
        %set that from (node x -> node y) == (node y -> node x)
        deltaTauAnt(:,:,i)=triu(deltaTauAnt(:,:,i))+tril(deltaTauAnt(:,:,i))';
    end
    deltaTau=0;
    for i=1:ants
        %sum the contribution from all ants
        deltaTau=deltaTau+deltaTauAnt(:,:,i);
    end
    
    for x=1:nodes
        for y=1:nodes
            %Add the evaporation factor
            tau(x,y)=(1-p)*tau(x,y)+deltaTau(x,y);
        end
    end
    
    for i=1:nodes
        xdif=[cityLocs(antLocation(i,ant),1),cityLocs(antLocation(i+1,ant),1)];
        ydif=[cityLocs(antLocation(i,ant),2),cityLocs(antLocation(i+1,ant),2)];
        line(xdif,ydif);
    end
    drawnow
    hold on
    title({"Ant Colony Optimization with " + nodes + " nodes, " + ants + " ants and " + itThres " iterations."});
    hold off
    pos1 = [0.65 0.10 0.30 0.8];
    subplot('Position',pos1)
    plot(iter,antPathLength(1),'o')
    axis([0 itThres 0 inf]);
    hold on
    xlabel('Iteration')
    ylabel('Total path distance')
    clearvars -except ants cityLocs tau distances eta startNode...
        scale p itThres nodes Q iter
    
end


