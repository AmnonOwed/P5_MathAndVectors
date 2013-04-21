
/*

 Rectangles Overlap by Amnon Owed (April 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon

 Get the overlapping area of two intersecting rectangles.

 Built with Processing 1.5.1

*/

PVector p1 = new PVector(300, 300);
float w1 = 150;
float h1 = 200;
float w2 = 200;
float h2 = 150;
 
void setup() {
  size(800, 800);
}
 
void draw() {
  background(255);
  PVector p2 = new PVector(mouseX, mouseY);
  noFill();
  rect(p1.x, p1.y, w1, h1);
  rect(p2.x, p2.y, w2, h2);
  if (rectCollision(p1,w1,h1, p2,w2,h2)) {
    PVector q1 = new PVector(max(p1.x, p2.x), max(p1.y, p2.y));
    PVector q2 = new PVector(min(p1.x+w1, p2.x+w2), min(p1.y+h1, p2.y+h2));
    float wq = q2.x - q1.x;
    float hq = q2.y - q1.y;
    fill(255, 0, 0);
    rect(q1.x, q1.y, wq, hq);
  }
}
 
boolean rectCollision(PVector p1, float w1, float h1, PVector p2, float w2, float h2) {
  return !(p1.x > p2.x + w2 || p1.x + w1 < p2.x || p1.y > p2.y + h2 || p1.y + h1 < p2.y);
}

