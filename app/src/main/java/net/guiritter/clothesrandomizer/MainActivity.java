package net.guiritter.clothesrandomizer;

import android.content.Context;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.Spinner;

import net.guiritter.clothesrandomizer.database.Clothing;
import net.guiritter.clothesrandomizer.database.Database;
import net.guiritter.clothesrandomizer.database.DatabaseContract;
import net.guiritter.clothesrandomizer.database.Location;
import net.guiritter.clothesrandomizer.database.Type;
import net.guiritter.clothesrandomizer.database.Use;

import org.random.util.RandomOrgRandom;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.NoSuchElementException;
import java.util.Random;

// TODO add update to CRUD
// TODO add database import/export
// TODO keep spinner selected item the same when orientation changes

public class MainActivity extends AppCompatActivity {

    public static final Comparator<Clothing> alphabetical
            = new Comparator<Clothing>() {
        @Override
        public int compare(Clothing lhs, Clothing rhs) {
            int i = lhs.typeName.compareToIgnoreCase(rhs.typeName);
            if (i != 0) return i;
            return lhs.name.compareToIgnoreCase(rhs.name);
        }
    };

    private static final Bundle argumentsMenu = new Bundle();

    private static final Bundle argumentsUse = new Bundle();

    static final String ARGUMENTS_ARRAY = "array";
    static final String ARGUMENTS_NAME = "name";
    static final String ARGUMENTS_USE = "use";

    /**
     * SQL to sort the results alphabetically ascending, ignoring case.
     * The problem is that lower case comes before upper case.
     */
    public static final String ASC = " COLLATE NOCASE";

    private static ArrayList<Clothing> clothingArray = null;

    private static final HashMap<Long, Clothing> clothingMap = new HashMap<>();

    private static final HashMap<Long, Use> clothingToUseMap = new HashMap<>();

    private static Context context = null;

    private static Location[] locationArray = null;

    private static Spinner locationSpinner = null;

    private static final MenuDialog menuDialog = new MenuDialog();

//    private static final RandomOrgRandom RNGActual
//            = new RandomOrgRandom("00b61d5b-0576-4854-9393-0f8f88d32fd3");

    private static final Random RNGPseudo
            = new Random(System.currentTimeMillis());

    private static int selectedIndex = 0;

    public static final String TABLE_INDEX = "tableIndex";

    public static final byte TABLE_CLOTHING = 0;
    public static final byte TABLE_TYPE = 1;
    public static final byte TABLE_LOCATION = 2;

    public static ArrayAdapter<String> typeAdapter = null;

    private static Type[] typeArray = null;

    private static Spinner typeSpinner = null;

    private static ArrayAdapter<String> useAdapter = null;

    private static Use[] useArray = null;

    private static final UseDialog useDialog = new UseDialog();

    private static ArrayList<String> useList = null;

    private static ListView useListView = null;

