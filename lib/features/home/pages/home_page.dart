import 'package:flutter/material.dart';

import '../../../core/widgets/section_title.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/category_list.dart';
import '../widgets/header_section.dart';
import '../widgets/popular_course_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
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
                    SectionTitle(title: 'Kategori Ngaji'),
                    SizedBox(height: 12),
                    CategoryList(),
                    SizedBox(height: 24),
                    SectionTitle(title: 'Kelas Populer'),
                    SizedBox(height: 12),
                    PopularCourseList(),
                    SizedBox(height: 80),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
