clc; close all; clear;
%% COMPORT AYARLARI

s = serialport("COM6",115200);    %Comport ayarları yapıldı.
%% MOBİL KAMERA AYARLARI

m = mobiledev;                    % Telefon kamerasıyla bağlantı kuruldu.
cam = camera(m,'back');           % Telefonun arka kamerası seçildi.
r1 = snapshot(cam,'manual');      % Manuel komutuyla deklanşöre basıldığında görüntü alınacak. 
%% TEMEL GÖRÜNTÜ İŞLEMLERİ

imshow(r1),title("original");     %Çekilen fotoğraf ekranda gösterilir.
G=rgb2gray(r1);                   %Gri görüntüye çevrilir. Gri görüntüde tüm kanal değerleri aynı değerde olur.

figure;                           % İki veya daha fazla pencere açılımını sağlamak için gerekli.

Red=r1(:,:,1);                    % Kırmızı bileşenler belirlenir.   
subplot(1,3,1);
imshow(Red), title("Red Channel");

Green=r1(:,:,2);                  % Yeşil bileşenler belirlenir.
subplot(1,3,2);
imshow(Green), title("Green Channel");

Blue=r1(:,:,3);                   % Mavi bileşenler belirlenir.
subplot(1,3,3);
imshow(Blue), title("Blue Channel");
%% GÖRÜNTÜYÜ MASKELEME İŞLEMLERİ
figure;

R=imsubtract(Red,G);               %Bir görüntüyü diğerinden çıkarır. 
R=imbinarize(R, 0.18);             %Görüntüyü binary forma dönüştürür.
subplot(1,3,1);
imshow(R); title("Red Mask");


Gr=imsubtract(Green,G);
Gr=imbinarize(Gr, 0.18);
subplot(1,3,2);
imshow(Gr); title("Green Mask");
  

B=imsubtract(Blue,G);
B=imbinarize(B, 0.18);
subplot(1,3,3);
imshow(B);   title("Blue Mask");
%% VERİLERİ YAZMA VE OKUMA İŞLEMLERİ

rsum1 = sum(sum(R))         % Vektör toplamı satır ve sütunlar toplanır. Red için. 
rsum2 = sum(sum(Gr))        % Vektör toplamı satır ve sütunlar toplanır. Green için. 
rsum3 = sum(sum(B))         % Vektör toplamı satır ve sütunlar toplanır. Blue için. 

if (rsum1>30000)
write(s,'r','char');        % Verileri seri porta yaz
read(s,20,'char')           % Seri porttan veri oku
end

if (rsum2>30000)
write(s,'g','char');        % Verileri seri porta yaz  
read(s,18,'char')           % Seri porttan veri oku
end

if (rsum3>30000)
write(s,'b','char');        % Verileri seri porta yaz
read(s,17,'char')           % Seri porttan veri oku
end

flush(s);                   % Hem giriş hem de çıkış arabelleklerini temizler.
%%