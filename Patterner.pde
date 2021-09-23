ArrayList<Line> lines = new ArrayList<Line>();
PVector[] origins = new PVector[64];
PGraphics pg, console;
int size = 16, hSize = size>>1, marge = 4, step = 96;
int[] motif = {0, 0, 0, 0};
int line = 8;
int mode;
int[] lastPattern = new int[4];
//PLotter
boolean plotting, doJob;
int selSquare, selQuad;
int nextX, nextY;
int theWay;
void setup() {
    size(1080, 390, P2D);
    surface.setTitle("Patterner by matheplica");
    cp5 = new ControlP5(this);
    smooth();
    pg = createGraphics(780, 390, P2D);
    console = createGraphics(300, 124);
    createMotif();
    createGui();
    //doConnect();
}
void createMotif() {
    for (int i=0; i<32; i++) origins[i] = new PVector((step>>1)+(i%8)*step, 48+(i/8)*step);
    lines.clear();
    for (int i=0; i<4; i++) lines.add(new Line(i, i+1));
}
void draw() {
    if (connect) isRunning();
    if (doJob && !isRunning && frameCount%30==0 && theWay<ways.size()) ways.get(theWay).plot();
    pg.beginDraw();
    pg.noFill();
    pg.strokeWeight(2);
    pg.ellipseMode(CENTER);
    if (mode==0) {
        pg.background(backRed, backGreen, backBlue);
        pg.stroke(stripes);
        for (Line line : lines) line.display();
    } else if (!motorsRunning) {
        pg.background(251, 59, 20);
        for (Line line : lines) line.display();
    } else {
        pg.background(251, 159, 0);
        for (int i=0; i<ways.size(); i++) ways.get(i).display();
        pg.stroke(103, 15, 212);
        pg.noFill();
        pg.ellipseMode(CENTER);
        pg.strokeWeight(3);
        pg.ellipse(10, 10, 12, 12);
        pg.text("origin", 18, 10);
    }
    pg.endDraw();
    if (mode==0) drawDeco();
    else drawDecoAxi();
    image(pg, 300, 0);
}
void drawDeco() {
    background(251, 159, 0);//223, 46, 121);
    fill(250);
    noStroke();
    rect(0, 0, 128, 160, 0, 0, 50, 0);
    noFill();
    strokeWeight(6);
    stroke(#FF0641);
    rect(80, 52, 32, 32);
    stroke(#E46A0B);
    rect(61, 63, 40, 40);
    stroke(#410B1D);
    rect(39, 74, 52, 52);
    stroke(#409486);
    rect(20, 84, 60, 60);
    stroke(255);
    strokeWeight(2);
    for (int i=0; i<3; i++)  line(156, 96+i*96, 300, 96+i*96);
}
void drawDecoAxi() {
    drawConsole();
    background(230);
    fill(210, 11, 208);
    noStroke();
    rect(0, 0, 128, 160, 0, 0, 50, 0);
    noFill();
    strokeWeight(6);
    stroke(#FFFFFF);
    rect(80, 52, 32, 32);
    rect(61, 63, 40, 40);
    rect(39, 74, 52, 52);
    rect(20, 84, 60, 60);
    textSize(17);
    fill(0);
    noStroke();
    rect(140, 143, 42, 16);
    text("1 step = "+int(range/4.5)+" mm / press ARROW to move", 11, 206);
    text("press SPACE for toggle Pen", 11, 232);
    image(console, 0, 264);
}
void keyPressed() {
     if (key=='s') pg.save("output.png");
    if (port!=null && motorsRunning) {
        if (keyCode==UP) move(0, -size);
        else if (keyCode==DOWN) move(0, size);
        else if (keyCode==LEFT) move(-size, 0);
        else if (keyCode==RIGHT) move(size, 0);
        else if (key==' ') togglePen();
    }
}
