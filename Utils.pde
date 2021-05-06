interface Callback {
    public void execute();
}

interface StringArrayCallback {
    public String[] execute();
}

PVector multByCoords(PVector a, PVector b) {
    return new PVector(a.x * b.x, a.y * b.y);
}

int bytesToInt(byte[] arr, int index){  
    int val = 0;

    for(int i = 0; i < VAR_SIZE; i++){
        val |= ((arr[index + i] & 0xFF) << (8 * i));
    }
  
    return int(val);
}

float bytesToFloat(byte[] arr, int index){
    return Float.intBitsToFloat(bytesToInt(arr, index));
}

String getLocalTime() {
    String time = nf(hour(), 2) + ":" + nf(minute(), 2) + ":" + nf(second(), 2);
    String date = nf(day(), 2) + "." + nf(month(), 2) + "." + year();
    return time + " " + date;
}

String getLocalTimeForFile() {
    String date = year() + "-" + nf(month(), 2) + "-" + nf(day(), 2);
    String time = nf(hour(), 2) + "-" + nf(minute(), 2) + "-" + nf(second(), 2);
    return date + " T" + time;
}

void cylinder(float topRadius, float bottomRadius, float tall, int sides) {
    float angle = 0;
    float angleIncrement = TWO_PI / sides;
    beginShape(QUAD_STRIP);
    for (int i = 0; i < sides + 1; ++i) {
        vertex(topRadius*cos(angle), 0, topRadius*sin(angle));
        vertex(bottomRadius*cos(angle), tall, bottomRadius*sin(angle));
        angle += angleIncrement;
    }
    endShape();
    
    // If it is not a cone, draw the circular top cap
    if (topRadius != 0) {
        angle = 0;
        beginShape(TRIANGLE_FAN);
        
        // Center point
        vertex(0, 0, 0);
        for (int i = 0; i < sides + 1; i++) {
            vertex(topRadius * cos(angle), 0, topRadius * sin(angle));
            angle += angleIncrement;
        }
        endShape();
    }
  
    // If it is not a cone, draw the circular bottom cap
    if (bottomRadius != 0) {
        angle = 0;
        beginShape(TRIANGLE_FAN);
    
        // Center point
        vertex(0, tall, 0);
        for (int i = 0; i < sides + 1; i++) {
            vertex(bottomRadius * cos(angle), tall, bottomRadius * sin(angle));
            angle += angleIncrement;
        }
        endShape();
    }
}