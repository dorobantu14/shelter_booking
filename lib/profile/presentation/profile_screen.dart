import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelter_booking/app/app_router.dart';
import 'package:shelter_booking/core/core.dart';
import 'package:shelter_booking/core/functions/file_picker_service.dart';
import 'package:shelter_booking/shelters_screen/entity/shelter_entity.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? username;
  List<ShelterEntity> bookedShelters = [];

  @override
  void initState() {
    super.initState();
    getUsername();
    getBookedShelters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: username != null
            ? Text(
                '$username\'s Profile',
                style: TextStyles.boldTitleTextStyle.copyWith(fontSize: 42),
              )
            : const SizedBox.shrink(),
        automaticallyImplyLeading: false,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              prefs.setBool(Strings.isLoggedInText, false);
            },
            icon: Icon(
              Icons.logout,
              size: 32,
              color: AppColors.grey.withOpacity(0.6),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, top: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booked Shelters:',
              style: TextStyles.boldGreyTextStyle.copyWith(
                fontSize: 32,
                color: AppColors.grey.withOpacity(0.4),
              ),
            ),
            if (bookedShelters.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 42),
                child: SpinKitFadingCube(
                  duration: Duration(milliseconds: 800),
                  color: AppColors.blue,
                  size: 40.0,
                ),
              ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 12),
                itemBuilder: (context, index) {
                  return _buildShelterItem(bookedShelters, index);
                },
                itemCount: bookedShelters.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShelterItem(List<ShelterEntity> sheltersList, int index) {
    return GestureDetector(
      onTap: () {
        context.router.push(
          MapRoute(
            selectedShelter: sheltersList[index],
            context: context,
          ),
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                _getShelterIcon(sheltersList, index),
                _getShelterDetails(sheltersList, index),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Divider(
              color: AppColors.lightGrey.withOpacity(0.2),
            ),
          )
        ],
      ),
    );
  }

  Widget _getShelterIcon(List<ShelterEntity> sheltersList, int index) {
    return Container(
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Center(
          child: sheltersList[index].tip == 'privat'
              ? const Icon(Icons.privacy_tip_outlined)
              : const Icon(Icons.people_alt_outlined)),
    );
  }

  Widget _getShelterDetails(List<ShelterEntity> sheltersList, int index) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getShelterAddress(sheltersList[index]),
            Row(
              children: [
                const Text('Available places: '),
                Text(
                  '${sheltersList[index].capacitate}',
                  style: const TextStyle(color: Colors.green),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getShelterAddress(ShelterEntity shelter) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.location_on_outlined,
          color: AppColors.lightGrey.withOpacity(0.5),
          size: 20,
        ),
        Expanded(
          child: Text(
            '${shelter.localitate}, ${shelter.adresa}',
          ),
        ),
      ],
    );
  }

  void getUsername() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final firebaseReference = FirebaseDatabase.instance.ref().child('users');
    firebaseReference.child(userId).get().then((DataSnapshot snapshot) {
      final Map<String, dynamic> values =
          convertMap(snapshot.value as Map<Object?, Object?>);
      final String username = values['name'];
      setState(() {
        this.username = username;
      });
    });
  }

  Future<void> getBookedShelters() async {
    final FilePickerService filePickerService = FilePickerService();

    final sheltersListCsv = await filePickerService.loadCsvData();
    final List<ShelterEntity> updatedShelters = sheltersListCsv.map(
      (e) {
        final json = {
          'localitate': e['localitate'],
          'adresa': e['adresa'],
          'tip': e['tip'],
          'latitudine': e['latitudine'] is double
              ? e['latitudine']
              : double.parse(e['latitudine'].replaceAll(',', '.')),
          'longitudine': e['latitudine'] is double
              ? e['latitudine']
              : double.parse(e['latitudine'].replaceAll(',', '.')),
          'capacitate': e['capacitate'],
        };
        return ShelterEntity.fromJson(json);
      },
    ).toList();

    final DatabaseReference usersReference =
        FirebaseDatabase.instance.ref().child('users');
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final response =
        await usersReference.child(userId!).child('bookedShelters').get();
    if (response.value != null) {
      final List<dynamic> bookedSheltersList = response.value as List<dynamic>;
      final List<ShelterEntity> bookedShelters = bookedSheltersList.map((e) {
        return ShelterEntity.fromJson(convertMap(e as Map<Object?, Object?>));
      }).toList();
      setState(() {
        this.bookedShelters = updatedShelters
            .where(
              (element) => bookedShelters
                  .map((e) => e.adresa)
                  .toList()
                  .contains(element.adresa),
            )
            .toList();
      });
    } else {
      setState(() {
        bookedShelters = [];
      });
    }
  }
}
