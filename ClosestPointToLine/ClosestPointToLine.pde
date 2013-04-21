
/*

 Closest Point To Line by Amnon Owed (April 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon

 Find the closest point on line AB to point P.

 Built with Processing 1.5.1

*/

PVector p1 = new PVector(200, 200);
PVector p2 = new PVector(600, 600);
PVector p3 = new PVector();

void setup() {
  size(800, 800);
  noFill();
}

void draw() {
  background(255);
  p3.set(mouseX, mouseY, 0);
  noFill();
  stroke(0);
  strokeWeight(1);
  ellipse(p1.x, p1.y, 10, 10);
  ellipse(p2.x, p2.y, 10, 10);
  ellipse(p3.x, p3.y, 10, 10);
  line(p1.x, p1.y, p2.x, p2.y);
  PVector cp = closestPoint(p1, p2, p3);
  fill(255, 0, 0);
  ellipse(cp.x, cp.y, 15, 15);
}

PVector closestPoint(PVector a, PVector b, PVector p) {
  PVector v1 = a.get();
  PVector v2 = b.get();
  PVector v3 = p.get();
  v2.sub(v1);
  v3.sub(v1);
  float t = v3.dot(v2) / pow(v2.mag(), 2);
  if (t < 0.0) {
    return a.get();
  } else if (t > 1.0f) {
    return b.get();
  }
  v2.mult(t);
  return PVector.add(v1, v2);
}

