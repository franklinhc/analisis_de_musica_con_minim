/*
sketch para visualizar la amplitud promedio de cada frame
 de una canción
 
 ph.d. franklin hernández-castro | tec costa rica | HfG gmuend | junio 2022
 www.skizata.com
 */

import ddf.minim.*; // importa la biblioteca
Minim minim; // declara la instancia de la biblioteca
AudioPlayer cancion; // declara la variable que contendrá la canción

// setup () ---------------------------------------------
void setup() {
  size(600, 600);
  minim = new Minim(this);
  cancion = minim.loadFile("groove.mp3");
  cancion.loop();
} // end of setup()


// draw () ---------------------------------------------
void draw() {
  background(64);
  // el ámbito de la amplitud (cancion.mix.level()) es [0,1] ya que es la media cuadrática de todas
  // las amplitudes cuyo ámbito es [-1,1]
  float radio = map(cancion.mix.level(), 0, 1, 50, width*4);
  stroke(#689DBC); // color celeste

  for (float alfa=0; alfa<TWO_PI; alfa+=0.105) { // 0.105 para 60 rayos 2*PI/60
    float x1Ahora = width/2 + cos (alfa) * 50;
    float y1Ahora = width/2 + sin (alfa) * 50;
    float x2Ahora = width/2 + cos (alfa) * radio;
    float y2Ahora = width/2 + sin (alfa) * radio;
    strokeWeight(3);
    line(x1Ahora, y1Ahora, x2Ahora, y2Ahora);
  }

} // end of draw()
