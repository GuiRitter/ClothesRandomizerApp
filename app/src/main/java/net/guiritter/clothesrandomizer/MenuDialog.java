package net.guiritter.clothesrandomizer;

import android.app.Dialog;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.DialogFragment;
import android.support.v7.app.AlertDialog.Builder;

import static net.guiritter.clothesrandomizer.MainActivity.ARGUMENTS_ARRAY;
import static net.guiritter.clothesrandomizer.MainActivity.ARGUMENTS_NAME;
import static net.guiritter.clothesrandomizer.MainActivity.ARGUMENTS_USE;

public final class MenuDialog extends DialogFragment {

    private static final Bundle arguments = new Bundle();

    private static final UseDialog useDialog = new UseDialog();

    @NonNull
    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        useDialog.setArguments(arguments);
        arguments.putString(ARGUMENTS_NAME,
                getArguments().getString(ARGUMENTS_NAME));
        Builder builder = new Builder(getActivity());
        final int array = getArguments().getInt(ARGUMENTS_ARRAY);
        builder.setItems(array, new OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                switch (which) {
                    case 0://first option: add use
                        arguments.putInt(ARGUMENTS_USE,
                                R.string.use_add_string);
                        break;
                    case 1:
                        if (array == R.array.menu_dialog_array) {
                            arguments.putInt(ARGUMENTS_USE,
                                    R.string.use_remove_string);
                        } else {
                            return;
                        }
                        break;
                    default: return;
                }
                useDialog.show(getActivity().getSupportFragmentManager(),
                        "DeleteFragment");
            }
        });
        return builder.create();
    }
}
