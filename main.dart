import 'package:flutter/material.dart';
import 'userDB.dart';

void main() {
  runApp(const MyApp(

  ));
}

//--------------------------------------------------------------------- Class declaration
class bmiCalc{
  static const String SQLiteTable = "";
  String bmivalue;
  double total;
  String bmicalc;
  String genderValue;
  String fullname;
  double weight;
  double height;

  bmiCalc(this.bmivalue, this.total, this.bmicalc, this.genderValue, this.fullname,this.weight,this.height);

}

enum gender {male, female} //radio button declaration

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  BMIDatabase bmiDatabase = BMIDatabase.instance;
  gender? _gender = gender.male;
  String bmivalue = "BMI Value";
  double total = 0.0;
  String bmicalc = "";
  String genderValue = "Male";
  double weight = 0.0;
  double height = 0.0;

  //--------------------------------------------------------------------- Function calculate BMI
  void calculateBMI() async{
    String height = heightController.text.trim();
    String weight = weightController.text.trim();

    //--------------------------------------------------------------------- Gender and BMI Condition
    if(height.isNotEmpty && weight.isNotEmpty){
      setState(() {
        total = (double.parse(weight)/(double.parse(height)*double.parse(height)))*10000;

        if(genderValue == "Male"){
          if (total <= 18.5){
            bmivalue = "Underweight. Careful during strong wind! Your BMI is: ${total.toStringAsFixed(2)}";
          }else if(total >= 18.6 && total <= 24.9){
            bmivalue = "That's ideal! Please maintain. Your BMI is: ${total.toStringAsFixed(2)}";
          }else if(total >= 25.0 && total <= 29.9){
            bmivalue = "Overweight! Work out please. Your BMI is: ${total.toStringAsFixed(2)}";
          }else if(total >= 30.0){
            bmivalue = "Whoa Obese! Dangerous Mate. Your BMI is: ${total.toStringAsFixed(2)}";
          }
        }else if (genderValue == "Female"){
          if (total < 16){
            bmivalue = "Underweight. Careful during strong wind! Your BMI is: ${total.toStringAsFixed(2)}";
          }else if(total >= 16.1 && total <= 22){
            bmivalue = "That's ideal! Please maintain. Your BMI is: ${total.toStringAsFixed(2)}";
          }else if(total >= 22.1 && total <= 27){
            bmivalue = "Overweight! Work out please. Your BMI is: ${total.toStringAsFixed(2)}";
          }else if(total >= 27.1){
            bmivalue = "Whoa Obese! Dangerous Mate. Your BMI is: ${total.toStringAsFixed(2)}";
          }
        }
      });
      //--------------------------------------------------------------------- Database Upload
      uploadData();
    }else{
      setState(() {
        bmivalue = "Input Error";
      });
    }
  }

  void uploadData() async {
    await bmiDatabase.insertData(
      username: fullnameController.text,
      weight: weightController.text,
      height: heightController.text,
      gender: genderValue,
      bmiStatus: bmivalue,
    );
  }

  void retrieveData() async{
    List<Map<String, dynamic>> allData = await bmiDatabase.getAllData();
    print(allData);
  }

  @override
  void initState(){
    super.initState();
    retrieveData();
  }
  Widget build(BuildContext context) {
    //--------------------------------------------------------------------- UI Configuration
    return MaterialApp(
      title: "BMI Calculator",
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "BMI Calculator",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.blue,
        ),
        body: Column(
          children: [
            //--------------------------------------------------------------------- Fullname
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: fullnameController,
                decoration: const InputDecoration(
                  labelText: 'Your Fullname',
                ),
              ),
            ),
            //--------------------------------------------------------------------- Height
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: heightController,
                decoration: const InputDecoration(
                  labelText: 'Height in cm, 170',
                ),
              ),
            ),
            //--------------------------------------------------------------------- Weight
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: weightController,
                decoration: const InputDecoration(
                  labelText: 'Weight in KG',
                ),
              ),
            ),
            //--------------------------------------------------------------------- Text Alignment
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  bmivalue,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            //--------------------------------------------------------------------- Radio Configuration
            Row(
              children: <Widget>[
                Expanded(
                  child: ListTile(
                      title: const Text('Male'),
                      leading: Radio<gender>(
                        value: gender.male,
                        groupValue: _gender,
                        onChanged: (gender? value){
                          setState(() {
                            _gender = value;
                            genderValue = "Male";
                          });
                        },
                      )
                  ),
                ),
                Expanded(
                  child: ListTile(
                      title: const Text('Female'),
                      leading: Radio<gender>(
                        value: gender.female,
                        groupValue: _gender,
                        onChanged: (gender? value){
                          setState(() {
                            _gender = value;
                            genderValue = "Female";
                          });
                        },
                      )
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            //--------------------------------------------------------------------- Calculate Button
            ElevatedButton(
              onPressed: calculateBMI,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Calculate BMI and Save',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
