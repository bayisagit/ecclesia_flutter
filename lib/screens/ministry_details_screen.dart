import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecclesia_flutter/models/user_model.dart';
import '../../models/ministry_post_model.dart';
import '../../services/database_service.dart';

import '../../models/comment_model.dart';
import '../widgets/expandable_text.dart';

class MinistryDetailsScreen extends StatefulWidget {
  final String ministryName;
  final String imageUrl;

  const MinistryDetailsScreen({
    super.key,
    required this.ministryName,
    required this.imageUrl,
  });

  @override
  State<MinistryDetailsScreen> createState() => _MinistryDetailsScreenState();
}

class _MinistryDetailsScreenState extends State<MinistryDetailsScreen> {
  final Set<String> _viewedPosts = {};

  void _onPostViewed(String postId) {
    if (!_viewedPosts.contains(postId)) {
      _viewedPosts.add(postId);
      DatabaseService().incrementView(postId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.ministryName,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                ),
              ),
              background: widget.imageUrl.startsWith('http')
                  ? Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                      color: Colors.black.withValues(alpha: 0.3),
                      colorBlendMode: BlendMode.darken,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[900],
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.white54,
                            size: 50,
                          ),
                        );
                      },
                    )
                  : Image.asset(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                      color: Colors.black.withValues(alpha: 0.3),
                      colorBlendMode: BlendMode.darken,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[900],
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.white54,
                            size: 50,
                          ),
                        );
                      },
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Latest Updates',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          StreamBuilder<List<MinistryPostModel>>(
            stream: DatabaseService().getMinistryPosts(widget.ministryName),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Center(child: Text('Error loading posts')),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final posts = snapshot.data ?? [];

              final user = FirebaseAuth.instance.currentUser;
              return StreamBuilder<UserModel>(
                stream: user != null
                    ? DatabaseService().getUserData(user.uid)
                    : Stream.value(UserModel(uid: '', email: '', role: 'user')),
                builder: (context, userSnapshot) {
                  final isAdmin = userSnapshot.data?.role == 'admin';

                  if (posts.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text('No updates available yet.'),
                        ),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      _onPostViewed(posts[index].id);
                      return _buildPostCard(context, posts[index], isAdmin);
                    }, childCount: posts.length),
                  );
                },
              );
            },
          ),
          SliverPadding(padding: EdgeInsets.only(bottom: 50)),
        ],
      ),
    );
  }

  Widget _buildPostCard(
    BuildContext context,
    MinistryPostModel post,
    bool isAdmin,
  ) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (post.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: post.imageUrl.startsWith('http')
                      ? Image.network(
                          post.imageUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                height: 200,
                                color: Colors.grey[300],
                                child: Icon(Icons.image_not_supported),
                              ),
                        )
                      : Image.asset(
                          post.imageUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                height: 200,
                                color: Colors.grey[300],
                                child: Icon(Icons.image_not_supported),
                              ),
                        ),
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            post.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (post.type == 'mission')
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'MISSION',
                              style: TextStyle(
                                color: Colors.orange[800],
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      DateFormat('MMM d, yyyy • h:mm a').format(post.date),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    SizedBox(height: 12),
                    ExpandableText(text: post.content),
                    if (post.type == 'mission' && post.heardCount != null) ...[
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem('Heard', post.heardCount!),
                            _buildStatItem('Hope', post.hopeCount!),
                            _buildStatItem('Believed', post.believedCount!),
                          ],
                        ),
                      ),
                    ],
                    if (post.audioUrl.isNotEmpty) ...[
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.audiotrack,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Audio Available',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.play_circle_fill),
                            color: Theme.of(context).primaryColor,
                            iconSize: 32,
                            onPressed: () {
                              // TODO: Implement audio player
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Audio playback coming soon'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                    SizedBox(height: 8),
                    Divider(),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            post.likedBy.contains(
                                  FirebaseAuth.instance.currentUser?.uid,
                                )
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                                post.likedBy.contains(
                                  FirebaseAuth.instance.currentUser?.uid,
                                )
                                ? Colors.red
                                : Colors.grey,
                          ),
                          onPressed: () {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              bool isLiked = post.likedBy.contains(user.uid);
                              DatabaseService().toggleLike(
                                post.id,
                                user.uid,
                                isLiked,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please login to like posts'),
                                ),
                              );
                            }
                          },
                        ),
                        Text('${post.likes}'),
                        SizedBox(width: 16),
                        Icon(
                          Icons.remove_red_eye,
                          color: Colors.grey,
                          size: 20,
                        ),
                        SizedBox(width: 4),
                        Text('${post.views}'),
                        SizedBox(width: 16),
                        IconButton(
                          icon: Icon(Icons.comment, color: Colors.grey),
                          onPressed: () {
                            _showCommentsSheet(context, post.id);
                          },
                        ),
                        Text('${post.commentCount}'),
                      ],
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
                  icon: Icon(Icons.delete, color: Colors.red, size: 20),
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
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await DatabaseService().deleteMinistryPost(
                                post.id,
                              );
                            },
                            child: Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
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
    );
  }

  void _showCommentsSheet(BuildContext context, String postId) {
    final TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Comments',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<CommentModel>>(
                    stream: DatabaseService().getComments(postId),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error loading comments'));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final comments = snapshot.data ?? [];

                      if (comments.isEmpty) {
                        return Center(child: Text('No comments yet'));
                      }

                      return ListView.builder(
                        controller: scrollController,
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: comment.userPhotoUrl != null
                                  ? NetworkImage(comment.userPhotoUrl!)
                                  : null,
                              child: comment.userPhotoUrl == null
                                  ? Icon(Icons.person)
                                  : null,
                            ),
                            title: Text(
                              comment.userName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(comment.text),
                                SizedBox(height: 4),
                                Text(
                                  DateFormat(
                                    'MMM d, h:mm a',
                                  ).format(comment.timestamp),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 16,
                    right: 16,
                    top: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            hintText: 'Add a comment...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send, color: Colors.blue),
                        onPressed: () async {
                          final user = FirebaseAuth.instance.currentUser;
                          if (user == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please login to comment'),
                              ),
                            );
                            return;
                          }

                          if (commentController.text.trim().isEmpty) return;

                          final comment = CommentModel(
                            id: '', // Generated by Firestore
                            userId: user.uid,
                            userName:
                                user.displayName ?? user.email ?? 'Member',
                            userPhotoUrl: user.photoURL,
                            text: commentController.text.trim(),
                            timestamp: DateTime.now(),
                          );

                          await DatabaseService().addComment(postId, comment);
                          commentController.clear();
                          // Increment view count as an interaction
                          DatabaseService().incrementView(postId);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildStatItem(String label, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
