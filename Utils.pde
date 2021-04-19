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
    short val = 0;

    for(int i = 0; i < VAR_SIZE; i++){
        val |= ((arr[index + i] & 0xFF) << (8 * i));
    }
  
    return int(val);
}

float bytesToFloat(byte[] arr, int index){  
    int val = bytesToInt(arr, index);
    return float(val) / PRECISION;
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