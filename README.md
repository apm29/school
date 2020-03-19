# school

anxinju school app

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


```java
package io.github.v7lin.fakepush;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.media.AudioAttributes;
import android.net.Uri;
import android.os.Build;
import android.text.TextUtils;

import com.tencent.android.tpush.XGPushShowedResult;
import com.tencent.android.tpush.XGPushTextMessage;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import io.github.v7lin.fakepush.util.JsonUtils;
import io.github.v7lin.fakepush.xinge.XinGeMSGClickActivity;

public abstract class PushMSGReceiver extends BroadcastReceiver {
    private static final String ACTION_RECEIVE_MESSAGE = "fake_push.action.RECEIVE_MESSAGE";
    private static final String ACTION_RECEIVE_NOTIFICATION = "fake_push.action.RECEIVE_NOTIFICATION";

    private static final String KEY_EXTRA_MAP = "extraMap";

    private static final int PUSH_CHANNEL_XINGE = 0;
    private static final int PUSH_CHANNEL_XIAOMI = 3;
    private static final int PUSH_CHANNEL_HUAWEI = 4;

    @Override
    public final void onReceive(Context context, Intent intent) {
        if (TextUtils.equals(ACTION_RECEIVE_MESSAGE, intent.getAction())) {
            onReceiveMessage(context, extraMap(intent));
        } else if (TextUtils.equals(ACTION_RECEIVE_NOTIFICATION, intent.getAction())) {
            onReceiveNotification(context, extraMap(intent));
        }
    }

    private Map<String, Object> extraMap(Intent intent) {
        String json = intent.getStringExtra(KEY_EXTRA_MAP);
        return JsonUtils.toMap(json);
    }

    public abstract void onReceiveMessage(Context context, Map<String, Object> map);

    public abstract void onReceiveNotification(Context context, Map<String, Object> map);

    public static <PR extends PushMSGReceiver> void registerReceiver(Context context, PR receiver) {
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction(ACTION_RECEIVE_NOTIFICATION);
        intentFilter.addAction(ACTION_RECEIVE_MESSAGE);
        context.registerReceiver(receiver, intentFilter);
    }

    public static <PR extends PushMSGReceiver> void unregisterReceiver(Context context, PR receiver) {
        context.unregisterReceiver(receiver);
    }

    static String ChannelID = "安保消息-1";
    static int REQUEST_CODE = 1212;

    public static void receiveMessage(Context context, XGPushTextMessage message) {
        System.out.println("context = [" + context + "], message = [" + message + "]");
        String json = message.getContent();
        String title = "告警消息";
        String text = "可疑人员进入,点击进入App查看";
        try {
            JSONObject jsonObject = new JSONObject(json);
            title = jsonObject.getString("title");
            text = jsonObject.getString("content");
        } catch (JSONException e) {
            e.printStackTrace();
        }
        Notification notification = null;
        NotificationManager notificationManager
                = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        Uri sound = Uri.parse("android.resource://" + context.getPackageName() + "/" + R.raw.ring_raw_wav);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            AudioAttributes audioAttributes = new AudioAttributes.Builder()
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                    .build();
            NotificationChannel channel = new NotificationChannel(
                    ChannelID,
                    ChannelID,
                    NotificationManager.IMPORTANCE_HIGH
            );
            channel.setLightColor(Color.RED);
            channel.enableLights(true);
            channel.setSound(
                    sound,
                    audioAttributes//Notification.AUDIO_ATTRIBUTES_DEFAULT
            );
            notificationManager.createNotificationChannel(
                    channel
            );
            notification = new Notification.Builder(context, ChannelID)
                    .setContentIntent(
                            PendingIntent.getActivity(
                                    context,
                                    REQUEST_CODE,
                                    new Intent(context, XinGeMSGClickActivity.class),
                                    PendingIntent.FLAG_UPDATE_CURRENT
                            )
                    )
                    .setDefaults(0)
                    .setContentTitle(title) // 设置下拉列表里的标题
                    .setContentText(text) // 设置上下文内容
                    .setWhen(System.currentTimeMillis()) //
                    .setChannelId(ChannelID)
                    .setSmallIcon(R.drawable.ic_launcher)
                    .build();
        } else {
            notification = new Notification.Builder(context)
                    .setContentIntent(
                            PendingIntent.getActivity(
                                    context,
                                    REQUEST_CODE,
                                    new Intent(context, XinGeMSGClickActivity.class),
                                    PendingIntent.FLAG_UPDATE_CURRENT
                            )
                    )
                    .setDefaults(0)
                    .setSmallIcon(R.drawable.ic_launcher)
                    .setContentTitle(title) // 设置下拉列表里的标题
                    .setContentText(text) // 设置上下文内容
                    .setSound(sound)
                    .setWhen(System.currentTimeMillis()) //
                    .build();
        }
        notificationManager.notify(12, notification);


        Map<String, Object> map = new HashMap<>();
        map.put(FakePushPlugin.ARGUMENT_KEY_RESULT_TITLE, message.getTitle());
        // 信鸽BUG？
        // 华为通道 content 为 json
        // 华为通道 customContent 喂狗了
        String dest = null;
        if (message.getPushChannel() == PUSH_CHANNEL_HUAWEI) {
            Map<String, Object> content = JsonUtils.toMap(message.getContent());
            Object value = content.get("content");
            if (value != null && value instanceof String) {
                dest = (String) value;
            }
        } else {
            dest = message.getContent();
        }
        map.put(FakePushPlugin.ARGUMENT_KEY_RESULT_CONTENT, dest);
        map.put(FakePushPlugin.ARGUMENT_KEY_RESULT_CUSTOMCONTENT, message.getCustomContent());

        Intent receiver = new Intent();
        receiver.setAction(ACTION_RECEIVE_MESSAGE);
        receiver.putExtra(KEY_EXTRA_MAP, JsonUtils.toJson(map));
        receiver.setPackage(context.getPackageName());
        context.sendBroadcast(receiver);
    }

    public static void receiveNotification(Context context, XGPushShowedResult message) {
        Map<String, Object> map = new HashMap<>();
        map.put(FakePushPlugin.ARGUMENT_KEY_RESULT_TITLE, message.getTitle());
        map.put(FakePushPlugin.ARGUMENT_KEY_RESULT_CONTENT, message.getContent());
        Map<String, Object> dest = new HashMap<>();
        // 信鸽BUG？
        // 华为通道 notificationActionType = 1
        // 信鸽通道 notificationActionType = 3
        Uri uri = null;
        if (message.getPushChannel() == PUSH_CHANNEL_XIAOMI && message.getNotificationActionType() == XGPushShowedResult.NOTIFICATION_ACTION_ACTIVITY) {
            Map<String, Object> customContent = JsonUtils.toMap(message.getCustomContent());
            Object intentUri = customContent.get("intent_uri");
            if (intentUri != null && intentUri instanceof String) {
                uri = Uri.parse((String) intentUri);
            }
        } else if (message.getPushChannel() == PUSH_CHANNEL_XINGE && message.getNotificationActionType() == XGPushShowedResult.NOTIFICATION_ACTION_INTENT) {
            uri = Uri.parse(message.getActivity());
        }
        if (uri != null) {
            Set<String> keys = uri.getQueryParameterNames();
            if (keys != null && !keys.isEmpty()) {
                for (String key : keys) {
                    if (!TextUtils.isEmpty(key)) {
                        List<String> values = uri.getQueryParameters(key);
                        if (values != null && !values.isEmpty()) {
                            if (values.size() == 1) {
                                dest.put(key, values.get(0));
                            } else {
                                dest.put(key, values);
                            }
                        }
                    }
                }
            }
        }
        map.put(FakePushPlugin.ARGUMENT_KEY_RESULT_CUSTOMCONTENT, JsonUtils.toJson(dest));

        Intent receiver = new Intent();
        receiver.setAction(ACTION_RECEIVE_NOTIFICATION);
        receiver.putExtra(KEY_EXTRA_MAP, JsonUtils.toJson(map));
        receiver.setPackage(context.getPackageName());
        context.sendBroadcast(receiver);
    }
}

```