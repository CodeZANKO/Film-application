import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:film_app/core/theme/app_theme.dart';
import 'package:film_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:film_app/features/auth/presentation/pages/login_page.dart';
import 'package:film_app/features/movies/presentation/pages/account_settings_page.dart';
import 'package:film_app/features/movies/presentation/pages/help_support_page.dart';
import 'package:film_app/features/movies/presentation/pages/notifications_screen.dart';
import 'package:film_app/features/movies/presentation/pages/streaming_history_screen.dart';
import 'package:film_app/core/widgets/glass_container.dart';
import 'downloads_screen.dart';
import 'watchlist_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            children: [
              // User Identity Section
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.5),
                      width: 3),
                ),
                child: const CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                      'https://t3.ftcdn.net/jpg/01/73/77/00/360_F_173770068_LRQyNUZQn9WtQyJoJsOEwK8qwBzypBm0.jpg'),
                ),
              ),
              const SizedBox(height: 24),
              const Text("John Doe",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.1)),
              const SizedBox(height: 4),
              Text("premium_user@example.com",
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 16)),
              const SizedBox(height: 48),

              // Settings Options
              _buildProfileOption(
                context,
                Icons.person_rounded,
                "Account Settings",
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AccountSettingsPage())),
              ),
              _buildProfileOption(
                context,
                Icons.download_for_offline_rounded,
                "Downloads",
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const DownloadsScreen())),
              ),
              _buildProfileOption(
                context,
                Icons.bookmark_rounded,
                "My Watchlist",
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const WatchlistScreen())),
              ),
              _buildProfileOption(
                context,
                Icons.notifications_rounded,
                "Notifications",
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const NotificationsScreen())),
              ),
              _buildProfileOption(
                context,
                Icons.history_rounded,
                "Streaming History",
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const StreamingHistoryScreen())),
              ),
              _buildProfileOption(
                context,
                Icons.help_rounded,
                "Help & Support",
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const HelpSupportPage())),
              ),

              const SizedBox(height: 40),

              // Logout Button with Glass Effect
              GlassContainer(
                borderRadius: 20,
                blur: 10,
                opacity: 0.1,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(LogoutRequested());
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    minimumSize: const Size(double.infinity, 64),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 0,
                  ),
                  child: const Text("LOGOUT",
                      style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ),
              ),

              // Bottom spacing to prevent navigation bar overlap
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context, IconData icon, String title,
      {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassContainer(
        borderRadius: 20,
        blur: 5,
        opacity: 0.05,
        child: ListTile(
          onTap: onTap,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppColors.primary),
          ),
          title: Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500)),
          trailing: Icon(Icons.arrow_forward_ios_rounded,
              size: 16, color: Colors.white.withValues(alpha: 0.3)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        ),
      ),
    );
  }
}