    public void onClickRandomizeButton(View view) {
        int useMinimum = Integer.MAX_VALUE;
        for (Use use : useArray) {
            useMinimum = Math.min(useMinimum, use.counter);
        }
        ArrayList<Use> useCandidates = new ArrayList<>(useArray.length);
        for (Use use : useArray) {
            if (use.counter == useMinimum) {
                useCandidates.add(use);
            }
        }
        int random = 0;
        if (useCandidates.size() != 1) {
            Log.i("MainActivity",
                    "onClickRandomizeButton: real random disabled for now");
//            try {
//                Log.i("MainActivity",
//                        "onClickRandomizeButton: trying to get real random");
//                random = RNGActual.nextInt(useCandidates.size());
//                Log.i("MainActivity",
//                        "onClickRandomizeButton: real random: " + random);
//            } catch (NoSuchElementException ex) {
                random = RNGPseudo.nextInt(useCandidates.size());
                Log.i("MainActivity",
                        "onClickRandomizeButton: pseudo random: " + random);
//            }
        } else {
            Log.i("MainActivity",
                    "onClickRandomizeButton: random not necessary");
        }
        selectedIndex = clothingArray.indexOf(
                clothingMap.get(useCandidates.get(random).clothing));
        argumentsUse.putInt(ARGUMENTS_USE, R.string.use_add_string);
        argumentsUse.putString(ARGUMENTS_NAME,
                clothingArray.get(selectedIndex).name);
        useDialog.show(this.getSupportFragmentManager(), "DeleteFragment");
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        context = this;
        menuDialog.setArguments(argumentsMenu);
        useDialog.setArguments(argumentsUse);
        typeSpinner = (Spinner) findViewById(R.id.main_type_spinner_id);
        typeSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent
                    , View view, int position, long id) {
                updateUses();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {}
        });
        locationSpinner = (Spinner) findViewById(R.id.main_location_spinner_id);
        locationSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent
                    , View view, int position, long id) {
                updateUses();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {}
        });
        useListView = (ListView) findViewById(R.id.main_list_view_id);
        useListView.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
            @Override
            public boolean onItemLongClick(AdapterView<?> parent
                    , View view, int position, long id) {
                return MainActivity.this.onItemLongClick(position);
            }
        });
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    private boolean onItemLongClick(int position) {
        selectedIndex = position;
        argumentsMenu.putString(ARGUMENTS_NAME, clothingArray.get(position).name);
        if (clothingToUseMap.get(clothingArray.get(position).id).counter == 0) {
            argumentsMenu.putInt(ARGUMENTS_ARRAY,
                    R.array.menu_dialog_incomplete_array);
        } else {
            argumentsMenu.putInt(ARGUMENTS_ARRAY, R.array.menu_dialog_array);
        }
        menuDialog.show(getSupportFragmentManager(),
                "DeleteFragment");
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        //noinspection SimplifiableIfStatement
        Intent intent = new Intent(this, SelectActivity.class);
        switch (id) {
            case R.id.main_bar_clothing_id:
                intent.putExtra(TABLE_INDEX, TABLE_CLOTHING);
                break;
            case R.id.main_bar_type_id:
                intent.putExtra(TABLE_INDEX, TABLE_TYPE);
                break;
            case R.id.main_bar_location_id:
                intent.putExtra(TABLE_INDEX, TABLE_LOCATION);
                break;
            default:
                return true;
        }
        startActivity(intent);
        return true;
    }

    @Override
    protected void onResume() {
        super.onResume();
        typeArray = Database.getTypes(this, null,
                DatabaseContract.Type.NAME + ASC);
        ArrayList<String> items = new ArrayList<>();
        for (Type type : typeArray) {
            items.add(type.name);
        }
        typeAdapter = new ArrayAdapter<>(
                this, android.R.layout.simple_spinner_dropdown_item, items);
        typeSpinner.setAdapter(typeAdapter);
        typeAdapter.notifyDataSetChanged();
        locationArray = Database.getLocations(this, null,
                DatabaseContract.Location.NAME + ASC);
        items = new ArrayList<>();
        for (Location location : locationArray) {
            items.add(location.name);
        }
        ArrayAdapter<String> locationAdapter = new ArrayAdapter<>(
                this, android.R.layout.simple_spinner_dropdown_item, items);
        locationSpinner.setAdapter(locationAdapter);
        locationAdapter.notifyDataSetChanged();
        useList = new ArrayList<>();
        useAdapter = new ArrayAdapter<>(
                this, android.R.layout.simple_list_item_1, useList);
        useListView.setAdapter(useAdapter);
        updateUses();
    }

    static void updateUses() {
        long typeId = typeSpinner.getSelectedItemPosition();
        long locationId = locationSpinner.getSelectedItemPosition();
        if ((typeId == -1) || (locationId == -1)) {
            useList.clear();
            useAdapter.notifyDataSetChanged();
            return;
        }
        typeId = typeArray[(int) typeId].id;
        locationId = locationArray[(int) locationId].id;
        clothingArray = Database.getClothes(context,
                DatabaseContract.Clothing.TYPE + " = " + typeId,
                DatabaseContract.Clothing.NAME + ASC);
        clothingMap.clear();
        for (Clothing clothing : clothingArray) {
            clothingMap.put(clothing.id, clothing);
        }
        useArray = Database.getUses(context, DatabaseContract.Use.TYPE
                + " = " + typeId + " AND " + DatabaseContract.Use.LOCATION
                + " = " + locationId, null);
        clothingToUseMap.clear();
        for(Use use : useArray) {
            clothingToUseMap.put(use.clothing, use);
        }
        useList.clear();
        for (Clothing clothing : clothingArray) {
            useList.add(clothing.name + ": "
                    + clothingToUseMap.get(clothing.id).counter);
        }
        useAdapter.notifyDataSetChanged();
    }

    static void useDecrement() {
        Database.updateUse(context,
                clothingToUseMap.get(clothingArray.get(selectedIndex).id), -1);
        updateUses();
    }

    static void useIncrement() {
        Use useSelected = clothingToUseMap.get(clothingArray.get(selectedIndex).id);
        useSelected = useSelected.increment();
        boolean decrementAll = true;
        for (Use use : useArray) {
            if ((use.id != useSelected.id) && (use.counter == 0)) {
                decrementAll = false;
                break;
            }
        }
        if (decrementAll) {
            for (Use use : useArray) {
                if (use.id == useSelected.id) continue;
                Database.updateUse(context, use, -1);
            }
        } else {
            Database.updateUse(context, useSelected, 0);
        }
        updateUses();
    }
}
