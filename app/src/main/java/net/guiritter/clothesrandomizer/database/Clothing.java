package net.guiritter.clothesrandomizer.database;

public final class Clothing {

    public final long id;

    public final String name;

    public String typeName;

    public final long typeId;

    public final String getFullName() {
        return typeName + ": " + name;
    }

    public Clothing(long id, String name, long typeId) {
        this.id     = id    ;
        this.name   = name  ;
        this.typeId = typeId;
    }
}
