function [ K B I ] = StiffMat2dTruss()

clr
fprintf('=========================================================== \n') ;
fprintf('A PROGRAM FOR SOLVING 2-D TRUSS \n\n') ;
fprintf('                          NOTES \n') ;
fprintf('1)Please be consistent with units. \n') ;
fprintf('=========================================================== \n\n') ;

N = input('Enter the number of elements in truss ') ;
n = input('Enter the number of nodes ') ;
Op = input('Do all elements have same E and A (Y/N) ','s') ;

if strcmp(Op,'Y')
    E = input('Enter the value of E ') ;
    A = input('Enter the value of A ') ;
end

%Inputing Co-ordinates of nodes
for i = 1:1:n
    disp(['For Node ',num2str(i)]) ;
    Cor{i,1} = i ;
      cord = input('Give Co-ordinates (Row vector [x,y]) ') ;
    Cor{i,2} = cord ;
end

% Inputing data
for i=1:1:N
    disp(['Data for element ',num2str(i)]) ;
    I{i,1}{1,1} = i ;
    glb1 = input('Enter Global node number for local node 1 ') ;
    glb2 = input('Enter Global node number for local node 2 ') ;
    I{i,1}{2,1} = glb1 ;
    I{i,1}{3,1} = glb2 ;
    x1 = Cor{glb1,2} ;
    x2 = Cor{glb2,2} ;
    I{i,1}{4,1} = x1 ;
    I{i,1}{5,1} = x2 ;
    L = sqrt((x2(1,2)-x1(1,2))^2 + (x2(1,1)-x1(1,1))^2) ;
    I{i,1}{6,1} = L ;
    cp = (x2(1,1)-x1(1,1))/L ;
    sp = (x2(1,2)-x1(1,2))/L ;
    I{i,1}{7,1} = cp ;
    I{i,1}{8,1} = sp ;
    Gdof = [2*glb1-1,2*glb1,2*glb2-1,2*glb2] ;
    I{i,1}{9,1} = Gdof ;
     if  strcmp(Op,'Y')
      I{i,1}{10,1} = E ; 
      I{i,1}{11,1} = A;  
     else
      E = input('Enter the value of E ') ;
      A = input('Enter the value of A ') ;
      I{i,1}{10,1} = E ; 
      I{i,1}{11,1} = A; 
     end
end

K = zeros(2*n,2*n) ;
C = zeros(N,4) ;


%Filling the connectivity matrix

for j = 1:1:N 
    c = I{j,1}{9,1} ;
   for k = 1:1:4
       C(j,k) = c(k) ;
   end
end

% % Forming the stiffness matrix

for m = 1:1:N
    e = I{m,1}{10,1} ;
    a =  I{m,1}{11,1} ;
    l = I{m,1}{6,1} ;
    KL = ((a*e)/l)*[1 0 -1 0;0 0 0 0;-1 0 1 0; 0 0 0 0] ;
    cp1 = I{m,1}{7,1} ;
    sp1 = I{m,1}{8,1} ;
    T = [cp1 sp1 0 0 ; -sp1 cp1 0 0 ;0 0 cp1 sp1 ; 0 0 -sp1 cp1 ] ;
    KG = T'*KL*T ;
    p = C(m,:) ;
    K2 = zeros(2*n,2*n) ;
    K2(p,p) = KG ;
    I{m,1}{12,1} = K2 ;
    K(p,p) = K(p,p) + KG ;
    L1 = I{m,1}{6,1} ;         %Length of element
    Gdof1 = I{m,1}{9,1} ;      %Global node numbers of dofs of th element
    L2 = zeros(4,2*n) ;        %Gather matrix of the element
    
    for i = 1:1:4               %Populating the gather matrix with global dof numbers
        
        L2(i,Gdof1(i)) = 1 ;  
        
    end
        
    B1 = [(-1/L1) (1/L1)]*[cp1 sp1 0 0 ; 0 0 cp1 sp1 ]*L2 ;
    
    I{m,1}{13,1} = B1 ;
    
    
    
end

B = zeros(N,2*n) ;

for i = 1:1:N
    
    B(i,:) = I{i,1}{13,1} ;
    
end
    
    

 
   
 %%
 %Plotting
X = zeros(2,1) ;
Y = zeros(2,1) ;

figure(1)
title('Figure of the Truss','FontSize',14) ;
grid on

for i = 1:1:N 
   
    c1 = I{i,1} {4,1} ;
    c2 = I{i,1} {5,1} ;
    c3 = I{i,1} {9,1} ;
    X(1,1) = c1(1,1) ;
    X(2,1) = c2(1,1) ;
    Y(1,1) = c1(1,2) ;
    Y(2,1) = c2(1,2) ;
   
     p1 = line(X,Y) ;
      hold on
      scatter(X,Y,'MarkerFaceColor','b','MarkerEdgeColor','g') ;
      hold on ;
   
end


end

