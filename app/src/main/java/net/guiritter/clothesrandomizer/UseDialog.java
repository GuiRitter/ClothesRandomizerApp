package net.guiritter.clothesrandomizer;

import android.app.Dialog;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.DialogFragment;
import android.support.v7.app.AlertDialog.Builder;

import static net.guiritter.clothesrandomizer.MainActivity.ARGUMENTS_NAME;
import static net.guiritter.clothesrandomizer.MainActivity.ARGUMENTS_USE;

public final class UseDialog extends DialogFragment {

    @NonNull
    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        Builder builder = new Builder(getActivity());
        final int useHow = getArguments().getInt(ARGUMENTS_USE);
        builder.setMessage(getString(useHow)
                + getArguments().getString(ARGUMENTS_NAME) + "?")
                .setPositiveButton(android.R.string.yes,
                        new OnClickListener() {

                            @Override
                            public void onClick(
                                    DialogInterface dialog, int which) {
                                switch (useHow) {
                                    case R.string.use_add_string:
                                        MainActivity.useIncrement();
                                        break;
                                    case R.string.use_remove_string:
                                        MainActivity.useDecrement();
                                }
                            }
                        }).setNegativeButton(android.R.string.no, new OnClickListener() {

            @Override
            public void onClick(DialogInterface dialog, int which) {}
        });
        return builder.create();
    }
}
