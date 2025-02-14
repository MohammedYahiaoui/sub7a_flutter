import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  resetToZero({bool resetGoal = false}) {
    SetCount(_counter = 0);
    SetTime(_time = 0);
    resetGoal == true ? SetGoal(_goal = 0) : null; 
  }

  setColor (int value) async {
   final SharedPreferences prefs = await SharedPreferences.getInstance();
   prefs.setInt('color', value);
   getCount();
  }

  
  SetCount (int value) async {
   final SharedPreferences prefs = await SharedPreferences.getInstance();
   prefs.setInt('counter', value);
   getCount();
  }

  SetTime (int value) async {
   final SharedPreferences prefs = await SharedPreferences.getInstance();
   prefs.setInt('time', value);
   getCount();
  }
 
  SetGoal (int value) async {
   final SharedPreferences prefs = await SharedPreferences.getInstance();
   prefs.setInt('goal', value);
   getCount();
  }

  getCount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt("counter") ?? 0;
      _time = prefs.getInt("time") ?? 0;
      _goal = prefs.getInt("goal") ?? 0;
      colorHex = prefs.getInt("color") ?? 0xFF448AFF;
    });
  }

 // Initialisation du widget
  @override
  void initState() {
    getCount();
    super.initState();
  }

int rad = 0;
int colorHex = 0xFF448AFF;
int _counter = 0;
int _time = 0;
int _goal = 0;
bool isActive = false;
TextDirection textDirection = TextDirection.rtl;
  @override
  Widget build(BuildContext context) {
 Color mainColor = Color(colorHex);
    return  Directionality(
      textDirection: textDirection,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () {
          resetToZero( resetGoal : true);
        },
        backgroundColor: mainColor,
        child: Icon(Icons.refresh, color: Colors.white,),
        ),
        appBar: AppBar(
          backgroundColor: mainColor,
          elevation: 0,
          actions: [ 
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                    isActive = !isActive;
                  });
                  },
                  child: Icon(isActive ? Icons.color_lens_sharp : Icons.lens,)),
              ),
              ],
              ),    
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration( color: mainColor),
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(child: Text(
                    "الهدف", 
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 28),
                      )
                      ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("$_goal",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28
                            ),
                            ),
                          ), 
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          resetToZero(resetGoal: true);
                          SetGoal(_goal + 33);
                        } ,
                        child: Container(
                          padding: EdgeInsets.all(12),
                          child: Text("33"),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      SizedBox(width: 8,),
                      GestureDetector(
                        onTap: () {
                          resetToZero(resetGoal: true);
                          SetGoal(_goal + 100);
                        },
                        child: Container(
                          padding: EdgeInsets.all(12),
                          child: Text("100"),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      SizedBox(width: 8,),
                      GestureDetector(
                        onTap: () {
                          resetToZero(resetGoal: true);
                          SetGoal(_goal = 1000);
                        },
                        child: Container(
                          padding: EdgeInsets.all(12),
                          child: Text("1000"),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Text("الاستغفار",
                style: TextStyle(
                  color: mainColor,
                  fontSize: 22,
                ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text("$_counter",
                style: TextStyle(
                  color: mainColor,
                  fontSize: 22,
                ),
                ),
                SizedBox(
                  height: 5,
                ),
                  CircularPercentIndicator(
                  radius: 80.0,
                  lineWidth: 5.0,
                  percent: _counter / _goal,
                  center: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_counter >= _goal) {
                          SetTime(_time + 1);
                          SetCount(_counter = 1);
                        } else if (_counter < _goal) {
                          SetCount(_counter + 1);
                        }
                      });
                    },
                    child: Icon(
                      Icons.touch_app,
                      size: 50.0,
                      color: mainColor,
                    ),
                  ),
                  backgroundColor: mainColor.withOpacity(0.2),
                  progressColor:mainColor,
                ),
                    SizedBox(
                  height: 10,
                ),
                Text("مرات التكرار :$_time",
                style: TextStyle(
                  color: mainColor,
                  fontSize: 22,
                ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("المجموع : ${_time * _goal + _counter}",
                style: TextStyle(
                  color: mainColor,
                  fontSize: 22
                ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Visibility(
                visible: isActive,
                child: Row(
                  children: [
                    Radio(
                      fillColor: WidgetStateColor.resolveWith((states) => Color(0xFF448AFF),), 
                      value: 0xFF448AFF, 
                      groupValue: colorHex, 
                      onChanged: (val) {
                      setState(() {
                      setColor(val!);
                      });
                    }),
                    Radio(
                      fillColor: WidgetStateColor.resolveWith((states) => Color(0xff14212A),), 
                      value: 0xff14212A, 
                      groupValue: colorHex, 
                      onChanged:  (val) {
                      setState(() {
                      setColor(val!);
                      });
                    }),
                    Radio(
                       fillColor: WidgetStateColor.resolveWith((states) => Color(0xFF4CAF50),),
                      value: 0xFF4CAF50, 
                      groupValue: colorHex, 
                      onChanged: (val) {
                      setState(() {
                      setColor(val!);
                      });
                    }),
                  ],
                ),
              ),
            )
          ], 
        ),
      ),
    );
  }
}