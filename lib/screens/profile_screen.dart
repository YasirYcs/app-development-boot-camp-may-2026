import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../utils/index.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Profile', style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.lg),

          // 1. USER INFO SECTION
          const Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                SizedBox(height: AppSpacing.md),
                Text('YasirYcs', style: AppTextStyles.heading3),
                Text('Student Developer', style: AppTextStyles.bodySmall),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // 2. SETTINGS SECTION
          Text('Settings', style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.md),

          _buildSettingsTile(
            icon: Icons.attach_money,
            title: 'Currency',
            trailing: Text(AppConstants.currencyName, style: AppTextStyles.bodySmall),
            onTap: () {},
          ),

          _buildSettingsTile(
            icon: Icons.palette_outlined,
            title: 'Theme',
            trailing: Text('Light Mode', style: AppTextStyles.bodySmall),
            onTap: () {},
          ),

          const SizedBox(height: AppSpacing.lg),

          // 3. COMING SOON SECTION
          Text('Future Features', style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.md),

          _buildSettingsTile(
            icon: Icons.cloud_upload_outlined,
            title: 'Cloud Backup',
            trailing: _buildComingSoonBadge(),
          ),

          _buildSettingsTile(
            icon: Icons.lock_outline,
            title: 'Login System',
            trailing: _buildComingSoonBadge(),
          ),

          const SizedBox(height: AppSpacing.xl),

          // 4. DANGER ZONE
          Text('Danger Zone', style: AppTextStyles.heading3.copyWith(color: AppColors.error)),
          const SizedBox(height: AppSpacing.md),

          Card(
            color: AppColors.error.withOpacity(0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.md),
              side: BorderSide(color: AppColors.error.withOpacity(0.2)),
            ),
            child: ListTile(
              leading: const Icon(Icons.delete_forever_outlined, color: AppColors.error),
              title: const Text('Clear All Data', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
              subtitle: const Text('This action cannot be undone', style: TextStyle(fontSize: 12)),
              onTap: () => _showDeleteConfirmation(context),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.body),
      trailing: trailing ?? const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }

  Widget _buildComingSoonBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'Soon',
        style: TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear all data?'),
        content: const Text('All your expenses will be permanently deleted from this device.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await context.read<ExpenseProvider>().clearAllExpenses();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All data cleared successfully')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete Everything'),
          ),
        ],
      ),
    );
  }
}
