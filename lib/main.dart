import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = true; // Modo oscuro por defecto
  bool _isExpanded = true; // Estado del sidebar

  void _toggleSidebar() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Sidebar',
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? _darkTheme() : _lightTheme(),
      home: HomeScreen(
        isExpanded: _isExpanded,
        toggleSidebar: _toggleSidebar,
        toggleTheme: _toggleTheme,
        isDarkMode: _isDarkMode,
      ),
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Color(0xFF3a444e),
      scaffoldBackgroundColor: Color(0xFF333a40),
      appBarTheme: AppBarTheme(backgroundColor: Color(0xFF3a444e)),
      drawerTheme: DrawerThemeData(backgroundColor: Color(0xFF3a444e)),
      iconTheme: IconThemeData(color: Colors.white),
      textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)),
    );
  }

  ThemeData _lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Color(0xFFf9fafd),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(backgroundColor: Color(0xFFf9fafd)),
      drawerTheme: DrawerThemeData(backgroundColor: Color(0xFFf9fafd)),
      iconTheme: IconThemeData(color: Colors.black),
      textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.black)),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final bool isExpanded;
  final Function toggleSidebar;
  final Function toggleTheme;
  final bool isDarkMode;

  HomeScreen({
    required this.isExpanded,
    required this.toggleSidebar,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationDrawer(
            isExpanded: isExpanded,
            toggleSidebar: toggleSidebar,
          ),
          Expanded(
            child: Column(
              children: [
                AppBar(
                  title: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () => toggleSidebar(),
                      ),
                      SizedBox(width: 8),
                      Text('Dashboard'),
                    ],
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0, left: 4.0),
                      child: IconButton(
                        icon: Icon(
                            isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
                        onPressed: () => toggleTheme(),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Main Content Here',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  final bool isExpanded;
  final Function toggleSidebar;

  NavigationDrawer({required this.isExpanded, required this.toggleSidebar});

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        Theme.of(context).drawerTheme.backgroundColor ?? Colors.transparent;

    return Container(
      width: isExpanded ? 250 : 70,
      color: backgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(context),
          _buildSectionTitle('Navigation', context),
          _buildModule(
              Icons.home, 'Dashboards', ['Overview', 'Stats'], context),
          _buildSectionTitle('Apps', context),
          _buildModule(Icons.calendar_today, 'Calendar', [], context),
          _buildModule(Icons.chat, 'Chat', [], context),
          _buildModule(
              Icons.store, 'Ecommerce', ['Products', 'Orders'], context),
          _buildSectionTitle('Custom', context),
          _buildModule(Icons.pages, 'Pages', [], context),
          _buildModule(Icons.public, 'Landing', [], context),
          _buildSectionTitle('Components', context),
          _buildModule(Icons.widgets, 'Base UI', [], context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.dashboard,
              size: 32, color: Theme.of(context).iconTheme.color),
          if (isExpanded) ...[
            SizedBox(width: 8),
            Text(
              'HYPER',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Visibility(
        visible: isExpanded,
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildModule(IconData icon, String title, List<String> submodules,
      BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Icon(icon, color: Theme.of(context).iconTheme.color),
        title: Visibility(
          visible: isExpanded,
          child: Text(
            title,
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
          ),
        ),
        trailing: isExpanded
            ? Icon(Icons.expand_more, color: Theme.of(context).iconTheme.color)
            : SizedBox.shrink(),
        children: submodules
            .map((submodule) => Visibility(
                  visible: isExpanded,
                  child: ListTile(
                    title: Text(
                      submodule,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    onTap: () {},
                  ),
                ))
            .toList(),
      ),
    );
  }
}
