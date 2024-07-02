/*
visualización para mostrar la posibildad de análisis de una canción 

 ph.d. franklin hernandez-castro, TEC costa rica, 2022
 */

// importa la biblioteca y el módulo de análisis
import ddf.minim.analysis.*;
import ddf.minim.*;

int posicion=0;
int duracion=0;

Minim minim; // declara la instancia de la biblioteca
AudioPlayer cancion; // declara la variable que contendrá la canción
FFT fftLog; // objeto que hace el análisis de las frecuencias

int tamagnoDeBuffer = 512; // se puede usar 1024 pero 512 es más fácil de analisar visualmente
color colorDeFondo = color (64);

// setup () ---------------------------------------------
void setup() {
  size(700, 400, P3D);
  colorMode(HSB, 360, 100, 100, 1);
  minim = new Minim(this);
  smooth();

  // se carga la canción y se especifica el tamaño del búfer en 512
  cancion = minim.loadFile("paris_texas.mp3", tamagnoDeBuffer);
  cancion.loop(); // si se termina vuelve a empezar

  // crea el objeto FFT con el tamaño de búfer y su relación de muestras
  // ambos son 512 en este caso
  fftLog = new FFT( cancion.bufferSize(), cancion.sampleRate() );

  // calcula los promedios basandose en octabas que comienzan en 22 Hz
  // cada octava la parte en tres bandas resultando 30 bandas en total
  fftLog.logAverages( 22, 3 );
} // end of setup()



// draw () ---------------------------------------------
void draw() {
  background(0);

  // calcula logaritmicamente las frecuencias en el canal mixto
  fftLog.forward( cancion.mix );

  for (int i = 0; i < fftLog.specSize(); i++) { 
    noStroke();
    
    // notas muy bajos y colores azules ---------------------
    int bandaActual = 3; 
    if (i>bandaActual-1 && i<bandaActual+1) { // define un rango de tres bandas
      fill (255, 100, 100, 0.5);
      float transparencia = map (fftLog.getBand(i), 0,3, 1, 0);
      colorDeFondo = color (219, 50, 50, transparencia); // color base 219,42,67 o #637CAD
      fill(colorDeFondo);
      rect(0,0,width,height); // pinta un rectángulo del tamaño total con transparencia variable
    }

    // notas medias y colores amarillo ------------------------
    bandaActual = 10;  
    if (i>bandaActual-3 && i <bandaActual+1) { // define un rango de tres bandas
      float tamagnoDeEllipse = fftLog.getBand(i) * 30;
      float grosorDelContorno = fftLog.getBand(i);
      stroke (55, 100, 100, 0.8);
      strokeWeight(grosorDelContorno);
      noFill();
      if (fftLog.getBand(i)>2) ellipse(350, 200, tamagnoDeEllipse, tamagnoDeEllipse);
    }
  } // fin del ciclo for de visualización del gráfico
  
  
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
