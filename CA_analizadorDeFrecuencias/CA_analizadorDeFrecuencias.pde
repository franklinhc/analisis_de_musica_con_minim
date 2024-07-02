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
FFT fftLog; // objeto que hace el análisis de las frecuencias
AudioMetaData metaDatos; // objeto para obtener datos de la canción

int tamagnoDeBuffer = 512; // se puede usar 1024 pero 512 es más fácil de analisar visualmente
boolean ayuda = false; // para visualizar la ayuda en la esquina superior derecha



// setup () ---------------------------------------------
void setup() {
  size(700, 400, P3D);
  colorMode(HSB, 360, 100, 100, 1);
  minim = new Minim(this);

  // se carga la canción y se especifica el tamaño del búfer en 512
  // las FFT solo funcionan con tamaños de búfer en potencias de dos
  //cancion = minim.loadFile("groove.mp3", tamagnoDeBuffer);
  //cancion = minim.loadFile("jingle.mp3", tamagnoDeBuffer);
  //cancion = minim.loadFile("mambo_craze.mp3", tamagnoDeBuffer);
  //cancion = minim.loadFile("marcus_kellis_theme.mp3", tamagnoDeBuffer);
  cancion = minim.loadFile("paris_texas.mp3", tamagnoDeBuffer);

  metaDatos = cancion.getMetaData(); // carga los megadatos del archivo
  cancion.loop(); // si se termina vuelve a empezar

  // crea el objeto FFT con el tamaño de búfer y su relación de muestras
  // ambos son 512 en este caso
  fftLog = new FFT( cancion.bufferSize(), cancion.sampleRate() );

  // calcula los promedios basandose en octabas que comienzan en 22 Hz
  // cada octaba la parte en tres bandas resultando 30 bandas en total
  fftLog.logAverages( 22, 3 );
} // end of setup()



// draw () ---------------------------------------------
void draw() {
  background(64);

  // calcula logaritmicamente las frecuencias en el canal mixto
  fftLog.forward( cancion.mix );

  float colorDeLinea =0; // variable para clacular el HUE de la banda
  float baseDeLinea = height*0.75; // altura de todo el gráfico
  float anchoDeLinea = 5; // ancho de la barra de cada banda
  strokeWeight(anchoDeLinea);

  for (int i = 0; i < fftLog.specSize(); i+=3) {
    // define un espectro de colores de azul a amarillo
    if (i<fftLog.specSize()*0.65) colorDeLinea = map (i, 0, fftLog.specSize()*0.65, 255, 360);
    else colorDeLinea = map (i, fftLog.specSize()*0.65, fftLog.specSize(), 0, 62);
    stroke(colorDeLinea, 100, 80);
  
    float xActual = 100 + i * fftLog.specSize()/125; // distribución en Xs

    // dibuja la frecuencias de las bandas definidas
    line( xActual, baseDeLinea, xActual, baseDeLinea - fftLog.getBand(i)*16 );

    // para los textos de las escalas en Xs de las barras
    if (i%5==0) {
      fill(255);
      text(i, xActual, baseDeLinea+20);
    }
  } // fin del ciclo for de visualización del gráfico


  // CONTROLES --------------------------------------------------
  // rectángulo de fondo del player
  noStroke();
  fill(255, 0.1);
  rect(0, height-35, width, 10);

  // aguja para ver por donde va la canción
  float agujaX = map(cancion.position(), 0, cancion.length(), 0, width);
  stroke(255);
  strokeWeight(1);
  line(agujaX, height-25, agujaX, height-35);
  
  // para GRABAR PNG --------------------------------------------------
  if (keyPressed && key == 's') saveFrame("line-######.png");

  // textos finales  --------------------------------------------------
  fill(255);
  text("fftLog.specSize(): " + fftLog.specSize(), 5, height-10);
  text("tamagnoDeBuffer: " + tamagnoDeBuffer, 150, height-10);
  text("duracion: " + cancion.length(), 300, height-10);
  text("posición: " + cancion.position(), 400, height-10);
  text("canción: " + metaDatos.fileName(), 500, height-10);

  text("?", width-15, 15);

  if (ayuda) mostrarAyudas();
} // end of draw()


// eventos ---------------------------------------------

void mouseReleased() {
  boolean encima = mouseY>height-35 && mouseY<height-25;
  if (encima) {
    // coloca la cabeza en donde se haga click
    int position = int( map( mouseX, 0, width, 0, cancion.length() ) );
    cancion.cue( position );
  }
  if (dist(mouseX, mouseY, width-12, 12)<10) ayuda=!ayuda;
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


// miscelaneos ---------------------------------------------
// imprime las ayudas en la esquina superior derecha
void mostrarAyudas() {
  fill(255);
  text("<-    = -1 seg.", width-120, 15);
  text("->    = +1 seg.", width-120, 25);
  text("^     = 0", width-120, 35);
  text("space = pause/play", width-120, 45);
  text("s = salva png", width-120, 55);
}
