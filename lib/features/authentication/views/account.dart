import 'package:batteryqk_web_app/common/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String name = 'Emon Halder';
  String email = 'emon.maktech@gmail.com';

  void _editAccountDetails() {
    final nameController = TextEditingController(text: name);
    final emailController = TextEditingController(text: email);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Account Details'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    name = nameController.text;
                    email = emailController.text;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(isBack: true),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionCard(
              title: 'Account Details',
              onEdit: _editAccountDetails,
              children: [
                _InfoRow(label: 'Name', value: name),
                _InfoRow(label: 'Email', value: email),
                const _InfoRow(label: 'Member Since', value: 'January 2023'),
              ],
            ),
            const SizedBox(height: 24),

            // Stats Grid
            Row(
              children: const [
                _StatCard(label: 'Total Sessions', value: '12'),
                SizedBox(width: 12),
                _StatCard(label: 'Upcoming', value: '3'),
                SizedBox(width: 12),
                _StatCard(label: 'Cancelled', value: '1'),
              ],
            ),
            const SizedBox(height: 28),

            // Recent Activity
            _sectionCard(
              title: 'Recent Activity',
              children: const [
                _ActivityItem(
                  title: 'Swimming Session Booked',
                  date: 'Apr 28, 2025',
                ),
                _ActivityItem(
                  title: 'Football Session Cancelled',
                  date: 'Apr 22, 2025',
                ),
                _ActivityItem(
                  title: 'Basketball Workshop Attended',
                  date: 'Apr 15, 2025',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    List<Widget> children = const [],
    VoidCallback? onEdit,
  }) {
    final bool isGradient = title == 'Account Details';

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isGradient ? Colors.white : const Color(0xFF111827),
                ),
              ),
            ),
            if (onEdit != null)
              IconButton(
                icon: Icon(
                  Icons.edit,
                  size: 20,
                  color: isGradient ? Colors.white : Colors.blue,
                ),
                onPressed: onEdit,
                tooltip: 'Edit',
              ),
          ],
        ),
        const SizedBox(height: 14),
        ...children,
      ],
    );

    final boxDecoration = BoxDecoration(
      gradient:
          isGradient
              ? const LinearGradient(
                colors: [Color(0xFF38A9FF), Color(0xff206CFD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
              : null,
      color: isGradient ? null : Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: boxDecoration,
      child:
          isGradient
              ? Theme(
                data: Theme.of(context).copyWith(
                  textTheme: Theme.of(context).textTheme.apply(
                    bodyColor: Colors.white,
                    displayColor: Colors.white,
                  ),
                ),
                child: content,
              )
              : content,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.white),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
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
                color: Color(0xFF3B82F6),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String title;
  final String date;

  const _ActivityItem({required this.title, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tileColor: const Color(0xFFF1F5F9),
        title: Text(title),
        subtitle: Text(date),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }
}
