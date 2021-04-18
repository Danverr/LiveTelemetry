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
  
    return val;
}

float bytesToFloat(byte[] arr, int index){  
    int val = bytesToInt(arr, index);
    return float(val) / PRECISION;
}
