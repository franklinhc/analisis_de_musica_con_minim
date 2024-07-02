/*
el skecth visualiza las frecuencias en cada frame
definidas por la transformada rápida de fourier FFT

código original de la biblioteca minim
http://code.compartmental.net/minim/

modificado por
ph.d. franklin hernandez-castro, TEC costa rica, 2022
*/

 // importa la biblioteca y el módulo de análisis
import ddf.minim.analysis.*;
import ddf.minim.*;


Minim       minim; // declara la instancia de la biblioteca
AudioPlayer jingle; // declara la variable que contendrá la canción
FFT         fft; // objeto que hace el análisis de las frecuencias 

float maximo, minimo;

// setup () ---------------------------------------------
void setup() {
  size(700, 400);
  colorMode(HSB, 360, 100, 100, 1);
  strokeCap(SQUARE);
  
  minim = new Minim(this);
  
  // se carga la canción y se especifica el tamaño del búfer en 1024
  // las FFT solo funcionan con tamaños de búfer en potencias de dos
  jingle = minim.loadFile("jingle.mp3", 1024);
  
  jingle.loop(); // si se termina vuelve a empezar
  
  // crea el objeto FFT con el tamaño de búfer y su realción de muestras
  // ambos son 1024 en este caso
  fft = new FFT( jingle.bufferSize(), jingle.sampleRate() );

} // end of setup()



// draw () ---------------------------------------------
void draw() {
  background(64); 

  // calcula las frecuencias en el canal mixto
  fft.forward( jingle.mix );
  
  float colorDeLinea =0;
  
  for(int i = 0; i < fft.specSize(); i+=10) {  
    if(i<296) colorDeLinea = map (i, 0, 296, 250, 360);
    else colorDeLinea = map (i, 296, 1024, 0, 250);
    
    stroke(colorDeLinea,100,80);
    strokeWeight(10);

    // dibuja la frecuencias de las 1024 bandas definidas
    line( i+100, height*0.75, i+100, height*0.75 - fft.getBand(i)*16 );
  }
  
} // end of draw()
