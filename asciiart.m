%Lettura dell'immagine
imgi = imread("img/lena.png");
%imgi = imresize(imread("img/img2.jpg"), [512, 512]);

% Carichiamo in una CELL ARRAY (parentesi graffe)
nomi = ["spazio", "punto", "duepunti", "meno", "piu", "asterisco", "ics", "cancelletto", "percentuale", "chiocciola"];
caratteri = cell(1, 10);

for i = 1:10
    img = imread("img/caratteri/" + nomi(i) + ".png");
    
    % Forza l'immagine a essere 8x8 uint8 a 1 canale, ignorando trasparenza o colori
    if size(img, 3) > 1
        img = img(:,:,1); % Prende solo il primo canale se è RGB o ha Alfa
    end
    %caratteri{i} = uint8(img); % Forza il tipo uint8
    % 2. CORREZIONE AUTOSCALE (L'accensione dei pixel)
    % Se il valore massimo è 1, moltiplichiamo per 255
    if max(img(:)) <= 1
        img = uint8(double(img) * 255); 
    else
        img = uint8(img);
    end
    
    caratteri{i} = img;

end



%Scala di grigi
gray = rgb2gray(imgi);
gray = imadjust(gray); %%%Aggiusta l'immagine per renderla più facile da distinguere nell'ascii art

%prendo l'immagine a blocchi di pixel 8x8
[righe, colonne] = size(gray);

%fprintf("\nrighe:"+righe+"\ncolonne:"+colonne);

%Creo immagine vuota tutta bianca
vuota=uint8(255*ones(righe, colonne));

temp=0.0;
valoremedio= 25.5;

for bloccoy = 1 : 8 : righe - 7
    for bloccox = 1 : 8 : colonne - 7
        
        temp=0.0;
        for i = 0 : 7 
            for j = 0 : 7
                temp = temp + single(gray(bloccoy + i, bloccox + j));
            end
        end
            
        media=temp/64;
        %fprintf(media+" ");
        
        switch(true)
            case (media <= valoremedio) % 0 - 25.5
                vuota(bloccoy:bloccoy+7, bloccox:bloccox+7) = caratteri{10}; % Più scuro (@)
            case (media <= valoremedio*2) % 25.5 - 51
                vuota(bloccoy:bloccoy+7, bloccox:bloccox+7) = caratteri{9}; %percentuale
            case (media <= valoremedio*3) % 51 - 76.5
                vuota(bloccoy:bloccoy+7, bloccox:bloccox+7) = caratteri{8}; %cancelletto
            case (media <= valoremedio*4) 
                vuota(bloccoy:bloccoy+7, bloccox:bloccox+7) = caratteri{7}; %lettera
            case (media <= valoremedio*5)  
                vuota(bloccoy:bloccoy+7, bloccox:bloccox+7) = caratteri{6};  %asterisco
            case (media <= valoremedio*6) 
                vuota(bloccoy:bloccoy+7, bloccox:bloccox+7) = caratteri{5}; % più
            case (media <= valoremedio*7) 
                vuota(bloccoy:bloccoy+7, bloccox:bloccox+7) = caratteri{4}; % trattino
            case (media <= valoremedio*8) 
                vuota(bloccoy:bloccoy+7, bloccox:bloccox+7) = caratteri{3}; %due punti
            case (media <= valoremedio*9) 
                vuota(bloccoy:bloccoy+7, bloccox:bloccox+7) = caratteri{2}; %punto
            otherwise % Sopra 229.5 fino a 255
                vuota(bloccoy:bloccoy+7, bloccox:bloccox+7) = caratteri{1}; % Più chiaro (spazio) 
            
        end


    
    end
    %fprintf("\n")
end


subplot(1,2,1); imshow(uint8(gray), [0 255]); title("Scala di grigi");
subplot(1,2,2); imshow(uint8(vuota), [0 255]); title("Ascii art");
