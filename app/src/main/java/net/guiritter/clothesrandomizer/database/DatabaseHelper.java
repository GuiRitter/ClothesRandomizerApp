package net.guiritter.clothesrandomizer.database;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

public final class DatabaseHelper extends SQLiteOpenHelper {

    static final String NUMERIC_TYPE = " NUMERIC";
    static final String REAL_TYPE = " REAL";
    static final String TEXT_TYPE = " TEXT";
    static final String COMMA_SEP = ",";

    private static final String SQL_CREATE_TABLE_CLOTHING =
        "CREATE TABLE " + DatabaseContract.Clothing.TABLE_NAME + " (" +
            DatabaseContract.Clothing._ID + " INTEGER PRIMARY KEY" + COMMA_SEP +
            DatabaseContract.Clothing.NAME + TEXT_TYPE + COMMA_SEP +
            DatabaseContract.Clothing.TYPE + NUMERIC_TYPE +
            " )";

    private static final String SQL_CREATE_TABLE_LOCATION =
        "CREATE TABLE " + DatabaseContract.Location.TABLE_NAME + " (" +
            DatabaseContract.Location._ID + " INTEGER PRIMARY KEY" + COMMA_SEP +
            DatabaseContract.Location.NAME + TEXT_TYPE +
            " )";

    private static final String SQL_CREATE_TABLE_TYPE =
        "CREATE TABLE " + DatabaseContract.Type.TABLE_NAME + " (" +
            DatabaseContract.Type._ID + " INTEGER PRIMARY KEY" + COMMA_SEP +
            DatabaseContract.Type.NAME + TEXT_TYPE +
            " )";

    private static final String SQL_CREATE_TABLE_USE =
        "CREATE TABLE " + DatabaseContract.Use.TABLE_NAME + " (" +
            DatabaseContract.Use._ID + " INTEGER PRIMARY KEY" + COMMA_SEP +
            DatabaseContract.Use.CLOTHING + NUMERIC_TYPE + COMMA_SEP +
            DatabaseContract.Use.TYPE + NUMERIC_TYPE + COMMA_SEP +
            DatabaseContract.Use.LOCATION + NUMERIC_TYPE + COMMA_SEP +
            DatabaseContract.Use.COUNTER + NUMERIC_TYPE +
            " )";

    private static final String SQL_DELETE_TABLE_CLOTHING =
        "DROP TABLE IF EXISTS " + DatabaseContract.Clothing.TABLE_NAME;

    private static final String SQL_DELETE_TABLE_LOCATION =
        "DROP TABLE IF EXISTS " + DatabaseContract.Location.TABLE_NAME;

    private static final String SQL_DELETE_TABLE_TYPE =
        "DROP TABLE IF EXISTS " + DatabaseContract.Type.TABLE_NAME;

    private static final String SQL_DELETE_TABLE_USE =
        "DROP TABLE IF EXISTS " + DatabaseContract.Use.TABLE_NAME;

    public static final int DATABASE_VERSION = 1;

    public static final String DATABASE_NAME
        = "net.guiritter.clothesrandomizer.database.db";

    @Override
    public void onCreate(SQLiteDatabase db) {
        db.execSQL(SQL_CREATE_TABLE_CLOTHING);
        db.execSQL(SQL_CREATE_TABLE_LOCATION);
        db.execSQL(SQL_CREATE_TABLE_TYPE    );
        db.execSQL(SQL_CREATE_TABLE_USE     );
    }

    public void onDowngrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        onUpgrade(db, oldVersion, newVersion);
    }

    @Override
    public void onOpen(SQLiteDatabase db) {
        super.onOpen(db);
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        db.execSQL(SQL_DELETE_TABLE_CLOTHING);
        db.execSQL(SQL_DELETE_TABLE_LOCATION);
        db.execSQL(SQL_DELETE_TABLE_TYPE    );
        db.execSQL(SQL_DELETE_TABLE_USE     );
        onCreate(db);
    }

    public DatabaseHelper(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }
}
