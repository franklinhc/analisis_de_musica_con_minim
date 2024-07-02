/*
el skecth visualiza el buffer de las 1024 muestras de amplitudes
y lo combina con un sistema de partículas a través de geometría polar
 ph.d. franklin hernandez-castro, TEC costa rica, 2022
 */

import ddf.minim.*; // importa la biblioteca
Minim minim; // declara la instancia de la biblioteca
AudioPlayer cancion; // declara la variable que contendrá la canción

// variables del sistema de partículas
import traer.physics.*;
Particle atractor;            // particle on atractor position
Particle[] particulasLibres;      // the moving particle
Particle[] particulasFijas;   // original particles - fixed
Spring [] mySprings;
Attraction [] misAtracciones;
ParticleSystem mundoVirtual;    // the particle system

int nodesCount = 200;
float gridSizeX, gridSizeY, gapX, gapY;
int radio, numeroDeMuestras; // point size


// setup () ---------------------------------------------
void setup() {
  size(800, 800);
  minim = new Minim(this); // inicializacion de la biblioteca

  // inicializa la variable "cancion" cargando la canción desde el folder data
  cancion = minim.loadFile("mambo_craze.mp3");
  cancion.play(); // pone a sonar la canción

  mundoVirtual = new ParticleSystem(0.0, 0.001); // 0,0.05
  // inicialización de las partículas ---------------------------
  radio = height/8;
  atractor = mundoVirtual.makeParticle(1, width/2, height/2, 0);  // crea la partícula que funciona como atractor
  atractor.makeFixed();  // deja el atractor libre
  particulasLibres    = new Particle[nodesCount]; // lista de parículas moviles
  particulasFijas = new Particle[nodesCount]; // lista de parículas fijas
  mySprings = new Spring [nodesCount]; // lista de resortes
  misAtracciones  = new Attraction [nodesCount]; // lista de atracciones

  float gradStep = TWO_PI / nodesCount;

  // se crean las partículas y los resortes entre ellas
  for (int x=0; x<nodesCount; x++) {
    float xPos =  width/2 + radio * sin (x*gradStep) ;
    float yPos = height/2 + radio * cos (x*gradStep);

    particulasLibres[x]= mundoVirtual.makeParticle(0.8, xPos, yPos, 0);
    particulasFijas[x] = mundoVirtual.makeParticle(0.8, xPos, yPos, 0);
    particulasFijas[x].makeFixed();
    // se hacen los resortes entre las aprtículas móviles y las fijas
    mySprings[x]= mundoVirtual.makeSpring(particulasLibres[x], particulasFijas[x], 0.5, 0.1, 50 );
    // declara la fuerza hacia en atractor
    misAtracciones[x]= mundoVirtual.makeAttraction(particulasLibres[x], atractor, 10000000, 100); // 50000, 100
  }
  
} // end of setup()



// draw () ---------------------------------------------
void draw() {
  background(64); // gris 25%
  fill(#FCC703); // color mostaza
  mundoVirtual.tick(); // reloj del sistema de partículas

  // calcula la intensidad de la fuerza de repulsión al volumen del frame
  float fuerza = map(cancion.mix.level(), 0, 0.6, 0, -1000000);
  
  // ajusta la intensida de la fuerza en cada partícula al volumen de la música
  for (int x=0; x<nodesCount; x++) {
    misAtracciones[x].setStrength( fuerza );
  }
  
  // dibuja las partículas
  for (int x=0; x<nodesCount; x++) { 
    float posx = particulasLibres[x].position().x();
    float posy = particulasLibres[x].position().y();
    fill(#689DBC);
    fill(#FCC703); // color mostaza
    noStroke();
    ellipse(posx, posy, 4, 4);
  } // end ciclos for

  // dibuja los resortes
  for (int n =0; n < mySprings.length; n++) {
    float x1 = mySprings[n].getOneEnd().position().x();
    float y1 = mySprings[n].getOneEnd().position().y();
    float x2 = mySprings[n].getTheOtherEnd().position().x();
    float y2 = mySprings[n].getTheOtherEnd().position().y();
    stroke(#689DBC);
    line (x1, y1, x2, y2);
  }
  
} // end of draw()
