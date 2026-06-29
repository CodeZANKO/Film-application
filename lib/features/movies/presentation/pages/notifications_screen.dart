import 'package:flutter/material.dart';
import 'package:film_app/core/theme/app_theme.dart';
import 'package:film_app/core/widgets/glass_container.dart';
import 'package:film_app/core/widgets/liquid_background.dart';

class NotificationModel {
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final bool isRead;

  NotificationModel({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    this.isRead = false,
  });
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NotificationModel> notifications = [
      NotificationModel(
        title: "New Release: Dune Part Two",
        message: "The wait is over! Stream Dune: Part Two in Ultra HD now.",
        time: "2 hours ago",
        icon: Icons.movie_filter_rounded,
      ),
      NotificationModel(
        title: "Account Security",
        message: "A new login was detected on a Linux device in Paris, France.",
        time: "5 hours ago",
        icon: Icons.security_rounded,
        isRead: true,
      ),
      NotificationModel(
        title: "Subscription Renewed",
        message: "Your Premium Ultra HD plan has been successfully renewed for another month.",
        time: "1 day ago",
        icon: Icons.subscriptions_rounded,
        isRead: true,
      ),
      NotificationModel(
        title: "Trending in Sci-Fi",
        message: "Based on your interest in Stranger Things, we think you'll love 'Foundation'.",
        time: "2 days ago",
        icon: Icons.trending_up_rounded,
        isRead: true,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all_rounded, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: LiquidBackground(
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return _buildNotificationCard(notification);
          },
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassContainer(
        borderRadius: 20,
        blur: 10,
        opacity: notification.isRead ? 0.03 : 0.08,
        border: notification.isRead ? null : Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.5),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (notification.isRead ? Colors.white : AppColors.primary).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(notification.icon, color: notification.isRead ? Colors.white70 : AppColors.primary),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  notification.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              if (!notification.isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Text(
                notification.message,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                notification.time,
                style: TextStyle(color: AppColors.primary.withValues(alpha: 0.6), fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

