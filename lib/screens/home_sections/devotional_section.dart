import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecclesia_flutter/models/user_model.dart';
import 'package:ecclesia_flutter/models/ministry_post_model.dart';
import 'package:ecclesia_flutter/services/database_service.dart';
import '../post_details_screen.dart';

class DevotionalSection extends StatelessWidget {
  const DevotionalSection({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MinistryPostModel>>(
      stream: DatabaseService().getDevotionalPosts(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: Text('Unable to load devotional content.')),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final posts = snapshot.data ?? [];

        if (posts.isEmpty) {
          return SizedBox.shrink(); // Hide section if no content
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
                    'Devotional Content',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 200, // Adjust height as needed
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: posts.length,
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PostDetailsScreen(post: post),
                            ),
                          );
                        },
                        child: Container(
                          width: 300,
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Stack(
                              children: [
                                if (post.imageUrl.isNotEmpty)
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: post.imageUrl.startsWith('http')
                                          ? Image.network(
                                              post.imageUrl,
                                              fit: BoxFit.cover,
                                              color: Colors.black.withValues(
                                                alpha: 0.4,
                                              ),
                                              colorBlendMode: BlendMode.darken,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Container(
                                                      color: Colors.grey[300],
                                                      child: Center(
                                                        child: Icon(
                                                          Icons
                                                              .image_not_supported,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                              loadingBuilder: (context, child, loadingProgress) {
                                                if (loadingProgress == null) {
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
                                              post.imageUrl,
                                              fit: BoxFit.cover,
                                              color: Colors.black.withValues(
                                                alpha: 0.4,
                                              ),
                                              colorBlendMode: BlendMode.darken,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Container(
                                                      color: Colors.grey[300],
                                                      child: Center(
                                                        child: Icon(
                                                          Icons
                                                              .image_not_supported,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                            ),
                                    ),
                                  ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withValues(alpha: 0.8),
                                          Colors.transparent,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(12),
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          post.title,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              post.ministryName,
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.remove_red_eye,
                                                  color: Colors.white70,
                                                  size: 14,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  '${post.views}',
                                                  style: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Icon(
                                                  Icons.favorite,
                                                  color: Colors.white70,
                                                  size: 14,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  '${post.likes}',
                                                  style: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
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
                                                          post.id,
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
