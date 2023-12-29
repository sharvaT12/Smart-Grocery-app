import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:smart_grocery_app/models/recipe_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'models/recipe.dart';
import 'models/recipe_parameters.dart';
import 'models/recipe_plan.dart';
import 'services/api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<RecipeInfo> getRecipeInfo(id, includeNutrition) async {
  RecipeInfo recipeInfo =
      await APIService.instance.getRecipeInfo(id, includeNutrition);
  return recipeInfo;
}

Future<RecipePlan> searchRecipes(recipeParameters) async {
  RecipePlan recipePlan =
      await APIService.instance.getRecipes(recipeParameters: recipeParameters);
  return recipePlan;
}

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  late Future<RecipePlan> recipePlan;
  late Future<RecipePlan> _newRecipePlan;
  late Future<RecipeInfo> recipeInfo;
  late RecipeInfo _recipeInfo;
  RecipeParameters? recipeParameters;
  final querycontroller = TextEditingController();
  late List<String>? _cuisines;
  late List<String>? _restrictions;
  late List<String>? _preferences;

  _buildRecipeCard(Recipe recipe, int index, Size deviceData) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CachedNetworkImage(
          height: deviceData.height * 0.25,
          width: deviceData.width * 0.25,
          fit: BoxFit.contain,
          imageUrl: recipe.imageUrl,
        ),
        //
        // Container does NOT work well for displaying the text.
        // The border only goes as far as the text goes.
        //
        // Container(
        //   padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        //   decoration: const BoxDecoration(
        //     border: Border(
        //       left: BorderSide(color: Color.fromARGB(255, 218, 218, 218)),
        //       right: BorderSide(color: Color.fromARGB(255, 218, 218, 218)),
        //       bottom: BorderSide(color: Color.fromARGB(255, 218, 218, 218)),
        //     ),
        //   ),
        //   height: deviceData.height * 0.2,
        //   child:
        // ),
        SizedBox(
          height: deviceData.height * 0.05,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: (recipe.title),
                    // softWrap: true,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.clip,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        try {
                          _recipeInfo = await APIService.instance
                              .getRecipeInfo(recipe.id, false);
                          var url = _recipeInfo.sourceUrl;
                          if (url.isNotEmpty) {
                            Uri _url = Uri.parse(_recipeInfo.sourceUrl);
                            if (await canLaunchUrl(_url)) {
                              await launchUrl(_url);
                            } else {
                              throw "Cannot launch $url";
                            }
                          }
                        } on SocketException catch (_) {
                          throw 'could not launch url';
                        }
                      },
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  _buildGridView(RecipePlan recipePlan, Size deviceData) {
    // late Future<RecipeInfos> recipe_infos;
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.0,
        crossAxisSpacing: 20,
        mainAxisSpacing: 100,
      ),
      padding: EdgeInsets.symmetric(horizontal: deviceData.width * 0.1),
      itemCount: recipePlan.recipes.length,
      itemBuilder: (BuildContext context, int index) {
        Recipe recipe = recipePlan.recipes[index];
        return _buildRecipeCard(recipe, index, deviceData);
        // return _buildRecipeCardFuture(recipe, index);
      },
    );
  }

  searchQuery() {
    setState(() {
      recipePlan = _newRecipePlan;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceData = MediaQuery.of(context).size;
    return ListView(
      shrinkWrap: true,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 35),
            const Text(
              "Recipes",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 35),
            SizedBox(
              width: deviceData.width * 0.35,
              child: TextField(
                onSubmitted: ((String value) {
                  if (querycontroller.value.text.isNotEmpty) {
                    recipeParameters!.query = value;
                    _newRecipePlan = searchRecipes(recipeParameters);
                    searchQuery();
                  }
                }),
                controller: querycontroller,
                obscureText: false,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  hintText: "Search for a recipe...",
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 35),
        FutureBuilder<RecipePlan>(
          future: recipePlan,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _buildGridView(snapshot.data!, deviceData);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
        const SizedBox(height: 35),
      ],
    );
  }

  // Load preferences on load
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      recipeParameters!.cuisine = prefs.getStringList('cuisines') ?? [];
      recipeParameters!.intolerances =
          prefs.getStringList('restrictions') ?? [];
      recipeParameters!.diet = prefs.getStringList('preferences') ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    recipeParameters = RecipeParameters();
    _loadPreferences();
    recipePlan = searchRecipes(recipeParameters);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    querycontroller.dispose();
    super.dispose();
  }
}
