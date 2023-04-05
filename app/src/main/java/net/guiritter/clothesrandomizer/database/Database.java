package net.guiritter.clothesrandomizer.database;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import java.util.ArrayList;

public final class Database {

    private static SQLiteDatabase database = null;

    private static int i = 0;

    private static long id = 0;

    private static Cursor resultSet = null;

    private static final ContentValues values = new ContentValues();

    public static boolean addClothing(Context context, String name, long type) {
        initDatabase(context);
        values.clear();
        values.put(DatabaseContract.Clothing.NAME, name);
        values.put(DatabaseContract.Clothing.TYPE, type);
        id = database.insert(
                DatabaseContract.Clothing.TABLE_NAME, null, values);
        if (id == -1) return false;
        Location locations[] = getLocations(context, null, null);
        for (Location location : locations) {
            if (!addUse(context, id, type, location.id)) {
                deleteClothing(context, id);
                deleteUse(context, id, null);
                return false;
            }
        }
        return true;
    }

    public static boolean addLocation(Context context, String name) {
        initDatabase(context);
        values.clear();
        values.put(DatabaseContract.Location.NAME, name);
        id = database.insert(
                DatabaseContract.Location.TABLE_NAME, null, values);
        if (id == -1) return false;
        ArrayList<Clothing> clothes = getClothes(context, null, null);
        for (Clothing clothing : clothes) {
            if (!addUse(context, clothing.id, clothing.typeId, id)) {
                deleteLocation(context, id);
                deleteUse(context, null, id);
                return false;
            }
        }
        return true;
    }

    public static boolean addType(Context context, String name) {
        initDatabase(context);
        values.clear();
        values.put(DatabaseContract.Type.NAME, name);
        return database.insert(
                DatabaseContract.Type.TABLE_NAME, null, values) > -1;
    }

    public static boolean addUse(
            Context context, long clothing, long type, long location) {
        initDatabase(context);
        values.clear();
        values.put(DatabaseContract.Use.CLOTHING, clothing);
        values.put(DatabaseContract.Use.TYPE, type);
        values.put(DatabaseContract.Use.LOCATION, location);
        values.put(DatabaseContract.Use.COUNTER ,        0);
        return database.insert(
                DatabaseContract.Use.TABLE_NAME, null, values) > -1;
    }

    public static int deleteClothing(Context context, long id) {
        initDatabase(context);
        deleteUse(context, id, null);
        return database.delete(DatabaseContract.Clothing.TABLE_NAME,
                DatabaseContract.Clothing._ID + " = " + id, null);
    }

    public static int deleteLocation(Context context, long id) {
        initDatabase(context);
        deleteUse(context, null, id);
        return database.delete(DatabaseContract.Location.TABLE_NAME,
                DatabaseContract.Location._ID + " = " + id, null);
    }

    public static int deleteType(Context context, long id) {
        initDatabase(context);
        ArrayList<Clothing> clothes = getClothes(context,
                DatabaseContract.Clothing.TYPE + " = " + id, null);
        for (Clothing clothing : clothes) {
            deleteClothing(context, clothing.id);
        }
        return database.delete(DatabaseContract.Type.TABLE_NAME,
                DatabaseContract.Type._ID + " = " + id, null);
    }

    public static int deleteUse(
            Context context, Long clothingId, Long locationId) {
        initDatabase(context);
        String whereClause = "";
        if (clothingId != null) {
            whereClause = DatabaseContract.Use.CLOTHING + " = " + clothingId;
            if (locationId != null) {
                whereClause += " AND ";
            }
        }
        if (locationId != null) {
            whereClause += DatabaseContract.Use.LOCATION + " = " + locationId;
        }
        return database.delete(
                DatabaseContract.Use.TABLE_NAME, whereClause, null);
    }

