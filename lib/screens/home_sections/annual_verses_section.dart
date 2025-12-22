import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecclesia_flutter/models/ministry_post_model.dart';
import 'package:ecclesia_flutter/models/user_model.dart';
import 'package:ecclesia_flutter/services/database_service.dart';

class AnnualVersesSection extends StatelessWidget {
  const AnnualVersesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MinistryPostModel>>(
      stream: DatabaseService().getAnnualVerses(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: Text('Unable to load annual verses.')),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final verses = snapshot.data ?? [];

        if (verses.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: Text('No annual verses available.')),
          );
        }

        final user = FirebaseAuth.instance.currentUser;
        return StreamBuilder<UserModel>(
          stream: user != null
              ? DatabaseService().getUserData(user.uid)
              : Stream.value(UserModel(uid: '', email: '', role: 'user')),
          builder: (context, userSnapshot) {
            final isAdmin = userSnapshot.data?.role == 'admin';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    'Annual Verses',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 320, // Increased height for Column layout
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: verses.length,
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    itemBuilder: (context, index) {
                      final verse = verses[index];
                      return Container(
                        width: 300,
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (verse.imageUrl.isNotEmpty)
                                    Expanded(
                                      flex: 5,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(12),
                                        ),
                                        child: Container(
                                          width: double.infinity,
                                          child:
                                              verse.imageUrl.startsWith('http')
                                              ? Image.network(
                                                  verse.imageUrl,
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        return Container(
                                                          color:
                                                              Colors.grey[300],
                                                          child: Center(
                                                            child: Icon(
                                                              Icons
                                                                  .image_not_supported,
                                                              color: Colors
                                                                  .grey[600],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                  loadingBuilder: (context, child, loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    }
                                                    return Center(
                                                      child: CircularProgressIndicator(
                                                        value:
                                                            loadingProgress
                                                                    .expectedTotalBytes !=
                                                                null
                                                            ? loadingProgress
                                                                      .cumulativeBytesLoaded /
                                                                  loadingProgress
                                                                      .expectedTotalBytes!
                                                            : null,
                                                      ),
                                                    );
                                                  },
                                                )
                                              : Image.asset(
                                                  verse.imageUrl,
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        return Container(
                                                          color:
                                                              Colors.grey[300],
                                                          child: Center(
                                                            child: Icon(
                                                              Icons
                                                                  .image_not_supported,
                                                              color: Colors
                                                                  .grey[600],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                ),
                                        ),
                                      ),
                                    ),
                                  Expanded(
                                    flex: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              verse.title, // Year
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              verse.content, // Verse Text
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontStyle: FontStyle.italic,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      8,
                                      0,
                                      8,
                                      8,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            verse.likedBy.contains(
                                                  FirebaseAuth
                                                      .instance
                                                      .currentUser
                                                      ?.uid,
                                                )
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color:
                                                verse.likedBy.contains(
                                                  FirebaseAuth
                                                      .instance
                                                      .currentUser
                                                      ?.uid,
                                                )
                                                ? Colors.red
                                                : Colors.grey,
                                          ),
                                          onPressed: () {
                                            final user = FirebaseAuth
                                                .instance
                                                .currentUser;
                                            if (user != null) {
                                              bool isLiked = verse.likedBy
                                                  .contains(user.uid);
                                              DatabaseService().toggleLike(
                                                verse.id,
                                                user.uid,
                                                isLiked,
                                              );
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Please login to like posts',
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                        Text(
                                          '${verse.likes}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Icon(
                                          Icons.remove_red_eye,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          '${verse.views}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (isAdmin)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 16,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Delete Post'),
                                            content: Text(
                                              'Are you sure you want to delete this post?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  await DatabaseService()
                                                      .deleteMinistryPost(
                                                        verse.id,
                                                      );
                                                },
                                                child: Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
