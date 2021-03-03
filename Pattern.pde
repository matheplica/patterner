class Pattern {
    Segment[] segments = new Segment[12];
    PVector center;
    PVector[]  middles = new PVector[4];
    boolean plotted, touched;
    int[] touch = {-1, -1};
    int idSeg, idPoint, lastSeg, loopSeg, memSeg, memPoint;
    ArrayList<Integer> list = new ArrayList<Integer>();
    int[] fullList = new int[12];
    Pattern(float x, float y, int[] sens) {
        center = new PVector(x, y);
        createMiddles();
        int[] tab = {3, 1, 3, 1};
        for (int i=0; i<12; i+=3) createSegments(i, middles[i/3], int(random(4)));
        passDouble();
    }
    void createWays() {
        idSeg = 0;
        idPoint = 0;
        memSeg = 0;
        memPoint = 0;
        for (int i=0; i<12; i++) fullList[i] = 3;
        while (yetWork()) {
            if ((touch(idSeg, idPoint)==-1 && fullList[idSeg]>0)|| fullList[idSeg]==0) {
                ways.add(ways.size(), new Way(segments[idSeg].getPoint(idPoint)));
                idPoint = (++idPoint)%2;
                ways.get(ways.size()-1).addPoint(segments[idSeg].getPoint(idPoint));
                fullList[idSeg] = -1;
                while (touch(idSeg, idPoint)>-1) {
                    ways.get(ways.size()-1).addPoint(segments[touch[0]].getPoint(((touch[1]+1)%2)));
                    idSeg = touch[0];
                    fullList[idSeg] = -1;
                    idPoint = (touch[1]+1)%2;
                }
                memPoint = idPoint;
            }
            nextPosition();
        }
    }
    boolean yetWork() {
        boolean output = false;
        for (int i=0; i<12; i++) if (fullList[i]>-1) output = true;
        return output;
    }
    void nextPosition() {
        if (memPoint==idPoint) {
            boolean gotIt = false;
            for (int i=idSeg+1; i<idSeg+12; i++) {
                if (!gotIt && fullList[i%12]>-1) {
                    idSeg = i%12;
                    fullList[i%12]--;
                    gotIt = true;
                }
            }
        } else idPoint = (++idPoint)%2;
    }
    int touch(int s, int p) {
        int output = -1;
        for (int i=s+1; i<s+12; i++) {
            if (fullList[i%12]>-1) {
                for (int j=0; j<2; j++) {
                    if (segments[s].getPoint(p).equals(segments[i%12].getPoint(j))) {
                        touch[0] = i%12;
                        touch[1] = j;
                        output = touch[1];
                    }
                }
            }
        }
        return output;
    }
    boolean isPlotted() {
        return plotted;
    }
    void display() {
        for (int i=0; i<segments.length; i++) segments[i].display();
    }
    void addX(int s) {
        center.add(s, 0);
        createMiddles();
        for (int i=0; i<segments.length; i++) segments[i].addX(s);
    }
    void subX(int s) {
        center.sub(s, 0);
        createMiddles();
        for (int i=0; i<segments.length; i++) segments[i].subX(s);
    }
    void createMiddles() {
        middles[0] = new PVector(center.x-hSize, center.y-hSize);
        middles[1] = new PVector(center.x+hSize, center.y-hSize);
        middles[2] = new PVector(center.x+hSize, center.y+hSize);
        middles[3] = new PVector(center.x-hSize, center.y+hSize);
    }
    void setSegment(int a, int  b, int c, int d) {
        createSegments(0, middles[0], a);
        createSegments(3, middles[1], b);
        createSegments(6, middles[2], c);
        createSegments(9, middles[3], d);
    }
    void setRandSegments(){
        for(int i=0; i<4; i++) createSegments(i*3, middles[i], int(random(4)));
    }
    void createSegments(int i, PVector m, int s) {
        if (s==0) {
            segments[i] = new Segment(m.x-hSize, m.y-hSize, m.x+hSize, m.y-hSize, s);
            segments[i+1] = new Segment(m.x-hSize, m.y, m.x+hSize, m.y, s);
            segments[i+2] = new Segment(m.x-hSize, m.y+hSize, m.x+hSize, m.y+hSize, s);
        } else if (s==1) {
            segments[i] = new Segment(m.x, m.y-hSize, m.x+hSize, m.y, s);
            segments[i+1] = new Segment(m.x-hSize, m.y-hSize, m.x+hSize, m.y+hSize, s);
            segments[i+2] = new Segment(m.x-hSize, m.y, m.x, m.y+hSize, s);
        } else if (s==2) {
            segments[i] = new Segment(m.x-hSize, m.y-hSize, m.x-hSize, m.y+hSize, s);
            segments[i+1] = new Segment(m.x, m.y-hSize, m.x, m.y+hSize, s);
            segments[i+2] = new Segment(m.x+hSize, m.y-hSize, m.x+hSize, m.y+hSize, s);
        } else if (s==3) {
            segments[i] = new Segment(m.x, m.y-hSize, m.x-hSize, m.y, s);
            segments[i+1] = new Segment(m.x+hSize, m.y-hSize, m.x-hSize, m.y+hSize, s);
            segments[i+2] = new Segment(m.x+hSize, m.y, m.x, m.y+hSize, s);
        }
    }

    void passDouble() {
        if (segments[2].getSens()==0 && segments[9].getSens()==0) fullList[2] = -1;
        if (segments[5].getSens()==0 && segments[6].getSens()==0) fullList[6] = -1;
        if (segments[2].getSens()==2 && segments[3].getSens()==2) fullList[3] = -1;
        if (segments[11].getSens()==2 && segments[6].getSens()==2) fullList[11] = -1;
    }
    /*  void setSens(int i, PVector m, int s) {
     if (s==0) {
     segments.get(i).setSens(m.x-hSize, m.y-hSize, m.x+hSize, m.y-hSize);
     segments[i] = new Segment(m.x-hSize, m.y, m.x+hSize, m.y));
     segments[i] = new Segment(m.x-hSize, m.y+hSize, m.x+hSize, m.y+hSize));
     } else if (s==1) {
     segments[i] = new Segment(m.x, m.y-hSize, m.x+hSize, m.y));
     segments[i] = new Segment(m.x-hSize, m.y-hSize, m.x+hSize, m.y+hSize));
     segments[i] = new Segment(m.x-hSize, m.y, m.x, m.y+hSize));
     } else if (s==2) {
     segments[i] = new Segment(m.x-hSize, m.y-hSize, m.x-hSize, m.y+hSize));
     segments[i] = new Segment(m.x, m.y-hSize, m.x, m.y+hSize));
     segments[i] = new Segment(m.x+hSize, m.y-hSize, m.x+hSize, m.y+hSize));
     } else if (s==3) {
     segments[i] = new Segment(m.x, m.y-hSize, m.x-hSize, m.y));
     segments[i] = new Segment(m.x+hSize, m.y-hSize, m.x-hSize, m.y+hSize));
     segments[i] = new Segment(m.x+hSize, m.y, m.x, m.y+hSize));
     }
     }*/
}
