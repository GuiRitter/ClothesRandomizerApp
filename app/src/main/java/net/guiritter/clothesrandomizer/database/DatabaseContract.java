package net.guiritter.clothesrandomizer.database;

import android.provider.BaseColumns;

public final class DatabaseContract {

    private DatabaseContract(){}

    public static abstract class Clothing implements BaseColumns {
        public final static String TABLE_NAME = "Clothing";
        public final static String NAME = "name";
        public final static String TYPE = "type";
    }

    public static abstract class Location implements BaseColumns {
        public final static String TABLE_NAME = "Location";
        public final static String NAME = "name";
    }

    public static abstract class Type implements BaseColumns {
        public final static String TABLE_NAME = "Type";
        public final static String NAME = "name";
    }

    public static abstract class Use implements BaseColumns {
        public final static String TABLE_NAME = "Use";
        public final static String CLOTHING = "clothing";
        public final static String TYPE = "type";
        public final static String LOCATION = "location";
        public final static String COUNTER = "counter";
    }
}
