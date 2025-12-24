import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/ministry_post_model.dart';
import '../models/comment_model.dart';
import '../services/database_service.dart';

class PostDetailsScreen extends StatefulWidget {
  final MinistryPostModel post;

  const PostDetailsScreen({super.key, required this.post});

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  final TextEditingController _commentController = TextEditingController();
  final DatabaseService _db = DatabaseService();

  @override
  void initState() {
    super.initState();
    // Increment view count
    _db.incrementView(widget.post.id);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.post.ministryName)),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Images
                  if (widget.post.imageUrls.isNotEmpty)
                    SizedBox(
                      height: 250,
                      child: PageView.builder(
                        itemCount: widget.post.imageUrls.length,
                        itemBuilder: (context, index) {
                          return Image.network(
                            widget.post.imageUrls[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          );
                        },
                      ),
                    )
                  else if (widget.post.imageUrl.isNotEmpty)
                    Image.network(
                      widget.post.imageUrl,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post.title,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat(
                            'MMM d, yyyy • h:mm a',
                          ).format(widget.post.date),
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.post.content,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),

                        // Stats Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStat(
                              Icons.remove_red_eye,
                              '${widget.post.views} Views',
                            ),
                            _buildLikeButton(user),
                            _buildStat(
                              Icons.comment,
                              '${widget.post.commentCount} Comments',
                            ),
                          ],
                        ),
                        const Divider(height: 32),

                        // Comments Section Header
                        Text(
                          'Comments',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),

                        // Comments List
                        StreamBuilder<List<CommentModel>>(
                          stream: _db.getComments(widget.post.id),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error loading comments');
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            final comments = snapshot.data ?? [];
                            if (comments.isEmpty) {
                              return const Text('No comments yet.');
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                final comment = comments[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        comment.userPhotoUrl != null
                                        ? NetworkImage(comment.userPhotoUrl!)
                                        : null,
                                    child: comment.userPhotoUrl == null
                                        ? Text(comment.userName[0])
                                        : null,
                                  ),
                                  title: Text(comment.userName),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(comment.text),
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Add Comment Input
          if (user != null)
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, -1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Write a comment...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () async {
                      if (_commentController.text.trim().isNotEmpty) {
                        final comment = CommentModel(
                          id: '',
                          userId: user.uid,
                          userName:
                              user.displayName ??
                              'Member', // Need to fetch actual name if not in auth
                          userPhotoUrl: user.photoURL,
                          text: _commentController.text.trim(),
                          timestamp: DateTime.now(),
                        );
                        await _db.addComment(widget.post.id, comment);
                        _commentController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildLikeButton(User? user) {
    final isLiked = user != null && widget.post.likedBy.contains(user.uid);
    return InkWell(
      onTap: user == null
          ? null
          : () {
              _db.toggleLike(widget.post.id, user.uid, isLiked);
            },
      child: Row(
        children: [
          Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            size: 20,
            color: isLiked ? Colors.red : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            '${widget.post.likes} Likes',
            style: TextStyle(color: isLiked ? Colors.red : Colors.grey),
          ),
        ],
      ),
    );
  }
}
