
/*

 Line Circle Intersection by Amnon Owed (April 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon
 
 I found several methods online that will return IF a line intersects with a circle,
 however methods that also return the points of intersection
 (as the lineIntersectCircle() method included below does)
 are much harder to find. Here is PVector-based implementation.

 Built with Processing 1.5.1

*/

int rad = 200;
PVector origin, mouse, moving;
PVector inA, inB, outA, outB;
 
void setup() {
  size(900, 900);
  origin = new PVector();
  mouse = new PVector();
  moving = new PVector();
  inA = new PVector(100, -50);
  inB = new PVector(-100, 100);
  outA = new PVector(-400, -350);
  outB = new PVector(300, -200);
  noFill();
  smooth();
}
 
void draw() {
  background(255);
  translate(width/2, height/2);
  
  moving.set(sin(frameCount*0.01)*width/2, 0, 0);  
  mouse.set(mouseX-width/2, mouseY-height/2, 0);
  
  drawLine(inA, inB); // completely in
  drawLine(outA, outB); // completely out
  drawLine(mouse, moving); // interactive
  
  stroke(0);
  ellipse(origin.x, origin.y, rad*2, rad*2);
}
 
void drawLine(PVector a, PVector b) {
  stroke(0);
  ellipse(a.x, a.y, 10, 10);
  ellipse(b.x, b.y, 10, 10);
  ArrayList <PVector> points = lineIntersectCircle(a, b, origin, rad);
  if (points.size()>0) {
    strokeWeight(1);
    line(a.x, a.y, b.x, b.y);
    stroke(0, 0, 255);
    for (PVector p : points) {
      ellipse(p.x, p.y, 20, 20);
    }
    if (points.size()==2) {
      a = points.get(0);
      b = points.get(1);
    } else {
      boolean inA = a.mag()<rad;
      if (!inA) {
        a = points.get(0);
      } else {
        b = points.get(0);
      }
    }
  } else {
    boolean inA = a.mag()<rad;
    boolean inB = b.mag()<rad;
    if (inA&&inB) { stroke(0, 255, 0); } else if (!inA&&!inB) { stroke(255, 0, 0); }
  }
  strokeWeight(5);
  line(a.x, a.y, b.x, b.y);
}
 
ArrayList <PVector> lineIntersectCircle(PVector a1, PVector a2, PVector c, float r) {
  ArrayList <PVector> points = new ArrayList <PVector> ();
  
  float a  = (a2.x - a1.x) * (a2.x - a1.x) + (a2.y - a1.y) * (a2.y - a1.y);
  float b  = 2 * ( (a2.x - a1.x) * (a1.x - c.x) + (a2.y - a1.y) * (a1.y - c.y)   );
  float cc = c.x*c.x + c.y*c.y + a1.x*a1.x + a1.y*a1.y - 2 * (c.x * a1.x + c.y * a1.y) - r*r;
  float d  = b*b - 4*a*cc;
  float e  = sqrt(d);
  float u1 = ( -b + e ) / ( 2*a );
  float u2 = ( -b - e ) / ( 2*a );
  
  if ( !( (u1 < 0 || u1 > 1) && (u2 < 0 || u2 > 1) ) ) {
    if ( 0 <= u1 && u1 <= 1) { points.add( new PVector( lerp(a1.x, a2.x, u1), lerp(a1.y, a2.y, u1) ) ); }
    if ( 0 <= u2 && u2 <= 1) { points.add( new PVector( lerp(a1.x, a2.x, u2), lerp(a1.y, a2.y, u2) ) ); }
  }
  
  return points;
}

