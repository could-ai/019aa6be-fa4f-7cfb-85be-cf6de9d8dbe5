import 'package:flutter/material.dart';
import 'dart:math';
import '../models/password_item.dart';
import '../services/mock_data_service.dart';

class AddEditPasswordScreen extends StatefulWidget {
  final PasswordItem? item;

  const AddEditPasswordScreen({super.key, this.item});

  @override
  State<AddEditPasswordScreen> createState() => _AddEditPasswordScreenState();
}

class _AddEditPasswordScreenState extends State<AddEditPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _accountController;
  late TextEditingController _passwordController;
  late TextEditingController _websiteController;
  late TextEditingController _notesController;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item?.title ?? '');
    _accountController = TextEditingController(text: widget.item?.accountName ?? '');
    _passwordController = TextEditingController(text: widget.item?.password ?? '');
    _websiteController = TextEditingController(text: widget.item?.website ?? '');
    _notesController = TextEditingController(text: widget.item?.notes ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _accountController.dispose();
    _passwordController.dispose();
    _websiteController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _generatePassword() {
    const length = 16;
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890!@#\$%^&*()';
    final rnd = Random();
    final password = String.fromCharCodes(Iterable.generate(
      length,
      (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
    ));
    
    setState(() {
      _passwordController.text = password;
      _isPasswordVisible = true; // Show generated password
    });
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final service = MockDataService();
      
      if (widget.item == null) {
        // Add new
        final newItem = PasswordItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text,
          accountName: _accountController.text,
          password: _passwordController.text,
          website: _websiteController.text,
          notes: _notesController.text,
          updatedAt: DateTime.now(),
        );
        service.addItem(newItem);
      } else {
        // Update existing
        final updatedItem = PasswordItem(
          id: widget.item!.id,
          title: _titleController.text,
          accountName: _accountController.text,
          password: _passwordController.text,
          website: _websiteController.text,
          notes: _notesController.text,
          updatedAt: DateTime.now(),
        );
        service.updateItem(updatedItem);
      }
      
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.item != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? '编辑密码' : '添加密码'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '标题 (例如: Google, 银行卡)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入标题';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _accountController,
                decoration: const InputDecoration(
                  labelText: '账号 / 用户名',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入账号';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: '密码',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.key),
                        suffixIcon: IconButton(
                          icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入密码';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 56,
                    child: OutlinedButton(
                      onPressed: _generatePassword,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.autorenew),
                          Text('生成', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _websiteController,
                decoration: const InputDecoration(
                  labelText: '网址 (可选)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.language),
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: '备注 (可选)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: _save,
                  child: const Text('保存'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
