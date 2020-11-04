function [acceptedNodes,prob] = AntProbability(antLocation,currentNode,nodes,ant,tau,eta)
%define the accepted nodes (where the and has not visited yet)
for i=1:nodes
    if any(antLocation(:,ant)==i)
    else
        acceptedNodes(i)=i;
    end
end
denom=0;
acceptedNodes=nonzeros(acceptedNodes);
%Getting denominator of the probability function
for nod=1:length(acceptedNodes)
    if currentNode>acceptedNodes(nod)
        denom=denom+tau(acceptedNodes(nod),currentNode).*eta(acceptedNodes(nod),currentNode);
    elseif currentNode<acceptedNodes(nod)
        denom=denom+tau(currentNode,acceptedNodes(nod)).*eta(currentNode,acceptedNodes(nod));
    end
end
%Calculating the nominator of the probability function
for nod=1:length(acceptedNodes)
    if currentNode>acceptedNodes(nod)
        prob(nod)=tau(acceptedNodes(nod),currentNode).*eta(acceptedNodes(nod),currentNode);
    elseif currentNode<acceptedNodes(nod)
        prob(nod)=tau(currentNode,acceptedNodes(nod)).*eta(currentNode,acceptedNodes(nod));
    else
        prob(nod)=0;
    end
end
%Getting the final probability
prob=prob/denom;
end