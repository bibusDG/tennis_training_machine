import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tennis_training_machine/models/training_model.dart';

class MyTrainingsPage extends StatelessWidget {
  const MyTrainingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<TrainingModel> myData = [];
    GetStorage myTrainings = GetStorage('myTrainings');
    for(var _ in myTrainings.getKeys()){
      TrainingModel trainingModel = TrainingModel(
          name: _.toString(), returnHits: myTrainings.read(_.toString()));
      myData.add(trainingModel);
    }
    print(myData);
    return ResponsiveScaledBox(
      width: 360,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My trainings'),
          centerTitle: true,
        ),
        body: ListView.builder(
          itemExtent: 80.0,
          itemCount: myData.length,
            itemBuilder: (BuildContext context, int index){
            return Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
              child: Card(
                color: Colors.teal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 20.0,),
                    Center(child: Text(myData[index].name, style: TextStyle(fontSize: 25.0),)),
                    const SizedBox(width: 30.0,),
                    const Icon(Icons.play_circle, size: 45.0,),
                    const SizedBox(width: 20.0,)

                  ],
                ),
              ),
            );
        }),
      ),
    );
  }
}
