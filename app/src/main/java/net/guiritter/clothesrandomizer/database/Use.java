package net.guiritter.clothesrandomizer.database;

public final class Use {

    public final long id;

    public final long clothing;

    // TODO Change to byte next time I upgrade this app
    public final int counter;

    public final long location;

    public final long type;

    public Use decrement() {
        return new Use(id, clothing, type, location, counter - 1);
    }

    public Use increment() {
        return new Use(id, clothing, type, location, counter + 1);
    }

    public Use(long id, long clothing, long type, long location, int counter) {
        this.id       = id      ;
        this.clothing = clothing;
        this.type     = type    ;
        this.location = location;
        this.counter  = counter ;
    }
}
