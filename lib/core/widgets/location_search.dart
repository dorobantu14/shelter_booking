import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shelter_booking/core/core.dart';

class LocationSearch extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final Widget? prefixIcon;
  final Color? fillColor;
  final double borderRadius;
  final Color? borderColor;
  final bool? hasShadow;
  final Function(String)? onTap;

  const LocationSearch({
    super.key,
    required this.controller,
    required this.hint,
    this.prefixIcon,
    this.fillColor,
    required this.borderRadius,
    this.borderColor,
    this.hasShadow,
    this.onTap,
  });

  @override
  State<LocationSearch> createState() => _LocationSearchState();
}

class _LocationSearchState extends State<LocationSearch> {
  List<dynamic> suggestionsList = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.controller.value.text != ''
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color:
                  widget.controller.value.text != '' ? AppColors.white : null,
            )
          : const BoxDecoration(),
      child: Column(
        children: [
          getSearchField(),
          if (widget.controller.value.text != '') getSuggestionsList(),
        ],
      ),
    );
  }

  Widget getSuggestionsList() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.white,
      ),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: suggestionsList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (widget.controller.value.text.isNotEmpty) {
                widget.onTap!(suggestionsList[index]);
                setState(() {
                  widget.controller.clear();
                  suggestionsList = [];
                });
              }
            },
            child: getLocationItem(index),
          );
        },
      ),
    );
  }

  Widget getLocationItem(int index) {
    return Column(
      children: [
        if (index != 0) getDivider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              getLocationIcon(),
              getLocationName(index),
            ],
          ),
        ),
        if (index == suggestionsList.length - 1) const SizedBox(height: 8),
      ],
    );
  }

  Widget getDivider() {
    return Divider(
      color: AppColors.lightGrey.withOpacity(0.3),
      thickness: 1,
    );
  }

  Widget getLocationIcon() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Icon(Icons.location_on_outlined),
    );
  }

  Widget getLocationName(int index) {
    return Expanded(
      child: Text(
        suggestionsList[index],
        style: TextStyles.normalGreyTextStyle,
      ),
    );
  }

  Widget getSearchField() {
    return AppTextField(
      borderRadius: 16,
      hintText: widget.hint,
      controller: widget.controller,
      onChanged: getSuggestions,
      prefixIcon: widget.prefixIcon,
      fillColor: widget.fillColor,
      borderColor: widget.borderColor,
      suffixIcon: getSuffixIcon(),
    );
  }

  Widget getSuffixIcon() {
    return Visibility(
      visible: widget.controller.text != '',
      child: GestureDetector(
        child: const Icon(
          Icons.close,
          size: 24,
        ),
        onTap: () {
          widget.controller.clear();
          setState(() {
            suggestionsList = [];
          });
        },
      ),
    );
  }

  void getSuggestions(location) async {
    http.Response response;

    response = await http.get(
      Uri.parse(
          "https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/suggest?token=AAPK0c541817ab564851bc8357710d6f7af54Wf1-bhKEqQ82lnwt5UUPcZBytYIUOB6crHo0q9cQrojImLFwWMdf3qHDXZ4MAYf&f=pjson&text=$location"),
    );
    List<dynamic> suggestions = jsonDecode(response.body)['suggestions'];
    setState(() {
      suggestionsList =
          suggestions.take(4).map((e) => e['text']).toList();
    });
  }
}
