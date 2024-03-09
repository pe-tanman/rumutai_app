class SportUtilities {
  static sport(String category) {
    if (category.contains('k')){
      return 'volleyball';
    }
    else if (category == '2d' || category == '1j'){
      return 'basketball';
    }
    else if (category == '2j'){
      return 'dodgeball';
    }
    else if (category == '1d'){
      return 'futsal';
    }
    return '';
  }
}
