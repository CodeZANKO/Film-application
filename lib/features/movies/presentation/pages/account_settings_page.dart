import 'package:flutter/material.dart';
import 'package:film_app/core/theme/app_theme.dart';
import 'package:film_app/core/widgets/glass_container.dart';
import 'package:film_app/core/widgets/liquid_background.dart';
import 'package:film_app/features/movies/presentation/pages/change_password_page.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  bool _is2FAEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Account Settings",
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
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
              _buildSectionHeader("Profile Information"),
              _buildSettingTile(
                context,
                icon: Icons.person_rounded,
                title: "Name",
                subtitle: "John Doe",
                onTap: () => _showEditDialog(context, "Name", "John Doe"),
              ),
              _buildSettingTile(
                context,
                icon: Icons.email_rounded,
                title: "Email",
                subtitle: "premium_user@example.com",
                onTap: () =>
                    _showEditDialog(context, "Email", "premium_user@example.com"),
              ),
              const SizedBox(height: 32),
              _buildSectionHeader("Security"),
              _buildSettingTile(
                context,
                icon: Icons.lock_rounded,
                title: "Change Password",
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ChangePasswordPage())),
              ),
              _buildSettingTile(
                context,
                icon: Icons.phonelink_lock_rounded,
                title: "Two-Factor Authentication",
                trailing: Switch(
                  value: _is2FAEnabled,
                  onChanged: (val) {
                    if (val) {
                      _showOTPDialog(context);
                    } else {
                      setState(() => _is2FAEnabled = false);
                    }
                  },
                  activeTrackColor: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32),
              _buildSectionHeader("Subscription & Billing"),
              _buildSettingTile(
                context,
                icon: Icons.card_membership_rounded,
                title: "Plan",
                subtitle: "Premium Ultra HD",
                onTap: () {},
              ),
              _buildSettingTile(
                context,
                icon: Icons.payment_rounded,
                title: "Payment Methods",
                subtitle: "Visa **** 4242",
                onTap: () {},
              ),
              const SizedBox(height: 48),
              _buildDangerZone(context),
              const SizedBox(height: 100),
            ],
          ),
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

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
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
          title: Text(title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500)),
          subtitle: subtitle != null
              ? Text(subtitle,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5)))
              : null,
          trailing: trailing ??
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: Colors.white.withValues(alpha: 0.3)),
        ),
      ),
    );
  }

  Widget _buildDangerZone(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Danger Zone"),
        GlassContainer(
          borderRadius: 16,
          blur: 10,
          opacity: 0.1,
          border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
          child: ListTile(
            onTap: () => _showDeleteConfirmation(context),
            leading:
                const Icon(Icons.delete_forever_rounded, color: Colors.redAccent),
            title: const Text("Delete Account",
                style:
                    TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            subtitle: Text("Permanently remove your account and data",
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4), fontSize: 12)),
          ),
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext context, String field, String currentValue) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        contentPadding: EdgeInsets.zero,
        content: GlassContainer(
          padding: const EdgeInsets.all(32),
          borderRadius: 32,
          opacity: 0.1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      field == "Name" ? Icons.person_rounded : Icons.email_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Edit $field",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                field.toUpperCase(),
                style: TextStyle(
                  color: AppColors.primary.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: currentValue,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Text("SAVE CHANGES", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        contentPadding: EdgeInsets.zero,
        content: GlassContainer(
          padding: const EdgeInsets.all(32),
          borderRadius: 32,
          opacity: 0.1,
          border: Border.all(color: Colors.redAccent.withValues(alpha: 0.2)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.warning_rounded, color: Colors.redAccent, size: 48),
              ),
              const SizedBox(height: 24),
              const Text(
                "Are you sure?",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                "This action cannot be undone. All your watchlist data and preferences will be lost forever.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6), height: 1.5),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text("DELETE EVERYTHING", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  "Keep My Account",
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOTPDialog(BuildContext context) {
    final controllers = List.generate(4, (index) => TextEditingController());
    final focusNodes = List.generate(4, (index) => FocusNode());

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 20),
            contentPadding: EdgeInsets.zero,
            content: GlassContainer(
              padding: const EdgeInsets.all(32),
              borderRadius: 32,
              opacity: 0.1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shield_rounded, size: 64, color: AppColors.primary),
                  const SizedBox(height: 24),
                  const Text(
                    "Verify Identity",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Enter the 4-digit code sent to your email to enable 2FA.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                      return SizedBox(
                        width: 50,
                        child: TextFormField(
                          controller: controllers[index],
                          focusNode: focusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            counterText: "",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppColors.primary, width: 2),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 3) {
                              focusNodes[index + 1].requestFocus();
                            }
                          },
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() => _is2FAEnabled = true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Two-Factor Authentication enabled!"), backgroundColor: Colors.green),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: const Text("VERIFY", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel", style: TextStyle(color: Colors.white.withValues(alpha: 0.5))),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


