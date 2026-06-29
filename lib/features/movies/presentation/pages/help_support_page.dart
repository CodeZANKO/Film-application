import 'package:flutter/material.dart';
import 'package:film_app/core/theme/app_theme.dart';
import 'package:film_app/core/widgets/glass_container.dart';
import 'package:film_app/core/widgets/liquid_background.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Help & Support", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: LiquidBackground(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              const SizedBox(height: 32),
              _buildSectionHeader("Frequently Asked Questions"),
              _buildFAQTile("How do I cancel my subscription?", "You can cancel your subscription anytime in the Account Settings section under 'Plan'."),
              _buildFAQTile("Can I download movies for offline viewing?", "Yes, look for the download icon on the movie details page. Offline viewing is available on Premium plans."),
              _buildFAQTile("How many devices can I use at once?", "Standard plans support 2 devices, while Premium supports up to 4 concurrent streams."),
              _buildFAQTile("Why is the video quality low?", "Video quality depends on your internet speed and subscription plan. Check your connection or upgrade to Premium for 4K."),
              const SizedBox(height: 32),
              _buildSectionHeader("Contact Us"),
              _buildContactTile(
                context,
                icon: Icons.chat_bubble_rounded,
                title: "Live Chat",
                subtitle: "Typical response time: 2 mins",
                onTap: () {},
              ),
              _buildContactTile(
                context,
                icon: Icons.email_rounded,
                title: "Email Support",
                subtitle: "support@filmapp.com",
                onTap: () {},
              ),
              _buildContactTile(
                context,
                icon: Icons.phone_rounded,
                title: "Phone Support",
                subtitle: "+1 (800) FILM-APP-0",
                onTap: () {},
              ),
              const SizedBox(height: 32),
              _buildSectionHeader("Legal"),
              _buildSettingTile(context, "Privacy Policy"),
              _buildSettingTile(context, "Terms of Service"),
              _buildSettingTile(context, "Open Source Licenses"),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return const GlassContainer(
      borderRadius: 16,
      blur: 10,
      opacity: 0.1,
      child: TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Search for help...",
          hintStyle: TextStyle(color: Colors.white54),
          prefixIcon: Icon(Icons.search_rounded, color: AppColors.primary),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildFAQTile(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        borderRadius: 16,
        blur: 5,
        opacity: 0.05,
        child: ExpansionTile(
          title: Text(question, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15)),
          iconColor: AppColors.primary,
          collapsedIconColor: Colors.white30,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(answer, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), height: 1.5)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        borderRadius: 16,
        blur: 5,
        opacity: 0.05,
        child: ListTile(
          onTap: onTap,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
          subtitle: Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13)),
          trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.white.withValues(alpha: 0.3)),
        ),
      ),
    );
  }

  Widget _buildSettingTile(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        borderRadius: 16,
        blur: 5,
        opacity: 0.05,
        child: ListTile(
          onTap: () {},
          title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
          trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.white.withValues(alpha: 0.3)),
        ),
      ),
    );
  }
}


