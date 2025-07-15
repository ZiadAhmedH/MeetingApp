import 'package:meeting_app/core/Routers/RouterContstants.dart';
import 'package:meeting_app/core/services/auth_services.dart';
import 'package:meeting_app/core/services/message_notifcation_service.dart';
import 'package:meeting_app/core/services/notifcation_service.dart';
import 'package:meeting_app/core/utils/ZigoCloudConst.dart';

import 'package:meeting_app/supabase_helper.dart';
import 'package:meeting_app/viewModel/data/SharedKeys.dart';
import 'package:meeting_app/viewModel/data/SharedPrefrences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:meeting_app/global_navigator.dart';
import 'package:meeting_app/model/Models/UserModel.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

class AppStartupService {
  static final AuthService authService = AuthService();

  static Future<void> initializeApp() async {
    await SupabaseHelper.init();
    LocalData.init();

    await NotificationService.initialize(onNotificationTap: handleNotificationTap);

    ZegoUIKit().init(
      appID: ZigoCloud.ZEGO_APP_ID,
      appSign: ZigoCloud.ZEGO_APP_SIGN,
    );

    final userId = LocalData.getData(key: SharedKey.uid);
    if (userId != null) {
      MessageNotificationService.subscribeToMessages(userId);
    }
  }



  static Future<void> handleNotificationTap(String? payload) async {
    if (payload == null) return;

    final parts = payload.split(',');
    if (parts.length != 2) return;

    final otherId = parts[0];
    final myId = LocalData.getData(key: SharedKey.uid);
    if (myId == null) return;

    final userRes = await Supabase.instance.client
        .from('users')
        .select()
        .eq('id', otherId)
        .single();

    final otherUser = UserModel.fromJson(userRes);

    navigatorKey.currentState?.pushNamed(
      RouteConst.chat,
      arguments: {
        'myUid': myId,
        'otherUser': otherUser,
      },
    );
  }


  
  


}
