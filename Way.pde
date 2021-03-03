import java.util.Collections;
class Way {
    int p;
    boolean plotted;
    ArrayList<PVector> pts = new ArrayList<PVector>();
    Way(PVector p) {
        pts.add(p);
    }
    void display() {
        if (plotted) pg.stroke(0);
        else pg.stroke(250);
        pg.line(pts.get(0).x, pts.get(0).y, pts.get(1).x, pts.get(1).y);
        for (int i=1; i<pts.size()-1; i++) pg.line(pts.get(i).x, pts.get(i).y, pts.get(i+1).x, pts.get(i+1).y);
        /*// see origin and end of ways
         pg.noStroke();
         pg.fill(80, 200, 20);
         pg.ellipse(pts.get(0).x, pts.get(0).y, 4, 4);//start blue
         pg.fill(21, 69, 250);
         pg.ellipse(pts.get(pts.size()-1).x, pts.get(pts.size()-1).y, 5, 5);//end green*/
    }
    void plot() {
        if (p==0) moveTo(int(pts.get(0).x), int(pts.get(0).y));
        else if (p==1) penDown();
        else if (p>1 && p<=pts.size()) moveTo(int(pts.get(p-1).x), int(pts.get(p-1).y));
        else if (p==pts.size()+1) {
            penUp();
            plotted = true;
        } else printConsole((++theWay)+" on "+ways.size()+" job done");
        p++;
    }
    void addPoint(PVector p) {
        pts.add(p);
    }
    void reverse() {
        Collections.reverse(pts);
    }
    void optimize() {
        if (pts.size()==4 && !pts.get(0).equals(pts.get(3))) {
            if (PVector.sub(pts.get(0), pts.get(3)).cross(pts.get(1)).equals(pts.get(0).cross(pts.get(3))) &&
                PVector.sub(pts.get(0), pts.get(3)).cross(pts.get(2)).equals(pts.get(0).cross(pts.get(3)))) {
                pts.remove(2);
                pts.remove(1);
            }
        }
        for (int i=0; i<pts.size()-2; i++) {
            if(PVector.add(PVector.sub(pts.get(i+1), pts.get(i)), pts.get(i+1)).equals(pts.get(i+2))) pts.remove(i+1);
        }
    }
    void adapt(int i) {
        if (PVector.dist(ways.get(i-1).lastPoint(), firstPoint())>PVector.dist(ways.get(i-1).lastPoint(), lastPoint())) reverse();
    }
    void setX(float x) {
        lastPoint().set(x, lastPoint().y);
    }
    void setY(float y) {
        lastPoint().set(lastPoint().x, y);
    }
    void reload() {
        p = 0;
        plotted = false;
    }
    PVector firstPoint() {
        return pts.get(0);
    }
    PVector lastPoint() {
        return pts.get(pts.size()-1);
    }
}
