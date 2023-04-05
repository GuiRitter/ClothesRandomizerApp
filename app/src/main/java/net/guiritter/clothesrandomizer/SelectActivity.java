package net.guiritter.clothesrandomizer;

import android.content.Context;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import net.guiritter.clothesrandomizer.database.Clothing;
import net.guiritter.clothesrandomizer.database.DatabaseContract;
import net.guiritter.clothesrandomizer.database.Database;
import net.guiritter.clothesrandomizer.database.Location;
import net.guiritter.clothesrandomizer.database.Type;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;

import static net.guiritter.clothesrandomizer.MainActivity.alphabetical;
import static net.guiritter.clothesrandomizer.MainActivity.ARGUMENTS_NAME;
import static net.guiritter.clothesrandomizer.MainActivity.ASC;
import static net.guiritter.clothesrandomizer.MainActivity.TABLE_INDEX;
import static net.guiritter.clothesrandomizer.MainActivity.TABLE_CLOTHING;
import static net.guiritter.clothesrandomizer.MainActivity.TABLE_TYPE;
import static net.guiritter.clothesrandomizer.MainActivity.TABLE_LOCATION;

public class SelectActivity extends AppCompatActivity {

    private static ArrayAdapter<String> adapter;

    private static final Bundle arguments = new Bundle();

    private static ArrayList<Clothing> clothingArray = null;

    private static Context context;

    private static final DeleteDialog deleteDialog = new DeleteDialog();

    private static int i = 0;

    private static final ArrayList<String> items = new ArrayList<>();

    private static Location locationArray[] = null;

    private static int selectedIndex = 0;

    private static byte table;

    private static Type typeArray[] = null;

    private static HashMap<Long, Type> typeMap = null;

    static void deleteClothing() {
        Database.deleteClothing(context, clothingArray.get(selectedIndex).id);
        updateClothes();
    }

    static void deleteLocation() {
        Database.deleteLocation(context, locationArray[selectedIndex].id);
        updateLocations();
    }

    static void deleteType() {
        Database.deleteType(context, typeArray[selectedIndex].id);
        updateTypes();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_select);
        context = this;
        table = getIntent().getByteExtra(TABLE_INDEX, (byte) -1);
        deleteDialog.setArguments(arguments);
        adapter = new ArrayAdapter<>(
                this, android.R.layout.simple_list_item_1, items);
        switch (table) {
            case TABLE_CLOTHING:
                setTitle(getString(R.string.select_title_clothing_string));
                typeArray = Database.getTypes(this, null,
                        DatabaseContract.Type.NAME + ASC);
                typeMap = new HashMap<>();
                for (Type type : typeArray) {
                    typeMap.put(type.id, type);
                }
                updateClothes();
                break;
            case TABLE_TYPE:
                setTitle(getString(R.string.select_title_type_string));
                updateTypes();
                break;
            case TABLE_LOCATION:
                setTitle(getString(R.string.select_title_location_string));
                updateLocations();
                break;
            default:
                finish();
                return;
        }
        ListView listView = (ListView) findViewById(R.id.select_list_view_id);
        listView.setAdapter(adapter);
        listView.setOnItemLongClickListener(
                new AdapterView.OnItemLongClickListener() {

                    @Override
                    public boolean onItemLongClick(AdapterView<?> parent
                            , View view, int position, long id) {
                        return SelectActivity.this.onItemLongClick(position);
                    }
                });
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_select, menu);
        return true;
    }

    @Override
    protected void onDestroy() {
        clothingArray = null;
        locationArray = null;
        typeArray = null;
        typeMap = null;
        super.onDestroy();
    }

    private boolean onItemLongClick(int position) {
        selectedIndex = position;
        switch (table) {
            case TABLE_CLOTHING:
                arguments.putByte(TABLE_INDEX, TABLE_CLOTHING);
                arguments.putString(ARGUMENTS_NAME,
                        typeMap.get(
                                clothingArray.get(selectedIndex).typeId).name
                                + ": "
                                + clothingArray .get(selectedIndex) .name);
                deleteDialog.show(getSupportFragmentManager(),
                        "DeleteFragment");
                break;
            case TABLE_LOCATION:
                arguments.putByte(TABLE_INDEX, TABLE_LOCATION);
                arguments.putString(ARGUMENTS_NAME,
                        locationArray[selectedIndex].name);
                deleteDialog.show(getSupportFragmentManager(),
                        "DeleteFragment");
                break;
            case TABLE_TYPE:
                arguments.putByte(TABLE_INDEX, TABLE_TYPE);
                arguments.putString(ARGUMENTS_NAME,
                        typeArray[selectedIndex].name);
                deleteDialog.show(getSupportFragmentManager(),
                        "DeleteFragment");
                break;
            default:
                finish();
        }
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        //noinspection SimplifiableIfStatement
        if (id == R.id.select_bar_add_id) {
            Intent intent = new Intent(this, AddActivity.class);
            switch (table) {
                case TABLE_CLOTHING:
                    intent.putExtra(TABLE_INDEX, TABLE_CLOTHING);
                    break;
                case TABLE_LOCATION:
                    intent.putExtra(TABLE_INDEX, TABLE_LOCATION);
                    break;
                case TABLE_TYPE:
                    intent.putExtra(TABLE_INDEX, TABLE_TYPE);
            }
            startActivity(intent);
        } else if (id == android.R.id.home) {
            onBackPressed();
        }
        return true;
    }

    @Override
    protected void onResume() {
        switch (table) {
            case TABLE_CLOTHING:
                updateClothes();
                break;
            case TABLE_LOCATION:
                updateLocations();
                break;
            case TABLE_TYPE:
                updateTypes();
        }
        super.onResume();
    }

    private static void updateClothes() {
        clothingArray = Database.getClothes(context, null, null);
        for (Clothing clothing : clothingArray) {
            clothing.typeName = typeMap.get(clothing.typeId).name;
        }
        Collections.sort(clothingArray, alphabetical);
        items.clear();
        for (i = 0; i < clothingArray.size(); i++) {
            items.add(clothingArray.get(i).getFullName());
        }
        adapter.notifyDataSetChanged();
    }

    private static void updateLocations() {
        locationArray = Database.getLocations(context, null,
                DatabaseContract.Location.NAME + ASC);
        items.clear();
        for (i = 0; i < locationArray.length; i++) {
            items.add(locationArray[i].name);
        }
        adapter.notifyDataSetChanged();
    }

    private static void updateTypes() {
        typeArray = Database.getTypes(context, null,
                DatabaseContract.Type.NAME + ASC);
        items.clear();
        for (i = 0; i < typeArray.length; i++) {
            items.add(typeArray[i].name);
        }
        adapter.notifyDataSetChanged();
    }
}
