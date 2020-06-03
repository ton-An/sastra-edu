import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sastra_ebooks/constants.dart';

import 'Services/Responsive/size_config.dart';

/// TextStyles ///
///
/// Headline1
final TextStyle headline1TextStyle = GoogleFonts.montserrat(
  fontSize: 20 * SizeConfig.widthMultiplier,
  fontWeight: FontWeight.w700,
  color: kDarkColor,
);

final TextStyle headline1HighlightTextStyle = headline1TextStyle.copyWith(
  color: Colors.lightBlueAccent,
);

/// Headline2
final TextStyle headline2TextStyle = GoogleFonts.montserrat(
  fontSize: 50,
  fontWeight: FontWeight.w700,
  color: kDarkColor,
);

final TextStyle headline2HighlightTextStyle = headline2TextStyle.copyWith(
  color: kHighlightColor,
);

/// Headline6
final TextStyle headline6TextStyle = GoogleFonts.notoSans(
  fontSize: 16,
  fontWeight: FontWeight.w500,
);

final TextStyle headline6HighlightTextStyle = headline6TextStyle.copyWith(
  color: kHighlightColor,
);

/// Subtitle6
final TextStyle subtitle1TextStyle = GoogleFonts.notoSans(
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

final TextStyle subtitle1HighlightTextStyle = subtitle1TextStyle.copyWith(
  color: kHighlightColor,
);

/// ButtonLabel
final TextStyle buttonLabelTextStyle = GoogleFonts.notoSans(
  fontWeight: FontWeight.w700,
  fontSize: 20,
  color: Colors.white,
);
