
package com.example.school;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class StartupReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        try {
            if (!Intent.ACTION_BOOT_COMPLETED.equals(intent.getAction())) {
                return;
            }
            Intent newIntent
                    = new Intent(context, MainActivity.class);
            newIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(newIntent);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
