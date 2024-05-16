% Leer la imagen
img = imread("Almuerzos/Almuerzo_38.png");

% Convertir la imagen a espacio de color LAB
cform = makecform('srgb2lab');
imgLAB = applycform(img, cform);

% Preparar la imagen LAB para K-means
imgLAB_red = double(reshape(imgLAB, [], 3));

% Número de clusters para K-means
k = 5;

% Aplicar K-means clustering
[cluster_id, cluster_centro] = kmeans(imgLAB_red, k, 'Distance', 'sqeuclidean', 'Replicates', 5);

% Reestructurar los identificadores de clusters
etiqueta_pixeles = reshape(cluster_id, size(imgLAB, 1), size(imgLAB, 2));

% Inicializar celdas para las imágenes segmentadas
imagenes_segmentadas = cell(1, 5);

% Crear las imágenes segmentadas
etiqueta_RGB = repmat(etiqueta_pixeles, [1 1 3]);
for k = 1:5
    color = img;
    color(etiqueta_RGB ~= k) = 0;
    imagenes_segmentadas{k} = color;
end

% Mostrar la imagen original y las cinco secciones segmentadas
figure,
subplot(2, 3, 1), imshow(img), title('Imagen Original')
subplot(2, 3, 2), imshow(imagenes_segmentadas{1}), title('Sección 1')
subplot(2, 3, 3), imshow(imagenes_segmentadas{2}), title('Sección 2')
subplot(2, 3, 4), imshow(imagenes_segmentadas{3}), title('Sección 3')
subplot(2, 3, 5), imshow(imagenes_segmentadas{4}), title('Sección 4')
subplot(2, 3, 6), imshow(imagenes_segmentadas{5}), title('Sección 5')

% Calculo del área de cada segmento
areas = zeros(1, 5);
for k = 1:5
    areas(k) = sum(cluster_id == k);
end

% Suponiendo que hemos identificado los ingredientes y sus calorías por gramo
% Ingredientes identificados manualmente para cada cluster (ejemplo)
calorias_por_gramo = [1.5, 2.5, 0.9, 1.2, 1.8]; % Calorías estimadas por gramo para cada cluster

% Estimar el peso de cada segmento basado en el área relativa (ejemplo)
% Nota: Este paso requiere una calibración real del área a gramos
peso_total_estimado = 500; % peso total estimado del plato en gramos
peso_por_segmento = (areas / sum(areas)) * peso_total_estimado;

% Calorías estimadas por segmento
calorias_por_segmento = peso_por_segmento .* calorias_por_gramo;

% Calorías totales estimadas
calorias_totales_estimadas = sum(calorias_por_segmento);

% Mostrar las calorías estimadas
disp('Calorías estimadas por segmento:');
disp(calorias_por_segmento);
disp(['Calorías totales estimadas: ', num2str(calorias_totales_estimadas)]);
