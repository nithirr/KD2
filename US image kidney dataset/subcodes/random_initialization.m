function X = random_initialization(NumberofBrownBears,max,min)

R= NumberofBrownBears;
X=rand(R,1)*(max-min)+(ones(R,1)*min);
    