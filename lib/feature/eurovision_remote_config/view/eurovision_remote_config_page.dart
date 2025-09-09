import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class EurovisionRemoteConfigPage extends StatefulWidget {
  const EurovisionRemoteConfigPage({super.key});

  @override
  State<EurovisionRemoteConfigPage> createState() =>
      _EurovisionRemoteConfigPageState();
}

class _EurovisionRemoteConfigPageState
    extends State<EurovisionRemoteConfigPage> {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  bool _isLoading = true;
  String _contestName = 'Eurovision';
  int _contestYear = 2024;
  String _contestImageUrl = '';
  bool _isHidden = false;

  @override
  void initState() {
    super.initState();
    _initializeRemoteConfig();
  }

  Future<void> _initializeRemoteConfig() async {
    try {
      await _remoteConfig.setDefaults({
        'contest_name': 'Eurovision Song Contest',
        'contest_year': 2024,
        'contest_image_url':
            'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
        'isHidden': false,
      });

      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero,
        ),
      );

      await _fetchConfig();
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchConfig() async {
    try {
      await _remoteConfig.fetchAndActivate();
      setState(() {
        _contestName = _remoteConfig.getString('contest_name');
        _contestYear = _remoteConfig.getInt('contest_year');
        _contestImageUrl = _remoteConfig.getString('contest_image_url');
        _isHidden = _remoteConfig.getBool('isHidden');
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const LoadingWidget()
        : Scaffold(
            backgroundColor: Colors.grey.shade100,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  TopBanner(
                    contestName: _contestName,
                    contestYear: _contestYear,
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        ContestCard(
                          contestImageUrl: _contestImageUrl,
                          isHidden: _isHidden,
                        ),
                        const SizedBox(height: 24),
                        StatsRow(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: _initializeRemoteConfig,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.refresh, color: Colors.white),
            ),
          );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 20),
            Text(
              'Loading Eurovision...',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopBanner extends StatelessWidget {
  final String contestName;
  final int contestYear;

  const TopBanner({
    super.key,
    required this.contestName,
    required this.contestYear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 290,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.purple.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Opacity(
              opacity: 0.1,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/pattern.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.music_note, size: 60, color: Colors.white),
                  const SizedBox(height: 16),
                  Text(
                    contestName.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    contestYear.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContestCard extends StatelessWidget {
  final String contestImageUrl;
  final bool isHidden;

  const ContestCard({
    super.key,
    required this.contestImageUrl,
    required this.isHidden,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            if (!isHidden && contestImageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  contestImageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 200,
                      color: Colors.grey.shade200,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.error_outline,
                        color: Colors.grey,
                        size: 50,
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                InfoItem(icon: Icons.calendar_today, text: 'May 11'),
                InfoItem(icon: Icons.location_on, text: 'Malmö'),
                InfoItem(icon: Icons.people, text: '37 Countries'),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome to Europe\'s biggest music festival! '
              'This year it is hosted in Sweden with 37 participating countries.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Colors.blue.shade600),
        const SizedBox(height: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}

class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        StatCard(value: '65', label: 'Years'),
        StatCard(value: '1.5B', label: 'Viewers'),
        StatCard(value: '37', label: 'Countries'),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String value;
  final String label;

  const StatCard({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
