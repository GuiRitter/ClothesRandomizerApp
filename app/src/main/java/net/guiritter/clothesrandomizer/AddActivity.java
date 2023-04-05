package net.guiritter.clothesrandomizer;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;

import net.guiritter.clothesrandomizer.database.DatabaseContract;
import net.guiritter.clothesrandomizer.database.Database;
import net.guiritter.clothesrandomizer.database.Type;

import java.util.ArrayList;

import static net.guiritter.clothesrandomizer.MainActivity.ASC;
import static net.guiritter.clothesrandomizer.MainActivity.TABLE_INDEX;
import static net.guiritter.clothesrandomizer.MainActivity.TABLE_CLOTHING;
import static net.guiritter.clothesrandomizer.MainActivity.TABLE_LOCATION;
import static net.guiritter.clothesrandomizer.MainActivity.TABLE_TYPE;

public class AddActivity extends AppCompatActivity {

    private static EditText nameEditText;

    private byte tableIndex = -1;

    private static Type typeArray[] = null;

    private static Spinner typeSpinner = null;

    public void onClickAddButton(View view) {
        switch (tableIndex) {
            case TABLE_CLOTHING:
                if (Database.addClothing(getApplicationContext(),
                        nameEditText.getText().toString(),
                        typeArray[typeSpinner.getSelectedItemPosition()].id)) {
                    nameEditText.setText("");
                    Toast.makeText(this, getString(
                                    R.string.add_clothing_success_string),
                            Toast.LENGTH_LONG).show();
                } else {
                    Toast.makeText(this, getString(
                                    R.string.add_clothing_failed_string),
                            Toast.LENGTH_LONG).show();
                }
                break;
            case TABLE_LOCATION:
                if (Database.addLocation(
                        getApplicationContext(), nameEditText.getText().toString())) {
                    nameEditText.setText("");
                    Toast.makeText(this, getString(
                                    R.string.add_location_success_string),
                            Toast.LENGTH_LONG).show();
                } else {
                    Toast.makeText(this, getString(
                                    R.string.add_location_failed_string),
                            Toast.LENGTH_LONG).show();
                }
                break;
            case TABLE_TYPE:
                if (Database.addType(
                        getApplicationContext(), nameEditText.getText().toString())) {
                    nameEditText.setText("");
                    Toast.makeText(this, getString(
                                    R.string.add_type_success_string),
                            Toast.LENGTH_LONG).show();
                } else {
                    Toast.makeText(this, getString(
                                    R.string.add_type_failed_string),
                            Toast.LENGTH_LONG).show();
                }
                break;
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        tableIndex = getIntent().getExtras().getByte(TABLE_INDEX);
        if (tableIndex == TABLE_CLOTHING) {
            setContentView(R.layout.activity_add_clothing);
            typeArray = Database.getTypes(this, null,
                    DatabaseContract.Type.NAME + ASC);
//            HashMap<Long, Type> typeMap = new HashMap<>();
//            for (Type type : typeArray) {
//                typeMap.put(type.id, type);
//            }
            ArrayList<String> items = new ArrayList<>();
            for (Type type : typeArray) {
                items.add(type.name);
            }
            ArrayAdapter<String> adapter = new ArrayAdapter<>(
                    this, android.R.layout.simple_spinner_dropdown_item, items);
            typeSpinner = (Spinner) findViewById(R.id.clothing_add_spinner_id);
            typeSpinner.setAdapter(adapter);
        } else {
            setContentView(R.layout.activity_add_location_type);
        }
        nameEditText = (EditText)
                findViewById(R.id.add_name_edit_text_id);
        switch (tableIndex) {
            case TABLE_CLOTHING:
                setTitle(R.string.add_clothing_title_string);
                break;
            case TABLE_LOCATION:
                setTitle(R.string.add_location_title_string);
                break;
            case TABLE_TYPE:
                setTitle(R.string.add_type_title_string);
        }
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            onBackPressed();
        }
        return true;
    }
}
