import 'package:flutter/material.dart';
import '../../../core/widgets/section_title.dart';
import '../../../routes/app_routes.dart';
import '../widgets/header_section.dart';
import '../widgets/category_list.dart';
import '../widgets/popular_course_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNav(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const HeaderSection(),
              const SizedBox(height: 70),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SectionTitle(title: "Kategori Ngaji"),
                    SizedBox(height: 12),
                    CategoryList(),
                    SizedBox(height: 24),
                    SectionTitle(title: "Kelas Populer"),
                    SizedBox(height: 12),
                    PopularCourseList(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomNav(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (int index) {
        setState(() {
          _selectedIndex = index;
        });
        switch (index) {
          case 0:
            Navigator.pushNamed(context, AppRoutes.home);
            break;
          case 1:
            Navigator.pushNamed(context, AppRoutes.home);
            break;
          case 2:
            Navigator.pushNamed(context, AppRoutes.home);
            break;
          case 3:
            Navigator.pushNamed(context, AppRoutes.profile);
            break;
          default:
            break;
        }
      },
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_rounded),
          label: "Belajar",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.play_circle_fill),
          label: "Kelas",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: "Favorit",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profil",
        ),
      ],
    );
  }
}

