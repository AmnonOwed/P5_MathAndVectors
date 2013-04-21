
/*

 Line Normal by Amnon Owed (April 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon

 Find the normal of a line between point A and B.
 The two perpendicular lines are drawn from the center of the line.

 Built with Processing 1.5.1

*/

void setup() {
  size(600, 600);
  strokeWeight(3);
  smooth();
}

void draw() {
  background(255);
  PVector s = new PVector(100, 100);
  PVector e = new PVector(mouseX, mouseY);
  line(s.x, s.y, e.x, e.y);
  ellipse(s.x, s.y, 10, 10);
  ellipse(e.x, e.y, 10, 10);
  PVector m = PVector.add(s,e);
  m.mult(0.5);
  ellipse(m.x, m.y, 10, 10);
  translate(m.x, m.y);
  PVector n = PVector.sub(e, s);
  n.normalize();
  n.mult(100);
  line(0, 0, -n.y, n.x);
  line(0, 0, n.y, -n.x);
}

