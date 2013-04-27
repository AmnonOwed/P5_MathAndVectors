
/*

 Point In Triangle by Amnon Owed (April 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon

 Check if point P is in triangle ABC.

 Source: http://www.blackpawn.com/texts/pointinpoly/

 Built with Processing 1.5.1

*/

PVector a, b, c, p;

void setup() {
  size(700, 700);
  a = new PVector(100, 100);
  b = new PVector(600, 300);
  c = new PVector(300, 600);
  p = new PVector();
  noStroke();
  smooth();
}

void draw() {
  background(255);
  p.set(mouseX, mouseY, 0);
  if ( pointInTriangle(p, a, b, c) ) {
    fill(0, 200, 0);
  } else {
    fill(200, 0, 0);
  }
  triangle(a.x, a.y, b.x, b.y, c.x, c.y);
}

boolean pointInTriangle(PVector P, PVector A, PVector B, PVector C) {

  // Compute vectors        
  PVector v0 = PVector.sub(C, A);
  PVector v1 = PVector.sub(B, A);
  PVector v2 = PVector.sub(P, A);

  // Compute dot products
  float dot00 = PVector.dot(v0, v0);
  float dot01 = PVector.dot(v0, v1);
  float dot02 = PVector.dot(v0, v2);
  float dot11 = PVector.dot(v1, v1);
  float dot12 = PVector.dot(v1, v2);

  // Compute barycentric coordinates
  float invDenom = 1 / (dot00 * dot11 - dot01 * dot01);
  float u = (dot11 * dot02 - dot01 * dot12) * invDenom;
  float v = (dot00 * dot12 - dot01 * dot02) * invDenom;

  // Check if point is in triangle
  return (u >= 0) && (v >= 0) && (u + v < 1);
}

