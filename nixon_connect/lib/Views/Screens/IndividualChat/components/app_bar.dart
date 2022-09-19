import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../Common/constant.dart';

AppBar buildAppBar(
    {required String title,
    required isLoading,
    required loadingProgress}) {
  return AppBar(
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
    elevation: 0,
    automaticallyImplyLeading: false,
    backgroundColor: kBackgroundColor,
    flexibleSpace: SafeArea(
      child: Container(
        padding: const EdgeInsets.only(right: 16),
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 14,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  "Online",
                  style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13),
                ),
              ],
            ),
            const Spacer(),
            isLoading
                ? Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Sending...",
                            style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12)),
                      ),
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          backgroundColor:
                              Colors.grey.shade200,
                          value: loadingProgress,
                          valueColor:
                              const AlwaysStoppedAnimation<
                                  Color>(Colors.blueAccent),
                          strokeWidth: 3,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                    ],
                  )
                : const SizedBox(
                    width: 8,
                  ),
          ],
        ),
      ),
    ),
  );
}
