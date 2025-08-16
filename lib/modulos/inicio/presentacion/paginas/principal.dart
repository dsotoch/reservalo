import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Principal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
          Container(
            
            width: 1.sw/2,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.sh),
                topRight: Radius.circular(15.h)
              )
            ),
            child:Text(
              "📆                 AYAR ",
              textAlign: TextAlign.center,
              style: TextStyle(

                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 4,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ],

              ),
            ) ,
          )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 1.sw/2,
              decoration: BoxDecoration(
                  color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(15.sh)
                )
              ),
              child:Text(
                "   RESÉRVAS ⏱️",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],

                ),
              ) ,
            )
          ],
        ),


        Container(
          width: double.infinity,
          height: 1.sh / 2,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/cabana.jpg"),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.yellow,
                offset: Offset(0, 10),
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ],
          ),
        )

      ],
    );
  }
}
