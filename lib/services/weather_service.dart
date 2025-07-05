import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class WeatherService {
  final String _apiKey = '9ca0acc2daf3ddfe23a0cdefdff9e30a'; // API Key Anda
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>> getWeather() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Servis lokasi tidak aktif.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Izin lokasi ditolak oleh pengguna.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Izin lokasi ditolak permanen, buka pengaturan aplikasi.');
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final url = '$_baseUrl?lat=${position.latitude}&lon=${position.longitude}&appid=$_apiKey&units=metric&lang=id';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Ambil deskripsi dan buat huruf pertamanya kapital
      String description = data['weather'][0]['description'];
      String capitalizedDescription = description[0].toUpperCase() + description.substring(1);

      // PERUBAHAN DI SINI: kirim 'description'
      return {
        'city': data['name'],
        'temp': data['main']['temp'].round(),
        'description': capitalizedDescription, // <-- KIRIM DESKRIPSI
      };
    } else {
      final errorBody = jsonDecode(response.body);
      throw Exception('Gagal memuat data cuaca: ${errorBody['message']}');
    }
  }
}