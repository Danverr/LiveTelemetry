interface Callback {
    public void execute();
}

interface StringArrayCallback {
    public String[] execute();
}

PVector multByCoords(PVector a, PVector b) {
    return new PVector(a.x * b.x, a.y * b.y);
}