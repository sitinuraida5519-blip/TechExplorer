import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const TechExplorerApp();
  }
}

// ============================================================
// WARNA APLIKASI
// ============================================================

const Color primaryColor = Color(0xFF1565C0);
const Color darkBlue = Color(0xFF0D47A1);
const Color lightBlue = Color(0xFFE3F2FD);
const Color backgroundColor = Color(0xFFF5F8FC);

// ============================================================
// MODEL MATERI
// ============================================================

class MaterialData {
  String title;
  String category;
  String description;
  String content;
  String importantPoints;
  IconData icon;

  MaterialData({
    required this.title,
    required this.category,
    required this.description,
    required this.content,
    required this.importantPoints,
    required this.icon,
  });
}

// ============================================================
// MODEL SOAL
// ============================================================

class QuizQuestion {
  String question;
  List<String> options;
  int correctAnswer;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}

// ============================================================
// DATA MATERI TECH EXPLORER
// ============================================================

List<MaterialData> materials = [
  MaterialData(
    title: 'Pengertian Komputer',
    category: 'Computer Basics',
    description:
        'Komputer adalah mesin elektronik yang menerima data, mengolahnya, dan menghasilkan informasi yang berguna bagi manusia.',
    content:
        'Komputer adalah perangkat elektronik yang digunakan untuk menerima data, mengolahnya, menyimpannya, dan menghasilkan informasi. Proses kerja komputer secara umum terdiri dari input, process, output, dan storage.\n\n'
        'Pada tahap input, pengguna memasukkan data melalui keyboard, mouse, scanner, atau perangkat masukan lainnya. Data kemudian diproses oleh processor sesuai instruksi program. Hasil pengolahan ditampilkan pada monitor, speaker, atau dicetak melalui printer. Setelah itu, data dapat disimpan dalam media penyimpanan seperti HDD, SSD, atau flash drive.\n\n'
        'Contoh penggunaan komputer adalah mengetik dokumen, mengolah angka, browsing internet, membuat presentasi, dan mengedit gambar. Manfaat komputer sangat luas, mulai dari pendidikan, pekerjaan, komunikasi, hingga hiburan. Dengan komputer, manusia dapat menyelesaikan pekerjaan lebih cepat, akurat, dan efisien.',
    importantPoints:
        '• Input adalah proses memasukkan data.\n'
        '• Process dilakukan oleh processor.\n'
        '• Output adalah hasil informasi yang ditampilkan.\n'
        '• Storage digunakan untuk menyimpan data.\n'
        '• Komputer membantu pekerjaan, belajar, dan komunikasi.',
    icon: Icons.computer,
  ),

  MaterialData(
    title: 'Sistem Komputer',
    category: 'Computer Basics',
    description:
        'Sistem komputer terdiri dari perangkat keras, perangkat lunak, dan pengguna yang saling bekerja sama.',
    content:
        'Sistem komputer merupakan gabungan dari perangkat keras (hardware), perangkat lunak (software), dan pengguna (brainware) yang bekerja bersama untuk menjalankan proses komputasi. Hardware adalah komponen fisik seperti monitor, keyboard, mouse, CPU, dan printer. Software adalah program yang mengendalikan kerja komputer, seperti sistem operasi, Microsoft Word, dan browser. Brainware adalah manusia yang menggunakan komputer untuk menjalankan tugas tertentu.\n\n'
        'Contoh sistem komputer dapat dilihat saat seseorang membuka aplikasi belajar, mengetik tugas, dan menyimpannya ke hard disk. Ketiga komponen ini saling bergantung: hardware menyediakan alat, software memberi perintah, dan brainware mengoperasikan sistem. Manfaat sistem komputer adalah memudahkan manusia dalam mengelola, memproses, dan menyimpan data dengan cepat dan akurat.',
    importantPoints:
        '• Hardware adalah perangkat fisik komputer.\n'
        '• Software adalah program dan aplikasi.\n'
        '• Brainware adalah manusia pengguna komputer.\n'
        '• Ketiga komponen saling berhubungan.\n'
        '• Sistem komputer membantu pekerjaan lebih efisien.',
    icon: Icons.devices,
  ),

  MaterialData(
    title: 'Motherboard',
    category: 'Hardware',
    description:
        'Motherboard adalah papan utama yang menjadi pusat hubungan semua komponen komputer.',
    content:
        'Motherboard atau papan induk adalah komponen utama pada komputer yang menjadi tempat pemasangan processor, RAM, kartu grafis, kartu jaringan, media penyimpanan, dan perangkat lain. Motherboard berfungsi sebagai pusat penghubung dan koordinasi kerja semua komponen agar komputer dapat berjalan dengan baik.\n\n'
        'Pada motherboard terdapat socket processor, slot RAM, slot ekspansi, konektor daya, dan port USB. Semua komponen terhubung melalui jalur elektronik pada motherboard. Contoh perangkat yang terhubung adalah CPU, RAM, SSD, keyboard, mouse, dan monitor.\n\n'
        'Manfaat motherboard sangat besar karena tanpa papan induk, komponen-komponen komputer tidak dapat bekerja secara terkoordinasi. Motherboard memungkinkan data dan sinyal listrik mengalir ke seluruh sistem, sehingga komputer dapat melakukan proses pengolahan dan komunikasi antar bagian.',
    importantPoints:
        '• Motherboard adalah papan utama komputer.\n'
        '• Menghubungkan processor, RAM, dan perangkat lain.\n'
        '• Memiliki slot, port, dan konektor.\n'
        '• Menjadi pusat komunikasi antar komponen.\n'
        '• Tanpa motherboard, sistem komputer tidak dapat berfungsi.',
    icon: Icons.developer_board,
  ),

  MaterialData(
    title: 'Processor',
    category: 'Hardware',
    description:
        'Processor adalah otak komputer yang menjalankan instruksi dan mengolah data.',
    content:
        'Processor atau CPU (Central Processing Unit) adalah komponen yang bertanggung jawab untuk menjalankan instruksi dan mengolah data. Processor membaca program, memproses perintah, dan menghasilkan hasil yang dibutuhkan pengguna. Dalam setiap komputer, processor menjadi pusat operasi utama.\n\n'
        'Processor memiliki kecepatan yang diukur dalam GHz dan biasanya dilengkapi beberapa core. Semakin tinggi kecepatan dan jumlah core, semakin cepat komputer dapat menjalankan aplikasi. Contoh penerapannya adalah saat membuka browser, memutar video, atau menjalankan game.\n\n'
        'Manfaat processor sangat penting karena ia menentukan kemampuan komputer dalam menjalankan berbagai program. Processor yang kuat membuat tugas seperti editing video, analisis data, dan simulasi komputer dapat berjalan lebih cepat dan lancar.',
    importantPoints:
        '• Processor adalah otak komputer.\n'
        '• Mengolah instruksi dan data.\n'
        '• Kecepatan processor memengaruhi performa komputer.\n'
        '• Memiliki core untuk menjalankan beberapa tugas.\n'
        '• Processor menentukan kemampuan komputer dalam menjalankan aplikasi.',
    icon: Icons.memory,
  ),

  MaterialData(
    title: 'RAM',
    category: 'Hardware',
    description:
        'RAM adalah memori sementara yang dipakai saat komputer aktif untuk menjalankan program dan data yang sedang dibuka.',
    content:
        'RAM atau Random Access Memory adalah memori yang digunakan untuk menyimpan data dan instruksi sementara ketika komputer sedang aktif. Data di RAM dapat diakses dengan cepat oleh processor saat program sedang berjalan. RAM berfungsi sebagai ruang kerja sementara bagi komputer.\n\n'
        'Saat seseorang membuka browser, Microsoft Word, dan aplikasi musik sekaligus, semua data aktif akan disimpan sementara di RAM. Semakin besar kapasitas RAM, semakin banyak aplikasi yang dapat dijalankan tanpa terasa lambat. Namun, RAM bersifat sementara, sehingga data di dalamnya akan hilang saat komputer dimatikan atau di-restart.\n\n'
        'Manfaat RAM adalah mempercepat akses data dan meningkatkan kemampuan multitasking. Dengan RAM yang cukup besar, user dapat bekerja lebih nyaman dan aplikasi dapat berjalan dengan cepat.',
    importantPoints:
        '• RAM adalah memori sementara.\n'
        '• Dipakai saat komputer aktif.\n'
        '• Menyimpan data program yang sedang dibuka.\n'
        '• Data RAM hilang saat komputer dimatikan.\n'
        '• Kapasitas RAM memengaruhi kecepatan multitasking.',
    icon: Icons.storage,
  ),

  MaterialData(
    title: 'Hard Disk dan SSD',
    category: 'Hardware',
    description:
        'Hard disk dan SSD adalah media penyimpanan utama yang digunakan untuk menyimpan data, aplikasi, dan sistem operasi.',
    content:
        'Hard Disk Drive (HDD) dan Solid State Drive (SSD) adalah perangkat penyimpanan data yang berfungsi menyimpan sistem operasi, aplikasi, file, foto, video, dan dokumen. HDD menggunakan piringan magnetik, sedangkan SSD menggunakan chip flash memory. Kedua perangkat ini memiliki fungsi yang sama, yaitu menyimpan data dalam jangka waktu lama.\n\n'
        'Contohnya, sistem operasi Windows atau Linux biasanya berada dalam SSD atau HDD, sedangkan file tugas sekolah, foto keluarga, dan permainan digital juga tersimpan di sana. SSD umumnya lebih cepat, lebih ringan, dan lebih tahan guncangan dibanding HDD.\n\n'
        'Manfaat media penyimpanan adalah memungkinkan data disimpan secara permanen dan dibuka kembali saat dibutuhkan. Dengan penyimpanan yang baik, komputer dapat menyimpan banyak file dan menjalankan aplikasi tanpa kehilangan data.',
    importantPoints:
        '• HDD menggunakan piringan magnetik.\n'
        '• SSD menggunakan flash memory.\n'
        '• Keduanya menyimpan data jangka panjang.\n'
        '• SSD biasanya lebih cepat dari HDD.\n'
        '• Menyimpan OS, aplikasi, dan file penting.',
    icon: Icons.storage,
  ),

  MaterialData(
    title: 'Sistem Operasi',
    category: 'Software',
    description:
        'Sistem operasi adalah perangkat lunak yang mengelola sumber daya komputer dan menjadi penghubung antara pengguna dan hardware.',
    content:
        'Sistem operasi (Operating System) adalah perangkat lunak yang mengelola sumber daya komputer dan bekerja sebagai penghubung antara pengguna, aplikasi, dan perangkat keras. Fungsi utamanya adalah mengatur penggunaan CPU, RAM, penyimpanan, perangkat input-output, serta menjalankan program.\n\n'
        'Contoh sistem operasi adalah Windows, Linux, dan macOS. Saat pengguna membuka aplikasi seperti browser atau Microsoft Word, sistem operasi mengatur bagaimana aplikasi tersebut berjalan dan menggunakan sumber daya komputer. Sistem operasi juga mengelola file, folder, dan memory, serta menjaga agar komputer bisa berjalan dengan tertib.\n\n'
        'Manfaat sistem operasi adalah membuat komputer mudah digunakan, aman, dan terorganisir. Tanpa sistem operasi, komputer tidak akan bisa menjalankan program dan tugas-tugas sehari-hari menjadi sulit dilakukan.',
    importantPoints:
        '• Sistem operasi mengatur hardware dan software.\n'
        '• Menjadi penghubung user dengan komputer.\n'
        '• Mengelola file, memori, dan proses aplikasi.\n'
        '• Contoh: Windows, Linux, macOS.\n'
        '• Membuat komputer mudah digunakan dan aman.',
    icon: Icons.desktop_windows,
  ),

  MaterialData(
    title: 'Driver',
    category: 'Software',
    description:
        'Driver adalah perangkat lunak yang memungkinkan sistem operasi berkomunikasi dengan perangkat keras tertentu.',
    content:
        'Driver adalah program khusus yang memungkinkan sistem operasi mengenali dan mengendalikan perangkat keras tertentu. Tanpa driver, perangkat seperti printer, kartu grafis, Wi-Fi, dan scanner tidak dapat berfungsi dengan baik. Driver berperan sebagai penerjemah antara hardware dan software.\n\n'
        'Contoh driver adalah driver printer untuk kegiatan cetak, driver kartu grafis untuk menampilkan gambar di monitor, dan driver jaringan untuk menghubungkan komputer ke internet. Jika driver tidak sesuai atau rusak, perangkat mungkin tidak terdeteksi atau tampil error.\n\n'
        'Manfaat driver adalah memastikan perangkat keras bisa berfungsi normal dan kompatibel dengan sistem operasi. Dengan driver yang tepat, user dapat bekerja dengan komputer secara optimal dan stabil.',
    importantPoints:
        '• Driver menghubungkan software dengan hardware.\n'
        '• Membuat hardware bisa dikenali sistem operasi.\n'
        '• Contoh: driver printer, VGA, Wi-Fi.\n'
        '• Driver harus sesuai dengan perangkat.\n'
        '• Tanpa driver, hardware tidak bekerja maksimal.',
    icon: Icons.settings_applications,
  ),

  MaterialData(
    title: 'Jaringan Komputer',
    category: 'Networking',
    description:
        'Jaringan komputer adalah hubungan antara beberapa perangkat yang memungkinkan komunikasi dan berbagi sumber daya.',
    content:
        'Jaringan komputer adalah kumpulan perangkat yang saling terhubung agar dapat bertukar data dan berbagi sumber daya. Perangkat yang terhubung bisa berupa komputer, laptop, printer, server, dan smartphone. Jaringan dapat dibuat dengan kabel maupun tanpa kabel.\n\n'
        'Contoh jaringan komputer adalah Wi-Fi di rumah, jaringan komputer di sekolah, dan internet yang menghubungkan seluruh dunia. Dalam jaringan, data dikirim dalam bentuk paket dan diterima oleh perangkat tujuan.\n\n'
        'Manfaat jaringan komputer adalah memudahkan komunikasi, berbagi file, menggunakan printer bersama, dan mengakses internet. Jaringan juga membantu kerja tim karena data dapat dibagikan secara cepat dan mudah.',
    importantPoints:
        '• Jaringan menghubungkan beberapa perangkat.\n'
        '• Memungkinkan pertukaran data.\n'
        '• Bisa menggunakan kabel atau nirkabel.\n'
        '• Mempermudah berbagi sumber daya.\n'
        '• Jaringan memungkinkan internet dan komunikasi.',
    icon: Icons.lan,
  ),

  MaterialData(
    title: 'LAN, MAN, dan WAN',
    category: 'Networking',
    description:
        'Jenis jaringan dibedakan berdasarkan jangkauan wilayahnya: LAN, MAN, dan WAN.',
    content:
        'LAN (Local Area Network) adalah jaringan yang mencakup wilayah kecil seperti rumah, kantor, atau laboratorium komputer. Jaringan ini biasanya menghubungkan beberapa komputer yang berdekatan.\n\n'
        'MAN (Metropolitan Area Network) memiliki cakupan yang lebih luas, biasanya mencakup kota atau kampus besar. WAN (Wide Area Network) adalah jaringan dengan cakupan yang sangat luas, bahkan bisa menghubungkan antar negara. Contoh WAN adalah internet.\n\n'
        'Contoh LAN adalah jaringan komputer di sekolah, contoh MAN adalah jaringan antara gedung di satu kota, dan contoh WAN adalah internet global. Manfaat memahami jenis-jenis jaringan adalah untuk menentukan desain yang sesuai dengan kebutuhan pengguna serta memudahkan pengelolaan jaringan.',
    importantPoints:
        '• LAN: cakupan kecil seperti rumah atau sekolah.\n'
        '• MAN: cakupan kota atau kampus.\n'
        '• WAN: cakupan luas seperti internet.\n'
        '• Perbedaannya berdasarkan luas wilayah.\n'
        '• Jenis jaringan dipilih sesuai kebutuhan.',
    icon: Icons.account_tree,
  ),

  MaterialData(
    title: 'IP Address',
    category: 'Networking',
    description:
        'IP Address adalah alamat unik yang digunakan untuk mengidentifikasi perangkat dalam jaringan.',
    content:
        'IP Address atau alamat IP adalah identitas numerik yang diberikan kepada perangkat agar dapat dikenal dalam jaringan. Setiap komputer, smartphone, router, atau server mempunyai IP untuk memastikan data dikirim ke perangkat yang benar.\n\n'
        'Pada IPv4, alamat IP ditulis dalam empat blok angka desimal seperti 192.168.1.10. IP Address dapat diberikan secara manual atau otomatis menggunakan DHCP. Selain IP, jaringan juga memerlukan subnet mask, gateway, dan DNS agar komunikasi berjalan dengan baik.\n\n'
        'Contoh penggunaan IP Address adalah laptop yang mendapat alamat 192.168.0.5 agar dapat terhubung ke router dan internet. Manfaat utama IP Address adalah memastikan data sampai ke tujuan yang tepat dalam jaringan besar seperti internet.',
    importantPoints:
        '• IP Address adalah identitas perangkat dalam jaringan.\n'
        '• IPv4 bentuknya seperti 192.168.1.10.\n'
        '• Dapat diatur manual atau otomatis.\n'
        '• Digunakan agar data sampai ke perangkat tujuan.\n'
        '• Memungkinkan komunikasi antar perangkat di jaringan.',
    icon: Icons.language,
  ),

  MaterialData(
    title: 'Topologi Jaringan',
    category: 'Networking',
    description:
        'Topologi jaringan menggambarkan bentuk hubungan antarperangkat dalam suatu jaringan.',
    content:
        'Topologi jaringan adalah pola atau bentuk hubungan antarperangkat dalam sebuah jaringan komputer. Topologi menjelaskan bagaimana komputer, switch, router, dan perangkat lain terhubung satu sama lain.\n\n'
        'Beberapa topologi yang umum adalah bus, star, ring, mesh, dan tree. Topologi star sering digunakan di sekolah dan kantor karena semua perangkat terhubung ke satu titik pusat seperti switch. Topologi bus menggunakan jalur utama, sedangkan mesh memiliki banyak jalur koneksi antar perangkat.\n\n'
        'Manfaat mempelajari topologi jaringan adalah memahami cara kerja jaringan, menentukan desain yang tepat, dan memperbaiki masalah saat gangguan terjadi. Dengan topologi yang tepat, jaringan dapat lebih stabil, mudah dikelola, dan efisien.',
    importantPoints:
        '• Topologi menunjukkan pola hubungan perangkat.\n'
        '• Star menggunakan perangkat pusat.\n'
        '• Bus menggunakan jalur utama bersama.\n'
        '• Setiap topologi memiliki kelebihan dan kekurangan.\n'
        '• Topologi penting untuk desain jaringan yang baik.',
    icon: Icons.hub,
  ),

  MaterialData(
    title: 'Router',
    category: 'Network Devices',
    description:
        'Router adalah perangkat yang menghubungkan jaringan yang berbeda dan meneruskan data ke tujuan yang tepat.',
    content:
        'Router adalah perangkat jaringan yang berfungsi menghubungkan beberapa jaringan menjadi satu sistem. Router bekerja dengan meneruskan paket data berdasarkan alamat tujuan agar data sampai ke jaringan yang benar.\n\n'
        'Router sering digunakan untuk menghubungkan jaringan lokal dengan internet. Dalam rumah atau sekolah, router memungkinkan komputer, laptop, dan smartphone terhubung ke internet dan berbagi koneksi. Router juga dapat memilih jalur terbaik agar data dikirim dengan cepat dan efisien.\n\n'
        'Contoh penerapannya adalah router Wi-Fi rumah yang menghubungkan perangkat ke internet. Manfaat router adalah memungkinkan banyak perangkat terhubung sekaligus, bekerja dalam jaringan lokal, dan melakukan akses internet dengan satu sambungan utama.',
    importantPoints:
        '• Router menghubungkan jaringan yang berbeda.\n'
        '• Meneruskan paket data berdasarkan tujuan.\n'
        '• Sering dipakai untuk akses internet.\n'
        '• Menetapkan jalur terbaik untuk data.\n'
        '• Menghubungkan LAN dengan internet.',
    icon: Icons.router,
  ),

  MaterialData(
    title: 'Switch',
    category: 'Network Devices',
    description:
        'Switch adalah perangkat jaringan yang menghubungkan banyak perangkat dalam satu jaringan lokal secara lebih efisien.',
    content:
        'Switch adalah perangkat jaringan yang berfungsi menghubungkan beberapa perangkat dalam satu jaringan lokal, seperti komputer, printer, server, dan laptop. Switch bekerja dengan meneruskan data berdasarkan alamat MAC, sehingga pengiriman data lebih cepat dan lebih tepat sasaran.\n\n'
        'Dalam jaringan LAN, switch sangat penting karena memungkinkan perangkat untuk bertukar informasi dengan lancar dalam area yang sama. Switch biasanya memiliki beberapa port sehingga banyak perangkat dapat terhubung sekaligus.\n\n'
        'Contoh penggunaannya adalah di laboratorium komputer sekolah, dimana semua komputer terhubung ke switch. Manfaat switch adalah membuat komunikasi antar perangkat dalam jaringan lokal menjadi lebih efektif, stabil, dan cepat dibandingkan hanya menggunakan hub.',
    importantPoints:
        '• Switch menghubungkan perangkat dalam LAN.\n'
        '• Meneruskan data berdasarkan alamat MAC.\n'
        '• Memiliki banyak port.\n'
        '• Digunakan dalam satu jaringan lokal.\n'
        '• Meningkatkan efisiensi komunikasi jaringan.',
    icon: Icons.swap_horiz,
  ),

  MaterialData(
    title: 'Access Point',
    category: 'Network Devices',
    description:
        'Access Point adalah perangkat yang menyediakan koneksi nirkabel agar perangkat dapat terhubung ke jaringan Wi-Fi.',
    content:
        'Access Point (AP) adalah perangkat jaringan yang menyediakan akses nirkabel menggunakan teknologi Wi-Fi. AP biasanya terhubung ke router atau switch melalui kabel, lalu menyebarkan sinyal Wi-Fi ke perangkat seperti laptop, smartphone, dan tablet.\n\n'
        'Contoh penggunaannya dapat ditemukan di sekolah, kantor, cafe, rumah, dan area publik. Banyak perangkat dapat terhubung ke jaringan tanpa perlu kabel. AP membantu mobilitas pengguna karena mereka bisa bergerak di area jangkauan Wi-Fi sambil tetap terhubung ke jaringan.\n\n'
        'Manfaat Access Point adalah memudahkan akses internet secara nirkabel, meningkatkan kenyamanan pengguna, dan memungkinkan banyak perangkat terhubung ke jaringan dengan cepat dan praktis.',
    importantPoints:
        '• Access Point menyediakan koneksi Wi-Fi.\n'
        '• Menghubungkan perangkat wireless ke jaringan.\n'
        '• Biasanya terhubung ke router atau switch.\n'
        '• Memudahkan akses internet secara nirkabel.\n'
        '• Digunakan di sekolah, kantor, dan rumah.',
    icon: Icons.wifi,
  ),

  MaterialData(
    title: 'Troubleshooting Jaringan',
    category: 'Troubleshooting',
    description:
        'Troubleshooting jaringan adalah proses mencari dan memperbaiki gangguan agar jaringan kembali berfungsi normal.',
    content:
        'Troubleshooting jaringan merupakan langkah sistematis untuk menemukan penyebab gangguan pada jaringan komputer lalu memperbaikinya. Gangguan bisa terjadi karena kabel putus, IP tidak sesuai, router rusak, atau sinyal Wi-Fi lemah. Proses ini penting agar jaringan dapat kembali berfungsi seperti semula.\n\n'
        'Langkah umum troubleshooting adalah memeriksa kabel dan port, mengecek status perangkat, menguji koneksi menggunakan ping, memeriksa konfigurasi IP Address, gateway, dan DNS, serta melihat apakah router atau switch berfungsi dengan baik. Contohnya, saat internet tidak bisa diakses, teknisi akan mengecek apakah modem atau router hidup, apakah kabel LAN terhubung, dan apakah perangkat menerima IP yang benar.\n\n'
        'Manfaat troubleshooting adalah menjaga jaringan tetap stabil, mengurangi gangguan, dan memastikan layanan seperti internet, komunikasi, dan berbagi file dapat terus digunakan tanpa hambatan.',
    importantPoints:
        '• Troubleshooting adalah proses mencari penyebab gangguan.\n'
        '• Cek kabel, perangkat, dan konfigurasi jaringan.\n'
        '• Gunakan ping untuk menguji koneksi.\n'
        '• Periksa IP, gateway, dan DNS.\n'
        '• Tujuannya adalah jaringan kembali normal dan stabil.',
    icon: Icons.build,
  ),
];

