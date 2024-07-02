/*
el skecth visualiza las frecuencias en cada frame
 definidas por la transformada rápida de fourier FFT
 
 ph.d. franklin hernandez-castro, TEC costa rica, 2022
 */

// importa la biblioteca y el módulo de análisis
import ddf.minim.analysis.*;
import ddf.minim.*;

int posicion=0;
int duracion=0;

Minim minim; // declara la instancia de la biblioteca
AudioPlayer cancion; // declara la variable que contendrá la canción
FFT fftLog; // objeto que hace el análisis de las frecuencias logarítmicas
FFT fftLin; // objeto que hace el análisis de las frecuencias lineales
AudioMetaData metaDatos; // objeto para obtener datos de la canción

int tamagnoDeBuffer = 1024; // se puede usar 1024 pero 512 es más fácil de analisar visualmente

float maximo = 0;
color colorDeFondo = color (64);
float actualMax = 0;

// setup () ---------------------------------------------
void setup() {
  size(700, 400);
  colorMode(HSB, 360, 100, 100, 1);
  minim = new Minim(this);
  smooth();
  rectMode(CENTER);

  // se carga la canción y se especifica el tamaño del búfer en 512
  cancion = minim.loadFile("marcus_kellis_theme.mp3", tamagnoDeBuffer);

  metaDatos = cancion.getMetaData(); // carga los megadatos del archivo
  cancion.play(); // si se termina vuelve a empezar

  // crea el objeto FFT logarítmico con el tamaño de búfer y su relación de muestras
  // ambos son 1024 en este caso
  fftLog = new FFT( cancion.bufferSize(), cancion.sampleRate() );
  // calcula los promedios basandose en octabas que comienzan en 22 Hz
  // cada octaba la parte en tres bandas resultando 30 bandas en total
  fftLog.logAverages( 22, 3 );

  // crea el objeto FFT lineal con el tamaño de búfer y su relación de muestras
  // ambos son 1024 en este caso
  fftLin = new FFT( cancion.bufferSize(), cancion.sampleRate() );
  // calcula linearmente las bandas en grupos con promedio de 30
  fftLin.linAverages( 30 );
} // end of setup()



// draw () ---------------------------------------------
void draw() {
  background(0);

  // calcula logaritmicamente las frecuencias en el canal mixto
  fftLog.forward( cancion.mix );

  // calcula linealmente las frecuencias en el canal mixto
  fftLin.forward( cancion.mix );

  for (int i = 0; i < fftLog.specSize(); i++) {
    // notas muy bajos y colores azules ---------------------
    noStroke();
    int bandaActual = 7;
    if (i>bandaActual-5 && i <bandaActual+5) {
      //if (maximo < fftLog.getBand(i)) maximo = fftLog.getBand(i);
      float ancho = fftLog.getBand(i) * 200;
      float alto = fftLog.getBand(i) * 100;
      float transparencia = map (fftLog.getBand(i), 0, 3, 1, 0.5);
      colorDeFondo = color (200, 85, 85, transparencia); // color base 219,42,67 o #637CAD
      fill(colorDeFondo);
      rect(width/2, height/2, ancho, alto);
      //imprimaValoresMaximos (i, bandaActual);
    }

    // notas intermedias y colores amarillos ---------------------
    bandaActual = 90;
    if (i>bandaActual-10 && i <bandaActual+10) {
      //if (maximo < fftLog.getBand(i)) maximo = fftLog.getBand(i);
      float tamagnoDeEllipse = fftLog.getBand(i) * 30;
      stroke (55, 100, 100, 0.5);
      strokeWeight(tamagnoDeEllipse/20);
      noFill();
      if (fftLog.getBand(i)>2) ellipse(350, 200, tamagnoDeEllipse, tamagnoDeEllipse);
      //imprimaValoresMaximos (i, bandaActual);
    }
  } // fin del ciclo FOR de visualización del gráfico por logaritmo

  // la elipse verde, que se basa en el aumento del promedio total de frecuencias
  for (int i = 0; i < fftLin.avgSize (); i++) {
    if (actualMax < fftLin.getAvg(i))actualMax = fftLin.getAvg(i);
    if (actualMax>41) {
      stroke(100, 255, 255, 0.5);
      fill(100, 255, 255, 0.5);
      strokeWeight(1);
      ellipse(width/2, height/2, -fftLin.getAvg(i)*16, 30 );
    }
  } // end FOR de promedios

  // aguja para ver por donde va la canción
  float agujaX = map(cancion.position(), 0, cancion.length(), 0, width);
  stroke(255);
  strokeWeight(1);
  line(agujaX, height-10, agujaX, height-15);
} // end of draw()


// eventos ---------------------------------------------

void mouseReleased() {
  boolean encima = mouseY>height-15 && mouseY<height;
  if (encima) {
    // coloca la cabeza en donde se haga click
    int position = int( map( mouseX, 0, width, 0, cancion.length() ) );
    cancion.cue( position );
    actualMax=0;
  }
}


void keyPressed() {
  if (key == CODED) { // si no es una letra
    if (keyCode == UP) {
      cancion.cue( 0 );
    } else if (keyCode == DOWN) {
      cancion.cue( 0 );
    }
    if (keyCode == LEFT) {
      cancion.skip(-1000);
    } else if (keyCode == RIGHT) {
      cancion.skip(1000);
    }
  } else { // si es una letra
    if ( key == ' ' ) {
      if ( cancion.isPlaying() ) cancion.pause();
      else cancion.loop();
    }
  } // end si es una letra
} // end keyPressed()
