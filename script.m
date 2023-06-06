clc
clear
close all
%% initialize
no=3; 
particlelNo=30;
itr=100;
W=1;
C1=2;
C2=2;
alpha=0.05;
bottom = -100*ones(1,no); 
top = 100+zeros(1,no);
solution=[];
solution.Position=[];
solution.Cost=[];
solution.Velocity=[];
x1(1000,1)=0.0;
x2(1000,1)=0.0;
Particle=repmat(solution,[particlelNo,1]);
best=repmat(solution,[particlelNo,1]);
bad=repmat(solution,[particlelNo,1]);
%%first search
for i=1:particlelNo
    Particle(i).Position=unifrnd(bottom,top);
    Particle(i).Cost=sphere(Particle(i).Position,no);
    Particle(i).Velocity=0;
    %save local best 
    best(i)=Particle(i);
end
% Find best particle
[value,index]=min([Particle.Cost]);
globalBest=Particle(index);
%% PSO
for it=1:itr
    globalAvgTemp=0;
    for i=1:particlelNo
        %Update velocity
        Particle(i).Velocity=W*Particle(i).Velocity...
        +C1*rand(1,no).*(best(i).Position-Particle(i).Position)...
        +C2*rand(1,no).*(globalBest.Position-Particle(i).Position);
        %Update position
        Particle(i).Position=Particle(i).Position+Particle(i).Velocity;
        % Check Boundari
        for j=1:no
            if Particle(i).Position(j)> top(j)
                Particle(i).Position(j)=top(j);
            end
            if Particle(i).Position(j)< bottom(j)
                Particle(i).Position(j)=bottom(j);
            end
        end
        %calc fitness
        Particle(i).Cost=sphere(Particle(i).Position,no);
        
        %Update local and global best solution
        if Particle(i).Cost<best(i).Cost
            best(i)=Particle(i);
            %update global solution
            if best(i).Cost<globalBest.Cost
                globalBest=best(i);
            end
        end
        
        if Particle(i).Cost>best(i).Cost
            bad(i)=Particle(i);
            %update global solution
            if bad(i).Cost>globalBest.Cost
                globalWorst=best(i);
            end
        end
        
        GlobalAvg = -100;
        if (Particle(i).Cost<best(i).Cost && Particle(i).Cost>bad(i).Cost)
            LocalAvg(i).Cost=Particle(i);
            %update global solution
            if (bad(i).Cost<globalBest.Cost && bad(i).Cost>globalWorst.Cost)
                globalAvg.Cost=best(i);
                globalAvgTemp=mean(globalAvg.Cost);
            end
        end        
    end    
    W=W*(1-alpha);
    %
    y=num2str(Particle(i).Position);
    x1(num2str(it))=y(1,1);
    x2(num2str(it))=y(1,2);
    disp(['In Iteration= ' num2str(it) ', Best X= ' num2str(Particle(i).Position) ', Best Cost= ' num2str(globalBest.Cost) ', Average Cost= ' num2str(mean(Particle(i).Cost)) ', Worst Cost= ' num2str(globalWorst.Cost)]);
    bestSoFar(it)=globalBest.Cost;
    worstSoFar(it)=globalWorst.Cost;    
    avgSoFar(it)=mean(Particle(i).Cost);    
end
%% plot
disp(['best fitness =  ' num2str(globalBest.Cost)]);
disp(' ');
disp(['best solution found is:  ' num2str( globalBest.Position)])
disp(['Standard Deviation is:  ' num2str(std(abs(x1-x2)/sqrt(2)))])
figure;
semilogy(bestSoFar,'y','LineWidth',1);
hold on; 
semilogy(worstSoFar,'r','LineWidth',1);
hold on;
semilogy(avgSoFar,'c','LineWidth',1);
hold on;
title(sprintf("PSO for: sphere,     Worst-Cost:red, Average-Cost:cyan, Best-Cost:yellow"));