// ============================================================
// DATA QUIZ
// ============================================================

List<QuizQuestion> quizQuestions = [
  QuizQuestion(
    question:
        'Komponen yang berfungsi sebagai pusat pemrosesan komputer adalah?',
    options: [
      'RAM',
      'Processor',
      'Keyboard',
      'Monitor',
    ],
    correctAnswer: 1,
  ),

  QuizQuestion(
    question: 'Apa fungsi utama RAM?',
    options: [
      'Menyimpan data sementara',
      'Menampilkan gambar',
      'Menghubungkan komputer ke internet',
      'Mencetak dokumen',
    ],
    correctAnswer: 0,
  ),

  QuizQuestion(
    question:
        'Perangkat yang digunakan untuk menghubungkan jaringan yang berbeda adalah?',
    options: [
      'Keyboard',
      'Monitor',
      'Router',
      'Mouse',
    ],
    correctAnswer: 2,
  ),

  QuizQuestion(
    question: 'IP Address digunakan untuk?',
    options: [
      'Mengidentifikasi perangkat dalam jaringan',
      'Menyimpan file',
      'Menampilkan gambar',
      'Menjalankan processor',
    ],
    correctAnswer: 0,
  ),

  QuizQuestion(
    question: 'Sistem operasi termasuk ke dalam jenis?',
    options: [
      'Hardware',
      'Software',
      'Brainware',
      'Network Device',
    ],
    correctAnswer: 1,
  ),

  QuizQuestion(
    question:
        'Perangkat yang banyak digunakan untuk menghubungkan komputer dalam LAN adalah?',
    options: [
      'Switch',
      'Monitor',
      'Printer',
      'Keyboard',
    ],
    correctAnswer: 0,
  ),

  QuizQuestion(
    question: 'Kepanjangan dari LAN adalah?',
    options: [
      'Local Area Network',
      'Large Area Network',
      'Local Access Node',
      'Link Area Network',
    ],
    correctAnswer: 0,
  ),

  QuizQuestion(
    question: 'Perangkat yang menyediakan koneksi Wi-Fi disebut?',
    options: [
      'RAM',
      'Access Point',
      'Processor',
      'Hard Disk',
    ],
    correctAnswer: 1,
  ),

  QuizQuestion(
    question: 'Contoh media penyimpanan adalah?',
    options: [
      'SSD',
      'Keyboard',
      'Monitor',
      'Mouse',
    ],
    correctAnswer: 0,
  ),

  QuizQuestion(
    question:
        'Perintah yang umum digunakan untuk menguji koneksi jaringan adalah?',
    options: [
      'copy',
      'ping',
      'delete',
      'format',
    ],
    correctAnswer: 1,
  ),
];

