/*
el skecth visualiza el buffer de las 1024 muestras de amplitudes
en un frame de processing a través de geometría polar
ph.d. franklin hernandez-castro, TEC costa rica, 2022
*/

import ddf.minim.*; // importa la biblioteca
Minim minim; // declara la instancia de la biblioteca
AudioPlayer cancion; // declara la variable que contendrá la canción


// setup () ---------------------------------------------
void setup() {
  size(800, 800);
  minim = new Minim(this); // inicializacion de la biblioteca
  
  // inicializa la variable "cancion" cargando la canción desde el folder data
  cancion = minim.loadFile("marcus_kellis_theme.mp3");
  cancion.play(); // pone a sonar la canción
  
} // end of setup()



// draw () ---------------------------------------------
void draw() {
  background(64); // gris 25%
  // pregunta el tamaño del buffer, por omisión es 1024
  int numeroDeMuestras = cancion.mix.size();
  
  // para el ángulo de cada punto
  float incrementoA = TWO_PI/numeroDeMuestras; // divide el círculo en tantos ángulos como muestras tenga el buffer
  float angulo = 0; // ángulo para la geometría polar
  
  fill(#FCC703); // color mostaza
  for (int i = 0; i < numeroDeMuestras; i++) {
    // punto externo
    float radio1 = map(cancion.mix.get(i), 1, -1, 0, width/2);
    float x1Ahora = width/2 + cos(angulo) * radio1;
    float y1Ahora = width/2 + sin(angulo) * radio1;
    
    // punto interno
    float radio2 = map(cancion.mix.get(i), 1, -1, 0, width/4);
    float x2Ahora = width/2 + cos(angulo) * radio2;
    float y2Ahora = width/2 + sin(angulo) * radio2;
    
    // línea entre los puntos
    stroke(#689DBC, 128); // color celeste
    line(x1Ahora, y1Ahora, x2Ahora, y2Ahora);
    
    //elipse al final
    noStroke();
    ellipse(x1Ahora, y1Ahora, 3, 3);
    
    angulo+=incrementoA;
  }
  
} // end of draw()
