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
void setup(){
  size(600, 600);
  minim = new Minim(this);
  cancion = minim.loadFile("groove.mp3");
  cancion.loop();
  rectMode(CENTER);
} // end of setup()


// draw () ---------------------------------------------
void draw(){
  background(64);
  // el ámbito de la amplitud (cancion.mix.level()) es [0,1] ya que es la media cuadrática de todas las amplitudes
  float ladoDelCuadrado = map(cancion.mix.level(),0,1,0,width*4);
  fill(#689DBC); // color celeste
  noStroke();
  // dibuja el rectángulo
  rect(width/2,height/2, ladoDelCuadrado, ladoDelCuadrado);
} // end of draw()