// ============================================================
// DATA USER
// ============================================================

List<Map<String, String>> users = [
  {
    'name': 'Siswa TKJ',
    'email': 'siswa@gmail.com',
    'password': '123456',
    'class': 'XI TKJ 1',
  },
];

// ============================================================
// DATA HASIL QUIZ
// ============================================================

List<Map<String, dynamic>> quizHistory = [];

// ============================================================
// APP
// ============================================================

class TechExplorerApp extends StatelessWidget {
  const TechExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TechExplorer',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
        ),
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: const SplashScreen(),
    );
  }
}

// ============================================================
// SPLASH SCREEN
// ============================================================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 2),
      () {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginPage(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 105,
              height: 105,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.computer,
                size: 60,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'TechExplorer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Belajar Teknik Komputer dan Jaringan',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 35),

            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// LOGIN PAGE
// ============================================================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  void login() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showMessage('Email dan password harus diisi.');
      return;
    }

    if (email == 'admin@gmail.com' &&
        password == 'admin123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const AdminDashboard(),
        ),
      );

      return;
    }

    final user = users.where(
      (user) =>
          user['email'] == email &&
          user['password'] == password,
    );

    if (user.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(
            userName: user.first['name']!,
            userEmail: user.first['email']!,
          ),
        ),
      );
    } else {
      showMessage('Email atau password salah.');
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const SizedBox(height: 40),

              Container(
                width: 85,
                height: 85,
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(
                  Icons.computer,
                  size: 48,
                  color: primaryColor,
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Selamat Datang',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172B4D),
                ),
              ),
            

              const SizedBox(height: 8),

              const Text(
                'Masuk untuk mulai belajar bersama TechExplorer.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 40),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: inputDecoration(
                  'Email',
                  Icons.email_outlined,
                ),
              ),

              const SizedBox(height: 18),

              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: inputDecoration(
                  'Password',
                  Icons.lock_outline,
                ).copyWith(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword =
                            !obscurePassword;
                      });
                    },
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  const Text(
                    'Belum memiliki akun?',
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const RegisterPage(),
                        ),
                      );
                    },
                    child: const Text('Registrasi'),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(15),
                ),
                child: const Column(
                  children: [
                    Text(
                      'Akun Demo',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Siswa: siswa@gmail.com / 123456',
                    ),
                    Text(
                      'Admin: admin@gmail.com / admin123',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// REGISTER
// ============================================================

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() =>
      _RegisterPageState();
}

class _RegisterPageState
    extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final classController = TextEditingController();
  final passwordController = TextEditingController();

  void register() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final className = classController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        className.isEmpty ||
        password.isEmpty) {
      showMessage('Semua data harus diisi.');
      return;
    }

    final emailExists = users.any(
      (user) => user['email'] == email,
    );

    if (emailExists) {
      showMessage('Email sudah terdaftar.');
      return;
    }

    users.add({
      'name': name,
      'email': email,
      'password': password,
      'class': className,
    });

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Registrasi Berhasil'),
        content: const Text(
          'Akun berhasil dibuat. Silakan login menggunakan akun tersebut.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    classController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrasi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: inputDecoration(
                'Nama Lengkap',
                Icons.person_outline,
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: emailController,
              keyboardType:
                  TextInputType.emailAddress,
              decoration: inputDecoration(
                'Email',
                Icons.email_outlined,
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: classController,
              decoration: inputDecoration(
                'Kelas',
                Icons.school_outlined,
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: inputDecoration(
                'Password',
                Icons.lock_outline,
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: register,
                child: const Text('Daftar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// HOME
// ============================================================

class HomePage extends StatefulWidget {
  final String userName;
  final String userEmail;

  const HomePage({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  Set<String> bookmarks = {};

  int completedMaterials = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      buildHome(),
      LearnPage(
        bookmarks: bookmarks,
        onBookmarkChanged: () {
          setState(() {});
        },
        onMaterialOpened: () {
          setState(() {
            completedMaterials++;
          });
        },
      ),
      QuizPage(
        onQuizFinished: () {
          setState(() {});
        },
      ),
      BookmarkPage(
        bookmarks: bookmarks,
        onBookmarkChanged: () {
          setState(() {});
        },
      ),
      ProfilePage(
        userName: widget.userName,
        email: widget.userEmail,
        completedMaterials: completedMaterials,
      ),
    ];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz_outlined),
            activeIcon: Icon(Icons.quiz),
            label: 'Quiz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            activeIcon: Icon(Icons.bookmark),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget buildHome() {
    final progress =
        materials.isEmpty
            ? 0.0
            : (completedMaterials /
                    materials.length)
                .clamp(0.0, 1.0);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),

            Text(
              'Halo, ${widget.userName}',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172B4D),
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Siap melanjutkan pembelajaran hari ini?',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            TextField(
              readOnly: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const SearchPage(),
                  ),
                );
              },
              decoration: inputDecoration(
                'Cari materi...',
                Icons.search,
              ),
            ),

            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius:
                    BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Progress Belajar',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '${(progress * 100).round()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor:
                          Colors.white30,
                      valueColor:
                          const AlwaysStoppedAnimation<
                              Color>(
                        Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Kategori Materi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            GridView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              itemCount: categoryData.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
              ),
              itemBuilder: (_, index) {
                final category =
                    categoryData[index];

                return InkWell(
                  borderRadius:
                      BorderRadius.circular(18),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CategoryPage(
                          category:
                              category['name']
                                  as String,
                          bookmarks: bookmarks,
                          onBookmarkChanged: () {
                            setState(() {});
                          },
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Icon(
                          category['icon']
                              as IconData,
                          size: 38,
                          color: primaryColor,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          category['name']
                              as String,
                          textAlign:
                              TextAlign.center,
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            const Text(
              'Materi Terbaru',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            ...materials.take(3).map(
              (material) {
                return Card(
                  margin:
                      const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          lightBlue,
                      child: Icon(
                        material.icon,
                        color: primaryColor,
                      ),
                    ),
                    title: Text(
                      material.title,
                    ),
                    subtitle: Text(
                      material.category,
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MaterialDetailPage(
                            material: material,
                            bookmarks: bookmarks,
                            onBookmarkChanged: () {
                              setState(() {});
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// DATA KATEGORI
// ============================================================

final List<Map<String, dynamic>>
    categoryData = [
  {
    'name': 'Computer Basics',
    'icon': Icons.computer,
  },
  {
    'name': 'Hardware',
    'icon': Icons.memory,
  },
  {
    'name': 'Software',
    'icon': Icons.apps,
  },
  {
    'name': 'Networking',
    'icon': Icons.wifi,
  },
  {
    'name': 'Network Devices',
    'icon': Icons.router,
  },
  {
    'name': 'Troubleshooting',
    'icon': Icons.build,
  },
];

// ============================================================
// LEARN PAGE
// ============================================================

class LearnPage extends StatefulWidget {
  final Set<String> bookmarks;
  final VoidCallback onBookmarkChanged;
  final VoidCallback onMaterialOpened;

  const LearnPage({
    super.key,
    required this.bookmarks,
    required this.onBookmarkChanged,
    required this.onMaterialOpened,
  });

  @override
  State<LearnPage> createState() =>
      _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final filtered = materials.where((material) {
      return material.title
              .toLowerCase()
              .contains(search.toLowerCase()) ||
          material.category
              .toLowerCase()
              .contains(search.toLowerCase());
    }).toList();

    return SafeArea(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Padding(
            padding:
                EdgeInsets.fromLTRB(20, 25, 20, 5),
            child: Text(
              'Materi Pembelajaran',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Pelajari materi dasar Teknik Komputer dan Jaringan.',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),

          const SizedBox(height: 15),

          Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  search = value;
                });
              },
              decoration: inputDecoration(
                'Cari materi...',
                Icons.search,
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      'Materi tidak ditemukan.',
                    ),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.all(20),
                    itemCount: filtered.length,
                    itemBuilder: (_, index) {
                      final material =
                          filtered[index];

                      final saved = widget
                          .bookmarks
                          .contains(
                        material.title,
                      );

                      return Card(
                        margin:
                            const EdgeInsets.only(
                          bottom: 12,
                        ),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.all(
                            12,
                          ),
                          leading: CircleAvatar(
                            radius: 28,
                            backgroundColor:
                                lightBlue,
                            child: Icon(
                              material.icon,
                              color: primaryColor,
                            ),
                          ),
                          title: Text(
                            material.title,
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            material.category,
                          ),
                          trailing:
                              IconButton(
                            icon: Icon(
                              saved
                                  ? Icons.bookmark
                                  : Icons
                                      .bookmark_border,
                              color: saved
                                  ? primaryColor
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              if (saved) {
                                widget.bookmarks
                                    .remove(
                                  material.title,
                                );
                              } else {
                                widget.bookmarks
                                    .add(
                                  material.title,
                                );
                              }

                              widget
                                  .onBookmarkChanged();

                              setState(() {});
                            },
                          ),
                          onTap: () {
                            widget
                                .onMaterialOpened();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    MaterialDetailPage(
                                  material:
                                      material,
                                  bookmarks:
                                      widget
                                          .bookmarks,
                                  onBookmarkChanged:
                                      widget
                                          .onBookmarkChanged,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SEARCH PAGE
// ============================================================

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() =>
      _SearchPageState();
}

class _SearchPageState
    extends State<SearchPage> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final result = materials.where((material) {
      return material.title
          .toLowerCase()
          .contains(search.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Materi'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              autofocus: true,
              onChanged: (value) {
                setState(() {
                  search = value;
                });
              },
              decoration: inputDecoration(
                'Masukkan nama materi...',
                Icons.search,
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: result.length,
              itemBuilder: (_, index) {
                final material = result[index];

                return ListTile(
                  leading: Icon(
                    material.icon,
                    color: primaryColor,
                  ),
                  title: Text(
                    material.title,
                  ),
                  subtitle: Text(
                    material.category,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            MaterialDetailPage(
                          material: material,
                          bookmarks: {},
                          onBookmarkChanged: () {},
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CATEGORY PAGE
// ============================================================

class CategoryPage extends StatelessWidget {
  final String category;
  final Set<String> bookmarks;
  final VoidCallback onBookmarkChanged;

  const CategoryPage({
    super.key,
    required this.category,
    required this.bookmarks,
    required this.onBookmarkChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filtered = materials
        .where(
          (material) =>
              material.category == category,
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: filtered.isEmpty
          ? const Center(
              child: Text(
                'Belum ada materi.',
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: filtered.length,
              itemBuilder: (_, index) {
                final material =
                    filtered[index];

                return Card(
                  margin:
                      const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          lightBlue,
                      child: Icon(
                        material.icon,
                        color: primaryColor,
                      ),
                    ),
                    title: Text(
                      material.title,
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      material.description,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MaterialDetailPage(
                            material: material,
                            bookmarks: bookmarks,
                            onBookmarkChanged:
                                onBookmarkChanged,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

// ============================================================
// DETAIL MATERI
// ============================================================

class MaterialDetailPage extends StatefulWidget {
  final MaterialData material;
  final Set<String> bookmarks;
  final VoidCallback onBookmarkChanged;

  const MaterialDetailPage({
    super.key,
    required this.material,
    required this.bookmarks,
    required this.onBookmarkChanged,
  });

  @override
  State<MaterialDetailPage> createState() =>
      _MaterialDetailPageState();
}

class _MaterialDetailPageState
    extends State<MaterialDetailPage> {
  @override
  Widget build(BuildContext context) {
    final saved = widget.bookmarks
        .contains(widget.material.title);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Materi'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (saved) {
                  widget.bookmarks.remove(
                    widget.material.title,
                  );
                } else {
                  widget.bookmarks.add(
                    widget.material.title,
                  );
                }
              });

              widget.onBookmarkChanged();
            },
            icon: Icon(
              saved
                  ? Icons.bookmark
                  : Icons.bookmark_border,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius:
                    BorderRadius.circular(20),
              ),
              child: Icon(
                widget.material.icon,
                size: 90,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 25),

            Text(
              widget.material.category,
              style: const TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              widget.material.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              widget.material.description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Pembahasan',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              widget.material.content,
              style: const TextStyle(
                fontSize: 16,
                height: 1.7,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Poin Penting',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius:
                    BorderRadius.circular(15),
              ),
              child: Text(
                widget.material.importantPoints,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.7,
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const QuizPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.quiz),
                label: const Text(
                  'Kerjakan Quiz',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// BOOKMARK
// ============================================================

class BookmarkPage extends StatelessWidget {
  final Set<String> bookmarks;
  final VoidCallback onBookmarkChanged;

  const BookmarkPage({
    super.key,
    required this.bookmarks,
    required this.onBookmarkChanged,
  });

  @override
  Widget build(BuildContext context) {
    final savedMaterials = materials
        .where(
          (material) =>
              bookmarks.contains(
            material.title,
          ),
        )
        .toList();

    return SafeArea(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Padding(
            padding:
                EdgeInsets.fromLTRB(20, 25, 20, 5),
            child: Text(
              'Bookmark',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Materi yang kamu simpan.',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),

          const SizedBox(height: 15),

          Expanded(
            child: savedMaterials.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bookmark_border,
                          size: 70,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Belum ada materi yang disimpan.',
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.all(20),
                    itemCount:
                        savedMaterials.length,
                    itemBuilder: (_, index) {
                      final material =
                          savedMaterials[index];

                      return Card(
                        child: ListTile(
                          leading: Icon(
                            material.icon,
                            color: primaryColor,
                          ),
                          title: Text(
                            material.title,
                          ),
                          subtitle: Text(
                            material.category,
                          ),
                          trailing:
                              IconButton(
                            icon: const Icon(
                              Icons.bookmark,
                              color: primaryColor,
                            ),
                            onPressed: () {
                              bookmarks.remove(
                                material.title,
                              );

                              onBookmarkChanged();
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    MaterialDetailPage(
                                  material: material,
                                  bookmarks:
                                      bookmarks,
                                  onBookmarkChanged:
                                      onBookmarkChanged,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// QUIZ
// ============================================================

class QuizPage extends StatefulWidget {
  final VoidCallback? onQuizFinished;

  const QuizPage({
    super.key,
    this.onQuizFinished,
  });

  @override
  State<QuizPage> createState() =>
      _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestion = 0;
  int score = 0;
  int? selectedAnswer;

  void chooseAnswer(int answer) {
    setState(() {
      selectedAnswer = answer;
    });
  }

  void nextQuestion() {
    if (selectedAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Pilih jawaban terlebih dahulu.'),
        ),
      );
      return;
    }

    if (selectedAnswer ==
        quizQuestions[currentQuestion]
            .correctAnswer) {
      score++;
    }

    if (currentQuestion <
        quizQuestions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedAnswer = null;
      });
    } else {
      final finalScore =
          ((score / quizQuestions.length) *
                  100)
              .round();

      quizHistory.add({
        'score': finalScore,
        'correct': score,
        'total': quizQuestions.length,
        'date': DateTime.now(),
      });

      widget.onQuizFinished?.call();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizResultPage(
            score: score,
            total: quizQuestions.length,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question =
        quizQuestions[currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz TKJ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              'Soal ${currentQuestion + 1} dari ${quizQuestions.length}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 15),

            LinearProgressIndicator(
              value:
                  (currentQuestion + 1) /
                  quizQuestions.length,
            ),

            const SizedBox(height: 30),

            Text(
              question.question,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 25),

            ...List.generate(
              question.options.length,
              (index) {
                final selected =
                    selectedAnswer == index;

                return Container(
                  margin:
                      const EdgeInsets.only(
                    bottom: 12,
                  ),
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      chooseAnswer(index);
                    },
                    style:
                        OutlinedButton.styleFrom(
                      padding:
                          const EdgeInsets.all(
                        18,
                      ),
                      alignment:
                          Alignment.centerLeft,
                      backgroundColor: selected
                          ? lightBlue
                          : Colors.white,
                      side: BorderSide(
                        color: selected
                            ? primaryColor
                            : Colors.grey
                                .shade300,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),
                    ),
                    child: Text(
                      question.options[index],
                      style: TextStyle(
                        color: selected
                            ? primaryColor
                            : Colors.black87,
                        fontWeight: selected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: nextQuestion,
                child: Text(
                  currentQuestion ==
                          quizQuestions.length - 1
                      ? 'Selesai'
                      : 'Soal Berikutnya',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// HASIL QUIZ
// ============================================================

class QuizResultPage extends StatelessWidget {
  final int score;
  final int total;

  const QuizResultPage({
    super.key,
    required this.score,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final nilai =
        ((score / total) * 100).round();

    String message;

    if (nilai >= 80) {
      message =
          'Pemahaman materi kamu sudah baik.';
    } else if (nilai >= 60) {
      message =
          'Pemahaman kamu cukup baik, tetapi masih dapat ditingkatkan.';
    } else {
      message =
          'Pelajari kembali materi kemudian coba quiz lagi.';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Quiz'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.assessment_outlined,
                size: 90,
                color: primaryColor,
              ),

              const SizedBox(height: 20),

              const Text(
                'Quiz Selesai',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                '$nilai',
                style: const TextStyle(
                  fontSize: 65,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),

              Text(
                '$score benar dari $total soal',
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                message,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Kembali',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// PROFILE
// ============================================================

class ProfilePage extends StatelessWidget {
  final String userName;
  final String email;
  final int completedMaterials;

  const ProfilePage({
    super.key,
    required this.userName,
    required this.email,
    required this.completedMaterials,
  });

  void logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 25),

            const CircleAvatar(
              radius: 50,
              backgroundColor: lightBlue,
              child: Icon(
                Icons.person,
                size: 55,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              userName,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              email,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            Card(
              child: Column(
                children: [
                  ListTile(
                    leading:
                        const Icon(Icons.person),
                    title: const Text('Nama'),
                    subtitle: Text(userName),
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading:
                        const Icon(Icons.email),
                    title: const Text('Email'),
                    subtitle: Text(email),
                  ),

                  const Divider(height: 1),

                  const ListTile(
                    leading:
                        Icon(Icons.school),
                    title: Text('Jurusan'),
                    subtitle: Text(
                      'Teknik Komputer dan Jaringan',
                    ),
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(
                      Icons.menu_book,
                    ),
                    title: const Text(
                      'Materi Dipelajari',
                    ),
                    subtitle: Text(
                      '$completedMaterials materi',
                    ),
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading:
                        const Icon(Icons.quiz),
                    title: const Text(
                      'Quiz Dikerjakan',
                    ),
                    subtitle: Text(
                      '${quizHistory.length} quiz',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  logout(context);
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ADMIN DASHBOARD
// ============================================================

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() =>
      _AdminDashboardState();
}

class _AdminDashboardState
    extends State<AdminDashboard> {
  int currentIndex = 0;

  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      buildDashboard(),
      AdminMaterialPage(
        onChanged: () {
          setState(() {});
        },
      ),
      const AdminQuizPage(),
      const AdminUserPage(),
    ];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon:
                Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Materi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz_outlined),
            activeIcon: Icon(Icons.quiz),
            label: 'Quiz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Pengguna',
          ),
        ],
      ),
    );
  }

  Widget buildDashboard() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Dashboard Admin',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: logout,
                  icon:
                      const Icon(Icons.logout),
                ),
              ],
            ),

            const Text(
              'Kelola konten aplikasi TechExplorer.',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            Row(
              children: [
                Expanded(
                  child: statCard(
                    'Materi',
                    materials.length.toString(),
                    Icons.menu_book,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: statCard(
                    'Soal',
                    quizQuestions.length
                        .toString(),
                    Icons.quiz,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: statCard(
                    'Pengguna',
                    users.length.toString(),
                    Icons.people,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: statCard(
                    'Hasil Quiz',
                    quizHistory.length
                        .toString(),
                    Icons.assessment,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Kategori',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            ...categoryData.map(
              (category) {
                final count = materials
                    .where(
                      (material) =>
                          material.category ==
                          category['name'],
                    )
                    .length;

                return Card(
                  child: ListTile(
                    leading: Icon(
                      category['icon']
                          as IconData,
                      color: primaryColor,
                    ),
                    title: Text(
                      category['name']
                          as String,
                    ),
                    trailing: Text(
                      '$count materi',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget statCard(
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: primaryColor,
            size: 30,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// ADMIN MATERI
// ============================================================

class AdminMaterialPage extends StatefulWidget {
  final VoidCallback onChanged;

  const AdminMaterialPage({
    super.key,
    required this.onChanged,
  });

  @override
  State<AdminMaterialPage> createState() =>
      _AdminMaterialPageState();
}

class _AdminMaterialPageState
    extends State<AdminMaterialPage> {
  void addMaterial() {
    final titleController =
        TextEditingController();
    final descriptionController =
        TextEditingController();
    final contentController =
        TextEditingController();

    String category = 'Hardware';

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder:
              (context, setDialogState) {
            return AlertDialog(
              title:
                  const Text('Tambah Materi'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller:
                          titleController,
                      decoration:
                          const InputDecoration(
                        labelText: 'Judul Materi',
                      ),
                    ),

                    TextField(
                      controller:
                          descriptionController,
                      decoration:
                          const InputDecoration(
                        labelText: 'Deskripsi',
                      ),
                    ),

                    TextField(
                      controller:
                          contentController,
                      maxLines: 5,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Pembahasan',
                      ),
                    ),

                    DropdownButtonFormField<
                        String>(
                      value: category,
                      decoration:
                          const InputDecoration(
                        labelText: 'Kategori',
                      ),
                      items: categoryData
                          .map(
                            (item) =>
                                DropdownMenuItem(
                              value:
                                  item['name']
                                      as String,
                              child: Text(
                                item['name']
                                    as String,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          category =
                              value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child:
                      const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController
                            .text
                            .isEmpty ||
                        descriptionController
                            .text
                            .isEmpty ||
                        contentController
                            .text
                            .isEmpty) {
                      return;
                    }

                    materials.add(
                      MaterialData(
                        title:
                            titleController
                                .text,
                        category: category,
                        description:
                            descriptionController
                                .text,
                        content:
                            contentController
                                .text,
                        importantPoints:
                            'Materi ditambahkan oleh admin.',
                        icon: Icons.menu_book,
                      ),
                    );

                    Navigator.pop(context);

                    setState(() {});

                    widget.onChanged();
                  },
                  child:
                      const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void deleteMaterial(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title:
            const Text('Hapus Materi'),
        content: Text(
          'Hapus materi "${materials[index].title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context),
            child:
                const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                materials.removeAt(index);
              });

              Navigator.pop(context);
              widget.onChanged();
            },
            child:
                const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.fromLTRB(
              20,
              25,
              20,
              10,
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Kelola Materi',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FloatingActionButton.small(
                  onPressed: addMaterial,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding:
                  const EdgeInsets.all(20),
              itemCount: materials.length,
              itemBuilder: (_, index) {
                final material =
                    materials[index];

                return Card(
                  child: ListTile(
                    leading: Icon(
                      material.icon,
                      color: primaryColor,
                    ),
                    title: Text(
                      material.title,
                    ),
                    subtitle: Text(
                      material.category,
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        deleteMaterial(index);
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// ADMIN QUIZ
// ============================================================

class AdminQuizPage extends StatelessWidget {
  const AdminQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Padding(
              padding:
                  EdgeInsets.fromLTRB(
                20,
                25,
                20,
                5,
              ),
              child: Text(
                'Kelola Quiz',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Padding(
              padding:
                  EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Text(
                'Daftar soal yang tersedia.',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.all(20),
                itemCount:
                    quizQuestions.length,
                itemBuilder: (_, index) {
                  final question =
                      quizQuestions[index];

                  return Card(
                    margin:
                        const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            lightBlue,
                        child: Text(
                          '${index + 1}',
                          style:
                              const TextStyle(
                            color:
                                primaryColor,
                          ),
                        ),
                      ),
                      title: Text(
                        question.question,
                      ),
                      subtitle: Text(
                        '${question.options.length} pilihan jawaban',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ADMIN USER
// ============================================================

class AdminUserPage extends StatelessWidget {
  const AdminUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Padding(
            padding:
                EdgeInsets.fromLTRB(
              20,
              25,
              20,
              5,
            ),
            child: Text(
              'Data Pengguna',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const Padding(
            padding:
                EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Text(
              'Daftar pengguna aplikasi TechExplorer.',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),

          const SizedBox(height: 15),

          Expanded(
            child: ListView.builder(
              padding:
                  const EdgeInsets.all(20),
              itemCount: users.length,
              itemBuilder: (_, index) {
                final user = users[index];

                return Card(
                  child: ListTile(
                    leading:
                        const CircleAvatar(
                      backgroundColor:
                          lightBlue,
                      child: Icon(
                        Icons.person,
                        color: primaryColor,
                      ),
                    ),
                    title: Text(
                      user['name'] ?? '',
                    ),
                    subtitle: Text(
                      '${user['email']}\n${user['class']}',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// INPUT DECORATION
// ============================================================

InputDecoration inputDecoration(
  String hint,
  IconData icon,
) {
  return InputDecoration(
    hintText: hint,
    prefixIcon: Icon(icon),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: primaryColor,
        width: 1.5,
      ),
    ),
  );
}