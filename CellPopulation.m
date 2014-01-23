clear all
clc
% Generating Life Span random variable with Standard Deviation of 3 (unit=hour)
numsamples = 1000;
LS = 240;
LSSD = 100;
LSsamples = round(LS + LSSD.*randn(numsamples, 1));

% Generating Cell Devision Rate random variable with Standard Deviation of 3 (unit=hour) 
numsamples = 1000;
CDR = 10;
CDRSD = 3;
CDRsamples = round(CDR + CDRSD.*randn(numsamples, 1));
% Initializing the variables
Tsize=1000;
TISSUE=zeros(Tsize);
LSREC=zeros(Tsize);
CDREC=zeros(Tsize);

%Transplantation of cell
TISSUE(5,5)=1;
CDREC(5,5)=CDRsamples(randi([1,numsamples]));
LSREC(5,5)=LSsamples(randi([1,numsamples]));


for h=1:2400
    
    
    [I,J] = find(TISSUE);            %Find the cells
    N=length(I);                     %Number of availible cells
   
    
    k=0;                              %Initializing cell counter
    for k=1:N;
        
        if LSREC(I(k),J(k))==h
            TISSUE(I(k),J(k))=0;
            LSREC(I(k),J(k))=0;
            CDREC(I(k),J(k))=0;
        elseif rem(h,CDREC(I(k),J(k)))==0
                    
            
            %Find number of neighboring cells
            %up left
            row_of_neighbors(1)=rem(I(k)-2+Tsize,Tsize)+1;
            column_of_neighbors(1)=rem(J(k)-2+Tsize,Tsize)+1;
            
            %up
             row_of_neighbors(2)=rem(I(k)-2+Tsize,Tsize)+1;
             column_of_neighbors(2)=J(k);
             
		    %up right
            row_of_neighbors(3)=rem(I(k)-2+Tsize,Tsize)+1;
            column_of_neighbors(3)=rem(J(k),Tsize)+1;            
        
            %right
            row_of_neighbors(4)=I(k);
            column_of_neighbors(4)=rem(J(k),Tsize)+1;
            
            %bottom right
            row_of_neighbors(5)=rem(I(k),Tsize)+1;
            column_of_neighbors(5)=rem(J(k),Tsize)+1;
        	
            %bottom
            row_of_neighbors(6)=rem(I(k),Tsize)+1;
            column_of_neighbors(6)=J(k);
        
            %bottom left
            row_of_neighbors(7)=rem(I(k),Tsize)+1;
            column_of_neighbors(7)=rem(J(k)-2+Tsize,Tsize)+1;           
         
            %left
            row_of_neighbors(8)=I(k);
            column_of_neighbors(8)=rem(J(k)-2+Tsize,Tsize)+1;
            
            %Select the place for daughter cell randomly
             p=randi([1,8]);
            
             if TISSUE(row_of_neighbors(p),column_of_neighbors(p))==0
                TISSUE(row_of_neighbors(p),column_of_neighbors(p))=1;
                LSREC(row_of_neighbors(p),column_of_neighbors(p))=LSsamples(randi([1,numsamples]))+h;
                CDREC(row_of_neighbors(p),column_of_neighbors(p))=CDRsamples(randi([1,numsamples]));
             end
            
        end
        
    end
   imagesc(TISSUE)
   pause(.01)
end
