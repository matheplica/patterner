class Motif {
    int place, p;
    boolean visible;
    boolean plotted;
    Pattern[] patterns = new Pattern[4];
    Motif(int place) {
        this.place = place;
        patterns[0] = new Pattern(origins[place].x-marge-size, origins[place].y-marge-size, motif);
        patterns[1] = new Pattern(origins[place].x+marge+size, origins[place].y-marge-size, motif);
        patterns[2] = new Pattern(origins[place].x+marge+size, origins[place].y+marge+size, motif);
        patterns[3] = new Pattern(origins[place].x-marge-size, origins[place].y+marge+size, motif);
    }
    Motif(int place, int line, int a, int b, int c, int d) {
        this.place = place;
        patterns[0] = new Pattern(origins[place].x-marge-size, origins[place].y-marge-size, motif);
        patterns[1] = new Pattern(origins[place].x+marge+size, origins[place].y-marge-size, motif);
        patterns[2] = new Pattern(origins[place].x+marge+size, origins[place].y+marge+size, motif);
        patterns[3] = new Pattern(origins[place].x-marge-size, origins[place].y+marge+size, motif);
        setPattern(a, b, c, d);
    }
    boolean hasPlace(int p){
        if(p==place%8) return true;
        return false;
    }
    int getPlace(){
        return place%8;
    }
    boolean isPlotted(){
        return plotted;
    }
    void display() {
        for (Pattern pattern : patterns) pattern.display();
    }
    void setRandPattern(){
        for(int i=0; i<4; i++) patterns[i].setRandSegments();
    }
    void setPattern(int a, int b, int c, int d) {
        patterns[0].setSegment(a, b, c, d);
        patterns[1].setSegment(a, (b+1)%4, c, d);
        patterns[2].setSegment(a, (b+1)%4, (c+1)%4, d);
        patterns[3].setSegment(a, (b+1)%4, (c+1)%4, (d+1)%4);
    }
    void goLeft(int s) {
        for (int i=0; i<4; i++) patterns[i].subX(s);
        place--;
    }
    void goRight(int s) {
        for (int i=0; i<4; i++) patterns[i].addX(s);
        place++;
    }
}
