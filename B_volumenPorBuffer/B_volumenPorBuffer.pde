/*
el skecth visualiza el buffer de las 1024 muestras de amplitudes
en un frame de processing
ph.d. franklin hernandez-castro, TEC costa rica, 2022
*/

import ddf.minim.*; // importa la biblioteca
Minim minim; // declara la instancia de la biblioteca
AudioPlayer cancion; // declara la variable que contendrá la canción


// setup () ---------------------------------------------
void setup() {
  size(1500, 500);
  minim = new Minim(this); // inicializacion de la biblioteca
  
  // inicializa la variable "cancion" cargando la canción desde el folder data
  cancion = minim.loadFile("marcus_kellis_theme.mp3");
  cancion.play(); // pone a sonar la canción
  
} // end of setup()



// draw () ---------------------------------------------
void draw() {
  background(64); // gris 25%
  float mitadAltura = height/2; // valor de y a la mitad de la ventana
  
  // pregunta el tamaño del buffer, por omisión es 1024
  int numeroDeMuestras = cancion.mix.size();
  
  // ciclo que recorre los 1024 valores del buffer y hace una línea vertical por cada valor
  for (int i = 0; i < numeroDeMuestras; i++) {
    //calculo de la longitud de la linea
    float x = map(i, 0, numeroDeMuestras -1, 0, width); // distribución de las Xs en el ancho
    float y = map(cancion.mix.get(i), 1, -1, 0, height); // altura de las Ys según las muestras
    
    // dibuja la linea
    stroke(#689DBC); // color celeste
    line(x, mitadAltura, x, y);
    // dibuja el punto
    noStroke();
    fill(#FCC703); // color mostaza
    ellipse(x, y, 1, 1);
  }
} // end of draw()
