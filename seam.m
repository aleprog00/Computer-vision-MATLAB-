%Leggo l'immagine
img = imread("img\lena.png");

%Converto in scala di grigi
gray = single(rgb2gray(img));

segnale = gray;


%Misure dell'immagine (matrice)
[righe, colonne] = size(gray);

%trovo il gradiente
%Convoluzione con sobel
sobel = fspecial('sobel');
gradiente = conv2(double(gray), sobel, 'same');

%Prendo i positivi energia
gradiente = abs(gradiente);

%Matrice dei percorsi
percorso = zeros(righe, colonne);


%Primo ciclo per avere tutti i percorsi
%percorso(1,:) = gradiente(1,:);

for j = 1 : colonne
    k=j;
    percorso(1,j) = gradiente(1,k);

    for i = 1 : righe - 1

        %Bordo estremo sinistro
        if( k == 1)
            if(gradiente(i+1,k) <= gradiente(i+1,k+1))
                min = gradiente(i+1,k);
            else
                min = gradiente(i+1,k+1);
                k=k+1;
            end
            
        %Bordo estremo destro    
        elseif( k == colonne)
            if(gradiente(i+1,k) <= gradiente(i+1,k-1))
                min = gradiente(i+1,k);
            else
                min = gradiente(i+1,k-1);
                k=k-1;
            end

        %Pixel centrale    
        else
            if(gradiente(i+1,k-1) <= gradiente(i+1,k) && gradiente(i+1,k-1) <= gradiente(i+1,k+1))
                min = gradiente(i+1,k-1);
                k=k-1;
                
            elseif(gradiente(i+1,k)<=gradiente(i+1,k-1) && gradiente(i+1,k) <= gradiente(i+1,k+1))
                min = gradiente(i+1,k);
            else
                min = gradiente(i+1,k+1);
                k=k+1;
            end

            %percorso(i+1,j) = min(min(gradiente(i+1,j-1),gradiente(i+1,j)),gradiente(i+1,j+1));
        end        
        percorso(i+1,j) = min;
        
    end
end


%Ho tutti i percorsi, devo prendere il minimo
%minimo = sum(percorso(:,1)); %TUTTA LA COLONNA
minimo = sum(abs(double(percorso(:, j))));
colonnaminima=1;

%Trovo qual è il percorso minimo e da quale colonna parte
for j = 2 : colonne
    %percorso(:,j) = double(percorso(:,j));
    %somma=sum(percorso(:,j));
    somma = sum(abs(double(percorso(:, j))));
    if(somma<minimo)
        minimo = somma;
        fprintf("PERCORSO N°"+j+" = "+minimo+"\n");
        colonnaminima=j;
    end
end

%Marco il segnale della prima riga
%segnale(1,colonnaminima)=0;




%Creazione immagine vuota più ristretta
ristretta = zeros(righe, colonne-1);



%Ultimo for per rimuovere effettivamente il percorso minimo
%for j = colonnaminima

    fprintf(colonnaminima+"colonnaminima\n");
    k=colonnaminima;
    ristretta(1,:)=[gray(1,1:colonnaminima-1),gray(1,colonnaminima+1:colonne)];

    %Marco il segnale
    segnale(1,colonnaminima) = 0;

    for i = 1 : righe - 1
        
        %Bordo estremo sinistro
        if( k ==1)
            if(gradiente(i+1,k) <= gradiente(i+1,k+1))
                min = gradiente(i+1,k);
            else
                min = gradiente(i+1,k+1);
                k=k+1;
            end
            
        %Bordo estremo destro    
        elseif( k == colonne)
            if(gradiente(i+1,k) <= gradiente(i+1,k-1))
                min = gradiente(i+1,k);
            else
                min = gradiente(i+1,k-1);
                k=k-1;
            end

        %Pixel centrale    
        else
            if(gradiente(i+1,k-1) <= gradiente(i+1,k) && gradiente(i+1,k-1) <= gradiente(i+1,k+1))
                min = gradiente(i+1,k-1);
                k=k-1;
                
            elseif(gradiente(i+1,k)<=gradiente(i+1,k-1) && gradiente(i+1,k) <= gradiente(i+1,k+1))
                min = gradiente(i+1,k);
            else
                min = gradiente(i+1,k+1);
                k=k+1;
            end
                

            %percorso(i+1,j) = min(min(gradiente(i+1,j-1),gradiente(i+1,j)),gradiente(i+1,j+1));
        end
        ristretta(i,:)=[gray(i,1:k-1),gray(i,k+1:colonne)];
        %Marco il segnale
        segnale(i,k) = 0;
        %fprintf("k-1: "+(k-1) + " k: "+ k + " k+1:"+(k+1) +" \n");
        %fprintf("gray: "+gray(i,k-1) + " k: "+ gray(i,k) + " k+1:"+ gray(i,k+1) +" \n");
    end


%subplot(2,2,1); imshow(uint8(img)); title("Colori");

%Visualizzo il gradiente
subplot(2,2,1); imshow(uint8(gray)); title("Scala di grigi");

subplot(2,2,2); imshow(uint8(gradiente)); title("Gradiente");

subplot(2,2,3); imshow(uint8(ristretta)); title("Ristretta di 1px");

subplot(2,2,4); imshow(uint8(segnale)); title("Segnale del percorso");


