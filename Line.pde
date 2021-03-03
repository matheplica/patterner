class Line {
    int id, p;
    ArrayList<Motif> motifs = new ArrayList<Motif>();
    int[] firstPattern = new int[4];
    boolean plotted;
    Line(int id, int len) {
        this.id = id;
        for (int i=0; i<len; i++) {
            motifs.add(new Motif(i+id*8));
        }
        for (int i=0; i<firstPattern.length; i++) firstPattern[i] = int(random(4));
        goOn();
    }

    void display() {
        for (Motif motif : motifs) motif.display();
    }
    void removeFirst() {
        for (int i=0; i<motifs.size(); i++) if (motifs.get(i).hasPlace(0)) motifs.remove(i);
    }
    void randomize() {
        for (int i=0; i<motifs.size(); i++) motifs.get(i).setRandPattern();
    }
    void goOn() {
        if (motifs.size()>0) {
            getFirstPattern();
            for (int i=0; i<motifs.size(); i++) motifs.get(i).setPattern((firstPattern[0]+i)%4, (firstPattern[1]+i)%4, (firstPattern[2]+i)%4, (firstPattern[3]+i)%4);
        }
    }
    void allLine() {
        for (int i=0; i<motifs.size(); i++) motifs.get(i).setPattern((lastPattern[0]+i)%4, (lastPattern[1]+i)%4, (lastPattern[2]+i)%4, (lastPattern[3]+i)%4);
        for (int i=0; i<4; i++) lastPattern[i] = motifs.get(motifs.size()-1).patterns[3].segments[i*3].getSens();
        lastPattern[0] = (++lastPattern[0])%4;
    }
    int[] getFirstPattern() {
        for (int i=0; i<4; i++) firstPattern[i] = motifs.get(0).patterns[0].segments[i*3].getSens();
        return firstPattern;
    }
    void augment() {
        if (motifs.size()<8) {
            if (motifs.size()>0) goRight();
            motifs.add(0, new Motif(id*8));
        }
    }
    void reduce() {
        if (motifs.size()>0) motifs.remove(0);
    }
    void goRight() {
        if (motifs.size()>0) {
            if (!motifs.get(motifs.size()-1).hasPlace(7)) motifs.get(motifs.size()-1).goRight(step);
            for (int i=motifs.size()-2; i>-1; i--) {
                if (!motifs.get(i+1).hasPlace(motifs.get(i).getPlace()+1)) motifs.get(i).goRight(step);
            }
        }
    }
    void goLeft() {
        if (motifs.size()>0) {
            if (!motifs.get(0).hasPlace(0)) motifs.get(0).goLeft(step);
            for (int i=1; i<motifs.size(); i++) {
                if (!motifs.get(i-1).hasPlace(motifs.get(i).getPlace()-1)) motifs.get(i).goLeft(step);
            }
        }
    }
}