    public static ArrayList<Clothing> getClothes(
            Context context, String select, String orderBy) {
        initDatabase(context);
        resultSet = database.query(
                DatabaseContract.Clothing.TABLE_NAME,
                null,
                select,
                null,
                null,
                null,
                orderBy
        );
        ArrayList<Clothing> clothes = new ArrayList<>(resultSet.getCount());
        resultSet.moveToFirst();
        for (i = 0; i < resultSet.getCount(); i++) {
            clothes.add(new Clothing(
                    resultSet.getLong(resultSet.getColumnIndexOrThrow(
                            DatabaseContract.Clothing._ID))
                    , resultSet.getString(resultSet
                    .getColumnIndexOrThrow(DatabaseContract.Clothing.NAME))
                    , resultSet.getLong(resultSet
                    .getColumnIndexOrThrow(DatabaseContract.Clothing.TYPE))));
            resultSet.moveToNext();
        }
        return clothes;
    }

    public static Location[] getLocations(
            Context context, String select, String orderBy) {
        initDatabase(context);
        resultSet = database.query(
                DatabaseContract.Location.TABLE_NAME,
                null,
                select,
                null,
                null,
                null,
                orderBy
                );
        Location locations[] = new Location[resultSet.getCount()];
        resultSet.moveToFirst();
        for (i = 0; i < resultSet.getCount(); i++) {
            locations[i] = new Location(
                    resultSet.getLong(resultSet
                    .getColumnIndexOrThrow(DatabaseContract.Location._ID))
                    ,resultSet.getString(resultSet
                    .getColumnIndexOrThrow(DatabaseContract.Location.NAME)));
            resultSet.moveToNext();
        }
        return locations;
    }

    public static Type[] getTypes(
            Context context, String select, String orderBy) {
        initDatabase(context);
        resultSet = database.query(
                DatabaseContract.Type.TABLE_NAME,
                null,
                select,
                null,
                null,
                null,
                orderBy
        );
        Type types[] = new Type[resultSet.getCount()];
        resultSet.moveToFirst();
        for (i = 0; i < resultSet.getCount(); i++) {
            types[i] = new Type(
                    resultSet.getLong(resultSet
                            .getColumnIndexOrThrow(DatabaseContract.Type._ID))
                    , resultSet.getString(resultSet
                    .getColumnIndexOrThrow(DatabaseContract.Type.NAME)));
            resultSet.moveToNext();
        }
        return types;
    }

    public static Use[] getUses(
            Context context, String select, String orderBy) {
        initDatabase(context);
        resultSet = database.query(
                DatabaseContract.Use.TABLE_NAME,
                null,
                select,
                null,
                null,
                null,
                orderBy
        );
        Use uses[] = new Use[resultSet.getCount()];
        resultSet.moveToFirst();
        for (i = 0; i < resultSet.getCount(); i++) {
            uses[i] = new Use(
                    resultSet.getLong(resultSet.getColumnIndexOrThrow(
                            DatabaseContract.Use._ID))
                    , resultSet.getLong(resultSet
                    .getColumnIndexOrThrow(DatabaseContract.Use.CLOTHING))
                    , resultSet.getLong(resultSet
                    .getColumnIndexOrThrow(DatabaseContract.Use.TYPE))
                    , resultSet.getLong(resultSet
                    .getColumnIndexOrThrow(DatabaseContract.Use.LOCATION))
                    , resultSet.getInt(resultSet
                    .getColumnIndexOrThrow(DatabaseContract.Use.COUNTER)));
            resultSet.moveToNext();
        }
        return uses;
    }

    private static void initDatabase(Context context) {
        if (database == null) {
            database
                    = new DatabaseHelper(context).getWritableDatabase();
        }
    }

    public static int updateUse(Context context
            , Use use, int counterIncrement) {
        initDatabase(context);
        values.clear();
        values.put(DatabaseContract.Use.COUNTER, use.counter + counterIncrement);
        return database.update(DatabaseContract.Use.TABLE_NAME, values,
                DatabaseContract.Use._ID + " = " + use.id, null);
    }
}
