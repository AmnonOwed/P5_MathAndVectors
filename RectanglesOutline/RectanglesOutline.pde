
/*

 Rectangles Outline by Amnon Owed (April 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon

 Get the outer perimeter (outline) of two intersecting rectangles.

 Built with Processing 1.5.1

*/

PVector p1 = new PVector(300, 300);
PVector p2 = new PVector();
float w1 = 150;
float h1 = 200;
float w2 = 200;
float h2 = 150;
 
void setup() {
  size(800, 800);
  noFill();
}
 
void draw() {
  p2.set(mouseX, mouseY, 0);
  background(255);
  stroke(0);
  strokeWeight(1);
  rect(p1.x, p1.y, w1, h1);
  rect(p2.x, p2.y, w2, h2);
  
  if (rectCollision(p1, w1, h1, p2, w2, h2)) {
    ArrayList <PVector> vecs = new ArrayList <PVector> ();
    addPoint(vecs, new PVector(p1.x, p1.y));
    addPoint(vecs, new PVector(p1.x+w1, p1.y));
    addPoint(vecs, new PVector(p1.x+w1, p1.y+h1));
    addPoint(vecs, new PVector(p1.x, p1.y+h1));
    addPoint(vecs, new PVector(p2.x, p2.y));
    addPoint(vecs, new PVector(p2.x+w2, p2.y));
    addPoint(vecs, new PVector(p2.x+w2, p2.y+h2));
    addPoint(vecs, new PVector(p2.x, p2.y+h2));
    addPoint(vecs, new PVector(max(p1.x, p2.x), max(p1.y, p2.y)));
    addPoint(vecs, new PVector(min(p1.x+w1, p2.x+w2), max(p1.y, p2.y)));
    addPoint(vecs, new PVector(max(p1.x, p2.x), min(p1.y+h1, p2.y+h2)));
    addPoint(vecs, new PVector(min(p1.x+w1, p2.x+w2), min(p1.y+h1, p2.y+h2)));
    
    stroke(0, 0, 255);
    strokeWeight(15);
    for (PVector v : vecs) {
      PVector hnb = neighbour(vecs, v, true);
      PVector vnb = neighbour(vecs, v, false);
      line(hnb.x, hnb.y, v.x, v.y);
      line(vnb.x, vnb.y, v.x, v.y);
    }
  }
}
 
boolean rectCollision(PVector p1, float w1, float h1, PVector p2, float w2, float h2) {
  return !(p1.x > p2.x + w2 || p1.x + w1 < p2.x || p1.y > p2.y + h2 || p1.y + h1 < p2.y);
}
 
void addPoint(ArrayList <PVector> list, PVector v) {
  boolean r1 = pointInRect(v, p1, w1, h1);
  boolean r2 = pointInRect(v, p2, w2, h2);
  if (!r1&&!r2) { list.add(v); }
}
 
boolean pointInRect(PVector v, PVector p, float w, float h) {
  return (v.x > p.x && v.x < p.x+w && v.y > p.y && v.y < p.y+h);
}
 
PVector neighbour(ArrayList <PVector> list, PVector p, boolean horizontal) {
  ArrayList <PVector> neighbours = new ArrayList <PVector> ();
  for (PVector v : list) {
    if (v!=p) {
      if (horizontal) { if (v.y==p.y) { neighbours.add(v); } }
      else { if (v.x==p.x) { neighbours.add(v); } }
    }
  }
  if (neighbours.size()==1) { 
    return neighbours.get(0);
  } else {
    PVector v1 = neighbours.get(0);
    float d1 = v1.dist(p);
    for (int i=1; i<neighbours.size(); i++) {
      PVector v2 = neighbours.get(i);
      float d2 = v2.dist(p);
      if (d2<d1) {
        d1 = d2;
        v1 = v2;
      }
    }
    return v1;
  }
}

