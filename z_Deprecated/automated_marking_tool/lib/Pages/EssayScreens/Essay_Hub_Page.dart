import 'package:automated_marking_tool/Pages/EssayScreens/Grading_Examples_Page.dart';
import 'package:automated_marking_tool/Pages/EssayScreens/Criteria_Page.dart';
import 'package:automated_marking_tool/Pages/EssayScreens/Essay_Grading_Page.dart';
import 'package:flutter/material.dart';
import 'Essay_List_Screen.dart';
import 'package:automated_marking_tool/Providers/project_provider.dart';
import 'package:provider/provider.dart';


class EssayHubPage extends StatefulWidget {
  EssayHubPage({Key? key}) : super(key: key);

  @override
  _EssayHubPageState createState() => _EssayHubPageState();
}

class _EssayHubPageState extends State<EssayHubPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    ProjectProvider projectProvider = Provider.of<ProjectProvider>(context, listen: false);

    print("In EHP: ${projectProvider.selectedProjectId}");
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: [
          // Replace with your corresponding tab views
          GradingPage(),
          EssayListPage(),
          CriteriaPage(),
          GradingExamplesPage(),
        ],
      ),
      bottomNavigationBar: Material(
        color: Theme.of(context).colorScheme.primary,
        child: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.secondary, // Color for the indicator below tabs
          labelColor: Theme.of(context).colorScheme.secondary, // Text color for selected tab label
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow, color: Theme.of(context).colorScheme.secondary),
                  SizedBox(width: 5),
                  Text('Grade', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit, color: Theme.of(context).colorScheme.secondary),
                  SizedBox(width: 5),
                  Text('Essays', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment, color: Theme.of(context).colorScheme.secondary),
                  SizedBox(width: 5),
                  Text('Criteria', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment, color: Theme.of(context).colorScheme.secondary),
                  SizedBox(width: 5),
                  Text('Examples', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
