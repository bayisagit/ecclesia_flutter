import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/database_service.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Members')),
      body: StreamBuilder<List<UserModel>>(
        stream: db.users,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data ?? [];

          if (users.isEmpty) {
            return const Center(child: Text('No members found.'));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.photoUrl != null
                        ? NetworkImage(user.photoUrl!)
                        : null,
                    child: user.photoUrl == null
                        ? Text(
                            user.firstName.isNotEmpty ? user.firstName[0] : '?',
                          )
                        : null,
                  ),
                  title: Text('${user.firstName} ${user.lastName}'),
                  subtitle: Text(
                    '${user.email}\nRole: ${user.role == 'user' ? 'Member' : user.role}',
                  ),
                  isThreeLine: true,
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'delete') {
                        bool confirm =
                            await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Member'),
                                content: Text(
                                  'Are you sure you want to delete ${user.firstName}?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ) ??
                            false;

                        if (confirm) {
                          await db.deleteUser(user.uid);
                        }
                      } else if (value == 'promote') {
                        await db.updateUserRole(user.uid, 'admin');
                      } else if (value == 'demote') {
                        await db.updateUserRole(user.uid, 'user');
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        if (user.role != 'admin')
                          const PopupMenuItem(
                            value: 'promote',
                            child: Text('Promote to Admin'),
                          ),
                        if (user.role == 'admin')
                          const PopupMenuItem(
                            value: 'demote',
                            child: Text('Demote to User'),
                          ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            'Delete Member',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ];
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
