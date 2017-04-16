

relu=NumerFunc;
relu.originFunc=@Toolbar.OriRelu;
relu.primeFunc=@(x) x>0;

Linear=NumerFunc;
Linear.originFunc=@(x) x;
Linear.primeFunc=@(x) 1;

FuzzyOperation=NumerFunc;
FuzzyOperation.originFunc=@(W,X,bias) Toolbar.fuzzyMul(W,X)+bias;
FuzzyOperation.primeFunc=@Toolbar.fuzzyMulPrime;

errorFunc=@Toolbar.ErrorCal;

InitStack=[5,10,1];
Operations={FuzzyOperation,FuzzyOperation,FuzzyOperation};
Activations={Linear,relu,relu,relu};

Net=NetLayer(InitStack,Activations,Operations,errorFunc);

X=rand(100,5)/10;
X(1:50,:)=X(1:50,:)+0.8;
y=rand(100,1)/10;
y(1:50)=y(1:50)+0.5;
Net=Net.fit(X,y);
Net=Net.fit(X,y);
Net=Net.fit(X,y);
Y=Net.predict(X);
[Y,y]
