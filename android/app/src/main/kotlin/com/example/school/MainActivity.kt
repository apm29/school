package com.example.school

import android.Manifest
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Color
import android.media.AudioAttributes
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.widget.Toast
import androidx.core.app.ActivityCompat

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.github.v7lin.fakepush.FakePushPlugin
import io.github.v7lin.fakepush.R
import io.github.v7lin.fakepush.util.JsonUtils
import io.github.v7lin.fakepush.util.NotificationManagerCompat
import io.github.v7lin.fakepush.xinge.XinGeMSGClickActivity
import org.json.JSONException
import java.util.HashMap

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)
        //startService(Intent(this, MyService::class.java))
        val bootPermission = ActivityCompat.checkSelfPermission(this, Manifest.permission.RECEIVE_BOOT_COMPLETED)
        if (bootPermission != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.RECEIVE_BOOT_COMPLETED), 1022)
        }

//        if(!NotificationManagerCompat.from(this).areNotificationsEnabled()){
//            Toast.makeText(this,"请在设置中打开通知权限",Toast.LENGTH_LONG).show()
//            openNotificationSetting()
//        }
    }

    private fun openNotificationSetting() {
        val intent = Intent()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            intent.action = Settings.ACTION_APP_NOTIFICATION_SETTINGS
            intent.putExtra(Settings.EXTRA_APP_PACKAGE, this.packageName)
        } else {
            intent.action = Settings.ACTION_APP_NOTIFICATION_SETTINGS
            intent.putExtra("app_package", this.packageName)
            intent.putExtra("app_uid", this.applicationInfo.uid)
        }
        if (intent.resolveActivity(this.packageManager) != null) {
            intent.action = Settings.ACTION_APPLICATION_DETAILS_SETTINGS
            intent.data = Uri.fromParts("package", this.packageName, null)
        }
        startActivity(intent)
    }

//    fun receiveMessage(context: Context, message: XGPushTextMessage) {
//        println("context = [$context], message = [$message]")
//        val json = message.getContent()
//        var title = "告警消息"
//        var text = "可疑人员进入,点击进入App查看"
//        try {
//            val jsonObject = JSONObject(json)
//            title = jsonObject.getString("title")
//            text = jsonObject.getString("content")
//        } catch (e: JSONException) {
//            e.printStackTrace()
//        }
//
//        var notification: Notification? = null
//        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
//        val sound = Uri.parse("android.resource://" + context.packageName + "/" + R.raw.ring_raw_wav)
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            val audioAttributes = AudioAttributes.Builder()
//                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
//                    .setUsage(AudioAttributes.USAGE_NOTIFICATION)
//                    .build()
//            val channel = NotificationChannel(
//                    ChannelID,
//                    ChannelID,
//                    NotificationManager.IMPORTANCE_HIGH
//            )
//            channel.lightColor = Color.RED
//            channel.enableLights(true)
//            channel.setSound(
//                    sound,
//                    audioAttributes//Notification.AUDIO_ATTRIBUTES_DEFAULT
//            )
//            notificationManager.createNotificationChannel(
//                    channel
//            )
//            notification = Notification.Builder(context, ChannelID)
//                    .setContentIntent(
//                            PendingIntent.getActivity(
//                                    context,
//                                    REQUEST_CODE,
//                                    Intent(context, XinGeMSGClickActivity::class.java),
//                                    PendingIntent.FLAG_UPDATE_CURRENT
//                            )
//                    )
//                    .setDefaults(0)
//                    .setContentTitle(title) // 设置下拉列表里的标题
//                    .setContentText(text) // 设置上下文内容
//                    .setWhen(System.currentTimeMillis()) //
//                    .setChannelId(ChannelID)
//                    .setSmallIcon(R.drawable.ic_launcher)
//                    .build()
//        } else {
//            notification = Notification.Builder(context)
//                    .setContentIntent(
//                            PendingIntent.getActivity(
//                                    context,
//                                    REQUEST_CODE,
//                                    Intent(context, XinGeMSGClickActivity::class.java),
//                                    PendingIntent.FLAG_UPDATE_CURRENT
//                            )
//                    )
//                    .setDefaults(0)
//                    .setSmallIcon(R.drawable.ic_launcher)
//                    .setContentTitle(title) // 设置下拉列表里的标题
//                    .setContentText(text) // 设置上下文内容
//                    .setSound(sound)
//                    .setWhen(System.currentTimeMillis()) //
//                    .build()
//        }
//        notificationManager.notify(12, notification)
//
//
//        val map = HashMap<String, Any>()
//        map[FakePushPlugin.ARGUMENT_KEY_RESULT_TITLE] = message.getTitle()
//        // 信鸽BUG？
//        // 华为通道 content 为 json
//        // 华为通道 customContent 喂狗了
//        var dest: String? = null
//        if (message.getPushChannel() == PUSH_CHANNEL_HUAWEI) {
//            val content = JsonUtils.toMap(message.getContent())
//            val value = content["content"]
//            if (value != null && value is String) {
//                dest = value
//            }
//        } else {
//            dest = message.getContent()
//        }
//        map[FakePushPlugin.ARGUMENT_KEY_RESULT_CONTENT] = dest
//        map[FakePushPlugin.ARGUMENT_KEY_RESULT_CUSTOMCONTENT] = message.getCustomContent()
//
//        val receiver = Intent()
//        receiver.action = ACTION_RECEIVE_MESSAGE
//        receiver.putExtra(KEY_EXTRA_MAP, JsonUtils.toJson(map))
//        receiver.setPackage(context.packageName)
//        context.sendBroadcast(receiver)
//    }
}
