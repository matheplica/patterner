class Segment {
    PVector[] points = new PVector[2];
    boolean inWay, hide;
    int sens;
    Segment(float a, float b, float c, float d, int s) {
        points[0] = new PVector(a, b);
        points[1] = new PVector(c, d);
        sens = s;
    }
    void display() {
        pg.line(points[0].x, points[0].y, points[1].x, points[1].y);
    }
    void setPos(float x0, float y0, float x1, float y1) {
        points[0].set(x0, y0);
        points[1].set(x1, y1);
    }
    void addX(int s) {
        for (int i=0; i<2; i++) points[i].add(s, 0);
    }
    void subX(int s) {
        for (int i=0; i<2; i++) points[i].sub(s, 0);
    }
    void hide(boolean h) {
        hide = h;
    }
    boolean isHide() {
        return hide;
    }
    int getSens() {
        return sens;
    }
    int checkPoint(PVector p) {
        if (p.equals(points[0])) return 0;
        else if (p.equals(points[1])) return 1;
        else return -1;
    }
    PVector getPoint(int i) {
        return points[i%2];
    }
    PVector getOtherPoint(PVector p) {
        if (p.equals(points[0])) return points[1];
        else return points[0];
    }
    int getLastIntPoint(PVector p) {
        if (p.dist(points[0])==0) return 1;
        else return 0;
    }
    void setWay(boolean w) {
        inWay = w;
    }
    boolean isInWay() {
        return inWay;
    }
    int getX(int i) {
        return int(points[i].x);
    }
    int getY(int i) {
        return int(points[i].y);
    }
    /*void setSens(int s) {
     sens = s;
     if (s==0) {
     segments[0].setPos(middle.x-hSize, middle.y-hSize, middle.x+hSize, middle.y-hSize);
     segments[1].setPos(middle.x-hSize, middle.y, middle.x+hSize, middle.y);
     segments[2].setPos(middle.x-hSize, middle.y+hSize, middle.x+hSize, middle.y+hSize);
     } else if (s==1) {
     segments[0].setPos(middle.x, middle.y-hSize, middle.x+hSize, middle.y);
     segments[1].setPos(middle.x-hSize, middle.y-hSize, middle.x+hSize, middle.y+hSize);
     segments[2].setPos(middle.x-hSize, middle.y, middle.x, middle.y+hSize);
     } else if (s==2) {
     segments[0].setPos(middle.x-hSize, middle.y-hSize, middle.x-hSize, middle.y+hSize);
     segments[1].setPos(middle.x, middle.y-hSize, middle.x, middle.y+hSize);
     segments[2].setPos(middle.x+hSize, middle.y-hSize, middle.x+hSize, middle.y+hSize);
     } else if (s==3) {
     segments[0].setPos(middle.x, middle.y-hSize, middle.x-hSize, middle.y);
     segments[1].setPos(middle.x+hSize, middle.y-hSize, middle.x-hSize, middle.y+hSize);
     segments[2].setPos(middle.x+hSize, middle.y, middle.x, middle.y+hSize);
     }
     else if (s==1) { // antenne
     segments[0].setPos(middle.x, middle.y-hSize, middle.x+hSize, middle.y);
     segments[1].setPos(middle.x-hSize, middle.y-hSize, middle.x+hSize, middle.y+hSize);
     segments[2].setPos(middle.x-hSize, middle.y, middle.x+hSize, middle.y);
     }else if (s==3) { // labyrinth
     segments[0].setPos(middle.x-hSize, middle.y-hSize, middle.x-hSize, middle.y);
     segments[1].setPos(middle.x+hSize, middle.y-hSize, middle.x-hSize, middle.y+hSize);
     segments[2].setPos(middle.x+hSize, middle.y, middle.x, middle.y+hSize);
     }
     }*/
}
