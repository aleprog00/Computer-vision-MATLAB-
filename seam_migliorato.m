img = imread("img/lena.png");

%Converto in scala di grigi
gray = single(rgb2gray(img));

segnale = gray;

%Misure dell'immagine (matrice)
[righe, colonne] = size(gray);

%Matrice di sobel per fare il gradiente
sobel = fspecial('sobel');
gradiente=conv2(gray,sobel,"same");


%Prendo i positivi energia
gradiente = abs(gradiente);

%Matrice dei percorsi
minimo = inf;
sommapercorso = zeros(colonne);
colonnaminima=1;

for j = 1 : colonne
    k=j;
    min=0;
    sommapercorso(j) = gradiente(1,k);
    
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
        sommapercorso(j) = sommapercorso(j) + min;

    end

    %fprintf("Percorso:"+ minimo + "\n");
    
    if sommapercorso(j) < minimo
        minimo = sommapercorso(j);
        colonnaminima=j;
    end


end

nuova=zeros(righe, colonne-1);
k=colonnaminima;

for i = 1 : righe - 1

    %Bordo estremo sinistro
    if( k == 1)
        if(gradiente(i+1,k) <= gradiente(i+1,k+1))
            
        else
            
            k=k+1;
        end
        
    %Bordo estremo destro    
    elseif( k == colonne)
        if(gradiente(i+1,k) <= gradiente(i+1,k-1))
        else
            k=k-1;
        end

    %Pixel centrale    
    else
        if(gradiente(i+1,k-1) <= gradiente(i+1,k) && gradiente(i+1,k-1) <= gradiente(i+1,k+1))
            k=k-1;
        elseif(gradiente(i+1,k)<=gradiente(i+1,k-1) && gradiente(i+1,k) <= gradiente(i+1,k+1))
        else
            k=k+1;
        end
    end        
    segnale(i,k)=0;
    nuova(i,:) = [gray(i,1:k-1),gray(i,k+1:colonne)];

end


subplot(2,2,1); imshow(uint8(gray)); title("Bianco e nero");
subplot(2,2,2); imshow(uint8(gradiente)); title("Gradiente");
subplot(2,2,3); imshow(uint8(segnale)); title("Segnale");
subplot(2,2,4); imshow(uint8(nuova)); title("Nuova");
   