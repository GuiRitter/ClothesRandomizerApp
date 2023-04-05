package net.guiritter.clothesrandomizer;

import android.app.Dialog;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.DialogFragment;
import android.support.v7.app.AlertDialog.Builder;

import static net.guiritter.clothesrandomizer.MainActivity.TABLE_INDEX;
import static net.guiritter.clothesrandomizer.MainActivity.TABLE_CLOTHING;
import static net.guiritter.clothesrandomizer.MainActivity.TABLE_LOCATION;
import static net.guiritter.clothesrandomizer.MainActivity.ARGUMENTS_NAME;

public final class DeleteDialog extends DialogFragment {

    @NonNull
    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        final byte tableIndex = getArguments().getByte(TABLE_INDEX, (byte) -1);
        Builder builder = new Builder(getActivity());
        builder.setMessage((tableIndex == TABLE_CLOTHING
                ? getString(R.string.delete_clothing_string)
                : (tableIndex == TABLE_LOCATION
                ? getString(R.string.delete_location_string)
                : getString(R.string.delete_type_string)))
                + getArguments().getString(ARGUMENTS_NAME) + "?")
                .setPositiveButton(android.R.string.yes,
                        new OnClickListener() {

                            @Override
                            public void onClick(
                                    DialogInterface dialog, int which) {
                                switch (tableIndex) {
                                    case TABLE_CLOTHING:
                                        SelectActivity.deleteClothing();
                                        break;
                                    case TABLE_LOCATION:
                                        SelectActivity.deleteLocation();
                                        break;
                                    default:
                                        SelectActivity.deleteType();
                                }
                            }
                        }).setNegativeButton(android.R.string.no, new OnClickListener() {

            @Override
            public void onClick(DialogInterface dialog, int which) {
            }
        });
        return builder.create();
    }
}
