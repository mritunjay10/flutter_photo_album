package in.indilabz.flutter_photo_album;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.util.Log;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "indilabz.in/permission";
    private MethodChannel.Result result;
    private static final String READ_EXTERNAL_STORAGE = "android.permission.READ_EXTERNAL_STORAGE";
    private static final String WRITE_EXTERNAL_STORAGE = "android.permission.WRITE_EXTERNAL_STORAGE";
    private static final String INTERNET = "android.permission.INTERNET";
    private static final int PERMISSIONS_REQUEST = 193;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                (call, res) -> {

                    MainActivity.this.result = res;
                    switch (call.method){
                        case "openSettings":
                            MainActivity.this.openSettings();
                            break;
                        case "requestPermission":
                            MainActivity.this.requestPermission();
                            break;
                        default:
                            MainActivity.this.askPermission();
                    }
                }
        );
    }

    private void askPermission(){

        if(hasPermission()){

            result.success("1");

            Log.d("TAG_WHERE", "here");
        }
        else {

           if(!checkPermissionRationale()){

               requestPermission();

               Log.d("TAG_WHERE", "there");
           }
           else {

               result.success("2");

               Log.d("TAG_WHERE", "no-here");
           }
        }
    }

    private void requestPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            requestPermissions(new String[]{INTERNET, WRITE_EXTERNAL_STORAGE,
                    READ_EXTERNAL_STORAGE}, PERMISSIONS_REQUEST);
        }

    }

    private boolean checkPermissionRationale(){
        if (Build.VERSION.SDK_INT >= 23) {
            //Log.d("PERMISSION_DEN", "PERMISSION_SUPER_DENIED");
            return shouldShowRequestPermissionRationale(WRITE_EXTERNAL_STORAGE) ||
                    shouldShowRequestPermissionRationale(READ_EXTERNAL_STORAGE) ||
                    shouldShowRequestPermissionRationale(INTERNET);
        }

        return false;
    }

    public void onRequestPermissionsResult(int i, String[] strArr, int[] iArr) {
        if (i == PERMISSIONS_REQUEST) {
            if (iArr.length > 0 && iArr[0] == 0 &&
                    iArr[1] == 0 && iArr[2] == 0) {

                result.success("1");
            } else if(checkPermissionRationale()){
                requestPermission();
            }
            else {

                result.success("3");
            }
        }
    }

    private boolean hasPermission() {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {

            if(checkSelfPermission
                    (WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED &&
                    checkSelfPermission
                            (READ_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED &&
                    checkSelfPermission
                            (INTERNET) == PackageManager.PERMISSION_GRANTED) {

                return true;
            }
            else {

                return false;
            }

        } else {

            return true;
        }
    }

    private void openSettings() {
        Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, Uri.parse("package:" + MainActivity.this.getPackageName()));
        intent.addCategory(Intent.CATEGORY_DEFAULT);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        MainActivity.this.startActivity(intent);
    }
}

