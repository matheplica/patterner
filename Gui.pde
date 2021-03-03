import controlP5.*;
ControlP5 cp5;
Slider r, g, b;
Tab image;
int backRed = 45, backGreen = 181, backBlue = 215, stripes = 255;
StringList msg = new StringList();
void createGui() {
    cp5.addTab("axidraw Mode").setHeight(36).setColorActive(color(255, 128, 0)).setId(51).activateEvent(true);
    cp5.getTab("default").setLabel("Graphic Mode").setHeight(36).setColorActive(color(255, 128, 0)).setId(50).activateEvent(true);
    for (int i=0; i<4; i++) {
        cp5.addButton("z"+i).setId(i).setLabel("random").setPosition(140, 26+i*96).setSize(36, 20);
        cp5.addButton("s"+i).setId(4+i).setLabel("line").setPosition(180, 26+i*96).setSize(26, 20);
        cp5.addButton("p"+i).setId(8+i).setLabel("-").setPosition(210, 26+i*96).setSize(36, 20);
        cp5.addButton("m"+i).setId(12+i).setLabel("+").setPosition(250, 26+i*96).setSize(36, 20);
        cp5.addButton("a"+i).setId(16+i).setLabel("<<").setPosition(170, 52+i*96).setSize(36, 20);
        cp5.addButton("l"+i).setId(20+i).setLabel(">>").setPosition(210, 52+i*96).setSize(36, 20);
    }
    cp5.addSlider("r").setLabelVisible(false).setId(25).setColorForeground(color(255, 0, 0)).setColorActive(color(255, 0, 0)).setPosition(20, 215).setSize(10, 96).setRange(0, 255).setValue(45);
    cp5.addSlider("g").setLabelVisible(false).setId(26).setColorForeground(color(0, 255, 0)).setColorActive(color(0, 255, 0)).setPosition(50, 215).setSize(10, 96).setRange(0, 255).setValue(181);
    cp5.addSlider("b").setLabelVisible(false).setId(27).setColorForeground(color(0, 0, 255)).setColorActive(color(0, 0, 255)).setPosition(80, 215).setSize(10, 96).setRange(0, 255).setValue(215);
    cp5.addSlider("t").setLabelVisible(false).setId(28).setColorForeground(color(255)).setValue(stripes).setColorActive(color(255)).setPosition(100, 230).setSize(10, 72).setRange(0, 255).setValue(255);
    cp5.addTextfield("name").setValue("output").setId(29).setPosition(16, 324).setSize(96, 28).setColor(color(205, 206, 0));
    cp5.addButton("allRandom").setLabel("allRandom").setId(30).setPosition(10, 180).setSize(56, 24);
    cp5.addButton("allLine").setLabel("allLine").setId(31).setPosition(70, 180).setSize(56, 24);
    cp5.addButton("savePng").setLabel("save").setId(32).setPosition(80, 360).setSize(32, 24);
    cp5.addButton("doConnect").setTab("axidraw Mode").setId(33).setLabel("connect").setPosition(140, 10).setSize(64, 36);
    cp5.addButton("startPlotting").setTab("axidraw Mode").setId(34).setLabel("start").setPosition(210, 10).setSize(72, 36);
    cp5.addButton("finish").setTab("axidraw Mode").setId(35).setLabel("stop").setPosition(140, 50).setSize(64, 36);
    cp5.addButton("pause").setTab("axidraw Mode").setId(36).setLabel("pause").setPosition(210, 50).setSize(72, 24);
    cp5.addToggle("origin").setTab("axidraw Mode").setId(37).setPosition(140, 120).setSize(72, 24);
    cp5.addSlider("range").setTab("axidraw Mode").setPosition(10, 170).setId(38).setLabelVisible(false).setWidth(270).setRange(16, 68).setValue(16).setNumberOfTickMarks(24);
}

void controlEvent(ControlEvent event) {
    //print(event);
    if (event.isTab()) {
        mode = event.getTab().getId()-50;
        if (mode==1  && !doJob) createWays();
    } else if (event.getId()<4) lines.get(event.getId()).randomize();
    else if (event.getId()>3 && event.getId()<8) lines.get(event.getId()-4).goOn();
    else if (event.getId()>7 && event.getId()<12) lines.get(event.getId()-8).reduce();
    else if (event.getId()>11 && event.getId()<16) lines.get(event.getId()-12).augment();
    else if (event.getId()>15 && event.getId()<20) lines.get(event.getId()-16).goLeft();
    else if (event.getId()>19 && event.getId()<24) lines.get(event.getId()-20).goRight();
    else if (event.getId()==25) backRed = int(event.getValue());
    else if (event.getId()==26) backGreen = int(event.getValue());
    else if (event.getId()==27) backBlue = int(event.getValue());
    else if (event.getId()==28) stripes = int(event.getValue());
    else if (event.getId()==37) setZero();
}
public void allRandom(int theValue) {
    if (lines.size()>0) for (int i=0; i<lines.size(); i++) lines.get(i).randomize();
}
public void allLine(int theValue) {
    boolean oneMore = false;
    for (int i=0; i<4; i++) {
        if (!oneMore && lines.get(i).motifs.size()>0) {
            arrayCopy(lines.get(i).getFirstPattern(), lastPattern);
            oneMore = true;
        }
    }
    for (int i=0; i<lines.size(); i++) if (lines.get(i).motifs.size()>0)lines.get(i).allLine();
}
public void savePng(int theValue) {
    pg.save(cp5.get(Textfield.class, "name").getText()+".png");
}
void drawConsole() {
    console.beginDraw();
    console.background(0);
    console.textSize(21);
    for (int i=0; i<msg.size(); i++) {
        console.text(msg.get(i), 32, 30+i*40);
    }
    console.endDraw();
}
void printConsole(String str) {
    msg.append(str);
    if (msg.size()>3) msg.remove(0);
}
