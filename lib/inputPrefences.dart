// ignore_for_file: camel_case_types
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_grocery_app/models/recipe_parameters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class MultiSelect extends StatefulWidget {
  final List<String> items;
  const MultiSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

final FirebaseAuth auth = FirebaseAuth.instance;

void inputData() {
  final User? user = auth.currentUser;
  final uid = user?.email;

  // final filename = "local_user";
  // final file = File('${(await getApplicationDocumentsDirectory()).path}/$filename.json');
  // file.writeAsString(json.encode(user.toJson()));
  // User.fromJson(file.readAsString());
  // here you write the codes to input the data into firestore
}

// Future<void> saveUser(uid ){

//   FirebaseFirestore.instance.collection("users");
// }

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items
  final List<String> _selectedItems = [];

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select From Given Options'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
                    value: _selectedItems.contains(item),
                    title: Text(item),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => _itemChange(item, isChecked!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}

class UserInputScreen extends StatefulWidget {
  const UserInputScreen({super.key});
  @override
  State<UserInputScreen> createState() => _UserInputScreenState();
}

class _UserInputScreenState extends State<UserInputScreen> {
  List<String> prefOptions = [
    'Gluten Free',
    'Ketogenic',
    'Vegetarian',
    'Lacto-Vegetarian',
    'Ovo-Vegetarian',
    'Vegan',
    'Pescetarian',
    'Paleo',
    'Primal',
    'Low FODMAP',
    'Whole30'
  ];
  List<String> selectedPrefs = [];

  List<String> restricOptions = [
    'Dairy',
    'Egg',
    'Gluten',
    'Grain',
    'Peanut',
    'Seafood',
    'Sesame',
    'Shellfish',
    'Soy',
    'Sulfite',
    'Tree Nut',
    'Wheat'
  ];
  List<String> selectedRestrictions = [];

  List<String> cuisineOptions = [
    'African',
    'American',
    'British',
    'Cajun',
    'Caribbean',
    'Chinese',
    'Eastern European',
    'European',
    'French',
    'German',
    'Greek',
    'Indian',
    'Irish',
    'Italian',
    'Japanese',
    'Jewish',
    'Korean',
    'Latin American',
    'Mediterranean',
    'Mexican',
    'Middle Eastern',
    'Nordic',
    'Southern',
    'Spanish',
    'Thai',
    'Vietnamese'
  ];
  List<String> selectedCuisine = [];

  void _showMultiSelect(List<String> items, int i) async {
    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: items);
      },
    );
    if (i == 1) {
      if (results != null) {
        setState(() {
          selectedPrefs = results;
        });
      }
    } else if (i == 2) {
      if (results != null) {
        setState(() {
          selectedRestrictions = results;
        });
      }
    } else {
      if (results != null) {
        setState(() {
          selectedCuisine = results;
        });
      }
    }
  }

  // Store user preferences
  Future<void> _storePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setStringList('cuisines', selectedCuisine);
      prefs.setStringList('restrictions', selectedRestrictions);
      prefs.setStringList('preferences', selectedPrefs);
    });
  }

  // Load preferences on load
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedCuisine = prefs.getStringList('cuisines') ?? [];
      selectedRestrictions = prefs.getStringList('restrictions') ?? [];
      selectedPrefs = prefs.getStringList('preferences') ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Input Preferences'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListTile(
                        leading:
                            const Icon(Icons.abc_rounded), // ListTile Icons
                        title: const Text('Enter Food Preferences'),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                        onTap: () => _showMultiSelect(prefOptions, 1),
                        selected: true,
                        enabled: true,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 2),
                          borderRadius: BorderRadius.circular(20),
                        )),
                  ),
                  // display selected items
                  Wrap(
                    spacing: 10,
                    children: selectedPrefs
                        .map((e) => Chip(
                              label: Text(e),
                            ))
                        .toList(),
                  ),
                  const Divider(
                    color: Colors.black,
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListTile(
                        leading:
                            const Icon(Icons.abc_rounded), // ListTile Icons
                        title: const Text('Enter Intolerances Information'),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                        onTap: () => _showMultiSelect(restricOptions, 2),
                        selected: true,
                        enabled: true,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 2),
                          borderRadius: BorderRadius.circular(20),
                        )),
                  ),
                  Wrap(
                    spacing: 10,
                    children: selectedRestrictions
                        .map((e) => Chip(
                              label: Text(e),
                            ))
                        .toList(),
                  ),
                  const Divider(
                    color: Colors.black,
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListTile(
                        leading:
                            const Icon(Icons.abc_rounded), // ListTile Icons
                        title: const Text('Preferred Cuisine'),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                        onTap: () => _showMultiSelect(cuisineOptions, 3),
                        selected: true,
                        enabled: true,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 2),
                          borderRadius: BorderRadius.circular(20),
                        )),
                  ),
                  Wrap(
                    spacing: 10,
                    children: selectedCuisine
                        .map((e) => Chip(
                              label: Text(e),
                            ))
                        .toList(),
                  ),
                  const Divider(
                    color: Colors.black,
                    height: 50,
                  ),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                        onPressed: () {
                          _storePreferences();
                          // var recipeParameters = RecipeParameters();
                          // recipeParameters.cuisine = selectedCuisine;
                          // recipeParameters.diet = selectedPrefs;
                          // recipeParameters.intolerances = selectedRestrictions;
                          Navigator.pop(context);
                        },
                        child: const Text('Submit')),
                  )
                ],
              ),
            ),
          )),
    ));
  }
}
