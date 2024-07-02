/*
el skecth visualiza las frecuencias de la canciones y al presionar la tecla "c"
cambia de canción y sigue las visualizaciones, ambas canciones se encuentra en un ciclo forzado
ph.d. franklin hernandez-castro, TEC costa rica, 2022
*/

// importa la biblioteca y el módulo de análisis
import ddf.minim.analysis.*;
import ddf.minim.*;
Minim       minim; // declara la instancia de la biblioteca
AudioPlayer jingle, marcus; // declara la variable que contendrá la canción
FFT         fft1, fft2; // objetos que hace los análisis de las frecuencias

float maximo, minimo;

boolean cancion1 = true; // defini si suena la canción uno o la dos
int posicionJingle, posicionMarcus; // posición en la que está canción

// setup () ---------------------------------------------
void setup() {
  size(700, 400);
  colorMode(HSB, 360, 100, 100, 1);
  strokeCap(SQUARE);

  minim = new Minim(this);
  // se carga la canción y se especifica el tamaño del búfer en 1024
  // las FFT solo funcionan con tamaños de búfer en potencias de dos
  // canción uno
  jingle = minim.loadFile("jingle.mp3", 1024);
  jingle.loop(); // si se termina vuelve a empezar
  // canción dos
  marcus = minim.loadFile("marcus_kellis_theme.mp3", 1024);
  marcus.loop();

  // crean los objetos FFT con el tamaño de búfer y su realción de muestras en cada canción
  fft1 = new FFT( jingle.bufferSize(), jingle.sampleRate() );
  fft2 = new FFT( marcus.bufferSize(), marcus.sampleRate() );
} // end of setup()



// draw () ---------------------------------------------
void draw() {
  background(64);
  float colorDeLinea =0;
  // actualizan la posición de cada canción en cada ciclo
  posicionJingle = jingle.position();
  posicionMarcus = marcus.position();

  if (cancion1) { // si está sonando la canción uno
    marcus.pause(); // para la canción que no es
    jingle.cue(posicionJingle); // posiciona la canción donde estaba
    jingle.play(); // pone a sonar la canción
    // hace el ciclo en caso de que se haya acabado la canción
    if (jingle.position() == jingle.length()) jingle.cue(0);

    fft1.forward( jingle.mix ); // análiza las frecuencias

    // ciclo para dibuajr las frecuencias
    for (int i = 0; i < fft1.specSize(); i+=10) {
      if (i<296) colorDeLinea = map (i, 0, 296, 250, 360);
      else colorDeLinea = map (i, 296, 1024, 0, 250);
      stroke(colorDeLinea, 100, 80);
      strokeWeight(10);
      // dibuja la frecuencias de las 1024 bandas definidas
      line( i+100, height*0.75, i+100, height*0.75 - fft1.getBand(i)*16 );
    }
    
  } else { // si está sonando la canción dos
    jingle.pause(); // para la canción que no es
    marcus.cue(posicionMarcus); // posiciona la canción donde estaba
    marcus.play(); // pone a sonar la canción
    // hace el ciclo en caso de que se haya acabado la canción
    if (marcus.position() == marcus.length()) marcus.cue(0);

    fft2.forward( marcus.mix ); // análiza las frecuencias

    // ciclo para dibuajr las frecuencias
    for (int i = 0; i < fft2.specSize(); i+=10) {
      if (i<296) colorDeLinea = map (i, 0, 296, 250, 360);
      else colorDeLinea = map (i, 296, 1024, 0, 250);
      stroke(colorDeLinea, 100, 80);
      strokeWeight(10);
      // dibuja la frecuencias de las 1024 bandas definidas
      line( i+100, height*0.75, i+100, height*0.75 - fft2.getBand(i)*16 );
    }
  } // fin del end del if de cada canción
  
} // end of draw()



// eventos
void keyPressed() {
  if (key == 'c') cancion1 = !cancion1;
}
