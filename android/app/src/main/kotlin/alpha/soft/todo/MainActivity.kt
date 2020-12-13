package alpha.soft.todo

import android.content.ContentResolver
import android.content.Context
import android.media.RingtoneManager
import androidx.annotation.NonNull
import com.transistorsoft.flutter.backgroundfetch.BackgroundFetchPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity(),  PluginRegistry.PluginRegistrantCallback  {
    private fun resourceToUriString(context: Context, resId: Int): String? {
        return (ContentResolver.SCHEME_ANDROID_RESOURCE
                + "://"
                + context.resources.getResourcePackageName(resId)
                + "/"
                + context.resources.getResourceTypeName(resId)
                + "/"
                + context.resources.getResourceEntryName(resId))
    }
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        BackgroundFetchPlugin.setPluginRegistrant(this)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.getDartExecutor(), "crossingthestreams.io/resourceResolver").setMethodCallHandler { call, result ->
            if ("drawableToUri" == call.method) {
                val resourceId: Int = this@MainActivity.getResources().getIdentifier(call.arguments as String, "drawable", this@MainActivity.getPackageName())
                result.success(resourceToUriString(this@MainActivity.getApplicationContext(), resourceId))
            }
            if ("getAlarmUri" == call.method) {
                result.success(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM).toString())
            }
        }
    }

    override fun registerWith(@NonNull registry: PluginRegistry) {
//        GeneratedPluginRegistrant.registerWith(registry)
    }
}
