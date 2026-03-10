import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/post_model.dart';
import '../providers/auth_provider.dart';
import '../providers/post_provider.dart';

class AddEditPostScreen extends StatefulWidget {
  final PostModel? post;

  const AddEditPostScreen({super.key, this.post});

  @override
  State<AddEditPostScreen> createState() => _AddEditPostScreenState();
}

class _AddEditPostScreenState extends State<AddEditPostScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _bodyController;

  bool _isSaving = false;
  bool get _isEditing => widget.post != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post?.title ?? '');
    _bodyController = TextEditingController(text: widget.post?.body ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final postProvider = context.read<PostProvider>();
    final userId = context.read<AuthProvider>().currentUserId;

    bool success;

    if (_isEditing) {
      success = await postProvider.updatePost(
        widget.post!.id,
        _titleController.text.trim(),
        _bodyController.text.trim(),
      );
    } else {
      success = await postProvider.createPost(
        _titleController.text.trim(),
        _bodyController.text.trim(),
        userId,
      );
    }

    if (!mounted) return;

    if (success) {
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Operation failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Post' : 'New Post')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Required' : null,
                  style: const TextStyle(fontSize: 16),
                  decoration: _inputDecoration(isDark, 'Title'),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TextFormField(
                    controller: _bodyController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Required' : null,
                    style: const TextStyle(fontSize: 16),
                    decoration: _inputDecoration(isDark, 'Description'),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSaving
                        ? const CupertinoActivityIndicator(color: Colors.white)
                        : Text(
                            _isEditing ? 'Save Changes' : 'Create Post',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(bool isDark, String label) {
    return InputDecoration(
      labelText: label,
      alignLabelWithHint: true,
      filled: true,
      fillColor: isDark ? const Color(0xFF1C1C1E) : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? Colors.transparent : Colors.grey.shade300,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
    );
  }
}
