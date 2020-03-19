package com.example.school

import android.app.*
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.os.Build
import android.os.IBinder

/**
 *  author : ciih
 *  date : 2019-09-11 10:30
 *  description :
 */
class MyService : Service() {

    companion object{
        const val REQUEST_CODE = 1011
        const val ChannelID = "安保消息"
    }

    override fun onBind(intent: Intent?): IBinder? {
        throw IllegalAccessException("not implemented")
    }

    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
        val notification = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

            val channel = NotificationChannel(
                    ChannelID,
                    ChannelID,
                    NotificationManager.IMPORTANCE_DEFAULT
            )
            (getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager).createNotificationChannel(
                    channel
            )
            Notification.Builder(this, ChannelID)
                    .setContentIntent(PendingIntent.getService(this, REQUEST_CODE, intent, 0))
                    .setLargeIcon(BitmapFactory.decodeResource(this.resources, R.mipmap.ic_launcher)) // 设置下拉列表中的图标(大图标)
                    .setContentTitle("安保消息同步服务") // 设置下拉列表里的标题
                    .setSmallIcon(R.mipmap.ic_launcher) // 设置状态栏内的小图标
                    .setContentText(ChannelID) // 设置上下文内容
                    .setWhen(System.currentTimeMillis()) //
                    .setChannelId(ChannelID)
                    .build()
        } else {
            Notification.Builder(this)
                    .setContentIntent(PendingIntent.getService(this, REQUEST_CODE, intent, 0))
                    .setLargeIcon(BitmapFactory.decodeResource(this.resources,R.mipmap.ic_launcher)) // 设置下拉列表中的图标(大图标)
                    .setContentTitle("安保消息同步服务") // 设置下拉列表里的标题
                    .setSmallIcon(R.mipmap.ic_launcher) // 设置状态栏内的小图标
                    .setContentText("数据同步中") // 设置上下文内容
                    .setWhen(System.currentTimeMillis()) //
                    .build()
        }
        startForeground(123, notification)
        return super.onStartCommand(intent, flags, startId)
    }

    override fun onDestroy() {
        super.onDestroy()
        startService(Intent(this, MyService::class.java))
    }
}