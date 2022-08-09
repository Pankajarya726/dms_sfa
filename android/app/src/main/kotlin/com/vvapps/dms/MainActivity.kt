package com.vvapps.dms

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.provider.Settings
import android.telephony.TelephonyManager
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.vvapps.sfa/imei"
//    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
//                call, result ->
//            if(call.method=="getImeiNumber"){
//                var info = getIMEIDeviceId(context);
//
//                Log.e(javaClass.simpleName,"info--->"+info)
//                result.success(info)
//            }
//            // This method is invoked on the main thread.
//            // TODO
//        }
//    }
//
////    fun getIMEIDeviceId(context: Context): String? {
//
//        val deviceId: String = Settings.Secure.getString(context.contentResolver, Settings.Secure.ANDROID_ID)
////        deviceId = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
////            Settings.Secure.getString(context.contentResolver, Settings.Secure.ANDROID_ID)
////        } else {
////            val mTelephony = context.getSystemService(TELEPHONY_SERVICE) as TelephonyManager
////            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
////                if (context.checkSelfPermission(Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
////                    return ""
////                }
////            }
////            if (mTelephony.deviceId != null) {
////                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
////                    mTelephony.imei
////                } else {
////                    mTelephony.deviceId
////                }
////            } else {
////                Settings.Secure.getString(context.contentResolver, Settings.Secure.ANDROID_ID)
////            }
////        }
//        Log.d("deviceId", deviceId)
//
//        return deviceId
//    }
}

