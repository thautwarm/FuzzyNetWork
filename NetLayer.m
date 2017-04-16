classdef NetLayer
    properties
      size
      input
      weights
      output
      error
      errorfunc
      activations
      operations
      bias
      tag
      
    end
    methods
        function nl=NetLayer(InitStack,Activations,Operations,errorFunc)
%    
%         "InitStack" is a vector that defines the size of each layer.
%           eg. InitStack=[300,200,100,5] ;
%
%               which means the Neuron Network has 4 layers, sizes of which are
%               defined by order. 
%
%         "Activations" is a cell-vector which contains the a couple of
%            the entities of NumerFunc class.
%
%         "Operations" is a cell-vector which contains a couple of function
%           handle defining how the we get an output from the parametres
%           Weight, input, Bias. 
%               the definations of Weight,input and Bias can be found at
%                   1.https://www.journals.elsevier.com/neural-networks/
%                   2.https://en.wikipedia.org/wiki/Neural_Network
%                           and so on...
%           
            nl.size=length(InitStack);
            getVec=@(x) zeros(x,1);
            getConnnet=@(a,b) rand(b,a);
            
            nl.input=Map(getVec,InitStack);
            nl.output=nl.input;
            nl.activations=Activations;
           
            nl.operations=Operations;
            nl.error=Map(getVec,InitStack(2:length(InitStack)));
            nl.bias=Map(getVec,InitStack(2:length(InitStack)));
            
            nl.weights=Toolbar.partial_gram(getConnnet,InitStack ) ;
            
            

            
            nl.errorfunc=errorFunc;
        end
        function nl=InData(nl,feature,tag)
                nl.input{1}=feature;
                nl.tag=tag;
        end 
        function [nl,Y]=forward(nl)    
            nl.output{1}=nl.activations{1}.originFunc(nl.input{1});
            
            %Ç°Ïò´«²¥
            for i=2:nl.size
            
                nl.input{i}=nl.operations{i-1}. ...
                    originFunc(nl.weights{i-1}, ...
                    nl.output{i-1}, ...
                    nl.bias{i-1});
               
                nl.output{i}=nl.activations{i}.originFunc(nl.input{i});
                
            end
            Y=nl.output{nl.size};
            nl.error{nl.size-1}=nl.errorfunc( Y,nl.tag,nl.activations{nl.size}.primeFunc);
        end
        function nl=backprop(nl)
            for i=nl.size-2:-1:1
                nl.error{i}= (nl.operations{i+1}. ...
                    primeFunc(nl.weights{i+1},nl.input{i+2},nl.bias{i+1})' ...
                    *  ...
                    nl.error{i+1})...
                    .* ...
                    nl.activations{i+1}. ...
                    primeFunc(nl.output{i+1});
            end
            
        end
        function nl=weightRenew(nl)
            for i=1:nl.size-1
                nl.weights{i}=nl.weights{i}-0.4.* (nl.error{i}*nl.input{i}');
                nl.bias{i}=nl.bias{i}-0.3*(nl.error{i});
            end
        end
        function nl=fit(nl,X,y)
            X=Toolbar.WeightToCell(X);
            N=length(y);
            for i=1:N
                nl=nl.InData(X{i}',y(i));
                for j=1:2
     
                   [nl,~]=nl.forward();
                    nl=nl.backprop();
                    nl=nl.weightRenew();
                end
            end        
        end
        function Y=predict(nl,X)
            X=Toolbar.WeightToCell(X);
            N=length(X);
            Y=zeros(N,1);
            
            for i=1:N
                nl=nl.InData(X{i}',-1);
                [nl,y]=nl.forward();
                y
                Y(i)=y;
            end
        end
    end
end


    