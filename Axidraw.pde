import processing.serial.*;
Serial port;
final int RATE = 115200;
String portName = "/dev/ttyACM0"; //assume LINUX
int servoDown = 16000;
int servoUp = 21000;
int posX, posY, range;
boolean penUp = true, motorsRunning = true, isRunning, connect;
ArrayList<Way> ways = new ArrayList<Way>();
void createWays() {
    ways.clear();
    msg.clear();
    int lastPlace = 0;
    for (int i=0; i<lines.size(); i++) {
        if (lines.get(i).motifs.size()>0) {
            if (lines.get(i).motifs.get(0).getPlace()>=lastPlace) {
                for (int j=0; j<lines.get(i).motifs.size(); j++) {
                    for (int k=0; k<4; k++) {
                        lines.get(i).motifs.get(j).patterns[k].createWays();
                    }
                    if (j==lines.get(i).motifs.size()-1) lastPlace = lines.get(i).motifs.get(j).getPlace();
                }
            } else {
                for (int j=lines.get(i).motifs.size()-1; j>-1; j--) {
                    for (int k=0; k<4; k++) {
                        lines.get(i).motifs.get(j).patterns[k].createWays();
                    }
                    if (j==0) lastPlace = lines.get(i).motifs.get(j).getPlace();
                }
            }
        }
    }
    for (int i=0; i<ways.size(); i++) {
        ways.get(i).optimize();
        if (i>0) ways.get(i).adapt(i);
    }
    printConsole(" "+ways.size()+" ways encoded");
}
public void pause() {
    if (connect) {
        if (theWay >0) {
            doJob =! doJob;
            if (doJob) printConsole("pause off");
            else printConsole("pause");
        } else printConsole("no Job Started");
    } else printConsole("no Axidraw connected");
}
public void startPlotting() {
    if (connect) {
        doJob = true;
        printConsole("start plotting");
        cp5.getTab("default").hide();
    } else printConsole("no Axidraw connected");
}
public void finish() {
    if (connect) {
        cp5.getTab("default").show();
        doJob = false;
        theWay = 0;
        port.write("ES\r");
        for (int i=0; i<ways.size(); i++) ways.get(i).reload();
        printConsole("finish plotting");
    } else printConsole("no Axidraw connected");
}
public void doConnect() {
    connect = connect();
    if (!connect) {
        printConsole("no Axidraw connected");
    } else {
        setupPlotter();
        printConsole("Axidraw connected");
    }
}
void penDown() {
    writeAxi("SP,1\r");
    penUp = false;
    //printConsole("pen is down");
}
void penUp() {
    writeAxi("SP,0\r");
    penUp = true;
    //printConsole("pen is up");
}
void togglePen() {
    if (penUp) penDown();
    else penUp();
}
void move(int x, int y) {
    int goalX = int(x*range);
    int goalY = int(y*range);
    int time = int(1540.0*max(abs(goalX), abs(goalY)) / 1500);
    writeAxi("XM,"+time+","+goalX+","+goalY+"\r");
    posX += goalX;
    posY += goalY;
    printConsole("position : "+posX+" "+posY);
}
void moveTo(int x, int y) {
    int goalX = int(x*range)-posX;
    int goalY = int(y*range)-posY;
    int time = int(1540.0*max(abs(goalX), abs(goalY)) / 1500);
    writeAxi("XM,"+time+","+goalX+","+goalY+"\r");
    posX += goalX;
    posY += goalY;
    //printConsole("actual position : "+posX+" "+posY);
}
void writeAxi(String c) {
    port.write(c);
}
void setupPlotter() {
    writeAxi("SC,4,"+servoDown+"\r");
    writeAxi("SC,5,"+servoUp+"\r");
    port.write("EM,1\r");
}
void setZero() {
    if (connect) {
        if (motorsRunning) port.write("EM,0,0\r");
        else port.write("EM,1\r");
        motorsRunning =! motorsRunning;
        posX = 0;
        posY = 0;
        if (motorsRunning) printConsole("move plotter origin");
        else printConsole("new origin");
    } else printConsole("no Axidraw connected");
}
void isRunning() {
    port.write("QM\r");
    char end = '\n';
    if (port != null) {
        String a = "";
        if (port.available() > 0) {
            boolean loop = true;
            while (loop) {
                String b = port.readStringUntil(end);
                if (b != null)  a += b;
                else loop = false;
            }
            if (a.length() > 0) {
                String[] c = a.split(end + "");
                for (String d : c) {
                    d = d.trim();
                    if (d.equals("OK")) continue;
                    else if (d.startsWith("QM")) isRunning = (d.charAt(5)=='0' || d.charAt(7)=='0') ? false : true;
                }
            }
        }
    }
}
boolean connect() {
    try {
        port = new Serial(this, portName, RATE);
    }
    catch (Exception e) {
    }
    if (port==null) return false;
    else return true;
}
