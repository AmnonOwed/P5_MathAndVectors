
/*

 Line 2 TriangleMesh by Amnon Owed (April 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon

 Original code by Paul Houx (May 09, 2012)
 https://forum.libcinder.org/#Topic/23286000001268015
 
 Turn a series of points (aka a line) into a triangle mesh.

 SPACE = clear all points
 o = toggle outlines
 c = toggle construction lines
 , = decrease line thickness
 . = increase line thickness

 Ported to Processing 1.5.1 + Toxiclibs 0021

*/
 
import toxi.geom.*;
import toxi.processing.*;
ToxiclibsSupport gfx;
 
float mRadius = 5;
float mThickness = 50;
float dotStepSize = 10;
ArrayList <Vec2D> mPoints = new ArrayList <Vec2D> ();
boolean bDrawOutlines = true;
boolean bDrawConstruction = false;
 
void setup() {
  size(1280, 720);
  gfx = new ToxiclibsSupport(this);
  smooth();
}
 
void draw() {
  background(255);
  
  for (int i=0; i<mPoints.size(); i++) {
    int a = ((i-1) < 0) ? 0 : (i-1);
    int b = i;
    int c = ((i+1) >= mPoints.size()) ? mPoints.size()-1 : (i+1);
    int d = ((i+2) >= mPoints.size()) ? mPoints.size()-1 : (i+2);

    drawSegment( mPoints.get(a), mPoints.get(b), mPoints.get(c), mPoints.get(d) );
  }
  
  noStroke();
  fill(255, 0, 0);
  for (Vec2D p : mPoints) {
    ellipse(p.x, p.y, mRadius*2, mRadius*2);
  }
}
 
void mousePressed() {
  Vec2D m = new Vec2D(mouseX, mouseY);
  mPoints.add(m);
}
 
void keyPressed() {
  if (key == ' ') { mPoints.clear(); }
  if (key == 'o') { bDrawOutlines = !bDrawOutlines; }
  if (key == 'c') { bDrawConstruction = !bDrawConstruction; }
  if (key == ',') { if (mThickness > 1) mThickness--; }
  if (key == '.') { if (mThickness < 100) mThickness++; }
}
 
void drawSegment(Vec2D p0, Vec2D p1, Vec2D p2, Vec2D p3) {
  
  // skip if zero length
  if (p1.equals(p2)) return;
  
  // 1) define the line between the two points
  Vec2D line = p2.sub(p1).normalize();
  
  // 2) find the normal vector of this line
  Vec2D normal = new Vec2D(-line.y, line.x).normalize();
  
  // 3) find the tangent vector at both the end points:
  //	- if there are no segments before or after this one, use the line itself
  //	- otherwise, add the two normalized lines and average them by normalizing again
  Vec2D tangent1, tangent2;
  if (p0.equals(p1)) { tangent1 = line.copy(); } else { tangent1 = p1.sub(p0).normalize().add(line).normalize(); }
  if (p2.equals(p3)) { tangent2 = line.copy(); } else { tangent2 = p3.sub(p2).normalize().add(line).normalize(); }
  
  // 4) find the miter line, which is the normal of the tangent
  Vec2D miter1 = new Vec2D(-tangent1.y, tangent1.x);
  Vec2D miter2 = new Vec2D(-tangent2.y, tangent2.x);
  
  // find length of miter by projecting the miter onto the normal,
  // take the length of the projection, invert it and scaleSelfiply it by the thickness:
  // length = thickness * ( 1 / |normal|.|miter| )
  float length1 = mThickness / normal.dot(miter1);
  float length2 = mThickness / normal.dot(miter2);
  
  // calculate miter end points
  Vec2D p1ms = p1.sub(miter1.scale(length1));
  Vec2D p1ma = p1.add(miter1.scale(length1));
  Vec2D p2ms = p2.sub(miter2.scale(length2));
  Vec2D p2ma = p2.add(miter2.scale(length2));
  
  if (bDrawConstruction) {
    // set line width to 2
    strokeWeight(2);
    
    // draw black line between p1 and p2
    stroke(0);
    drawLine(p1, p2);
    
    Vec2D n = normal.scale(mThickness);
    
    // draw normals in stippled red
    stroke(255, 0, 0);
    drawDottedLine(p1.sub(n), p1.add(n));
    drawDottedLine(p2.sub(n), p2.add(n));
    
    // draw line segment in stippled gray
    stroke(128);
    drawDottedLine(p1.sub(n), p2.sub(n));
    drawDottedLine(p1.add(n), p2.add(n));
    
    // draw tangents in gray
    if (!p0.equals(p1)) { drawLine(p1.sub(tangent1.scale(mThickness)), p1.add(tangent1.scale(mThickness))); }
    if (!p2.equals(p3)) { drawLine(p2.sub(tangent2.scale(mThickness)), p2.add(tangent2.scale(mThickness))); }
    
    // draw miter (normal of tangents) in stippled black
    stroke(0);
    if (!p0.equals(p1)) { drawDottedLine(p1.sub(miter1.scale(length1)), p1.add(miter1.scale(length1))); }
    if (!p2.equals(p3)) { drawDottedLine(p2.sub(miter2.scale(length2)), p2.add(miter2.scale(length2))); }
    
    // draw black circles on miter    
    fill(0);
    ellipse(p1ms.x, p1ms.y, mRadius, mRadius);
    ellipse(p1ma.x, p1ma.y, mRadius, mRadius);
    ellipse(p2ms.x, p2ms.y, mRadius, mRadius);
    ellipse(p2ma.x, p2ma.y, mRadius, mRadius);
  }
  
  if (bDrawOutlines) {
    // finally, draw segment in thick black
    strokeWeight(3);
    stroke(0);
    drawLine(p1ms, p2ms);
    drawLine(p1ma, p2ma);
    
    // stipple triangles
    drawDottedLine(p1ms, p1ma);
    drawDottedLine(p1ms, p2ma);
    drawDottedLine(p2ms, p2ma);
  }
}
 
void drawLine(Vec2D s, Vec2D e) {
  gfx.line(s, e);
}
 
void drawDottedLine(Vec2D s, Vec2D e) {
  Line2D l = new Line2D(s, e);
  gfx.points2D(l.splitIntoSegments(null, dotStepSize, true));
}

