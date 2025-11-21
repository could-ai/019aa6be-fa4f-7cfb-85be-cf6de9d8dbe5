import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/password_item.dart';
import '../services/mock_data_service.dart';
import 'add_edit_password_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MockDataService _dataService = MockDataService();
  
  void _refresh() {
    setState(() {});
  }

  void _copyToClipboard(String value, String label) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label 已复制到剪贴板'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteItem(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这条密码记录吗？此操作无法撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              _dataService.deleteItem(id);
              Navigator.pop(ctx);
              _refresh();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _dataService.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的密码'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('搜索功能开发中...')),
              );
            },
          ),
        ],
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_open, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text('暂无密码记录', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.only(bottom: 80),
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple.shade100,
                      child: Text(
                        item.title.isNotEmpty ? item.title[0].toUpperCase() : '?',
                        style: const TextStyle(color: Colors.deepPurple),
                      ),
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(item.accountName),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow('账号', item.accountName),
                            const SizedBox(height: 12),
                            _buildDetailRow('密码', item.password, isPassword: true),
                            if (item.website != null && item.website!.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              _buildDetailRow('网址', item.website!),
                            ],
                            if (item.notes != null && item.notes!.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              _buildDetailRow('备注', item.notes!),
                            ],
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  icon: const Icon(Icons.edit, size: 18),
                                  label: const Text('编辑'),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddEditPasswordScreen(item: item),
                                      ),
                                    );
                                    _refresh();
                                  },
                                ),
                                const SizedBox(width: 8),
                                TextButton.icon(
                                  icon: const Icon(Icons.delete, size: 18),
                                  label: const Text('删除'),
                                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                                  onPressed: () => _deleteItem(item.id),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditPasswordScreen(),
            ),
          );
          _refresh();
        },
        label: const Text('添加密码'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isPassword = false}) {
    return Row(
      children: [
        SizedBox(
          width: 40,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            isPassword ? '•' * value.length : value,
            style: const TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.copy, size: 20, color: Colors.grey),
          onPressed: () => _copyToClipboard(value, label),
          tooltip: '复制$label',
        ),
      ],
    );
  }
}
