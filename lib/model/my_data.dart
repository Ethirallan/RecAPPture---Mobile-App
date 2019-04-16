class MyData {
  static List<String> photoList = [
    '',
    '',
    '',
  ];

  static List<String> imgBackList = [
    'assets/photo1.png',
    'assets/photo2.png',
    'assets/photo3.png',
  ];

  static String location;
  static double lat;
  static double lng;
  static int quantity;
  static int woodType;
  static int quiz1;
  static int quiz2;
  static int quiz3;
  static String phone;
  static String email;

  static int userId;
  static int orderId;

  static void printData() {
    print('loc: ' + location);
    print('lat: ' + lat.toString());
    print('lng: ' + lng.toString());
    print('quan: ' + quantity.toString());
    print('type: ' + woodType.toString());
    print('q1 ' + quiz1.toString());
    print('q2: ' + quiz2.toString());
    print('q3: ' + quiz3.toString());
    print('phone: ' + phone);
    print('mail: ' + email);
  }
}